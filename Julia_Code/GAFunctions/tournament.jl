function assign_stats(phenotype, stats)
    for i in eachindex(phenotype)
        phenotype[i].Stats = stats[:, :, i]
    end
    return nothing
end

function find_best(phenotypes)
    bestIndx = 1
    bestFitness = 0

    for i in eachindex(phenotypes)
        if i == 1
            bestFitness = phenotypes[i].Fitness
            bestIndx = i
        else
            if bestFitness > phenotypes[i].Fitness
                bestFitness = phenotypes[i].Fitness
                bestIndx = i
            end
        end
    end
    return phenotype(P=phenotypes[bestIndx].P), phenotypes[bestIndx].Fitness, bestIndx
end


function assign_fitness(phenotypes, realdata_stats)
    for i in eachindex(phenotypes)
        get_total_fitness(phenotypes[i], realdata_stats)
    end
    return nothing
end

function get_total_fitness(phenotypes, realdata_stats)
    fitnessMat = zeros(size(realdata_stats))
    for i in eachindex(fitnessMat)
            fitnessMat[i] = (abs(realdata_stats[i] - phenotypes.Stats[i])) / abs(realdata_stats[i])
    end

    if isnan(sum(fitnessMat)) == true
        phenotypes.Fitness = 10^7 # gets rid of NaN values from matlab (i.e if no β-bursts were detected etc.)
    else
        phenotypes.Fitness = sum(fitnessMat)
    end
    return nothing
end

function setFitnessTest(phenotypes)
    rperm = randperm(size(phenotypes, 1))
    for i in eachindex(phenotypes, 1)
        phenotypes[i].Fitness = rperm[i]
    end

    return phenotypes
end

function tournament(phenotypes, rounds, pThreshold)
    winners = phenotypes
    i = 1
    while i <= rounds && size(winners, 1) > pThreshold
        #print(i)
        winners = tournamentRound(winners)
        i += 1
    end

    return winners
end




function tournamentRound(phenotypes)

    size_pop = size(phenotypes, 1)

    if mod(size_pop, 2) != 0.0
        maxFitness = 0
        indexMaxFitness = 0
        for i = 1:size_pop
            if i == 1
                maxFitness = phenotypes[i].Fitness
                indexMaxFitness = i
            else
                if phenotypes[i].Fitness > maxFitness
                    maxFitness = phenotypes[i].Fitness
                    indexMaxFitness = i
                    #println(indexMaxFitness)
                end
            end
        end
        #println(phenotypes[indexMaxFitness].Fitness)
        phenotypes = phenotypes[setdiff(Int.(round.(LinRange(1, size_pop, size_pop))), [indexMaxFitness])]
        size_pop = size_pop - 1

    end

    global groupA = phenotypes[1:Int(round(size_pop) / 2)]

    global groupB = phenotypes[Int(round(size_pop) / 2)+1:end]
    winners = []
    for i = 1:Int(size_pop / 2)
        if i == 1
            if groupA[i].Fitness > groupB[i].Fitness
                winners = [groupB[i]]
            else
                winners = [groupA[i]]
            end
        else
            if groupA[i].Fitness > groupB[i].Fitness
                winners = cat(winners, groupB[i], dims=1)
            else
                winners = cat(winners, groupA[i], dims=1)
            end
        end

    end
    return winners
end


