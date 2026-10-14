# PACKAGE-OWNED: the package loads and runs without precompiled modules. A
# generator sees only the methods defined before its generated function,
# which precompiled loading does not check, so a fresh process builds and
# calls recurrences with `--compiled-modules=no`.

@testitem "Loading: recurrences run without precompiled modules" tags = [:quality] begin
    script = """
    using ComposableRecurrences
    CR = ComposableRecurrences
    removals = TimeVarying(fill(1.0, 6))
    r = Recurrence([0.3, 0.5, 0.2]; modifiers = (CR.Depletion(100.0; removals),))
    r(fill(2.0, 6); history = [5.0])
    ward = CR.Pool(;
        stocks = (:U, :C), draw = nothing, flows = (
            CR.Flow(:U => :C, Derived(exp, -1.0)),
            CR.Flow(:C => 0, TimeVarying(fill(0.1, 4)); form = CR.Share()),
        )
    )
    leaky = CR.Pool(
        100.0; stocks = (:S, :V), draw = (:S => 1, :V => 0.3) => CR.Hazard(),
        flows = CR.Flow(:S => :V, 1.0; form = CR.Truncate())
    )
    Recurrence([0.3, 0.5, 0.2]; modifiers = (leaky,))(fill(2.0, 6); history = [5.0])
    add = [fill(1.0, 1, 4); zeros(1, 4)]
    Recurrence([1.0]; modifiers = (ward,))(; history = zeros(2, 1), add)
    beds = CR.Pool(
        10.0; stocks = (:O,), draw = CR.Truncate() => :O, flows_first = true,
        flows = CR.Flow(:O => 0, 0.2; form = CR.Share()), overflow = :stratum
    )
    Recurrence([1.0]; modifiers = (beds,))(fill(3.0, 2, 4); history = zeros(2, 1))
    print(Recurrence([0.5])(ones(3); history = [1.0]))
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --compiled-modules=no --startup-file=no
        --project=$project -e $script`
    @test read(cmd, String) == "[0.5, 0.25, 0.125]"
end
