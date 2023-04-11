using DifferentialEquations
using NLsolve
using LinearAlgebra
using Parameters
using MAT
using JLD
using Random
using Test
include("../Julia_Code/massModelFunctions/FuncRunMassModel.jl")
include("../Julia_Code/GAFunctions/GenerateInitialPopulation.jl")
include("../Julia_Code/GAFunctions/tournament.jl")
include("../Julia_Code/GAFunctions/structures.jl")
include("../Julia_Code/massModelFunctions/stability.jl")
include("../Julia_Code/massModelFunctions/rhsFunctions.jl")
include("../Julia_Code/GAFunctions/Genetic_Operators.jl")
include("../Julia_Code/scripts/config.jl")
include("../Julia_Code/scripts/burstDetectionMethod.jl")

testdir = "$(homedir())/BetaBurstGA/tests"
GenPhenotype = load("$testdir/test_data/Generation.jld", "GenPop")





file = matopen("$testdir/test_data/HMMStats.mat")
phenotype_stats = read(file, "stats")
close(file)

include("$testdir/test_data/HMMrealDataStats.jl")



assignStats(GenPhenotype,phenotype_stats)
assignFitness(GenPhenotype,realdata_stats)

winnersTour = tournament(GenPhenotype,tourRounds,minParents)
bestInGen,bestFitness,bestindx = findBest(winnersTour)


nextGen = makeNextGen(winnersTour,bestInGen,sizePop,numChild,constParams)


@testset "non-zeros phenotypes" begin
    for i = 1:100
        @test nextGen[i].P != zeros(20)
    end
end


# get the fitness of each phenotype