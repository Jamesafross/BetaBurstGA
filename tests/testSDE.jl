using DifferentialEquations,NLsolve,LinearAlgebra,Parameters,MAT,JLD,ProgressBars,NLsolve,Random,Test
HOMEDIR = homedir()
include("../Julia_Code/massModelFunctions/FuncRunMassModel.jl")
include("../Julia_Code/GAFunctions/GenerateInitialPopulation.jl")
include("../Julia_Code/GAFunctions/structures.jl")
include("../Julia_Code/massModelFunctions/stability.jl")
include("../Julia_Code/massModelFunctions/rhsFunctions.jl")
include("../Julia_Code/scripts/config.jl")
include("../Julia_Code/scripts/burstDetectionMethod.jl")
include("../Julia_Code/massModelFunctions/rhsFunctions.jl")


testdir = "$HOMEDIR/BetaBurstGA/tests"

Pop = load("$testdir/test_data/Generation.jld","GenPop")

PhenotypeParams = Pop[3].P
σE = PhenotypeParams[1]
σI = PhenotypeParams[2]
τxE = PhenotypeParams[3]
τxI = PhenotypeParams[4]
κSEE = PhenotypeParams[5]
κSIE = PhenotypeParams[6]
κSEI = PhenotypeParams[7]
κSII = PhenotypeParams[8]
αEE = PhenotypeParams[9]
αIE = PhenotypeParams[10]
αEI = PhenotypeParams[11]
αII = PhenotypeParams[12]
κVEE= PhenotypeParams[13]
κVIE= PhenotypeParams[14]
κVEI = PhenotypeParams[15]
κVII = PhenotypeParams[16]
VsynEE = PhenotypeParams[17]
VsynIE = PhenotypeParams[18]
VsynEI = PhenotypeParams[19]
VsynII = PhenotypeParams[20]

p = σE,σI,τxE,τxI,
κSEE,κSIE,κSEI,κSII,
αEE,αIE,αEI,αII,
κVEE,κVIE,κVEI,κVII,
VsynEE,VsynIE,VsynEI,VsynII,ΔE,ΔI,η_0E,η_0I,τE,τI

u0 =  init_conds_SS(params[5:end])
u0 = cat(u0,[randn(); randn()],dims=1)


σE,σI,τxE,τxI,
κSEE,κSIE,κSEI,κSII,
αEE,αIE,αEI,αII,
κVEE,κVIE,κVEI,κVII,
VsynEE,VsynIE,VsynEI,VsynII,ΔE,ΔI,η_0E,η_0I,τE,τI = p

prob = SDEProblem(f,g,u0,tspan,p)

sol = solve(prob,EM(),dt=0.0001,maxiters=10^20,saveat = saveat)
rE = sol[1,:]
rI = sol[2,:]
vE = sol[3,:]
vI = sol[4,:]
gEE = sol[6,:]
gIE = sol[8,:]
gEI = sol[10,:]
gII = sol[12,:]
noiseE = sol[13,:]
noiseI = sol[14,:]