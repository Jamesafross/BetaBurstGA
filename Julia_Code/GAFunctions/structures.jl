using NLsolve
using LinearAlgebra
using Parameters

@with_kw mutable struct ConstParams
    ΔE = 0.2
    ΔI = 0.2
    η_0E = 2.0
    η_0I = 1.8
    τE = 12
    τI = 15
end

@with_kw mutable struct phenotype
    P = 0
    Stats = 0
    Fitness = 0.0
    Rank = 0
end