# [Operators](@id operators)

!!! note "Planned"
    This page describes the planned `Recurrence` and `Convolution` operators.
    Its examples do not run yet.

An operator holds a kernel and the options that shape its steps.
It is built once and then called on its inputs like a function.

## Recurrence

`Recurrence(kernel; coupling = I, modifiers = ())` steps a value forward from its last `L` outputs.
At each time step `t` it computes

```math
\begin{aligned}
x_t &= P(\text{coupling}, \text{kernel}_t, y_{t-1}, \ldots, y_{t-L}) \\
v_t &= \text{gain}_t \odot x_t + \text{add}_t \\
(y_t, s_t) &= \text{modifiers}(v_t, s_{t-1})
\end{aligned}
```

`P` combines the lagged outputs through the kernel and the coupling.
`gain` scales the pressure and `add` adds an input at each step.
The modifiers run in order and thread their own state `s_t`.

## Convolution

`Convolution(kernel)` weights past inputs by a kernel.

```math
y_t = \sum_i \text{kernel}_{t,i} \odot x_{t-i}
```

## Calling an operator

<!-- becomes @example once Recurrence and Convolution land -->
```julia
r = Recurrence(kernel)
y = r(gain; history, add = nothing, return_state = false)

c = Convolution(kernel)
z = c(x; history = nothing)
```

`history` supplies the values before the first step.
`return_state = true` also returns the modifier state.

## Composing operators

A section on chaining operators, for example a renewal followed by a delay.
