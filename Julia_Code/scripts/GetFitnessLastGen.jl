using DifferentialEquations
using NLsolve
using LinearAlgebra
using Parameters
using MAT
using JLD
using Random
using Test
using ProgressBars

include("../massModelFunctions/_includes.jl")
include("../GAFunctions/GenerateInitialPopulation.jl")
include("../GAFunctions/tournament.jl")
include("../GAFunctions/structures.jl")
include("../massModelFunctions/stability.jl")

include("../GAFunctions/Genetic_Operators.jl")
include("config.jl")
include("burstDetectionMethod.jl")
include("../GAFunctions/GenerateInitialPopulation.jl")
include("../GAFunctions/structures.jl")
include("config.jl")
include("burstDetectionMethod.jl")
import Base.length
length(x::phenotype) = 1



@time pop = load("$JulDIR/Generation.jld", "GenPop")

println(size(pop))

if size_pop < num_child
    @error "sizePop is larger than the number of child phenotypes!"
end




gen_phenotype = load("$JulDIR/Generation.jld", "GenPop")
println(size(gen_phenotype))
if typeBurstAnalysis == "Threshold"
    file = matopen("$JulDIR/ThresholdStats.mat")
    phenotype_stats = read(file, "stats")
    close(file)

    file = matopen("$JulDIR/ThresholdRealDataStats.mat")
    realdata_stats = read(file, "realdatastats")
    close(file)

elseif typeBurstAnalysis == "HMM"
    file = matopen("$JulDIR/HMMStats.mat")
    phenotype_stats = read(file, "stats")
    close(file)

    include("$JulDIR/HMMrealDataStats.jl")
end

best_phenotype = load("$JulDIR/BestInGen.jld", "BestPhenotype")
@test size(phenotype_stats) == (4, 2, size_pop)
assign_stats(gen_phenotype, phenotype_stats)
assign_fitness(gen_phenotype, realdata_stats)

winners_tour = tournament(gen_phenotype, tour_rounds, min_parents)
best_in_gen, best_fitness, best_indx = find_best(winners_tour)
best_fitness_params = best_in_gen.P
bp = best_in_gen
bp.Fitness = best_fitness
best_phenotype = cat(bestPhenotype, bp, dims=1)
save("$JulDIR/BestInGen.jld", "BestPhenotype", best_phenotype)
println(
    "best phenotype in this generation is: \n $bestFitnessParams. \n \n with total fitness: $bestFitness \n \n at index ",
    best_indx,
)

open("$JulDIR/BestFitnessLog.txt", "w") do f #outputs best fitness phenotype to a .txt file
end

save("$JulDIR/LastGeneration.jld", "GenPop", gen_phenotype)
