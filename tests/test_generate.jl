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

GenRandParams()