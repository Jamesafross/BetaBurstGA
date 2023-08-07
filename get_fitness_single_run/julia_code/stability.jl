using NLsolve,LinearAlgebra
function JacMat(rE, rI, vE, vI, p)
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI = p

    gEE = κSEE * rE
    gIE = κSIE * rE
    gEI = κSEI * rI
    gII = κSII * rI
    # 1  2  3  4  5   6   7   8   9   10  11  12
    # rE rI vE vI pEE gEE pIE gIE pEI gEI pII gII

    J = zeros(12, 12)
    #rE
    J[1, 1] = (1 / τE) * (-gEE - gEI - κVEE - κVEI + 2 * vE) #/rE
    J[1, 3] = (1 / τE) * (2 * rE) #/vE
    J[1, 6] = (1 / τE) * (-rE) # /gEE
    J[1, 10] = (1 / τE) * (-rE) #/gEI

    #rI

    J[2, 2] = (1 / τI) * (-gII - gIE - κVII - κVIE + 2 * vI) #/rI
    J[2, 4] = (1 / τI) * (2 * rI) #/vI
    J[2, 8] = (1 / τI) * (-rI) #/gIE
    J[2, 12] = (1 / τI) * (-rI) #/gII

    #vE
    J[3, 1] = (1 / τE) * (-2 * (τE^2) * (pi^2) * (rE))
    J[3, 3] = (1 / τE) * (-gEE - gEI - κVEI + 2 * vE)
    J[3, 4] = (1 / τE) * (κVIE)
    J[3, 6] = (1 / τE) * (VsynEE)
    J[3, 10] = (1 / τE) * (VsynEI)

    #vI
    J[4, 2] = (1 / τI) * (-2 * (τI^2) * (pi^2) * (rI))
    J[4, 3] = (1 / τI) * (κVIE)
    J[4, 4] = (1 / τI) * (-gIE - gII - κVIE + 2 * vI)
    J[4, 8] = (1 / τI) * (VsynIE)
    J[4, 12] = (1 / τI) * (VsynII)


    #pEE
    J[5, 1] = κSEE * αEE
    J[5, 5] = -αEE

    #gEE
    J[6, 5] = αEE
    J[6, 6] = -αEE

    #pIE
    J[7, 1] = κSIE * αIE
    J[7, 7] = -αIE

    #gEI
    J[8, 7] = αIE
    J[8, 8] = -αIE

    #pEI
    J[9, 2] = κSEI * αEI
    J[9, 9] = -αEI


    #gEI
    J[10, 9] = αEI
    J[10, 10] = -αEI

    #pEI
    J[11, 2] = κSII * αII
    J[11, 11] = -αII

    #gEI
    J[12, 11] = αII
    J[12, 12] = -αII
    return J
end

function test()
    p = 0
    for i = 1:10
        p = i
    end
    return p
end

function get_eigenvalues(p)

    steady_state_list = find_steady_states(p)

    eigs = []
    for i = 1:size(steady_state_list, 1)
        rE, rI, vE, vI = steady_state_list[i, :]
        J = JacMat(rE, rI, vE, vI, p)
        if i == 1
            eigs = eigen(J).values
        else
            eigs = cat(eigs, eigen(J).values, dims=1)
        end
    end
    return eigs
end



function f(F, x, p)
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI = p

    rE = x[1]
    rI = x[2]
    vE = x[3]
    vI = x[4]
    gEE = κSEE * rE
    gEI = κSEI * rI
    gIE = κSIE * rE
    gII = κSII * rI

    #rE
    F[1] = (-gEE * rE - gEI * rE - κVEE * rE - κVEI * rE + 2 * rE * vE + (ΔE / (τE * pi)))
    #rI
    F[2] = (-gII * rI - gIE * rI - κVIE * rI - κVII * rI + 2 * rI * vI + (ΔI / (τI * pi)))
    #vE
    F[3] = (κVEI * (vI - vE) + gEE * (VsynEE - vE) + gEI * (VsynEI - vE) - (τE^2) * (pi^2) * (rE^2) + (vE^2) + η_0E)

    #vI
    F[4] = (κVIE * (vE - vI) + gIE * (VsynIE - vI) + gII * (VsynII - vI) - (τI^2) * (pi^2) * (rI^2) + (vI^2) + η_0I)

end

function get_steady_state(p)

    f!(F, x) = f(F, x, p)
    X = rand(4)
    steady_state = nlsolve(f!, [X[1]; X[2]; X[3]; X[4]])
    break_condition = false
    while break_condition == false
        X = rand(4)
        steady_state = nlsolve(f!, [X[1]; X[2]; X[3]; X[4]])
        if steady_state.f_converged == true && (steady_state.zero[1] > 0 && steady_state.zero[2] > 0)
            break_condition = true
        end
    end

    return steady_state.zero
end

function get_init_conditions(p)
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI = p
    x = get_steady_state(p)
    rE = x[1]
    rI = x[2]
    vE = x[3]
    vI = x[4]
    gEE = κSEE * rE
    gEI = κSEI * rI
    gIE = κSIE * rE
    gII = κSII * rI

    return [rE, rI, vE, vI, gEE, gEE, gIE, gIE, gEI, gEI, gII, gII]

end


function find_steady_states(p)
    steady_state_list = []
    for i = 1:1000
        #print(i)
        global flag = false
        steady_state_test = get_steady_state(p)'
        while steady_state_test[1] < 0 || steady_state_test[2] < 0
            steady_state_test = get_steady_state(p)'
        end
        if i == 1
            steady_state_list = cat(steady_state_list, steady_state_test, dims=1)
        else
            for j = 1:size(steady_state_list, 1)
                if sum(abs.((steady_state_test' .- steady_state_list[j, :]))) < 10^-1
                    global flag = true
                end
            end
            if flag == false
                if steady_state_test[1] > 0
                    if steady_state_test[3] > 0
                        steady_state_list = cat(steady_state_list, steady_state_test, dims=1)
                    end
                end
            end
        end
    end
    return steady_state_list
end
