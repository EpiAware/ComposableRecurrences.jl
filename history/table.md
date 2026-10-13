|                                                                                                          | v0.1.0              | 9699ecd276b068...   | v0.1.0 / 9699ecd276b068... |
|:---------------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                               | 0.0684 ± 0.0081 ms  | 0.0658 ± 0.0086 ms  | 1.04 ± 0.18                |
| AD gradients/Convolution delay with history/Enzyme reverse                                               | 29.9 ± 0.63 μs      | 28.3 ± 0.69 μs      | 1.06 ± 0.034               |
| AD gradients/Convolution delay with history/ForwardDiff                                                  | 9.19 ± 1.6 μs       | 6.87 ± 1.8 μs       | 1.34 ± 0.41                |
| AD gradients/Convolution delay with history/Mooncake forward                                             | 0.224 ± 0.039 ms    | 0.236 ± 0.0098 ms   | 0.95 ± 0.17                |
| AD gradients/Convolution delay with history/Mooncake reverse                                             | 0.0515 ± 0.0018 ms  | 0.0378 ± 0.0011 ms  | 1.36 ± 0.061               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                                  | 0.242 ± 0.013 ms    | 0.237 ± 0.024 ms    | 1.02 ± 0.12                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                                  | 0.0415 ± 0.0012 ms  | 0.0361 ± 0.0042 ms  | 1.15 ± 0.14                |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                                     | 0.0347 ± 0.0037 ms  | 0.0319 ± 0.0016 ms  | 1.09 ± 0.13                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                                | 1.02 ± 0.031 ms     | 0.897 ± 0.014 ms    | 1.14 ± 0.039               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                                | 0.0654 ± 0.0042 ms  | 0.0421 ± 0.0012 ms  | 1.55 ± 0.11                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                            | 0.326 ± 0.015 ms    | 0.367 ± 0.054 ms    | 0.888 ± 0.14               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                            | 0.0357 ± 0.00078 ms | 0.0394 ± 0.0033 ms  | 0.906 ± 0.078              |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                               | 0.043 ± 0.0076 ms   | 0.0649 ± 0.0048 ms  | 0.662 ± 0.13               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                          | 1.24 ± 0.064 ms     | 1.03 ± 0.029 ms     | 1.2 ± 0.071                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                          | 0.0652 ± 0.0048 ms  | 0.0816 ± 0.0044 ms  | 0.8 ± 0.073                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                              | 0.626 ± 0.09 ms     | 0.567 ± 0.025 ms    | 1.1 ± 0.17                 |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                              | 30.1 ± 1.3 μs       | 25.9 ± 0.74 μs      | 1.16 ± 0.059               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                                 | 0.0831 ± 0.0056 ms  | 0.0761 ± 0.081 ms   | 1.09 ± 1.2                 |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                            | 1.8 ± 0.53 ms       | 1.22 ± 0.53 ms      | 1.47 ± 0.77                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                            | 0.0575 ± 0.0028 ms  | 0.0333 ± 0.0011 ms  | 1.73 ± 0.1                 |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                              | 0.31 ± 0.019 ms     | 0.355 ± 0.45 ms     | 0.874 ± 1.1                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                             | 0.37 ± 0.29 ms      | 0.374 ± 0.29 ms     | 0.989 ± 1.1                |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                                | 7.86 ± 1 ms         | 7.58 ± 0.11 ms      | 1.04 ± 0.14                |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                           | 0.0349 ± 0.0006 s   | 0.0348 ± 9.1e-05 s  | 1 ± 0.017                  |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                                 | 1.56 ± 0.051 ms     | 0.293 ± 0.014 ms    | 5.3 ± 0.3                  |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                                    | 0.0666 ± 0.017 s    | 31 ± 11 ms          | 2.15 ± 0.92                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 1.35 ± 0.041 ms     | 0.317 ± 0.015 ms    | 4.25 ± 0.24                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 30.1 ± 12 μs        | 9.79 ± 6.4 μs       | 3.07 ± 2.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 0.422 ± 0.05 ms     | 0.296 ± 0.44 ms     | 1.43 ± 2.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.0604 ± 0.0042 ms  | 16.7 ± 2.5 μs       | 3.62 ± 0.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.0605 ± 0.013 ms   | 0.037 ± 0.0063 ms   | 1.63 ± 0.45                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 0.446 ± 0.022 ms    | 0.387 ± 0.31 ms     | 1.15 ± 0.93                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.108 ± 0.0067 ms   | 0.054 ± 0.0083 ms   | 2 ± 0.33                   |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 0.595 ± 0.015 ms    | 0.0656 ± 0.0035 ms  | 9.07 ± 0.54                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 19 ± 9.7 ms         | 10.7 ± 3.6 ms       | 1.78 ± 1.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 0.601 ± 0.041 ms    | 0.0893 ± 0.0019 ms  | 6.73 ± 0.48                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.0969 ± 0.016 ms   | 0.0524 ± 0.0092 ms  | 1.85 ± 0.44                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 2.77 ± 0.041 ms     | 0.75 ± 0.63 ms      | 3.69 ± 3.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 0.142 ± 0.03 ms     | 0.0809 ± 0.0039 ms  | 1.75 ± 0.38                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 0.922 ± 0.053 ms    | 0.151 ± 0.013 ms    | 6.09 ± 0.61                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 0.0721 ± 0.00095 s  | 0.0362 ± 0.00028 s  | 1.99 ± 0.03                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 0.849 ± 0.026 ms    | 0.23 ± 0.012 ms     | 3.7 ± 0.22                 |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 1.05 ± 0.034 ms     | 1.01 ± 0.018 ms     | 1.04 ± 0.039               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.138 ± 0.012 ms    | 0.129 ± 0.0056 ms   | 1.07 ± 0.11                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.117 ± 0.025 ms    | 0.399 ± 0.02 ms     | 0.293 ± 0.065              |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 3.24 ± 0.47 ms      | 3.84 ± 0.097 ms     | 0.843 ± 0.12               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 0.17 ± 0.0086 ms    | 0.15 ± 0.015 ms     | 1.13 ± 0.13                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 0.107 ± 0.0097 ms   | 0.0679 ± 0.0063 ms  | 1.57 ± 0.2                 |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 12.8 ± 2.1 μs       | 5.4 ± 0.55 μs       | 2.37 ± 0.46                |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 29.2 ± 4.6 μs       | 25.6 ± 1.6 μs       | 1.14 ± 0.19                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 0.847 ± 0.027 ms    | 0.384 ± 0.1 ms      | 2.21 ± 0.61                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 0.0389 ± 0.0027 ms  | 16.7 ± 2.3 μs       | 2.32 ± 0.36                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme forward                     | 0.436 ± 0.02 ms     | 0.296 ± 0.023 ms    | 1.47 ± 0.13                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme reverse                     | 0.103 ± 0.0071 ms   | 0.0601 ± 0.0032 ms  | 1.72 ± 0.15                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/ForwardDiff                        | 0.0738 ± 0.0089 ms  | 0.0935 ± 0.0042 ms  | 0.79 ± 0.1                 |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake forward                   | 1.68 ± 0.19 ms      | 1.4 ± 0.026 ms      | 1.21 ± 0.14                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake reverse                   | 0.147 ± 0.0079 ms   | 0.0949 ± 0.0045 ms  | 1.55 ± 0.11                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward             | 0.43 ± 0.021 ms     | 0.286 ± 0.021 ms    | 1.5 ± 0.13                 |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse             | 0.0827 ± 0.0059 ms  | 0.0586 ± 0.0033 ms  | 1.41 ± 0.13                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff                | 0.0956 ± 0.012 ms   | 0.0597 ± 0.0036 ms  | 1.6 ± 0.23                 |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward           | 1.8 ± 0.18 ms       | 1.29 ± 0.022 ms     | 1.4 ± 0.14                 |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse           | 0.133 ± 0.0082 ms   | 0.0929 ± 0.0043 ms  | 1.43 ± 0.11                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                        | 0.244 ± 0.029 ms    | 0.204 ± 0.011 ms    | 1.2 ± 0.16                 |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                        | 0.0501 ± 0.001 ms   | 0.0439 ± 0.0031 ms  | 1.14 ± 0.085               |
| AD gradients/Recurrence in Float32/ForwardDiff                                                           | 0.0488 ± 0.022 ms   | 0.0378 ± 0.0036 ms  | 1.29 ± 0.6                 |
| AD gradients/Recurrence in Float32/Mooncake forward                                                      | 0.825 ± 0.049 ms    | 0.693 ± 0.019 ms    | 1.19 ± 0.078               |
| AD gradients/Recurrence in Float32/Mooncake reverse                                                      | 0.083 ± 0.0021 ms   | 0.0667 ± 0.0047 ms  | 1.24 ± 0.093               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                                   | 0.393 ± 0.048 ms    | 0.36 ± 0.038 ms     | 1.09 ± 0.18                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.0697 ± 0.0052 ms  | 0.0389 ± 0.0011 ms  | 1.79 ± 0.14                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.069 ± 0.0088 ms   | 0.0923 ± 0.005 ms   | 0.747 ± 0.1                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 1.37 ± 0.024 ms     | 1.56 ± 0.024 ms     | 0.876 ± 0.02               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.0905 ± 0.0042 ms  | 0.052 ± 0.0016 ms   | 1.74 ± 0.096               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 0.417 ± 0.033 ms    | 0.282 ± 0.017 ms    | 1.48 ± 0.15                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.0582 ± 0.0052 ms  | 0.0513 ± 0.0039 ms  | 1.13 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.0695 ± 0.014 ms   | 0.0499 ± 0.0036 ms  | 1.39 ± 0.31                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 1.12 ± 0.064 ms     | 1.09 ± 0.053 ms     | 1.03 ± 0.077               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 0.0902 ± 0.0052 ms  | 0.0777 ± 0.0057 ms  | 1.16 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.0688 ± 0.0019 ms  | 0.0704 ± 0.0024 ms  | 0.979 ± 0.043              |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 0.0377 ± 0.0039 ms  | 0.037 ± 0.0027 ms   | 1.02 ± 0.13                |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 13.1 ± 2 μs         | 11.8 ± 2.6 μs       | 1.11 ± 0.29                |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 0.217 ± 0.019 ms    | 0.211 ± 0.0093 ms   | 1.03 ± 0.1                 |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.0685 ± 0.0051 ms  | 0.0499 ± 0.0035 ms  | 1.37 ± 0.14                |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 0.332 ± 0.033 ms    | 0.304 ± 0.016 ms    | 1.09 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.075 ± 0.0054 ms   | 0.072 ± 0.0027 ms   | 1.04 ± 0.085               |
| AD gradients/Recurrence returning its state/ForwardDiff                                                  | 0.0654 ± 0.011 ms   | 0.0627 ± 0.0036 ms  | 1.04 ± 0.18                |
| AD gradients/Recurrence returning its state/Mooncake forward                                             | 1.64 ± 0.045 ms     | 1.2 ± 0.025 ms      | 1.37 ± 0.047               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                             | 0.116 ± 0.005 ms    | 0.0978 ± 0.0047 ms  | 1.18 ± 0.077               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                              | 0.135 ± 0.0098 ms   | 0.121 ± 0.013 ms    | 1.12 ± 0.15                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                              | 26.7 ± 0.77 μs      | 0.0393 ± 0.0011 ms  | 0.679 ± 0.028              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                                 | 27.2 ± 1.8 μs       | 26.6 ± 2.4 μs       | 1.02 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                            | 0.406 ± 0.12 ms     | 0.354 ± 0.014 ms    | 1.15 ± 0.33                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                            | 0.0524 ± 0.0033 ms  | 0.0505 ± 0.0053 ms  | 1.04 ± 0.13                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                                   | 0.282 ± 0.048 ms    | 0.233 ± 0.015 ms    | 1.21 ± 0.22                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                                   | 0.075 ± 0.0037 ms   | 0.0431 ± 0.0028 ms  | 1.74 ± 0.14                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                                      | 0.0327 ± 0.0019 ms  | 0.0397 ± 0.0033 ms  | 0.822 ± 0.083              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                                 | 0.788 ± 0.15 ms     | 0.829 ± 0.025 ms    | 0.95 ± 0.18                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                                 | 0.0918 ± 0.0088 ms  | 0.0718 ± 0.0044 ms  | 1.28 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 0.424 ± 0.022 ms    | 0.35 ± 0.02 ms      | 1.21 ± 0.093               |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.0926 ± 0.0053 ms  | 0.0548 ± 0.0032 ms  | 1.69 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.0919 ± 0.016 ms   | 0.0627 ± 0.0032 ms  | 1.47 ± 0.26                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 1.92 ± 0.21 ms      | 1.39 ± 0.026 ms     | 1.38 ± 0.16                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 0.161 ± 0.0074 ms   | 0.0946 ± 0.0046 ms  | 1.71 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                                  | 1.17 ± 0.27 ms      | 1.19 ± 0.037 ms     | 0.983 ± 0.23               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                                  | 0.0611 ± 0.0052 ms  | 0.0494 ± 0.0017 ms  | 1.24 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                                     | 0.135 ± 0.0089 ms   | 0.15 ± 0.018 ms     | 0.901 ± 0.12               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                                | 3.82 ± 0.75 ms      | 3.56 ± 0.49 ms      | 1.07 ± 0.26                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                                | 0.0997 ± 0.011 ms   | 0.0764 ± 0.0056 ms  | 1.31 ± 0.17                |
| Convolution body/BLAS axpy per lag                                                                       | 0.776 ± 0.0034 μs   | 0.78 ± 0.0045 μs    | 0.995 ± 0.0072             |
| Convolution body/native axpy per lag                                                                     | 0.497 ± 0.0062 μs   | 0.493 ± 0.0062 μs   | 1.01 ± 0.018               |
| Convolution body/package                                                                                 | 0.776 ± 0.0034 μs   | 0.359 ± 0.0044 μs   | 2.16 ± 0.028               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                                  | 0.0721 ± 0.0016 ms  | 0.0516 ± 0.001 ms   | 1.4 ± 0.041                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                                 | 4.48 ± 0.29 μs      | 4.09 ± 0.3 μs       | 1.1 ± 0.11                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                                | 2.68 ± 1.6 μs       | 2.26 ± 0.45 μs      | 1.18 ± 0.76                |
| Evaluation/Matrix overview T200_L20_S3                                                                   | 0.0409 ± 0.015 ms   | 23.2 ± 1.5 μs       | 1.77 ± 0.64                |
| Evaluation/Matrix renewal T200_L20_S1                                                                    | 10.1 ± 1.8 μs       | 10.3 ± 1.8 μs       | 0.981 ± 0.25               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                              | 0.0504 ± 0.0019 ms  | 0.0335 ± 0.00069 ms | 1.51 ± 0.064               |
| AD gradients/Recurrence removals from recent outputs/Enzyme reverse                                      |                     | 0.0437 ± 0.0032 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/FFT forward                                                          |                     | 25.8 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                           |                     | 0.147 ± 0.0085 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse                   |                     | 0.0508 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/ForwardDiff                              |                     | 0.0458 ± 0.0067 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward                     |                     | 2.47 ± 0.098 ms     |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake forward                     |                     | 5.61 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                  |                     | 0.0444 ± 0.0012 ms  |                            |
| Convolution methods/S 1 T 200 L 64/FFT Mooncake gradient                                                 |                     | 24.9 ± 4 μs         |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward   |                     | 0.282 ± 0.018 ms    |                            |
| Convolution methods/S 1 T 300 L 60/FFT forward                                                           |                     | 7.86 ± 0.45 μs      |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme reverse                              |                     | 0.0679 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                                      |                     | 0.416 ± 0.017 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                                   |                     | 0.0706 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff                     |                     | 0.0485 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake forward                        |                     | 1.14 ± 0.027 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward                      |                     | 0.371 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                                 |                     | 0.862 ± 0.0073 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse        |                     | 17.7 ± 0.49 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                              |                     | 1.94 ± 0.028 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                                     |                     | 0.29 ± 0.015 ms     |                            |
| Convolution methods/S 1 T 200 L 64/Direct forward                                                        |                     | 3.22 ± 0.48 μs      |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake reverse                                       |                     | 0.101 ± 0.003 ms    |                            |
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                     | 7.69 ± 1 μs         |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                     | 2.69 ± 0.048 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake reverse            |                     | 1.74 ± 0.019 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                       |                     | 0.0523 ± 0.0036 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                              |                     | 1.2 ± 0.23 ms       |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                              |                     | 0.0712 ± 0.0082 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse               |                     | 0.0631 ± 0.0018 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake forward                         |                     | 1.28 ± 0.033 ms     |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward |                     | 1.25 ± 0.036 ms     |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                        |                     | 4.6 ± 0.08 ms       |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake forward                            |                     | 1.98 ± 0.035 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                     | 0.0517 ± 0.0029 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                     | 0.0946 ± 0.0027 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/ForwardDiff                                 |                     | 0.0866 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme reverse                          |                     | 0.0596 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff      |                     | 0.0595 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                        |                     | 1.04 ± 0.026 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                          |                     | 0.118 ± 0.0058 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake forward                                  |                     | 1.21 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                        |                     | 0.239 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse |                     | 0.114 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                              |                     | 0.228 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme forward                 |                     | 0.288 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake reverse         |                     | 0.121 ± 0.0072 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                     | 0.143 ± 0.0099 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                     | 0.0675 ± 0.0015 ms  |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                     | 0.663 ± 0.047 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                     | 3.52 ± 0.27 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                     | 0.463 ± 0.019 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                     | 0.0851 ± 0.0032 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                     | 0.228 ± 0.013 ms    |                            |
| AD gradients/Recurrence protected pool in Float32/ForwardDiff                                            |                     | 0.118 ± 0.0049 ms   |                            |
| AD gradients/Recurrence removals from recent outputs/ForwardDiff                                         |                     | 0.0512 ± 0.033 ms   |                            |
| Convolution methods/S 1 T 2000 L 100/Direct forward                                                      |                     | 0.0375 ± 0.0038 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                                |                     | 0.067 ± 0.0015 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                            |                     | 0.095 ± 0.0056 ms   |                            |
| Convolution methods/S 50 T 200 L 64/Direct forward                                                       |                     | 0.087 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                                |                     | 0.164 ± 0.0094 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme reverse                           |                     | 0.0431 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                                    |                     | 1.97 ± 0.36 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                                   |                     | 1.33 ± 0.051 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward            |                     | 2.75 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake reverse                             |                     | 0.17 ± 0.0074 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                                 |                     | 0.0832 ± 0.0026 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                                |                     | 0.909 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme reverse                 |                     | 0.062 ± 0.0013 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                           |                     | 1.15 ± 0.031 ms     |                            |
| Convolution methods/S 1 T 2000 L 32/Direct forward                                                       |                     | 9.76 ± 0.47 μs      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward                      |                     | 0.856 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                       |                     | 1.52 ± 0.044 ms     |                            |
| Convolution methods/S 1 T 300 L 60/Direct forward                                                        |                     | 2.67 ± 0.23 μs      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward                    |                     | 1.74 ± 0.29 μs      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                              |                     | 1.16 ± 0.13 ms      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                         |                     | 0.0402 ± 0.0016 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                          |                     | 0.553 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/ForwardDiff                    |                     | 0.0668 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                                 |                     | 0.248 ± 0.025 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                                |                     | 0.0465 ± 0.00095 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                       |                     | 25.5 ± 19 μs        |                            |
| Convolution methods/S 1 T 300 L 60/Direct Mooncake gradient                                              |                     | 15.4 ± 0.53 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                        |                     | 0.0644 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse                 |                     | 0.0425 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse                    |                     | 0.144 ± 0.018 ms    |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                              |                     | 1.12 ± 0.028 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse                  |                     | 0.0372 ± 0.00078 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                                    |                     | 0.602 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                                 |                     | 0.0419 ± 0.0034 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                             |                     | 0.0726 ± 0.012 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme reverse                                 |                     | 0.114 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                         |                     | 0.0766 ± 0.0054 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                     | 0.629 ± 0.046 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                     | 1.98 ± 0.079 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                     | 0.133 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                     | 0.253 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                     | 0.167 ± 0.006 ms    |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                     | 0.0511 ± 0.0013 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                     | 0.104 ± 0.0033 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                     | 4.72 ± 0.4 ms       |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                     | 0.0721 ± 0.0039 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                     | 0.0325 ± 0.0047 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                     | 0.113 ± 0.0041 ms   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                     | 0.108 ± 0.0078 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                     | 0.0647 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                     | 0.213 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                     | 25.9 ± 1.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                     | 0.0859 ± 0.0073 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                     | 3.76 ± 0.45 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                     | 0.263 ± 0.018 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                     | 0.354 ± 0.059 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                     | 0.155 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                     | 0.0733 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake forward            |                     | 8.85 ± 0.091 ms     |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/ForwardDiff                           |                     | 0.167 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                     | 1.16 ± 0.084 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                     | 1.05 ± 0.019 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                     | 3.8 ± 0.21 ms       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                     | 13.4 ± 0.74 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                     | 0.039 ± 0.00093 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                     | 0.0683 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                     | 0.343 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                     | 0.144 ± 0.0059 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                     | 0.285 ± 0.019 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                     | 0.449 ± 0.019 ms    |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                     | 14.9 ± 1.7 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                     | 0.267 ± 0.016 ms    |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                     | 1.57 ± 0.059 ms     |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                     | 0.0738 ± 0.0021 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                           |                     | 0.251 ± 0.023 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/ForwardDiff                              |                     | 0.0683 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake reverse                     |                     | 0.191 ± 0.014 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                                |                     | 0.243 ± 0.017 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                             |                     | 0.0504 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                                   |                     | 0.0527 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                       |                     | 0.0908 ± 0.0022 ms  |                            |
| Convolution methods/S 1 T 200 L 32/FFT Mooncake gradient                                                 |                     | 27.1 ± 3.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme reverse                    |                     | 0.0806 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                             |                     | 0.074 ± 0.0047 ms   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                              |                     | 0.0646 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                         |                     | 0.362 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake reverse                          |                     | 0.143 ± 0.0065 ms   |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme forward                               |                     | 0.679 ± 0.066 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                     | 0.144 ± 0.0059 ms   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                     | 0.134 ± 0.0065 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                     | 0.157 ± 0.0073 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                     | 30.6 ± 0.79 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                     | 0.0894 ± 0.047 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                     | 0.941 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                     | 0.0318 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                     | 0.0653 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                     | 0.108 ± 0.0027 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                     | 0.638 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                     | 1.83 ± 0.065 ms     |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                     | 0.0689 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                     | 1.72 ± 0.26 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                     | 0.0427 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                     | 0.0887 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                     | 0.0567 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                     | 0.103 ± 0.006 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                     | 0.0905 ± 0.0025 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                     | 2.93 ± 0.18 ms      |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                     | 1.65 ± 0.24 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                     | 1.05 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                     | 0.0588 ± 0.0046 ms  |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                     | 0.473 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                     | 0.0428 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme reverse              |                     | 1.97 ± 0.021 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                     | 0.0594 ± 0.0014 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                     | 0.0973 ± 0.0027 ms  |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme forward                                         |                     | 0.594 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme reverse                  |                     | 6.61 ± 0.89 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward                      |                     | 0.34 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                            |                     | 0.0412 ± 0.005 ms   |                            |
| Convolution methods/S 1 T 300 L 60/FFT Mooncake gradient                                                 |                     | 28.8 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme reverse                            |                     | 0.123 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                        |                     | 0.261 ± 0.088 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/ForwardDiff                             |                     | 0.0498 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake forward         |                     | 1.34 ± 0.034 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                            |                     | 0.0875 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                      |                     | 0.0898 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse                      |                     | 0.0601 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                          |                     | 0.352 ± 0.017 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                                |                     | 0.409 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                         |                     | 0.0438 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake reverse                          |                     | 0.111 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/ForwardDiff              |                     | 0.0673 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                               |                     | 0.222 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                                |                     | 0.531 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                                   |                     | 0.4 ± 0.02 ms       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward                  |                     | 16.1 ± 0.6 μs       |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake forward                                    |                     | 1.32 ± 0.048 ms     |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                              |                     | 0.0542 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward              |                     | 0.694 ± 0.063 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                         |                     | 0.143 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                              |                     | 0.138 ± 0.0038 ms   |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake forward                          |                     | 1.33 ± 0.019 ms     |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward                 |                     | 0.256 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                             |                     | 1.01 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward                    |                     | 0.156 ± 0.0072 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff                 |                     | 0.103 ± 0.0052 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake forward                               |                     | 5.76 ± 0.24 ms      |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse            |                     | 0.138 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse                      |                     | 0.129 ± 0.0062 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse                |                     | 0.0589 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                                    |                     | 17.7 ± 3.1 μs       |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme forward                                     |                     | 0.204 ± 0.032 ms    |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme forward                        |                     | 0.958 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme forward                          |                     | 0.278 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                           |                     | 0.171 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                         |                     | 0.0559 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                           |                     | 0.0969 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                             |                     | 0.973 ± 0.024 ms    |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff                    |                     | 0.0807 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                                    |                     | 0.0431 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff             |                     | 1.37 ± 0.21 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                                 |                     | 0.0649 ± 0.051 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake forward               |                     | 1.28 ± 0.048 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse                |                     | 0.0794 ± 0.0032 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/Direct Mooncake gradient                                             |                     | 0.0816 ± 0.0017 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                     | 0.0957 ± 0.0048 ms  |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                     | 0.646 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                     | 0.134 ± 0.0067 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                     | 0.0651 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                     | 30.4 ± 18 μs        |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                     | 0.0764 ± 0.0049 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                     | 0.987 ± 0.051 ms    |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                     | 0.35 ± 0.016 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                     | 0.0812 ± 0.0036 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                     | 0.142 ± 0.0094 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                     | 0.404 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                     | 1.51 ± 0.05 ms      |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                     | 0.15 ± 0.052 ms     |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                     | 0.047 ± 0.0065 ms   |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                     | 0.173 ± 0.056 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                     | 3.82 ± 0.097 ms     |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                     | 1.82 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                     | 0.89 ± 0.017 ms     |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                     | 0.0845 ± 0.0022 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                     | 1.33 ± 0.23 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                     | 0.0657 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme reverse                               |                     | 0.141 ± 0.0082 ms   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                     | 1.48 ± 0.034 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                     | 1.53 ± 0.54 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                     | 0.0792 ± 0.005 ms   |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                     | 0.513 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                     | 0.863 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                     | 0.167 ± 0.072 ms    |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/ForwardDiff                                  |                     | 0.125 ± 0.0093 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                     | 0.0334 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                     | 0.06 ± 0.0021 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                     | 0.086 ± 0.0023 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                     | 0.0954 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                     | 1.68 ± 0.084 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                     | 0.325 ± 0.017 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                     | 0.0528 ± 0.0034 ms  |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme reverse                                         |                     | 0.0749 ± 0.0056 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake forward                      |                     | 8.89 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                               |                     | 0.139 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme forward                  |                     | 0.0604 ± 0.023 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake forward                         |                     | 0.83 ± 0.014 ms     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                                |                     | 0.171 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward                |                     | 1.03 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                         |                     | 0.127 ± 0.0057 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse                      |                     | 0.0863 ± 0.0045 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                           |                     | 0.106 ± 0.0084 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                              |                     | 2.21 ± 0.061 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                        |                     | 0.141 ± 0.0064 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward                  |                     | 1.44 ± 0.11 ms      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                                |                     | 0.105 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                                     |                     | 0.0693 ± 0.0047 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme forward                           |                     | 0.282 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward                  |                     | 0.349 ± 0.11 ms     |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake forward                                       |                     | 2.34 ± 0.19 ms      |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                                     |                     | 0.04 ± 0.0027 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                                      |                     | 0.0584 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                                      |                     | 0.69 ± 0.013 ms     |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake forward                                   |                     | 0.821 ± 0.016 ms    |                            |
| Convolution methods/S 1 T 20000 L 500/FFT Mooncake gradient                                              |                     | 1.28 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake reverse                        |                     | 0.104 ± 0.0028 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                             |                     | 0.755 ± 0.025 ms    |                            |
| Convolution methods/S 1 T 200 L 32/FFT forward                                                           |                     | 8.91 ± 2.6 μs       |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                                   |                     | 0.0658 ± 0.0045 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                           |                     | 0.343 ± 0.064 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                                  |                     | 2.24 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                     | 0.0579 ± 0.0063 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                     | 0.0846 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme forward              |                     | 0.977 ± 0.19 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                        |                     | 0.0671 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme forward                           |                     | 0.202 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward     |                     | 1.38 ± 0.021 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                          |                     | 0.199 ± 0.0094 ms   |                            |
| Convolution methods/S 50 T 200 L 64/FFT forward                                                          |                     | 0.145 ± 0.0096 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff                    |                     | 0.0756 ± 0.0076 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                                     |                     | 1.16 ± 0.014 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme forward           |                     | 0.288 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                        |                     | 0.0467 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff                   |                     | 0.164 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward        |                     | 16.2 ± 0.63 μs      |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward               |                     | 1.36 ± 0.019 ms     |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake reverse                      |                     | 0.148 ± 0.007 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                     | 0.503 ± 0.026 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                     | 0.0467 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                     | 2.54 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                     | 0.115 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/ForwardDiff                 |                     | 0.711 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                     | 10.5 ± 0.61 μs      |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                     | 0.0778 ± 0.048 ms   |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                     | 0.0888 ± 0.016 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                     | 0.102 ± 0.0051 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                     | 0.0548 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                     | 0.11 ± 0.0054 ms    |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                     | 0.175 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake forward                             |                     | 3.32 ± 0.047 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                     | 0.0738 ± 0.013 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                     | 0.0599 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                     | 0.0612 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                     | 0.089 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                     | 0.15 ± 0.015 ms     |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                     | 29.6 ± 1.2 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                     | 0.0919 ± 0.041 ms   |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                     | 0.0729 ± 0.006 ms   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme reverse                        |                     | 0.107 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                                    |                     | 0.0629 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                        |                     | 8.67 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                             |                     | 0.109 ± 0.0066 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                                 |                     | 0.0741 ± 0.0025 ms  |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse                 |                     | 0.0438 ± 0.00099 ms |                            |
| Convolution methods/S 1 T 2000 L 32/FFT Mooncake gradient                                                |                     | 0.119 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/ForwardDiff                               |                     | 0.0986 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                                  |                     | 0.128 ± 0.0061 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                       |                     | 0.947 ± 0.07 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake reverse                  |                     | 0.117 ± 0.01 ms     |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme reverse                                    |                     | 0.0577 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                                   |                     | 0.248 ± 0.024 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme reverse                           |                     | 0.0603 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse                    |                     | 0.0579 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                             |                     | 0.0692 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/ForwardDiff                       |                     | 0.0703 ± 0.003 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                                |                     | 0.484 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward                 |                     | 0.103 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                        |                     | 0.116 ± 0.0056 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                       |                     | 0.709 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                                   |                     | 0.0605 ± 0.0062 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                                |                     | 0.0337 ± 0.00084 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward                |                     | 1.28 ± 0.075 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                       |                     | 0.0829 ± 0.002 ms   |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake reverse                                    |                     | 0.0707 ± 0.0052 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/FFT Mooncake gradient                                               |                     | 0.129 ± 0.01 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                           |                     | 0.0653 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                        |                     | 1.44 ± 0.054 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                                      |                     | 0.5 ± 0.023 ms      |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                           |                     | 0.161 ± 0.013 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                             |                     | 0.0433 ± 0.0025 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                         |                     | 1.09 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake forward                |                     | 0.4 ± 0.039 ms      |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                                      |                     | 0.0345 ± 0.003 ms   |                            |
| Convolution methods/S 1 T 200 L 32/Direct Mooncake gradient                                              |                     | 13.9 ± 2.1 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                         |                     | 0.0648 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward                 |                     | 0.315 ± 0.04 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                                |                     | 0.0585 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse                 |                     | 0.0765 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                                    |                     | 0.111 ± 0.0096 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme reverse                                     |                     | 0.0328 ± 0.00082 ms |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                           |                     | 0.0338 ± 0.0009 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward               |                     | 1.25 ± 0.078 ms     |                            |
| Convolution methods/S 50 T 200 L 64/Direct Mooncake gradient                                             |                     | 0.473 ± 0.012 ms    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                     | 0.0864 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                     | 0.0937 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                     | 0.0338 ± 0.0031 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                     | 0.0965 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                     | 0.127 ± 0.0041 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                     | 0.105 ± 0.0031 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                           |                     | 0.0876 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                                 |                     | 1.45 ± 0.059 ms     |                            |
| Convolution methods/S 1 T 200 L 32/Direct forward                                                        |                     | 2.54 ± 0.46 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                                    |                     | 1.35 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/ForwardDiff                          |                     | 0.341 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                 |                     | 1.88 ± 0.045 ms     |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/ForwardDiff                               |                     | 0.0516 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward              |                     | 4.51 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                                   |                     | 0.368 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                                    |                     | 0.0738 ± 0.0031 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme forward                                      |                     | 0.496 ± 0.048 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward                      |                     | 2.3 ± 0.11 ms       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                                   |                     | 0.117 ± 0.0057 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme forward                                 |                     | 1.63 ± 0.038 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                                |                     | 10.4 ± 0.56 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                                     |                     | 2.72 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                                |                     | 0.14 ± 0.0064 ms    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                                      |                     | 0.0624 ± 0.0049 ms  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct forward                                                     |                     | 1.11 ± 0.026 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                    |                     | 25.6 ± 0.69 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward                    |                     | 1.7 ± 0.031 ms      |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme reverse                                      |                     | 0.0779 ± 0.0018 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/ForwardDiff                                    |                     | 0.283 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward                   |                     | 0.0339 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme forward                            |                     | 0.275 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme forward                    |                     | 0.544 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                           |                     | 4.65 ± 0.068 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                              |                     | 0.423 ± 0.041 ms    |                            |
| time_to_load                                                                                             | 0.238 ± 0.0013 s    | 0.354 ± 0.0068 s    | 0.672 ± 0.013              |

|                                                                                                          | v0.1.0                    | 9699ecd276b068...         | v0.1.0 / 9699ecd276b068... |
|:---------------------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                               | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                               | 0.147 k allocs: 7.97 kB   | 0.143 k allocs: 7.06 kB   | 1.13                       |
| AD gradients/Convolution delay with history/ForwardDiff                                                  | 0.042 k allocs: 12.1 kB   | 0.034 k allocs: 6.28 kB   | 1.93                       |
| AD gradients/Convolution delay with history/Mooncake forward                                             | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                             | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                                  | 1.94 k allocs: 0.195 MB   | 1.81 k allocs: 0.171 MB   | 1.14                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                                  | 0.204 k allocs: 18 kB     | 0.15 k allocs: 10.7 kB    | 1.69                       |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                                     | 0.188 k allocs: 0.113 MB  | 0.134 k allocs: 0.046 MB  | 2.47                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                                | 13.7 k allocs: 0.635 MB   | 10.5 k allocs: 0.512 MB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                                | 0.829 k allocs: 31.1 kB   | 0.583 k allocs: 21.8 kB   | 1.42                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                            | 2.99 k allocs: 0.267 MB   | 2.8 k allocs: 0.241 MB    | 1.11                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                            | 0.15 k allocs: 11.9 kB    | 0.154 k allocs: 10.8 kB   | 1.1                        |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                               | 0.266 k allocs: 0.133 MB  | 0.242 k allocs: 0.111 MB  | 1.2                        |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                          | 19.8 k allocs: 0.899 MB   | 15.3 k allocs: 0.739 MB   | 1.22                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                          | 0.682 k allocs: 24.9 kB   | 0.586 k allocs: 22 kB     | 1.14                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                              | 4.7 k allocs: 0.505 MB    | 4.31 k allocs: 0.435 MB   | 1.16                       |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                              | 0.122 k allocs: 12.5 kB   | 0.123 k allocs: 9.7 kB    | 1.29                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                                 | 0.437 k allocs: 0.289 MB  | 0.392 k allocs: 0.234 MB  | 1.24                       |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                            | 0.0319 M allocs: 1.73 MB  | 23.8 k allocs: 1.41 MB    | 1.23                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                            | 0.542 k allocs: 22.2 kB   | 0.446 k allocs: 19 kB     | 1.17                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                              | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                             | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                                | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                           | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                                 | 3.25 k allocs: 0.494 MB   | 0.438 k allocs: 0.149 MB  | 3.32                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                                    | 8.89 k allocs: 0.0511 GB  | 6.97 k allocs: 0.0399 GB  | 1.28                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 9.4 k allocs: 0.381 MB    | 1.26 k allocs: 0.169 MB   | 2.25                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 0.054 k allocs: 0.0376 MB | 0.039 k allocs: 19 kB     | 2.03                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.161 k allocs: 0.0396 MB | 0.152 k allocs: 21 kB     | 1.93                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 0.542 k allocs: 1.69 MB   | 0.422 k allocs: 0.852 MB  | 1.98                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 1.53 k allocs: 0.293 MB   | 0.111 k allocs: 0.0881 MB | 3.33                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 2.71 k allocs: 24.9 MB    | 1.1 k allocs: 12.3 MB     | 2.02                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 5.84 k allocs: 0.353 MB   | 0.087 k allocs: 0.0883 MB | 4                          |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.18 k allocs: 0.0375 MB  | 0.193 k allocs: 27.3 kB   | 1.4                        |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 2.31 k allocs: 0.0849 MB  | 0.661 k allocs: 0.0398 MB | 2.13                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 1.53 k allocs: 0.307 MB   | 0.279 k allocs: 0.126 MB  | 2.43                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 6.2 k allocs: 0.0508 GB   | 5.15 k allocs: 0.0396 GB  | 1.28                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 9.06 k allocs: 0.369 MB   | 0.903 k allocs: 0.143 MB  | 2.59                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 8.54 k allocs: 0.784 MB   | 7.89 k allocs: 0.71 MB    | 1.11                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.652 k allocs: 0.0473 MB | 0.416 k allocs: 0.0331 MB | 1.43                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.713 k allocs: 0.321 MB  | 0.632 k allocs: 0.268 MB  | 1.2                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 0.0394 M allocs: 1.95 MB  | 0.0369 M allocs: 1.81 MB  | 1.07                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 1.69 k allocs: 0.0622 MB  | 1.3 k allocs: 0.0538 MB   | 1.16                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 1.13 k allocs: 0.141 MB   | 0.807 k allocs: 0.103 MB  | 1.36                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 0.077 k allocs: 10.4 kB   | 0.091 k allocs: 9.31 kB   | 1.11                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 0.162 k allocs: 0.108 MB  | 0.117 k allocs: 0.0811 MB | 1.33                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 7.39 k allocs: 0.455 MB   | 2.47 k allocs: 0.272 MB   | 1.67                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 0.44 k allocs: 18 kB      | 0.118 k allocs: 10 kB     | 1.79                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme forward                     | 3.66 k allocs: 0.234 MB   | 2.91 k allocs: 0.181 MB   | 1.29                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme reverse                     | 0.375 k allocs: 22.1 kB   | 0.27 k allocs: 14 kB      | 1.57                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/ForwardDiff                        | 0.332 k allocs: 0.116 MB  | 0.242 k allocs: 0.0874 MB | 1.33                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake forward                   | 14.5 k allocs: 0.654 MB   | 10.8 k allocs: 0.511 MB   | 1.28                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake reverse                   | 1.27 k allocs: 0.042 MB   | 0.821 k allocs: 30.7 kB   | 1.4                        |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward             | 3.66 k allocs: 0.234 MB   | 2.91 k allocs: 0.181 MB   | 1.29                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse             | 0.347 k allocs: 20.2 kB   | 0.27 k allocs: 14 kB      | 1.44                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff                | 0.332 k allocs: 0.116 MB  | 0.242 k allocs: 0.0874 MB | 1.33                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward           | 14.5 k allocs: 0.654 MB   | 10.8 k allocs: 0.511 MB   | 1.28                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse           | 1.15 k allocs: 0.0385 MB  | 0.821 k allocs: 30.7 kB   | 1.28                       |
| AD gradients/Recurrence in Float32/Enzyme forward                                                        | 2.77 k allocs: 0.162 MB   | 2.43 k allocs: 0.136 MB   | 1.19                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                        | 0.295 k allocs: 16.2 kB   | 0.211 k allocs: 10.1 kB   | 1.61                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                                           | 0.222 k allocs: 0.0645 MB | 0.182 k allocs: 0.049 MB  | 1.32                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                                      | 11.5 k allocs: 0.443 MB   | 10.1 k allocs: 0.389 MB   | 1.14                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                                      | 1.02 k allocs: 0.033 MB   | 0.674 k allocs: 23.8 kB   | 1.42                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                                   | 3.14 k allocs: 0.279 MB   | 2.95 k allocs: 0.281 MB   | 0.991                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.246 k allocs: 20 kB     | 0.182 k allocs: 13.4 kB   | 1.49                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.303 k allocs: 0.154 MB  | 0.296 k allocs: 0.161 MB  | 0.956                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 17.4 k allocs: 0.834 MB   | 15.8 k allocs: 0.828 MB   | 1.01                       |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.691 k allocs: 26.1 kB   | 0.642 k allocs: 26.1 kB   | 0.999                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 3.18 k allocs: 0.261 MB   | 2.77 k allocs: 0.214 MB   | 1.22                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.233 k allocs: 17.1 kB   | 0.235 k allocs: 15.3 kB   | 1.11                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.29 k allocs: 0.13 MB    | 0.242 k allocs: 0.0952 MB | 1.37                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 15.7 k allocs: 0.716 MB   | 14 k allocs: 0.611 MB     | 1.17                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 1.15 k allocs: 0.0397 MB  | 0.807 k allocs: 30.5 kB   | 1.33                       |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 0.176 k allocs: 7.66 kB   | 0.193 k allocs: 8.34 kB   | 0.918                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 4.09 k allocs: 0.137 MB   | 3.75 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.809 k allocs: 25.5 kB   | 0.668 k allocs: 21.9 kB   | 1.16                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 3.31 k allocs: 0.237 MB   | 3.21 k allocs: 0.212 MB   | 1.12                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.336 k allocs: 21.5 kB   | 0.311 k allocs: 17.2 kB   | 1.25                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                                  | 0.287 k allocs: 0.125 MB  | 0.262 k allocs: 0.102 MB  | 1.23                       |
| AD gradients/Recurrence returning its state/Mooncake forward                                             | 15.9 k allocs: 0.718 MB   | 12.5 k allocs: 0.584 MB   | 1.23                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                             | 1.16 k allocs: 0.0393 MB  | 0.895 k allocs: 0.0325 MB | 1.21                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                              | 1.5 k allocs: 0.132 MB    | 1.25 k allocs: 0.104 MB   | 1.27                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                              | 0.198 k allocs: 15.6 kB   | 0.237 k allocs: 19.3 kB   | 0.809                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                                 | 0.174 k allocs: 0.0836 MB | 0.138 k allocs: 0.0622 MB | 1.34                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                            | 5.38 k allocs: 0.321 MB   | 4.41 k allocs: 0.264 MB   | 1.22                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                            | 0.39 k allocs: 16.1 kB    | 0.431 k allocs: 23.2 kB   | 0.696                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                                   | 2.74 k allocs: 0.209 MB   | 2.38 k allocs: 0.168 MB   | 1.24                       |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                                   | 0.382 k allocs: 21.7 kB   | 0.203 k allocs: 12.4 kB   | 1.75                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                                      | 0.237 k allocs: 0.105 MB  | 0.192 k allocs: 0.0755 MB | 1.39                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                                 | 12.3 k allocs: 0.571 MB   | 10.9 k allocs: 0.487 MB   | 1.17                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                                 | 1.02 k allocs: 0.0353 MB  | 0.683 k allocs: 26.2 kB   | 1.38                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 3.74 k allocs: 0.297 MB   | 3.35 k allocs: 0.252 MB   | 1.18                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.375 k allocs: 23.9 kB   | 0.259 k allocs: 17.5 kB   | 1.37                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.338 k allocs: 0.149 MB  | 0.284 k allocs: 0.114 MB  | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 19.4 k allocs: 0.879 MB   | 14.8 k allocs: 0.69 MB    | 1.27                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 1.35 k allocs: 0.046 MB   | 0.895 k allocs: 0.0337 MB | 1.36                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                                  | 10.7 k allocs: 0.915 MB   | 9.37 k allocs: 0.762 MB   | 1.2                        |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                                  | 0.383 k allocs: 25 kB     | 0.234 k allocs: 18 kB     | 1.39                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                                     | 0.886 k allocs: 0.384 MB  | 0.733 k allocs: 0.275 MB  | 1.4                        |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                                | 0.0515 M allocs: 2.58 MB  | 0.0464 M allocs: 2.29 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                                | 0.863 k allocs: 0.033 MB  | 0.811 k allocs: 0.0316 MB | 1.04                       |
| Convolution body/BLAS axpy per lag                                                                       | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                                                     | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                                  | 0.091 k allocs: 0.0452 MB | 0.073 k allocs: 0.035 MB  | 1.29                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                                 | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                                | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                                   | 0.052 k allocs: 0.0399 MB | 28  allocs: 29.7 kB       | 1.37                       |
| Evaluation/Matrix renewal T200_L20_S1                                                                    | 0.034 k allocs: 7.98 kB   | 30  allocs: 7.72 kB       | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                              | 0.072 k allocs: 0.0443 MB | 0.054 k allocs: 0.0343 MB | 1.29                       |
| AD gradients/Recurrence removals from recent outputs/Enzyme reverse                                      |                           | 0.203 k allocs: 13.5 kB   |                            |
| Convolution methods/S 1 T 2000 L 32/FFT forward                                                          |                           | 25  allocs: 0.0544 MB     |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                           |                           | 1.19 k allocs: 0.0452 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse                   |                           | 0.224 k allocs: 16.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/ForwardDiff                              |                           | 0.232 k allocs: 0.116 MB  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward                     |                           | 23.2 k allocs: 1.12 MB    |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake forward                     |                           | 0.0464 M allocs: 2.71 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                  |                           | 0.333 k allocs: 13.8 kB   |                            |
| Convolution methods/S 1 T 200 L 64/FFT Mooncake gradient                                                 |                           | 0.057 k allocs: 0.0334 MB |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward   |                           | 2.97 k allocs: 0.184 MB   |                            |
| Convolution methods/S 1 T 300 L 60/FFT forward                                                           |                           | 25  allocs: 19.2 kB       |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme reverse                              |                           | 0.357 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                                      |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                                   |                           | 0.234 k allocs: 0.0975 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff                     |                           | 0.274 k allocs: 0.112 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake forward                        |                           | 12 k allocs: 0.643 MB     |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward                      |                           | 3.2 k allocs: 0.221 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                                 |                           | 0.904 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse        |                           | 0.103 k allocs: 4.42 kB   |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                              |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                                     |                           | 3.14 k allocs: 0.211 MB   |                            |
| Convolution methods/S 1 T 200 L 64/Direct forward                                                        |                           | 6  allocs: 4.91 kB        |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake reverse                                       |                           | 1.02 k allocs: 0.0363 MB  |                            |
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                           | 22  allocs: 13.9 kB       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                           | 22.8 k allocs: 1.1 MB     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake reverse            |                           | 2.91 k allocs: 0.116 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                       |                           | 0.225 k allocs: 14.8 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                              |                           | 13.9 k allocs: 0.592 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                              |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse               |                           | 0.619 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake forward                         |                           | 11.9 k allocs: 0.608 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward |                           | 11 k allocs: 0.519 MB     |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                        |                           | 0.0411 M allocs: 2.11 MB  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake forward                            |                           | 21.8 k allocs: 1.1 MB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                           | 0.535 k allocs: 22.6 kB   |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                           | 0.999 k allocs: 0.0393 MB |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/ForwardDiff                                 |                           | 0.464 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme reverse                          |                           | 0.275 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff      |                           | 0.247 k allocs: 0.088 MB  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                        |                           | 9.61 k allocs: 0.79 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                          |                           | 0.45 k allocs: 0.162 MB   |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake forward                                  |                           | 11.8 k allocs: 0.634 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                        |                           | 2.44 k allocs: 0.165 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse |                           | 0.829 k allocs: 29.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                              |                           | 2.49 k allocs: 0.14 MB    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme forward                 |                           | 3.02 k allocs: 0.224 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake reverse         |                           | 0.829 k allocs: 29.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                           | 1.03 k allocs: 0.0382 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                           | 0.33 k allocs: 18.7 kB    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                           | 5.65 k allocs: 0.455 MB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                           | 0.053 k allocs: 3.42 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                           | 4.61 k allocs: 0.325 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                           | 0.956 k allocs: 0.0361 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                           | 2.38 k allocs: 0.163 MB   |                            |
| AD gradients/Recurrence protected pool in Float32/ForwardDiff                                            |                           | 0.418 k allocs: 0.0896 MB |                            |
| AD gradients/Recurrence removals from recent outputs/ForwardDiff                                         |                           | 0.227 k allocs: 0.108 MB  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct forward                                                      |                           | 9  allocs: 0.046 MB       |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                                |                           | 0.336 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                            |                           | 0.699 k allocs: 24.2 kB   |                            |
| Convolution methods/S 50 T 200 L 64/Direct forward                                                       |                           | 9  allocs: 0.229 MB       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                                |                           | 0.596 k allocs: 0.195 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme reverse                           |                           | 0.177 k allocs: 16.5 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                                    |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                                   |                           | 12.4 k allocs: 0.6 MB     |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward            |                           | 28 k allocs: 1.28 MB      |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake reverse                             |                           | 1.03 k allocs: 0.0363 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                                 |                           | 0.346 k allocs: 20.1 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                                |                           | 10.1 k allocs: 0.463 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme reverse                 |                           | 0.277 k allocs: 18.5 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                           |                           | 18.8 k allocs: 0.873 MB   |                            |
| Convolution methods/S 1 T 2000 L 32/Direct forward                                                       |                           | 9  allocs: 0.046 MB       |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward                      |                           | 10.8 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                       |                           | 16.2 k allocs: 0.842 MB   |                            |
| Convolution methods/S 1 T 300 L 60/Direct forward                                                        |                           | 9  allocs: 7.37 kB        |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward                    |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                              |                           | 16 k allocs: 0.671 MB     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                         |                           | 0.586 k allocs: 25 kB     |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                          |                           | 4.49 k allocs: 0.326 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/ForwardDiff                    |                           | 0.262 k allocs: 0.121 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                                 |                           | 2.16 k allocs: 0.165 MB   |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                                |                           | 0.211 k allocs: 14.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                       |                           | 0.138 k allocs: 0.0622 MB |                            |
| Convolution methods/S 1 T 300 L 60/Direct Mooncake gradient                                              |                           | 30  allocs: 20.6 kB       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                        |                           | 0.272 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse                 |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse                    |                           | 1.09 k allocs: 0.0364 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                              |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse                  |                           | 0.163 k allocs: 11.3 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                                    |                           | 4.54 k allocs: 0.451 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                                 |                           | 0.177 k allocs: 8.16 kB   |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                             |                           | 0.356 k allocs: 0.135 MB  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme reverse                                 |                           | 0.541 k allocs: 0.0523 MB |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                         |                           | 0.282 k allocs: 0.109 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                           | 5.77 k allocs: 0.424 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                           | 21.2 k allocs: 0.957 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                           | 0.621 k allocs: 0.0488 MB |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                           | 2.34 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                           | 0.675 k allocs: 0.0356 MB |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                           | 0.558 k allocs: 24 kB     |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                           | 1.19 k allocs: 0.0464 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                           | 31  allocs: 1.23 MB       |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                           | 0.783 k allocs: 31.1 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                           | 0.23 k allocs: 0.0895 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                           | 0.982 k allocs: 0.0327 MB |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                           | 1.17 k allocs: 0.0445 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                           | 0.542 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                           | 1.89 k allocs: 0.175 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                           | 0.14 k allocs: 0.0463 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                           | 0.38 k allocs: 0.137 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                           | 0.097 k allocs: 5.78 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                           | 2.45 k allocs: 0.172 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                           | 5.28 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                           | 0.963 k allocs: 0.0351 MB |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                           | 0.287 k allocs: 17.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake forward            |                           | 0.0406 M allocs: 2.34 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/ForwardDiff                           |                           | 1.8 k allocs: 0.209 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                           | 11.5 k allocs: 0.524 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                           | 0.0472 M allocs: 2.33 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                           | 0.122 k allocs: 5.83 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                           | 0.336 k allocs: 21.4 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                           | 2.91 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                           | 1.09 k allocs: 0.0351 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                           | 25  allocs: 0.581 MB      |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                           | 4.52 k allocs: 0.319 MB   |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                           | 22  allocs: 14 kB         |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                           | 2.85 k allocs: 0.214 MB   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                           | 22.8 k allocs: 0.978 MB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                           | 0.634 k allocs: 27.5 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                           |                           | 2.16 k allocs: 0.165 MB   |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/ForwardDiff                              |                           | 0.257 k allocs: 0.12 MB   |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake reverse                     |                           | 1.39 k allocs: 0.0635 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                                |                           | 2.54 k allocs: 0.176 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                             |                           | 0.331 k allocs: 18.7 kB   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                                   |                           | 0.202 k allocs: 0.248 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                       |                           | 0.662 k allocs: 27.3 kB   |                            |
| Convolution methods/S 1 T 200 L 32/FFT Mooncake gradient                                                 |                           | 0.048 k allocs: 0.0316 MB |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme reverse                    |                           | 0.33 k allocs: 24.3 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                             |                           | 0.251 k allocs: 16.5 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                              |                           | 0.31 k allocs: 19.8 kB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                         |                           | 3.05 k allocs: 0.289 MB   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake reverse                          |                           | 1.11 k allocs: 0.0396 MB  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme forward                               |                           | 5.87 k allocs: 0.363 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                           | 0.587 k allocs: 0.192 MB  |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                           | 1.06 k allocs: 0.0367 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                           | 0.96 k allocs: 31.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                           | 0.129 k allocs: 11.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                           | 0.303 k allocs: 0.161 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                           | 16.9 k allocs: 0.927 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                           | 0.117 k allocs: 0.0811 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                           | 0.298 k allocs: 20.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                           | 5.87 k allocs: 0.435 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                           | 21.5 k allocs: 0.972 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                           | 0.287 k allocs: 17.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                           | 0.217 k allocs: 0.0845 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                           | 0.452 k allocs: 0.237 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                           | 0.479 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                           | 0.393 k allocs: 28 kB     |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                           | 0.846 k allocs: 0.0315 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                           | 0.0398 M allocs: 2.03 MB  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                           | 12.4 k allocs: 1.27 MB    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                           | 9.98 k allocs: 0.727 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                           | 2.48 k allocs: 0.195 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                           | 0.202 k allocs: 0.0499 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme reverse              |                           | 0.713 k allocs: 0.0512 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                           | 0.296 k allocs: 20.3 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                           | 1.11 k allocs: 0.0404 MB  |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme forward                                         |                           | 5.77 k allocs: 0.353 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme reverse                  |                           | 0.059 k allocs: 8.95 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward                      |                           | 2.48 k allocs: 0.174 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                            |                           | 0.212 k allocs: 0.0765 MB |                            |
| Convolution methods/S 1 T 300 L 60/FFT Mooncake gradient                                                 |                           | 0.065 k allocs: 0.0462 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme reverse                            |                           | 0.363 k allocs: 25.7 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                        |                           | 0.593 k allocs: 0.257 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/ForwardDiff                             |                           | 0.267 k allocs: 0.12 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake forward         |                           | 11 k allocs: 0.519 MB     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                            |                           | 0.436 k allocs: 0.15 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                      |                           | 0.266 k allocs: 0.0965 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse                      |                           | 0.754 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                          |                           | 3.42 k allocs: 0.26 MB    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                                |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                         |                           | 0.266 k allocs: 0.0989 MB |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake reverse                          |                           | 0.631 k allocs: 23.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/ForwardDiff              |                           | 0.247 k allocs: 0.088 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                               |                           | 3.83 k allocs: 0.134 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                                |                           | 4.58 k allocs: 0.341 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                                   |                           | 1.07 k allocs: 0.22 MB    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward                  |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake forward                                    |                           | 10.3 k allocs: 0.576 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                              |                           | 0.235 k allocs: 14.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward              |                           | 5.75 k allocs: 0.473 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                         |                           | 1.1 k allocs: 0.0365 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                              |                           | 1.2 k allocs: 0.0449 MB   |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake forward                          |                           | 10.3 k allocs: 0.575 MB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward                 |                           | 2.34 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                             |                           | 8.01 k allocs: 0.733 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward                    |                           | 1.25 k allocs: 0.104 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff                 |                           | 0.464 k allocs: 0.179 MB  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake forward                               |                           | 0.0459 M allocs: 2.67 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse            |                           | 1.21 k allocs: 0.0456 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse                      |                           | 0.286 k allocs: 16.7 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse                |                           | 0.619 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                                    |                           | 0.064 k allocs: 13.4 kB   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme forward                                     |                           | 2.02 k allocs: 0.183 MB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme forward                        |                           | 7.44 k allocs: 0.713 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme forward                          |                           | 2.92 k allocs: 0.217 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                           |                           | 1.37 k allocs: 0.054 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                         |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                           |                           | 0.74 k allocs: 29.5 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                             |                           | 9.37 k allocs: 0.695 MB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff                    |                           | 0.262 k allocs: 0.121 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                                    |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff             |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                                 |                           | 0.324 k allocs: 0.147 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake forward               |                           | 12.1 k allocs: 0.618 MB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse                |                           | 0.335 k allocs: 25 kB     |                            |
| Convolution methods/S 1 T 2000 L 32/Direct Mooncake gradient                                             |                           | 30  allocs: 0.123 MB      |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                           | 0.831 k allocs: 0.0319 MB |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                           | 0.065 k allocs: 1.14 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                           | 0.834 k allocs: 30.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                           | 0.103 k allocs: 7 kB      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                           | 0.284 k allocs: 22.2 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                           | 9.13 k allocs: 0.678 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                           | 3.13 k allocs: 0.219 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                           | 0.262 k allocs: 0.121 MB  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                           | 1.27 k allocs: 0.0611 MB  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                           | 3.96 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                           | 16.6 k allocs: 0.705 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                           | 1.24 k allocs: 0.0486 MB  |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                           | 0.232 k allocs: 0.116 MB  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                           | 30  allocs: 0.124 MB      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                           | 0.0373 M allocs: 1.85 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                           | 18.9 k allocs: 0.832 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                           | 10.3 k allocs: 0.469 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                           | 0.412 k allocs: 27.3 kB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                           | 0.683 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme reverse                               |                           | 0.394 k allocs: 25.8 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                           | 17.3 k allocs: 0.816 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                           | 22.1 k allocs: 1.11 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                           | 0.181 k allocs: 0.0406 MB |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                           | 5.3 k allocs: 0.4 MB      |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                           | 10.7 k allocs: 0.424 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                           | 0.75 k allocs: 0.277 MB   |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/ForwardDiff                                  |                           | 0.426 k allocs: 0.0907 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                           | 0.34 k allocs: 23.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                           | 0.371 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                           | 0.825 k allocs: 0.0323 MB |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                           | 0.832 k allocs: 0.0337 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                           | 19.2 k allocs: 0.846 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                           | 2.85 k allocs: 0.222 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                           | 0.274 k allocs: 17.3 kB   |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme reverse                                         |                           | 0.337 k allocs: 18.5 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake forward                      |                           | 0.0403 M allocs: 2.33 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                               |                           | 0.288 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme forward                  |                           | 0.807 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake forward                         |                           | 9.19 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                                |                           | 0.786 k allocs: 0.261 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward                |                           | 10.1 k allocs: 0.736 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                         |                           | 0.226 k allocs: 0.0894 MB |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse                      |                           | 0.749 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                           |                           | 1.09 k allocs: 0.0546 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                              |                           | 23.5 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                        |                           | 0.413 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward                  |                           | 17.6 k allocs: 0.831 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                                |                           | 0.295 k allocs: 15 kB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                                     |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme forward                           |                           | 2.95 k allocs: 0.221 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward                  |                           | 4.41 k allocs: 0.263 MB   |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake forward                                       |                           | 22.8 k allocs: 0.93 MB    |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                                     |                           | 0.212 k allocs: 0.084 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                                      |                           | 0.256 k allocs: 16.5 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                                      |                           | 1.16 k allocs: 0.191 MB   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake forward                                   |                           | 9.19 k allocs: 0.521 MB   |                            |
| Convolution methods/S 1 T 20000 L 500/FFT Mooncake gradient                                              |                           | 0.066 k allocs: 1.5 MB    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake reverse                        |                           | 0.84 k allocs: 0.0323 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                             |                           | 6.98 k allocs: 0.527 MB   |                            |
| Convolution methods/S 1 T 200 L 32/FFT forward                                                           |                           | 18  allocs: 13.2 kB       |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                                   |                           | 0.262 k allocs: 0.108 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                           |                           | 4.6 k allocs: 0.345 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                                  |                           | 25.8 k allocs: 1.53 MB    |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                           | 0.203 k allocs: 19.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                           | 0.22 k allocs: 15.8 kB    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme forward              |                           | 7.52 k allocs: 0.72 MB    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                        |                           | 0.221 k allocs: 14.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme forward                           |                           | 2.02 k allocs: 0.183 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward     |                           | 10.2 k allocs: 0.584 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                          |                           | 0.722 k allocs: 0.258 MB  |                            |
| Convolution methods/S 50 T 200 L 64/FFT forward                                                          |                           | 25  allocs: 0.441 MB      |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff                    |                           | 0.49 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                                     |                           | 1.25 k allocs: 0.115 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme forward           |                           | 2.97 k allocs: 0.184 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                        |                           | 0.21 k allocs: 14.2 kB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff                   |                           | 0.746 k allocs: 0.357 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward        |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward               |                           | 10.2 k allocs: 0.585 MB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake reverse                      |                           | 1.38 k allocs: 0.0715 MB  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                           | 4.41 k allocs: 0.314 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                           | 30.7 k allocs: 1.42 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/ForwardDiff                 |                           | 1.8 k allocs: 0.21 MB     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                           | 0.05 k allocs: 9.29 kB    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                           | 0.331 k allocs: 0.148 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                           | 0.332 k allocs: 0.128 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                           | 1.02 k allocs: 0.0393 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                           | 0.317 k allocs: 17.5 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                           | 0.734 k allocs: 0.357 MB  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake forward                             |                           | 23.2 k allocs: 0.95 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                           | 0.715 k allocs: 29.3 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                           | 0.458 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                           | 0.214 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                           | 0.847 k allocs: 0.0315 MB |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                           | 0.516 k allocs: 0.0568 MB |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                           | 25  allocs: 0.071 MB      |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                           | 0.262 k allocs: 0.119 MB  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                           | 0.327 k allocs: 21.7 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme reverse                        |                           | 0.845 k allocs: 0.0573 MB |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                                    |                           | 0.39 k allocs: 0.0646 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                        |                           | 0.042 k allocs: 6.62 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                             |                           | 0.396 k allocs: 27.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                                 |                           | 0.812 k allocs: 0.0408 MB |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse                 |                           | 0.239 k allocs: 16.9 kB   |                            |
| Convolution methods/S 1 T 2000 L 32/FFT Mooncake gradient                                                |                           | 0.065 k allocs: 0.142 MB  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/ForwardDiff                               |                           | 0.338 k allocs: 0.129 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                                  |                           | 0.443 k allocs: 0.151 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                       |                           | 2.8 k allocs: 0.48 MB     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake reverse                  |                           | 1.01 k allocs: 0.0387 MB  |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme reverse                                    |                           | 0.265 k allocs: 15.8 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                                   |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme reverse                           |                           | 0.272 k allocs: 15.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse                    |                           | 0.292 k allocs: 19.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                             |                           | 0.29 k allocs: 0.114 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/ForwardDiff                       |                           | 0.471 k allocs: 0.2 MB    |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                                |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward                 |                           | 1.11 k allocs: 0.0559 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                        |                           | 0.902 k allocs: 0.0331 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                       |                           | 6.86 k allocs: 0.512 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                                   |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                                |                           | 0.152 k allocs: 12.4 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward                |                           | 16.3 k allocs: 0.8 MB     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                       |                           | 0.708 k allocs: 26 kB     |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake reverse                                    |                           | 0.591 k allocs: 24.6 kB   |                            |
| Convolution methods/S 1 T 2000 L 100/FFT Mooncake gradient                                               |                           | 0.065 k allocs: 0.18 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                           |                           | 0.822 k allocs: 0.0315 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                        |                           | 15.1 k allocs: 0.703 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                                      |                           | 3.77 k allocs: 0.332 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                           |                           | 0.436 k allocs: 0.176 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                             |                           | 0.213 k allocs: 15 kB     |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                         |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake forward                |                           | 2.47 k allocs: 0.272 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                                      |                           | 0.069 k allocs: 0.0332 MB |                            |
| Convolution methods/S 1 T 200 L 32/Direct Mooncake gradient                                              |                           | 22  allocs: 13.8 kB       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                         |                           | 0.307 k allocs: 17.6 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward                 |                           | 4.71 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                                |                           | 0.434 k allocs: 0.13 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse                 |                           | 0.558 k allocs: 22.9 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                                    |                           | 1.13 k allocs: 0.0395 MB  |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme reverse                                     |                           | 0.203 k allocs: 13.6 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                           |                           | 0.239 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward               |                           | 17.9 k allocs: 0.98 MB    |                            |
| Convolution methods/S 50 T 200 L 64/Direct Mooncake gradient                                             |                           | 30  allocs: 0.612 MB      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                           | 0.897 k allocs: 0.0348 MB |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                           | 0.61 k allocs: 24.6 kB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                           | 0.442 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                           | 1.06 k allocs: 0.0392 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                           | 1.06 k allocs: 0.0404 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                           |                           | 0.326 k allocs: 16.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                                 |                           | 19.6 k allocs: 0.917 MB   |                            |
| Convolution methods/S 1 T 200 L 32/Direct forward                                                        |                           | 6  allocs: 4.91 kB        |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                                    |                           | 14.8 k allocs: 0.965 MB   |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/ForwardDiff                          |                           | 1.23 k allocs: 0.393 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                 |                           | 14.7 k allocs: 0.659 MB   |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/ForwardDiff                               |                           | 0.227 k allocs: 0.108 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward              |                           | 0.0417 M allocs: 2.13 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                                   |                           | 5.37 k allocs: 0.323 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                                    |                           | 0.632 k allocs: 25.9 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme forward                                      |                           | 4.33 k allocs: 0.306 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward                      |                           | 27.1 k allocs: 1.2 MB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                                   |                           | 0.849 k allocs: 30.8 kB   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme forward                                 |                           | 12.2 k allocs: 1.24 MB    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                                |                           | 0.049 k allocs: 9.18 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                                     |                           | 30.3 k allocs: 1.39 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                                |                           | 0.641 k allocs: 0.27 MB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                                      |                           | 0.458 k allocs: 0.131 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct forward                                                     |                           | 9  allocs: 0.458 MB       |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                    |                           | 0.153 k allocs: 13.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward                    |                           | 13.7 k allocs: 0.586 MB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme reverse                                      |                           | 0.354 k allocs: 21.2 kB   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/ForwardDiff                                    |                           | 1.22 k allocs: 0.39 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward                   |                           | 0.349 k allocs: 24.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme forward                            |                           | 2.48 k allocs: 0.195 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme forward                    |                           | 5.39 k allocs: 0.407 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                           |                           | 0.0419 M allocs: 2.16 MB  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                              |                           | 3.87 k allocs: 0.311 MB   |                            |
| time_to_load                                                                                             | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

