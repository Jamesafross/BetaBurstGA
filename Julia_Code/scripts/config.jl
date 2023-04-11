# CONFIG FILE FOR VARIOUS
# PARAMETERS IN THE GENETIC
# ALGORITHM.

#sizePop = 10 # size of the population (i.e number of parameter sets)
# in each generation ---
# this is currently constant throughout each
# generation though I may change this in future
#numTrial = 10 # this is the number of monte carlo trials for each parameter set

#basepath
BASEDIR = homedir()
progDIR = pwd()
JulDIR = "$progDIR/datafiles"
MatDIR = "$progDIR/datafiles"# working directory
include("burstDetectionMethod.jl")
import Base.length
length(x::phenotype) = 1


size_pop = 100
num_child = 20

tour_rounds = 4
min_parents = 15
mc_trials = 100


const_params = ConstParams()


if typeBurstAnalysis == "HMM"
    saveat = 10.0
    Fs = 1000 / saveat #1000 t = 1 second
elseif typeBurstAnalysis == "Threshold"
    saveat = 2.0
    Fs = 1000 / saveat
end
println("Sampling Rate is: ", Fs)
dt = 0.01
buffer_period = 2000
time_max = 100000 + buffer_period
time_span = (0.0, time_max)
global time_range = collect(buffer_period+saveat:saveat:time_max)




if size_pop < num_child
    @error "sizePop is larger than the number of child phenotypes!"
end
