# PACKAGE-OWNED: the package loads and runs without precompiled modules. A
# generator sees only the methods defined before its generated function,
# which precompiled loading does not check, so a fresh process builds and
# calls recurrences with `--compiled-modules=no`.

@testitem "Loading: recurrences run without precompiled modules" tags = [:quality] begin
    script = """
    using ComposableRecurrences
    using ComposableRecurrences: Derived
    CR = ComposableRecurrences
    removals = TimeVarying(fill(1.0, 6))
    removal = CR.Flow(:S => 0, removals; form = CR.Truncate())
    d = CR.Depletion(100.0, CR.Hazard(), removal)
    r = Recurrence([0.3, 0.5, 0.2]; modifiers = (d,))
    r(fill(2.0, 6); history = [5.0])
    ward = CR.Depletion(
        CR.Flow(:U => :C, Derived(exp, -1.0)),
        CR.Flow(:C => 0, TimeVarying(fill(0.1, 4)); form = CR.Share());
        pools = (:U, :C)
    )
    leaky = CR.Depletion(
        100.0, CR.Hazard(; weights = (S = 1, V = 0.3)),
        CR.Flow(:S => :V, 1.0; form = CR.Truncate()); pools = (:S, :V)
    )
    Recurrence([0.3, 0.5, 0.2]; modifiers = (leaky,))(fill(2.0, 6); history = [5.0])
    add = [fill(1.0, 1, 4); zeros(1, 4)]
    Recurrence([1.0]; modifiers = (ward,))(; history = zeros(2, 1), add)
    beds = CR.Depletion(
        10.0, CR.Flow(:O => 0, 0.2; form = CR.Share()),
        CR.Truncate(; into = :O, overflow = :stratum); pools = (:O,)
    )
    Recurrence([1.0]; modifiers = (beds,))(fill(3.0, 2, 4); history = zeros(2, 1))
    print(Recurrence([0.5])(ones(3); history = [1.0]))
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --compiled-modules=no --startup-file=no
        --project=$project -e $script`
    @test read(cmd, String) == "[0.5, 0.25, 0.125]"
end

# Without `ForwardDiff` loaded, built-in pieces keep their rules, a piece
# without a `pullback!` runs forward but its gradient says to load
# `ForwardDiff`, `PieceInterface`'s pullback check passes with a note, and
# once loaded the operator built before it checks its parts at the call.
@testitem "Loading: gradients without ForwardDiff" tags = [:quality] begin
    script = raw"""
    using ComposableRecurrences, Mooncake, DifferentiationInterface
    CR = ComposableRecurrences
    loaded(name) = any(k -> k.name == name, keys(Base.loaded_modules))
    println(loaded("ForwardDiff"))
    backend = AutoMooncake(; config = nothing)
    function fd(f, x; h = 1.0e-6)
        return map(eachindex(x)) do i
            e = zero(x)
            e[i] = h
            (f(x + e) - f(x - e)) / 2h
        end
    end
    builtin(θ) = Recurrence(θ[1:2]; modifiers = (CR.Depletion(50.0),))
    f(θ) = sum(builtin(θ)(fill(1.5, 6); history = [1.0, 2.0]))
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(f, backend, [0.3, 0.2])
    println(CR._PULLBACK_CALLS[] > n0, " ", isapprox(g, fd(f, [0.3, 0.2]); rtol = 1.0e-5))
    struct Cap{T}
        c::T
    end
    CR.blocks(::Cap) = (1, 1)
    function CR.forward!(m::Cap, ::CR.Step, v, s, t)
        for k in eachindex(v)
            v[k] = m.c * v[k] / (m.c + v[k])
        end
        return nothing
    end
    r = Recurrence([0.3, 0.2]; modifiers = (Cap(5.0),))
    println(r.rebuilds === nothing, " ", CR.uses_adjoint(r, CR.Run()))
    h(x) = sum(r(x; history = [1.0, 2.0]))
    x = fill(1.5, 6)
    println(round(h(x); digits = 6))
    msg = try
        gradient(h, backend, x)
        ""
    catch err
        sprint(showerror, err)
    end
    println(occursin("Cap has no `pullback!`", msg), " ",
        occursin("add `using ForwardDiff`", msg))
    using Interfaces
    unchecked = Interfaces.test(CR.PieceInterface{(:pullback,)}, CR.Clamp; show = false)
    using ForwardDiff
    n0 = CR._PULLBACK_CALLS[]
    g = gradient(h, backend, x)
    println(CR._PULLBACK_CALLS[] > n0, " ", isapprox(g, fd(h, x); rtol = 1.0e-5))
    println(Recurrence([0.3, 0.2]; modifiers = (Cap(5.0),)).rebuilds)
    println(unchecked)
    """
    project = Base.active_project()
    cmd = `$(Base.julia_cmd()) --startup-file=no --project=$project -e $script`
    lines = split(read(cmd, String), '\n'; keepempty = false)
    @test lines[1] == "false"
    @test lines[2] == "true true"
    @test lines[3] == "true true"
    @test parse(Float64, lines[4]) > 0
    @test lines[5] == "true true"
    @test lines[6] == "true true"
    @test lines[7] == "true"
    @test lines[8] == "true"
end
