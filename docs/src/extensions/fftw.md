# [FFTW extension](@id extension-fftw)

Loading FFTW runs the lag sum of a [`Convolution`](@ref) with [`FFTMethod`](@ref ComposableRecurrences.FFTMethod).
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

## Known issues

| Symptom | Workaround |
|---|---|
| Results differ from the direct method by up to `1e-10` relative, or `1e-4` in `Float32` | Pass `method = Direct()` where exact agreement matters |
| Only a fixed kernel on `Float32` or `Float64` arrays runs with it | Other kernels and types use the direct method |

The reverse pass runs inside the package's own rule, so no AD backend needs FFT rules.

All extensions are listed in the [overview](@ref extensions-overview).
