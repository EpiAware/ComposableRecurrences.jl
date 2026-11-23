# [Extension API](@id overview-extending)

Every name for a new type, with the arguments of each role; the [easy path](@ref extending) shows them in use.

## [Roles](@id extending-roles)

A role is one job a new type can do, named by a type with no fields.
A new type does its work in a [`forward!`](@ref ComposableRecurrences.forward!) method for each role it has, and may add a [`pullback!`](@ref ComposableRecurrences.pullback!) for each.
The role is the second argument of `forward!` and the third of `pullback!`, and selects the method by dispatch.

- [`Step()`](@ref ComposableRecurrences.Step) computes one step.
- [`Init()`](@ref ComposableRecurrences.Init) computes the starting state.
- [`Pressure()`](@ref ComposableRecurrences.Pressure) is a coupling's mixing.
- [`Trace()`](@ref ComposableRecurrences.Trace) is a modifier's record for a call with `record = (:trace,)`.

Both methods write their outputs in place and return `nothing`, and a method that returns anything else is an error.
`pullback!` receives the named tuple `grads`.
Its field `grads.piece` is the mirror, the cotangents of the type's own fields, laid out as [The gradient mirror](@ref extending-mirror) gives.
Its other fields hold the cotangents of the role's arguments.

| Type | `forward!` | `pullback!` | `grads` |
|---|---|---|---|
| modifier step | `forward!(m, Step(), v, s, t)` updates `v` and `s` | `pullback!(grads, m, Step(), v, s, t)` | the mirror; `v` and `s` hold the cotangents of `v′` and `s′`; overwrite them with those of `v` and `s` |
| initial state | `forward!(m, Init(), s, history)` writes `s` | `pullback!(grads, m, Init(), s, history)` | the mirror; `s` holds the cotangent of `s`; add into `history`, which may be `nothing` |
| coupling | `forward!(C, Pressure(), q, p, t)` writes `q` | `pullback!(grads, C, Pressure(), q, p, t)`, with `q === nothing` | the mirror; `q` holds the cotangent of `q`; add into `p` |

The rows for a [blockwise step](@ref extending-blockwise), a [trace](@ref extending-trace-own) and a [form](@ref extending-form-pullback) are on their pages; the arguments mean the same in every role:

- `t` is the absolute time, counted from 1 as `start` and `stop` are.
- `v` holds one value per [stratum](@ref overview-step), indexed by stratum, and `s` is the modifier's state after the previous step, with [`nstate`](@ref ComposableRecurrences.nstate) entries.
- `history` is the call's `history` as given: a vector for one series, else strata × time.
  Without an `Init` method the state starts at zero, and no `Init` pullback is needed.

## [Names](@id extending-names)

| Name | What it does | Returns |
|:--|:--|:--|
| [`ntrace(m, S)`](@ref ComposableRecurrences.ntrace) | how many rows a modifier's trace has | `Int` |
| [`blocks(m)`](@ref ComposableRecurrences.blocks) | a modifier's groups of strata | a tuple, or `nothing` |
| [`nstate(m, S)`](@ref ComposableRecurrences.nstate) | the number of state entries a modifier keeps for `S` strata | `Int` |
| [`isstateless(m)`](@ref ComposableRecurrences.isstateless) | whether a modifier leaves its state unchanged, so it records no trace | `Bool` |
| [`islinear(x)`](@ref ComposableRecurrences.islinear) | whether a coupling or whole-step modifier is a matrix, so a call runs that matrix in its place | `Bool` |
| [`param(x, k, t)`](@ref ComposableRecurrences.param) | reads a parameter for stratum `k` at time `t` | a value |
| [`add_param!(x̄, x, v, k, t)`](@ref ComposableRecurrences.add_param!) | adds to a parameter's cotangent | `nothing` |
| [`cotangent(x̄, name)`](@ref ComposableRecurrences.cotangent) | the cotangent of a field | a cotangent, or `nothing` |
| [`add_cotangent!(x̄, v, idx...)`](@ref ComposableRecurrences.add_cotangent!) | adds to a cotangent | `nothing` |
| [`PieceInterface`](@ref ComposableRecurrences.PieceInterface) | the conformance test for a new type, built on the Interfaces.jl package | a test result |

## [Checking your type](@id overview-gradients)

`PieceInterface` takes one `Arguments` per role the type has, each holding the type, the role and the arguments after the role:

- `(s, history)` for `Init()`;
- `(v, s, t)`, with vectors, for a modifier's `Step()`;
- `(q, p, t)` for `Pressure()`;
- `(v, s, N)`, with a float `N`, for a depletion form;
- `(r, v, s, v′, s′, t)` for `Trace()`, with `r` as [Traces](@ref extending-trace-own) gives.
  A blockwise group takes `g` after `t`, and its arguments are tuples of `Ref`s.

It also checks that the rule finds any `pullback!` the type has.
The optional checks are `:pointwise` and `:nstate` for a pointwise step and the state length, `:blocks` for a blockwise step and `:pullback`.
The `:pullback` check compares each `pullback!` for `Step()` or `Pressure()` with the ForwardDiff Jacobian of `forward!` on the same inputs, so it needs `using ForwardDiff`.

[`NoAdjoint(op)`](@ref ComposableRecurrences.NoAdjoint) is the same operator differentiated by automatic differentiation instead of its [rule](@ref adjoints-backends), so its gradient checks the rule's and timing both compares their cost.

The names below are internal helpers.
They help check a new type, but they may change without notice.

| Name | What it does | Returns |
|:--|:--|:--|
| [`ComposableRecurrences.uses_adjoint(m, role)`](@ref ComposableRecurrences.uses_adjoint) | whether the rule calls `m`'s `pullback!` for `role` | `Bool` |
| [`ComposableRecurrences.Run()`](@ref ComposableRecurrences.Run) | the role of an operator's whole call | a type with no fields |
| [`ComposableRecurrences.test_adjoint(backend, op, ComposableRecurrences.Run(), args...)`](@ref ComposableRecurrences.test_adjoint) | runs the rule tester of an automatic differentiation package on an operator's rule | a test result |

For an operator, pass `Run()` as the role to `uses_adjoint`, `PieceInterface` and `test_adjoint`.
`test_adjoint` needs Mooncake, or Enzyme with EnzymeTestUtils, loaded.
