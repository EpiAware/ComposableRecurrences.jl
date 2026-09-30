# [Couplings](@id couplings)

A coupling mixes the strata's kernel convolutions before the gain is applied.
The default `I` keeps strata independent.

## Fixed mixing

Any `S × S` matrix is a coupling, and `C[a, b]` weights stratum `b`'s convolution into stratum `a`.
So a row is the stratum being infected and a column the stratum infecting it.
With `C = [1 0; 1 0]` both strata are driven by stratum 1 alone.

```@example couplings
using ComposableRecurrences

Recurrence([1.0]; coupling = [1.0 0.0; 1.0 0.0])(2.0; history = [1.0; 5.0;;], stop = 3)
```


```@example couplings
K = [0.9 0.1; 0.2 0.8]
r = Recurrence([0.2, 0.5, 0.3]; coupling = K)
r(1.1; history = [10.0 10.0 10.0; 0.0 0.0 0.0], stop = 6)
```

A sparse matrix or a `Diagonal` runs its own fast path.

```@example couplings
using SparseArrays

Ks = sparse([1, 2, 2, 3], [1, 1, 2, 3], [0.9, 0.1, 1.0, 1.0])
Recurrence([0.2, 0.5, 0.3]; coupling = Ks)(1.1; history = ones(3, 3), stop = 4)
```

## Mixing over time

`TimeVarying` takes an `S × S × T` array and uses its `t`-th slice at time `t`.

```@example couplings
Kt = cat([[1.0 0.1t; 0.1t 1.0] for t in 1:4]...; dims = 3)
Recurrence([0.5, 0.5]; coupling = TimeVarying(Kt))(1.0; history = ones(2, 2), stop = 4)
```

## Mixing by lag

When the mixing depends on the lag, use a `Pairwise` kernel instead of a coupling.
See [Shapes and coefficients](@ref shapes).

## Adding a coupling

A coupling is any struct with `forward(C, Pressure(), q, p, t)`, which writes the mixed convolutions into `q`.
This one sends a fixed share of every stratum's convolution to the first stratum.

```@example couplings
struct ToFirst
    share::Float64
end
function ComposableRecurrences.forward(C::ToFirst, ::ComposableRecurrences.Pressure, q, p, t)
    q .= (1 - C.share) .* p
    q[1] += C.share * sum(p)
    return nothing
end

r = Recurrence([0.5, 0.5]; coupling = ToFirst(0.2))
r(1.0; history = [1.0 1.0; 1.0 1.0], stop = 4)
```
