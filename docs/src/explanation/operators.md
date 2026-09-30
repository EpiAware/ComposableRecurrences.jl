# [Operators](@id operators)

An operator holds a kernel and the coupling and modifiers that shape its steps.
You build it once, outside any model loop, and call it on its inputs like a function.

## Recurrence

`Recurrence(kernel; coupling = I, modifiers = ())` steps a value forward from its own past outputs.
At each time step `t` it computes

```math
\begin{aligned}
x_t &= \text{coupling}_t\Big(\sum_i \text{kernel}_t[i]\, y_{t-i}\Big) \\
v_t &= \text{gain}_t \odot x_t + \text{add}_t \\
(y_t, s_t) &= \text{modifiers}(v_t, s_{t-1})
\end{aligned}
```

`kernel[1]` weights `y_{t-1}`, because a value cannot depend on itself in the same step, so a recurrence has no lag 0.
`gain` scales the mixed convolution and `add` adds an input before the modifiers.
The modifiers run in tuple order and each threads its own state `s_t`.

```@example operators
using ComposableRecurrences

r = Recurrence([0.2, 0.5, 0.3])
y = r(fill(1.1, 10); history = fill(10.0, 3))
```

## Convolution

`Convolution(kernel)` weights the current and past inputs by a kernel.

```math
y_t = \sum_d \text{kernel}_t[d + 1]\, x_{t-d}
```

`kernel[1]` weights lag 0.

```@example operators
c = Convolution([0.1, 0.4, 0.3, 0.2])
c(y)
```

## Calling an operator

A recurrence is called as `r(gain = 1; history, state, add, start, stop)`.
A convolution is called as `c(x; history, start, stop)`.
Every time-indexed input is read at absolute time `t`, and a call covers `start:stop`.
`history` gives the values before `start`, and a history shorter than the kernel is zero-padded.

## The time base

Every time-indexed input (`gain`, `add`, `x`, and any `TimeVarying` kernel, coupling or parameter) is read at absolute time `t`.
`start` defaults to 1 and `stop` to the common length of the call's time-indexed inputs.
Inputs of different lengths without a `stop` are an error, and so is an input that does not cover `stop`.

```@example operators
try
    r(fill(1.1, 10); history = fill(10.0, 3), add = zeros(8))
catch err
    err
end
```

A call without a gain takes its length from `add`, or from `stop`.

```@example operators
walk = Recurrence([1.0])
walk(; history = [0.0], add = [0.5, -0.2, 0.1, 0.3])
```

## Starting and resuming

`with_state` takes the same arguments as a call and also returns a `State`.
Pass the state back as `state` to resume from where the call stopped.

```@example operators
using ComposableRecurrences: with_state

R = fill(1.1, 10)
y1, state = with_state(r, R; history = fill(10.0, 3), stop = 5)
y2 = r(R; state)
maximum(abs, vcat(y1, y2) .- r(R; history = fill(10.0, 3)))
```

## Seeded runs

`seeded(r, gain; history)` treats the history as the first outputs and returns them with the rest of the run.
`gain` covers the whole run, seed included.

```@example operators
using ComposableRecurrences: seeded

seeded(r, fill(1.1, 10); history = fill(10.0, 3))
```

## Prepending and trimming

Operators return only the steps they run.
They do not prepend the history or trim the output, so a model that wants either does it with ordinary array operations.

- A random walk or AR process that reports its starting values prepends them, `vcat(z0, rw(; history = [z0], add = ϵ))`.
- An MA(q) process reads its first `q` innovations from the input, so `c(ϵ)[(q + 1):end]` drops the days without a full window.
- A seed that belongs in the output is returned by `seeded`.

## Composing operators

An operator's output is an ordinary array, so operators chain by calling one on the output of another.

## Recomputing intermediate quantities

Operators do not record intermediate quantities.
Each step's pre-gain value is a convolution of the outputs, so it can be recomputed afterwards.
Prepending a zero to a recurrence kernel gives that convolution, lag 1 first.

```@example operators
foi = Convolution(vcat(0.0, [0.2, 0.5, 0.3]))
pre_gain = foi(y; history = fill(10.0, 3))
maximum(abs, 1.1 .* pre_gain .- y)
```

Times the gain, the recomputed values match the outputs to rounding error.
