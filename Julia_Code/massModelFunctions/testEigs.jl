using DifferentialEquations
using LinearAlgebra
using ForwardDiff
using Plots
include("stability.jl")

ΔE = 0.2;
ΔI = 0.2;
η_0E = 1.5;
η_0I = 1.5;
τE = 12;
τI = 15;

σE, σI, τxE, τxI,
κSEE, κSIE, κSEI, κSII,
αEE, αIE, αEI, αII,
κVEE, κVIE, κVEI, κVII,
VsynEE, VsynIE, VsynEI, VsynII = GenRandParams()


p = κSEE, κSIE, κSEI, κSII, αEE, αIE, αEI, αII,
κVEE, κVIE, κVEI, κVII,
VsynEE, VsynIE, VsynEI, VsynII, ΔE, ΔI, η_0E, η_0I, τE, τI


EIGS = get_EigenValues(p)

vals, vecs = get_EigValsAndVecs(p)

if maximum(real(EIGS)) > 0
    println("should be unstable")
else
    println("should be stable")
end
u0 = init_conds_SS(p) .+ 0.001
tspan = (0.0, 5000.0)

prob2 = ODEProblem(fdeterministic, u0, tspan, p)
sol2 = solve(prob2, saveat=4000:0.1:5000)

p1 = plot(sol2[1, :])
p2 = plot(sol2[2, :])

t0 = 0
tmax = 1
# time coordinate
t = t0:0.1/1000:tmax

# signal
signal = sol2[1, :] # sin (2π f t)

# Fourier Transform of it
F = fft(signal) |> fftshift
freqs = fftfreq(length(t), 1.0 / (0.1 / 1000)) |> fftshift

# plots
time_domain = plot(t, signal, title="Signal")
freq_domain = plot(freqs, abs.(F), title="Spectrum", xlim=(5, +100))
plot(time_domain, freq_domain, layout=2)

