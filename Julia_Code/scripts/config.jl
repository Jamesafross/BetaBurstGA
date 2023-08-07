# CONFIG FILE FOR VARIOUS
# PARAMETERS IN THE GENETIC
# ALGORITHM.
HOMEDIR = homedir()
PROGDIR = pwd()
JULDIR = joinpath("$PROGDIR","Julia_Code/")
MATDIR = joinpath("$PROGDIR","HMM/")
DATADIR = joinpath("$PROGDIR","datafiles/")


include(joinpath("$JULDIR","GAFunctions","structures.jl"))
include(joinpath("$JULDIR","common","helpers.jl"))

import JSON


configuration = load_config_json(joinpath("$PROGDIR","config.json"))

size_pop = configuration["GA_config"]["size_pop"]
num_child = configuration["GA_config"]["num_child"]

tour_rounds = configuration["GA_config"]["tour_rounds"]
min_parents = configuration["GA_config"]["min_parents"]
mc_trials = configuration["solve_options"]["mc_trials"]

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
time_max = 100000 + buffer_period
time_span = (0.0, time_max)
time_range = collect(buffer_period+saveat:saveat:time_max)
println("Sampling Rate is: ", sampling_rate)


if size_pop < num_child
    @error "sizePop is larger than the number of child phenotypes!"
end





