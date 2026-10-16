# PACKAGE-OWNED — scaffold writes this once and never overwrites it.
#
# Optional JET configuration for the isolated runner (test/jet/runtests.jl).
# If this file defines `JET_REPORT_FILTER` (a `report -> Bool` predicate; a
# report is kept when it returns `true`), the runner switches from
# `test_package` to `report_package` + filter and fails only on kept reports.
#
# Common need: a DynamicPPL `@model` package. JET emits a false
# `UndefVarErrorReport` for every `~`-assigned local (and `MethodErrorReport`s
# through the `:=` tracker), because the tilde macro hides the assignment
# from JET's static analysis. Uncomment to drop exactly those:
#
# const JET_REPORT_FILTER = dynamicppl_model_filter
#
# Or write your own predicate. No `JET_REPORT_FILTER` keeps the strict
# default (fail on any report).

# Checks that need JET loaded, run here so the main test environment does not
# depend on it: a step of each built-in depletion form compiles to one path,
# with no dispatch on the form at run time.
let CR = ComposableRecurrences
    for form in (CR.Hazard(), CR.Floor(), CR.Truncate(), CR.SoftTruncate(0.1))
        m = CR.Depletion(100.0, form)
        r = JET.@report_opt CR.forward(m, CR.Step(), 2.0, 80.0, 1, 1)
        reports = JET.get_reports(r)
        isempty(reports) || error("runtime dispatch in a $(typeof(form)) step: $r")
    end
    println("JET: each depletion form's step compiles to one path")
end

# The reverse pass of a `Recurrence` whose `Allocate` batches a dense
# pattern and spill kernel runs with no dispatch at run time: the per-pass
# buffers' types follow from the types alone.
let CR = ComposableRecurrences
    S, L, T = 5, 3, 8
    P = [i == j ? 0.0 : 0.1 * (i + j) for i in 1:S, j in 1:S]
    K = 0.2 .* P
    m = CR.Allocate(
        [1:2, 3:5], 6.0; imports = (0.3, P),
        spill = CR.Redistribute(K, PerStratum(fill(0.2, S)))
    )
    r = Recurrence([0.3, 0.2, 0.1]; modifiers = (m, CR.Add(0.1)))
    R, h = fill(1.2, S, T), ones(S, L)
    y, cache = CR._run_forward(r, R, nothing, h, nothing, 1, nothing)
    m̄ = (;
        imports = (;
            fraction = Ref(0.0), pattern = zero(P),
            spill = (; K = zero(K), ε = (; x = zeros(S))),
        ),
        total = Ref(0.0),
    )
    r̄ = (;
        gain = zeros(3), coupling = nothing, kernel = nothing,
        modifiers = (m̄, (; amount = Ref(0.0))),
    )
    args = (zero(R), nothing, zero(h), nothing, nothing, nothing)
    grads = (; piece = r̄, y = ones(size(y)), args)
    rep = JET.@report_opt target_modules = (CR,) CR._run_pullback!(grads, r, cache)
    reports = JET.get_reports(rep)
    isempty(reports) || error("runtime dispatch in the reverse pass with imports: $rep")
    println("JET: the reverse pass with batched imports compiles to one path")
end
