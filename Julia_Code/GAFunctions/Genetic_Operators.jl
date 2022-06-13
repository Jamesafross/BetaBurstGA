using Random
#genetic operations


function mutate(parent)
    numParams = size(parent,1)
    #mutate genes in the parameter set
    numMutations = Int(round(numParams*rand()))
    
    mInd = Int.(randperm(numParams)[1:Int(numMutations)]) # mutation indicies
    for i = 1:numMutations
            parent[mInd[i]] += (-0.5 + 1*rand())*parent[mInd[i]] # changes a gene
    end
 
end

function crossover(Parent1,Parent2;justStoch = 0)
    if justStoch == 1
    nP = 4
    else
    nP = size(Parent1.P,1)
    end
    numCrossover = rand(1:nP)
    cP = randperm(nP)[1:numCrossover]

    crossoverParamsParent1 = Parent1.P
    crossoverParamsParent2 = Parent2.P
    
    for i = 1:numCrossover
        crossoverParamsParent1[cP[i]] = Parent2.P[cP[i]]
        crossoverParamsParent2[cP[i]] = Parent1.P[cP[i]]
    end
    child1 = phenotype(P = crossoverParamsParent1)
    child2 = phenotype(P = crossoverParamsParent2)
    #println(crossoverPoints)
    pr = rand()

    if pr > 0.5
        return child1
    else
        return child2
    end

end

function doCrossover(parents,n)
    nextGen = []
    i = 0
    sizeP = size(parents,1)
    while i <= n
        r1,r2 = randperm(sizeP)[1:2]
        child = acceptChild(constParams,parents[r1],parents[r2])
        if i == 1
            nextGen = child
        else
            nextGen = cat(nextGen,child,dims=1)
        end

        i += 1
        #println(size(nextGen,1))
    end

    return nextGen
end

function makeNextGen(phenotypes,bestPhenotype,sizePop,n,constParams)
    children = doCrossover(phenotypes,n)
    numNew = sizePop - size(children,1) - 1
    return cat(bestPhenotype,children,GenPop(numNew,constParams),dims=1)
end

function normaliseFitness(phenotypes)
    fitnessSum = 0
    for i in 1:size(phenotypes,1)
        fitnessSum += phenotypes[i].Fitness
    end
    for i in 1:size(phenotypes,1)
        phenotypes[i].Fitness = phenotypes[i].Fitness/fitnessSum
    end
    return phenotypes
end


function acceptChild(constParams,Parent1,Parent2)

    ΔE,ΔI,η_0E,η_0I,τE,τI =  constParams
    p = crossover(Parent1,Parent2).P


    σE,σI,τxE,τxI,
    κSEE,κSIE,κSEI,κSII,
    αEE,αIE,αEI,αII,
    κVEE,κVIE,κVEI,κVII,
    VsynEE,VsynIE,VsynEI,VsynII  = p
    pr= rand()
    if pr > 0.3
        mutate(p)
    end

    params = κSEE,κSIE,κSEI,κSII,αEE,αIE,αEI,αII,
    κVEE,κVIE,κVEI,κVII,
    VsynEE,VsynIE,VsynEI,VsynII,ΔE,ΔI,η_0E,η_0I,τE,τI

    params2 = κSEE,κSIE,κSEI,κSII,
    αEE,αIE,αEI,αII,
    κVEE,κVIE,κVEI,κVII,
    VsynEE,VsynIE,VsynEI,VsynII,ΔE,ΔI,η_0E+rand(),η_0I+rand(),τE,τI

    EIGS1 = get_EigenValues(params)
    EIGS2 = get_EigenValues(params2)

    #println(maximum(real.(EIGS)))

    breakcond = false
    counter = 1
    while  (maximum(real.(EIGS1)) > 0.0 || maximum(real.(EIGS2)) < 0.0) && counter < 200
        #println(maximum(real.(EIGS)))
            if counter > 100
                p = crossover(Parent1,Parent2;justStoch=1).P  
            else
                p = crossover(Parent1,Parent2).P
            end

           pr = rand()
           if pr > 0.85
            mutate(p)
           end
            

            σE,σI,τxE,τxI,
            κSEE,κSIE,κSEI,κSII,
            αEE,αIE,αEI,αII,
            κVEE,κVIE,κVEI,κVII,
            VsynEE,VsynIE,VsynEI,VsynII = p

            params = κSEE,κSIE,κSEI,κSII,αEE,αIE,αEI,αII,
            κVEE,κVIE,κVEI,κVII,
            VsynEE,VsynIE,VsynEI,VsynII,ΔE,ΔI,η_0E,η_0I,τE,τI

            params2 = κSEE,κSIE,κSEI,κSII,
            αEE,αIE,αEI,αII,
            κVEE,κVIE,κVEI,κVII,
            VsynEE,VsynIE,VsynEI,VsynII,ΔE,ΔI,η_0E+rand(),η_0I+rand(),τE,τI

            EIGS1 = get_EigenValues(params)
            EIGS2 = get_EigenValues(params2)

            counter += 1
            #println("counter = ", counter)
    end

    if counter  == 200
        println("could not make child")
        if rand() > 0.5
            return phenotype(P=Parent1.P)
        else
            return phenotype(P=Parent2.P)
        end
    else 
        return phenotype(P = p)
    end
end



    

