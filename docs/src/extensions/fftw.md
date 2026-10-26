# [FFTW extension](@id extension-fftw)

`ComposableRecurrencesFFTWExt` loads when FFTW and ComposableRecurrences are both loaded.
It runs the [`FFTMethod`](@ref ComposableRecurrences.FFTMethod) lag sum of a [`Convolution`](@ref).
It runs for a fixed kernel on `Float32` or `Float64` arrays, and matches the direct method to a relative accuracy of `1e-10`, or `1e-4` in `Float32`.
With the extension loaded, the default [`Auto()`](@ref ComposableRecurrences.Auto) method takes it for long kernels and series, as its docstring sets out.
Its reverse pass runs inside the package's own rule, so no backend needs FFT rules.
