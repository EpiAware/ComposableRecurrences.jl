# [FFTW extension](@id extension-fftw)

`ComposableRecurrencesFFTWExt` is loaded automatically when FFTW is available alongside ComposableRecurrences.

It computes the lag sum of a [`Convolution`](@ref) built with `method = ComposableRecurrences.FFTMethod()` through FFTW transforms; [`ComposableRecurrences.FFTMethod`](@ref) says which calls take it and what accuracy to expect.
Its reverse pass runs inside the package's own rule, so no backend needs FFT rules.
