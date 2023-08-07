# CONFIG FILE FOR VARIOUS
# PARAMETERS IN THE GENETIC
# ALGORITHM.
using JLD,DifferentialEquations,MAT
import JSON
include("MonteCarloLoop.jl")
include("stability.jl")

HOMEDIR = homedir()
PROGDIR = pwd()
JULDIR = joinpath("$PROGDIR","Julia_Code/")
MATDIR = joinpath("$PROGDIR","HMM/")
DATADIR = joinpath("$PROGDIR","get_fitness_single_run","data/")




configuration = load_config_json(joinpath("$PROGDIR","get_fitness_single_run","config.json"))


params_dict = configuration["const_model_params"]

const_params = ConstParams(
    ΔE = params_dict["Delta_E"],
    ΔI = params_dict["Delta_I"],
    η_0E = params_dict["eta_0E"],
    η_0I = params_dict["eta_0I"],
    τE = params_dict["tau_E"],
    τI = params_dict["tau_I"],
)



sampling_rate = configuration["solve_options"]["sampling_rate"]
saveat = 1000/sampling_rate
dt = configuration["solve_options"]["dt"]
buffer_period = configuration["solve_options"]["buffer_period"]
const_model_params = configuration["const_model_params"]
time_max = 100000 + buffer_period
time_span = (0.0, time_max)
time_range = collect(buffer_period+saveat:saveat:time_max)
println("Sampling Rate is: ", sampling_rate)

trials = 100
params = configuration["optimised_params"]


pop_current = zeros(trials, length(time_range))

monte_carlo_loop!(params, const_params, dt, time_range, time_span, trials, pop_current)
 




file = matopen(joinpath("$DATADIR","PopCurrent.mat"), "w") # save current for use in HMM-MAR
    write(file, "popcurrent", pop_current[:, :])
    close(file)

