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
    ward = CR.Flows(
        CR.Flow(1 => 2, Derived(exp, -1.0)),
        CR.Flow(2 => 0, TimeVarying(fill(0.1, 4)); form = CR.Share()),
    )
    add = [fill(1.0, 1, 4); zeros(1, 4)]
    Recurrence([1.0]; modifiers = (ward,))(; history = zeros(2, 1), add)
    print(Recurrence([0.5])(ones(3); history = [1.0]))
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --compiled-modules=no --startup-file=no
        --project=$project -e $script`
    @test read(cmd, String) == "[0.5, 0.25, 0.125]"
end
