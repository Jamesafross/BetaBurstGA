using DifferentialEquations,NLsolve,LinearAlgebra,Parameters,MAT,JLD,ProgressBars,NLsolve,Random,Test
HOMEDIR = homedir()

testdir = "$HOMEDIR/BetaBurstGA/tests"

test_gen = load("$testdir/test_data/Generation.jld","GenPop")

@testset "length" begin 
    @test length(test_gen) == 100
    @test length(test_gen[1].P) == 20
end


@testset "non-zeros phenotypes" begin
    for i = 1:100
        @test test_gen[i].P != zeros(20)
    end
end




