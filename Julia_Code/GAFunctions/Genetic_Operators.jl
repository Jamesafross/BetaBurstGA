using Random
include("_helpers.jl")
#genetic operations


function mutate(parent)
    number_params = size(parent, 1)
    #mutate genes in the parameter set
    number_mutations = Int(round(number_params * rand()))

    mutation_indices = Int.(randperm(numParams)[1:Int(number_mutations)]) # mutation indicies
    for i = 1:number_mutations
        parent[mutation_indices[i]] += (-0.5 + 1 * rand()) * parent[mutation_indices[i]] # changes a gene
    end

end

function crossover(parent1, parent2; just_stochastic=false)
    if just_stochastic == true
        number_params = 4
    else
        number_params = size(parent1.P, 1)
    end
    number_crossover = rand(1:number_params)
    crossover_points = randperm(number_params)[1:number_crossover]

    crossover_params_parent1 = parent1.P
    crossover_params_parent2 = parent2.P

    for i = 1:numCrossover
        crossover_params_parent1[crossover_points[i]] = parent2.P[cP[i]]
        crossover_params_parent2[crossover_points[i]] = parent1.P[cP[i]]
    end
    child1 = phenotype(P=crossover_params_parent1)
    child2 = phenotype(P=crossover_params_parent2)


    if rand() > 0.5
        return child1
    else
        return child2
    end

end

function do_crossover(parents, n, const_params)
    next_generation = []
    i = 0
    size_p = size(parents, 1)
    while i <= n
        println("Attempting to generate child (", i, "/", n, ")")
        r1, r2 = randperm(size_p)[1:2]

        child, children_generated = accept_child(const_params, parents[r1], parents[r2])
        if children_generated == true
            if i == 1
                next_generation = child
            else
                next_generation = cat(next_generation, child, dims=1)
            end
            i += 1
        end

        println(length(next_generation))
    end

    return next_generation
end

function make_next_gen(phenotypes, best_phenotype, size_pop, n, const_params)
    children = do_crossover(phenotypes, n, const_params)
    println(length(children))

    number_new = size_pop - length(children) - 1

    new_phenotypes = GenPop(number_new, const_params)
    print("length new phenotypes = ", length(new_phenotypes))

    next_generation = cat(best_phenotype, children, new_phenotypes, dims=1)
    println(length(next_generation))
    return next_generation
end

function normalise_fitness(phenotypes, size_pop)
    fitnessSum = 0
    for i = 1:size_pop
        fitnessSum += phenotypes[i].Fitness
    end
    for i = 1:size_pop
        phenotypes[i].Fitness = phenotypes[i].Fitness / fitnessSum
    end
    return phenotypes
end


function accept_child(const_params, parent1, parent2)


    @unpack ΔE, ΔI, η_0E, η_0I, τE, τI = const_params
    params = crossover(parent1, parent2).P


    σE, σI, τxE, τxI,
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII = params


    if rand() > 0.3
        mutate(p)
    end

    params1 = κSEE, κSIE, κSEI, κSII, αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI

    params2 = κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E + rand(), η_0I + rand(), τE, τI

    eigs = get_eigenvalues(params1)
    eigs = get_eigenvalues(params2)


    counter = 1
    timer_catch = @timeout 200 begin
        while (maximum(real.(eigs1)) > 0.0 || maximum(real.(eigs2)) < 0.0) && Main.counter < 200
            #println(maximum(real.(EIGS)))
            if Main.counter > 100
                p = crossover(parent1, parent2; just_stochastic=true).P
            else
                p = crossover(Parent1, Parent2).P
            end


            if rand() > 0.3
                mutate(p)
            end


            σE, σI, τxE, τxI,
            κSEE, κSIE, κSEI, κSII,
            αEE, αIE, αEI, αII,
            κVEE, κVIE, κVEI, κVII,
            VsynEE, VsynIE, VsynEI, VsynII = params

            params1 = κSEE, κSIE, κSEI, κSII, αEE, αIE, αEI, αII,
            κVEE, κVIE, κVEI, κVII,
            VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI

            params2 = κSEE, κSIE, κSEI, κSII,
            αEE, αIE, αEI, αII,
            κVEE, κVIE, κVEI, κVII,
            VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E + rand(), η_0I + rand(), τE, τI

            eigs1 = get_EigenValues(params1)
            eigs2 = get_EigenValues(params2)

            Main.counter += 1

        end
    end true


    if counter == 200 | timer_catch
        println("...could not make child ")
        if timer_catch
            print("because it took too long")
        else
            print("because the maximum number of attempts was reached")
        end

        children_generated = false

        return 0, children_generated
    else
        println("successfully generated a valid child")
        children_generated = true
        return phenotype(P=p), children_generated
    end
end





