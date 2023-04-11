using DifferentialEquations
using NLsolve
using LinearAlgebra
using Parameters
using MAT
using JLD

include("../GAFunctions/GenerateInitialPopulation.jl")
include("../GAFunctions/structures.jl")
include("../massModelFunctions/stability.jl")
include("../massModelFunctions/_includes.jl")
include("config.jl")



println("Generating Initial Population of ", size_pop, " Phenotypes ... ")
init_pop = generate_population(size_pop, const_params)
#print(length(InitPop))
println("Done.")

save("$JulDIR/Generation.jld", "GenPop", init_pop)

best_phenotype = []
save("$JulDIR/BestInGen.jld", "BestPhenotype", best_phenotype)
