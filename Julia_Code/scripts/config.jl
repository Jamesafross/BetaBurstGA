# CONFIG FILE FOR VARIOUS
# PARAMETERS IN THE GENETIC
# ALGORITHM.

#sizePop = 10 # size of the population (i.e number of parameter sets)
             # in each generation ---
             # this is currently constant throughout each
             # generation though I may change this in future
#numTrial = 10 # this is the number of monte carlo trials for each parameter set

#basepath
BASEDIR=homedir()
progDIR=pwd()
JulDIR="$progDIR/datafiles"
MatDIR="$progDIR/datafiles"# working directory
include("burstDetectionMethod.jl")



sizePop = 100
numChild = 60
tourRounds = 4
minParents = 15
MCtrials = 80
ΔE = 0.2;
ΔI = 0.2;
η_0E = 2.0;
η_0I = 1.8;
τE = 12;
τI = 15;

constParams = ΔE,ΔI,η_0E,η_0I,τE,τI


if typeBurstAnalysis == "HMM"
    saveat = 4.0
    Fs = 1000/saveat #1000 t = 1 second
elseif typeBurstAnalysis == "Threshold"
    saveat = 2.0
    Fs = 1000/saveat
end
println("Sampling Rate is: ",Fs)
dt = 0.01
bufferPeriod = 2000
T_max = 30000 + 2000
tspan = (0.0,T_max)
tRange = collect(0:saveat:T_max)




