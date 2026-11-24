# [FFT convolutions](@id extension-fftw)

Loading FFTW runs the lag sum of a [`Convolution`](@ref) with [`FFTMethod`](@ref ComposableRecurrences.FFTMethod).
It covers a fixed kernel on `Float32` or `Float64` arrays, and matches the direct method to a relative `1e-10`, or `1e-4` in `Float32`.
The default [`Auto()`](@ref ComposableRecurrences.Auto) method switches to it for a kernel of at least 300 lags over at least 1000 `Float64` outputs.

```jldoctest
using ComposableRecurrences, FFTW
using ComposableRecurrences: Direct, FFTMethod
kernel = exp.(-(0:399) ./ 50) ./ 50
x = abs.(sin.(1:2000))
Convolution(kernel; method = FFTMethod())(x) ≈
    Convolution(kernel; method = Direct())(x)

# output

true
```

The reverse pass runs inside the package's own rule, so no AD backend needs FFT rules.
