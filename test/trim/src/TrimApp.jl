# A small app that runs the forward path of a few representative models, built
# with `juliac --trim=safe` to check that the package compiles without dynamic
# dispatch. It prints each model's checksums and exits non-zero on a mismatch.
module TrimApp

using ComposableRecurrences
using ComposableRecurrences: Depletion, Derived, Flow, Hazard, Recent, Threaded,
    Transform, Truncate, _Current, _each!

const GI = [0.1, 0.3, 0.3, 0.2, 0.1]
const T = 60

# Checksums of an output: its sum and its last value.
checksums(y::AbstractVector) = (sum(y), y[end])
checksums(y::AbstractMatrix) = (sum(y), y[end, end])

function renewal()
    R = [1.6 - 0.8 * (t > 30) for t in 1:T]
    return checksums(Recurrence(GI)(R; history = fill(5.0, 5)))
end

function convolution()
    x = [10.0 + sin(t / 5) for t in 1:T]
    delay = Convolution([0.0, 0.2, 0.4, 0.3, 0.1])
    return checksums(delay(x; gain = 0.4, history = fill(10.0, 4)))
end

function depletion_flows()
    N = 2_000.0
    doses = [t < 15 ? 0.0 : 40.0 for t in 1:T]
    pool = Depletion(
        N, Hazard(; weights = (S = 1, V = 0.3)),
        Flow(:S => :V, TimeVarying(doses); form = Truncate()),
        Flow(:V => :S, 1 / 20); pools = (:S, :V)
    )
    y = Recurrence(GI; modifiers = (pool,))(fill(1.8, T); history = [5.0])
    return checksums(y)
end

function transform_derived()
    N = 5_000.0
    response = Transform(*, Derived(exp, -10.0 / N * Recent(7)))
    r = Recurrence(GI; modifiers = (response, Depletion(N)))
    return checksums(r(fill(1.5, T); history = [5.0]))
end

function coupled()
    pop = [60_000.0, 25_000.0, 10_000.0]
    K = [0.98 0.015 0.005; 0.02 0.97 0.01; 0.01 0.02 0.97]
    seed = [fill(10.0, 1, 5); zeros(2, 5)]
    R = [1.8 - clamp((t - 40) / 6, 0, 1) for _ in 1:3, t in 1:T]
    r = Recurrence(GI; coupling = K, modifiers = (Depletion(PerStratum(pop)),))
    infections = r(R; history = seed)
    reports = Convolution([0.0, 0.3, 0.4, 0.3])(infections; gain = 0.4)
    return checksums(reports)
end

# A loop split into tasks. A trimmed build cannot set `EXECUTOR` with
# `with`, so the loop takes the executor as operators pass it.
function threaded_loop()
    y = zeros(T)
    square!(k, y) = (y[k] = k^2; nothing)
    _each!(square!, _Current(Threaded(; min_work = 0, ntasks = 2)), y, T, T, y)
    return checksums(y)
end

# Expected checksums, from the untrimmed run.
const EXPECTED = (
    renewal = (14312.180421651366, 75.49579395833648),
    convolution = (240.80891874123293, 3.663378885777023),
    depletion_flows = (1145.1167080354787, 0.003893786272316724),
    transform_derived = (958.5901518870926, 16.12111590713957),
    coupled = (26271.092770674793, 0.04407131537196616),
    threaded_loop = (73810.0, 3600.0),
)

function check(name::String, got::NTuple{2, Float64}, want::NTuple{2, Float64})
    ok = all(isapprox.(got, want; rtol = 1.0e-8))
    println(Core.stdout, ok ? "ok   " : "FAIL ", name, " ", got[1], " ", got[2])
    return ok
end

function (@main)(args::Vector{String})::Cint
    ok = check("renewal", renewal(), EXPECTED.renewal)
    ok &= check("convolution", convolution(), EXPECTED.convolution)
    ok &= check("depletion_flows", depletion_flows(), EXPECTED.depletion_flows)
    ok &= check("transform_derived", transform_derived(), EXPECTED.transform_derived)
    ok &= check("coupled", coupled(), EXPECTED.coupled)
    ok &= check("threaded_loop", threaded_loop(), EXPECTED.threaded_loop)
    return ok ? 0 : 1
end

end
