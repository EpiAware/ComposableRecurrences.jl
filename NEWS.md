# News

## Unreleased

### Breaking

- A call on device arrays (GPU arrays, such as `CuArray` or `JLArray`) whose kernel, coupling, modifier parameters, gain or add input, or resumed state holds a host array is now an `ArgumentError`.
  Before, such a call ran its strata loops with the host arrays inside device kernels, which works on JLArrays but not on a GPU.
  To migrate, move kernels and parameters to the device first, for example with `Adapt.adapt(CuArray, r)`, which moves every parameter of an operator `r`, or `Recurrence(cu(g))`.
- A ragged `TimeVarying` kernel (a vector of columns) on device inputs is an `ArgumentError`, as its column offsets live on the host.

### New

- Every operator, coupling and built-in modifier runs its forward pass on GPU arrays, without scalar indexing.
  Dense and time-varying couplings use `mul!`, and device CSR couplings run one kernel per step.
  `Adapt.adapt` moves an operator's parameters to a device.
  The GPU arrays section of the adjoints and backends explanation says how each part runs on a device.
