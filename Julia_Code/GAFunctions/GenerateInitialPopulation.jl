#functions for generating the initial population of parameters
include("_helpers.jl")

function random_number_generator(a, b, y)
    # creates a uniform random number between a and b
    return a .+ (b - a) * rand(y)
end

function generate_good_parameters(const_params)


    @unpack ΔE, ΔI, η_0E, η_0I, τE, τI = const_params

    params_out = generate_random_params()

    σE, σI, τxE, τxI,
    κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII = params_out

    params1 = κSEE, κSIE, κSEI, κSII, αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI

    params2 = κSEE, κSIE, κSEI, κSII,
    αEE, αIE, αEI, αII,
    κVEE, κVIE, κVEI, κVII,
    VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E + rand(), η_0I + rand(), τE, τI

    eigs1 = get_eigenvalues(params1)
    eigs2 = get_eigenvalues(params2)


    while maximum(real.(eigs1)) > 0.0 || maximum(real.(eigs2)) < 0.0

        params_out = generate_random_params()

        σE, σI, τxE, τxI,
        κSEE, κSIE, κSEI, κSII,
        αEE, αIE, αEI, αII,
        κVEE, κVIE, κVEI, κVII,
        VsynEE, VsynIE, VsynEI, VsynII = params_out

        params1 = κSEE, κSIE, κSEI, κSII, αEE, αIE, αEI, αII,
        κVEE, κVIE, κVEI, κVII,
        VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI

        params2 = κSEE, κSIE, κSEI, κSII,
        αEE, αIE, αEI, αII,
        κVEE, κVIE, κVEI, κVII,
        VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E + rand(), η_0I + rand(), τE, τI

        eigs1 = get_eigenvalues(params1)
        eigs2 = get_eigenvalues(params2)

    end


    return params_out

end


function generate_random_params()
    parameters_out = zeros(20)
    #row 1 : sigE
    #row 2 : sigI
    #row 3 : tauxE
    #row 4 : tauxI
    #row 5-8 : kappaS
    #row 9-12 : alpha
    #row 13-16 : kappaV
    #row 17-20 : VsynAB


    parameters_out[1], parameters_out[3] = enforce_varience()

    parameters_out[2], parameters_out[4] = enforce_varience()
    parameters_out[5:8] .= random_number_generator(0.1, 8.0, 4)
    parameters_out[9:12] .= random_number_generator(0.1, 1.5, 4)
    parameters_out[13:16] .= random_number_generator(0.0, 0.5, 4)
    parameters_out[14] = parameters_out[15]
    parameters_out[17:18] .= random_number_generator(1, 20, 2)
    parameters_out[19:20] .= random_number_generator(-1, -20, 2)
    return parameters_out
end


function generate_population(size_pop::Int, const_params::ConstParams)
    #Generates a population of phenotypes near a hopf bifurcation
    phenotypes = []
    Threads.@threads for i = 1:size_pop
        println("Generating Parameters (", i, "/", size_pop, ")")
        push!(phenotypes, phenotype(P=generate_good_parameters(const_params)))

    end
    return phenotypes
end
