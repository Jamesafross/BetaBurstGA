include("structures.jl")
function enforce_varience()
    sig = random_number_generator(0.001, 0.1, 1)
    tau = random_number_generator(30, 100, 1)

    while ((sig[1]^2) / (2 * (1 / tau[1])) > 0.1) | ((sig[1]^2) / (2 * (1 / tau[1])) < 0.01)
        sig = random_number_generator(0.001, 0.1, 1)
        tau = random_number_generator(30, 100, 1)
    end

    return sig[1], tau[1]
end

macro timeout(seconds, expr, fail)
    quote
        tsk = @task $expr
        schedule(tsk)
        Timer($seconds) do timer
            istaskdone(tsk) || Base.throwto(tsk, InterruptException())
        end
        try
            fetch(tsk)
        catch _
            $fail
        end
    end
end

x = @timeout 1.8 begin
    x = 1
    sleep(1.0)
    println("done")

end 8
