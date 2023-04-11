function monte_carlo_loop!(pop_i, const_params, dt, time_range, time_span, pop_current, i)

    @unpack ΔE, ΔI, η_0E, η_0I, τE, τI = const_params
    println("Running MC trials for phenotype: ", i)
    PhenotypeParams = pop_i.P
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
    κVEE = PhenotypeParams[13]
    κVIE = PhenotypeParams[14]
    κVEI = PhenotypeParams[15]
    κVII = PhenotypeParams[16]
    VsynEE = PhenotypeParams[17]
    VsynIE = PhenotypeParams[18]
    VsynEI = PhenotypeParams[19]
    VsynII = PhenotypeParams[20]

    params = σE, σI, τxE, τxI,
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI

    u0 = get_init_conditions(params[5:end])
    u0 = cat(u0, [randn(); randn()], dims=1)

    for j = 1:mc_trials
        #println("Running MC trial ",j)
        pop_current[j, :, i] = run_mass_model(u0, dt, time_range, params, time_span)
    end

end


function run_mass_model(u0, dt, time_range, p, time_span)
    # This function runs the mass model using
    # the SingleNodeEM solver.
    # The output is the sum of excitatory and
    # inhibitory current
    σE, σI, τxE, τxI,
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI = p

    prob = SDEProblem(f, g, u0, time_span, p)

    sol = solve(prob, EM(), dt=dt, maxiters=10^20, saveat=time_range)

    rE = sol[1, :]
    rI = sol[2, :]
    vE = sol[3, :]
    vI = sol[4, :]
    gEE = sol[6, :]
    gIE = sol[8, :]
    gEI = sol[10, :]
    gII = sol[12, :]
    noiseE = sol[13, :]
    noiseI = sol[14, :]
    WE = (1 .- conj.(sol[1, :])) ./ (1 .+ conj.(sol[1, :]))
    WI = (1 .- conj.(sol[2, :])) ./ (1 .+ conj.(sol[2, :]))
    currentE = real(gEE .* (VsynEE .- vE) .+ gEI .* (VsynEI .- vE))
    currentI = real(gIE .* (VsynIE .- vI) .+ gII .* (VsynII .- vI))
    current = currentE .+ currentI

    return current
end



#################################
# Functions for use in the SDE  #
# solver                        #
#################################

function f(du, u, p, t)
    σE, σI, τxE, τxI,
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI = p

    rE = u[1]
    rI = u[2]
    vE = u[3]
    vI = u[4]
    pEE = u[5]
    gEE = u[6]
    pIE = u[7]
    gIE = u[8]
    pEI = u[9]
    gEI = u[10]
    pII = u[11]
    gII = u[12]
    #rE
    du[1] = (1.0 / τE) * (-gEE * rE - gEI * rE - κVEE * rE - κVEI * rE + 2.0 * rE * vE + (ΔE / (τE * π)))
    #rI
    du[2] = (1.0 / τI) * (-gII * rI - gIE * rI - κVIE * rI - κVII * rI + 2.0 * rI * vI + (ΔI / (τI * π)))
    #vE
    du[3] = (1.0 / τE) * (gEE * (VsynEE - vE) + gEI * (VsynEI - vE) + κVEI * (vI - vE) - (τE^2.0) * (π^2.0) * (rE^2) + vE^2.0 + η_0E + u[13])
    #vI
    du[4] = (1.0 / τI) * (gIE * (VsynIE - vI) + gII * (VsynII - vI) + κVIE * (vE - vI) - (τI^2.0) * (π^2.0) * (rI^2) + vI^2.0 + η_0I + u[14])
    #psiEE
    du[5] = αEE * (-pEE + κSEE * rE)
    #gEE
    du[6] = αEE * (-gEE + pEE)
    #pIE
    du[7] = αIE * (-pIE + κSIE * rE)
    #gIE
    du[8] = αIE * (-gIE + pIE)
    #pEI
    du[9] = αEI * (-pEI + κSEI * rI)
    #gEI
    du[10] = αEI * (-gEI + pEI)
    #pII
    du[11] = αII * (-pII + κSII * rI)
    #gII
    du[12] = αII * (-gII + pII)

    du[13] = -u[13] / τxE

    du[14] = -u[14] / τxI


end

function g(du, u, p, t)
    σE, σI, τxE, τxI,
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI = p

    du[1] = 0.0
    du[2] = 0.0
    du[3] = 0.0
    du[4] = 0.0
    du[5] = 0.0
    du[6] = 0.0
    du[7] = 0.0
    du[8] = 0.0
    du[9] = 0.0
    du[10] = 0.0
    du[11] = 0.0
    du[12] = 0.0
    du[13] = σE
    du[14] = σI

end
