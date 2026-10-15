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
