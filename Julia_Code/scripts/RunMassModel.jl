using DifferentialEquations, NLsolve, LinearAlgebra, Parameters, MAT, JLD, ProgressBars
include("../massModelFunctions/_includes.jl")
include("../GAFunctions/GenerateInitialPopulation.jl")
include("../GAFunctions/structures.jl")
include("config.jl")
include("burstDetectionMethod.jl")




@time pop = load(joinpath("$DATADIR","Generation.jld"),"GenPop")

print(size(pop))

if size_pop < num_child
    @error "sizePop is larger than the number of child phenotypes!"
end

pop_current = zeros(mc_trials, length(time_range), size_pop)
failed_attempts = zeros(size_pop)
instability_detected = zeros(size_pop)
Threads.@threads for i = 1:size_pop
    try

        # try running the monte carlo iterations
        monte_carlo_loop!(pop[i], const_params, dt, time_range, time_span, pop_current, mc_trials, i)
    catch
        instability_detected[i] = 1
        #catch if running sims fails (unstable maybe)
        try

            # run with lower dt ( fix stability issue, maybe?)
            monte_carlo_loop!(pop[i], const_params, dt / 10, time_range, time_span, pop_current, mc_trials, i)
        catch
            failed_attempts[i] = 1
            #if it fails, give up and generate new parameter set
            pop_current[:, :, i] .= zeros()
        end
    end
end

num_instability_detected = Int(sum(instability_detected))
num_failed_attempts = Int(sum(failed_attempts))

print("\n *********************************************************
\n    Finish running simulations! \n \n    Number of failed attempts was: ", num_failed_attempts, "  \n \n    ", num_instability_detected, 
" simulation(s) needed to use a lower dt value.   
\n ********************************************************* \n")
#save("$JulDIR/Generation.jld", "GenPop", Pop)

num_instability_detected = Int(sum(instability_detected))
num_failed_attempts = Int(sum(failed_attempts))
if configuration["type_burst_analysis"] == "Threshold"
    file = matopen(joinpath("$DATADIR","PopCurrent.mat"), "w") # save current for use in HMM-MAR
    write(file, "popcurrent", 10 * PopCurrent[:, :, :])
    close(file)
elseif configuration["type_burst_analysis"] == "HMM"
    file = matopen(joinpath("$DATADIR","PopCurrent.mat"), "w") # save current for use in HMM-MAR
    write(file, "popcurrent", pop_current[:, :, :])
    close(file)
end
