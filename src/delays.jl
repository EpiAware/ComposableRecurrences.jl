@doc raw"""
    delay_masses(k, lags)

The masses of a delay `k` on lags `0` to `lags - 1`, lag 0 first, as a
vector of length `lags`:

```math
\big(p_0, p_1, \dots, p_{L-1}\big), \qquad p_l = P(D = l),
```

where ``D`` is the delay in whole steps and ``L`` = `lags`.
A [`Convolution`](@ref) kernel is this vector.
A [`Recurrence`](@ref) kernel starts at lag 1, so it is the vector without
``p_0``.

The method for a vector returns it as it is, whatever `lags`.
A package that owns a delay type adds a method for that type:

  - it returns an `AbstractVector` of length `lags`, lag 0 first;
  - it builds the masses from the delay's parameters with differentiable
    operations, so that gradients reach those parameters through the
    kernel;
  - it does not normalise the masses or fold the mass past `lags - 1` into
    the last lag, since where a delay is cut is the caller's choice.

A delay on continuous time has masses only once a censoring choice turns it
into one on whole steps, so a method for it belongs with that choice.

# Arguments
- `k`: the delay, or a vector of masses.
- `lags`: the number of lags, from lag 0.

# Examples
```jldoctest
using ComposableRecurrences
k = [0.2, 0.5, 0.3]
ComposableRecurrences.delay_masses(k, 3) === k

# output

true
```
"""
delay_masses(k::AbstractVector, lags) = k
