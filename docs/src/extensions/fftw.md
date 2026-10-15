# [FFTW extension](@id extension-fftw)

`ComposableRecurrencesFFTWExt` loads when FFTW and ComposableRecurrences are both loaded.
It runs the [`FFTMethod`](@ref ComposableRecurrences.FFTMethod) lag sum of a [`Convolution`](@ref).
That docstring says which calls take it and what accuracy to expect.
With the extension loaded, the default [`Auto()`](@ref ComposableRecurrences.Auto) method takes it for long kernels and series, as its docstring sets out.
Its reverse pass runs inside the package's own rule, so no backend needs FFT rules.
