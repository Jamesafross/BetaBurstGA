using DifferentialEquations, NLsolve, LinearAlgebra, Parameters, MAT, JLD, ProgressBars
include("../massModelFunctions/_includes.jl")
include("../GAFunctions/GenerateInitialPopulation.jl")
include("../GAFunctions/structures.jl")
include("config.jl")
include("burstDetectionMethod.jl")




@time pop = load("$JulDIR/Generation.jld", "GenPop")

print(size(pop))

if size_pop < num_child
    @error "sizePop is larger than the number of child phenotypes!"
end

pop_current = zeros(mc_trials, length(time_range), size_pop)

Threads.@threads for i in ProgressBar(1:size_pop)
    try

        # try running the monte carlo iterations
        monte_carlo_loop!(pop[i], const_params, dt, time_range, time_span, pop_current, i)
    catch
        #catch if running sims fails (unstable maybe)
        try
            # run with lower dt ( fix stability issue, maybe?)
            monte_carlo_loop!(pop[i], const_params, dt / 10, time_range, time_span, pop_current, i)
        catch
            #if it fails, give up and generate new parameter set
            pop_current[:, :, i] .= zeros()
        end
    end
end
#save("$JulDIR/Generation.jld", "GenPop", Pop)

if typeBurstAnalysis == "Threshold"
    file = matopen("$MatDIR/PopCurrent.mat", "w") # save current for use in HMM-MAR
    write(file, "popcurrent", 10 * PopCurrent[:, :, :])
    close(file)
else
    typeBurstAnalysis == "HMM"
    file = matopen("$MatDIR/PopCurrent.mat", "w") # save current for use in HMM-MAR
    write(file, "popcurrent", pop_current[:, :, :])
    close(file)
end
