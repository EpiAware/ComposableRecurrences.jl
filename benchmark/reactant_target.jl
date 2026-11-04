# The Reactant targets of `matrix.jl`: the loss, or its Enzyme reverse-mode
# gradient, compiled by Reactant on the CPU. A Reactant worker includes this
# file after loading Reactant, so `matrix.jl` itself parses without it.
# `prep_s` is the compile time, which a Reactant user pays once for each
# size, and the timed run is the compiled call on parameters already on the
# device.

import Reactant, Enzyme, ForwardDiff

function _time_reactant!(row, f, θ, seconds, gradient)
    Reactant.set_default_backend("cpu")
    θr = Reactant.to_rarray(θ)
    # A loss may index its parameters as scalars; the package's own loops
    # allow it already.
    traced(θ) = Reactant.@allowscalar f(θ)
    call = gradient ? (θ -> Enzyme.gradient(Enzyme.Reverse, traced, θ)[1]) : traced
    t0 = time()
    c = Reactant.@compile call(θr)
    y = c(θr)
    row["prep_s"] = round(time() - t0; digits = 2)
    if !gradient
        row["relerr"] = relerr([Float64(Reactant.to_number(y))], [f(θ)])
        row["check"] = "plain Julia"
    elseif length(θ) <= FD_MAX
        row["relerr"] = relerr(Array(y), ForwardDiff.gradient(f, θ))
        row["check"] = "ForwardDiff"
    else
        row["check"] = "none"
    end
    b = @benchmark(
        Reactant.synchronize($c($θr));
        samples = 1000, evals = 1, seconds = seconds
    )
    return _record!(row, b)
end
