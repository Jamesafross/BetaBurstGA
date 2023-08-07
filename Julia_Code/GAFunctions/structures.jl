using Parameters

@with_kw mutable struct ConstParams
    ΔE = 0.2
    ΔI = 0.2
    η_0E = 2.0
    η_0I = 1.8
    τE = 12
    τI = 15
end

@with_kw mutable struct AllParams
    const_params = ConstParams()
    σE = 0.
    σI = 0.
    τxE = 0.
    τxI = 0.
    κSEE = 0.
    κSIE = 0.
    κSEI = 0.
    κSII = 0.
    αEE = 0.
    αIE = 0.
    αEI = 0.
    αII = 0.
    κVEE = 0.
    κVIE = 0.
    κVEI = 0.
    κVII = 0.
    VsynEE = 0.
    VsynIE = 0.
    VsynEI = 0.
    VsynII = 0. 
end



@with_kw mutable struct phenotype
    P = 0
    Stats = 0
    Fitness = 0.0
    Rank = 0
end