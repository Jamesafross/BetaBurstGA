include("config.jl")
using JLD


include(joinpath("$JULDIR","GAFunctions","GenerateInitialPopulation.jl"))
include(joinpath("$JULDIR","GAFunctions","structures.jl"))




println("Generating Initial Population of ", size_pop, " Phenotypes ... ")
init_pop = generate_population(size_pop, const_params)
#print(length(InitPop))
println("Done.")

save(joinpath("$DATADIR","Generation.jld"), "GenPop", init_pop)

best_phenotype = []
save(joinpath("$DATADIR","BestInGen.jld"), "BestPhenotype", best_phenotype)
generation_data = Dict("Data" => [])


open(joinpath("$PROGDIR","generation_results.json"),"w") do f
    JSON.print(f, generation_data, 4)
end