# Options are Symbols in the public API, resolved once at construction to
# a singleton type held as a type parameter, so no loop branches on them.

@doc "
The option named `name` in `family`, as the type instance a constructor
stores.

A constructor calls `option(Val(family), Val(name))` once, so a literal
Symbol resolves at compile time.
Add a method to give a family a new option, then implement that family's
interface for the returned type:

  - `:form` ([`Depletion`](@ref)): built-in `:hazard` and `:floor`;
    implement [`ComposableRecurrences.deplete`](@ref) and optionally
    [`ComposableRecurrences.deplete_pullback`](@ref).

An unknown name is an `ArgumentError` naming the built-in options.

# Arguments
- `family`: `Val` of the option family, such as `Val(:form)`.
- `name`: `Val` of the option's name.

# Examples
```@example
using ComposableRecurrences
CR = ComposableRecurrences
struct Linear end                     # take what is asked, up to the pool
CR.option(::Val{:form}, ::Val{:linear}) = Linear()
CR.deplete(::Linear, v, s, N, α) = (y = min(v, s); (y, s - y))
d = CR.Depletion(100.0; form = :linear)
Recurrence([0.5, 0.5]; modifiers = (d,))(fill(2.0, 8); history = [1.0, 2.0])
```
"
function option(::Val{family}, ::Val{name}) where {family, name}
    throw(ArgumentError(_unknown_option(Val(family), name)))
end

function _unknown_option(::Val{family}, name) where {family}
    return "unknown option :$name for :$family"
end
function _unknown_option(::Val{:form}, name)
    return "unknown form :$name for Depletion (built-in: :hazard, :floor). " *
        "Add one with ComposableRecurrences.option(::Val{:form}, " *
        "::Val{:$name}) = YourForm() and a deplete method."
end
