|                                                                                                          | v0.1.0              | 8707c593d80e65...   | v0.1.0 / 8707c593d80e65... |
|:---------------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                               | 0.0678 ± 0.0063 ms  | 0.0644 ± 0.0086 ms  | 1.05 ± 0.17                |
| AD gradients/Convolution delay with history/Enzyme reverse                                               | 30.3 ± 0.64 μs      | 29.2 ± 0.63 μs      | 1.04 ± 0.031               |
| AD gradients/Convolution delay with history/ForwardDiff                                                  | 9.25 ± 1.6 μs       | 6.67 ± 1.7 μs       | 1.39 ± 0.43                |
| AD gradients/Convolution delay with history/Mooncake forward                                             | 0.236 ± 0.035 ms    | 0.233 ± 0.0094 ms   | 1.02 ± 0.16                |
| AD gradients/Convolution delay with history/Mooncake reverse                                             | 0.0552 ± 0.003 ms   | 0.0388 ± 0.00097 ms | 1.42 ± 0.086               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                                  | 0.243 ± 0.019 ms    | 0.234 ± 0.023 ms    | 1.04 ± 0.13                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                                  | 0.0413 ± 0.0012 ms  | 0.0341 ± 0.0041 ms  | 1.21 ± 0.15                |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                                     | 0.0341 ± 0.0039 ms  | 29.3 ± 1.8 μs       | 1.16 ± 0.15                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                                | 1.03 ± 0.032 ms     | 0.883 ± 0.016 ms    | 1.16 ± 0.042               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                                | 0.0645 ± 0.0041 ms  | 0.0416 ± 0.0011 ms  | 1.55 ± 0.11                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                            | 0.33 ± 0.017 ms     | 0.311 ± 0.033 ms    | 1.06 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                            | 0.0354 ± 0.00086 ms | 0.0347 ± 0.0041 ms  | 1.02 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                               | 0.0411 ± 0.0068 ms  | 0.0429 ± 0.0036 ms  | 0.958 ± 0.18               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                          | 1.23 ± 0.034 ms     | 1.05 ± 0.039 ms     | 1.18 ± 0.055               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                          | 0.0641 ± 0.0052 ms  | 0.055 ± 0.0038 ms   | 1.17 ± 0.12                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                              | 0.638 ± 0.03 ms     | 0.571 ± 0.024 ms    | 1.12 ± 0.07                |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                              | 31.4 ± 3.7 μs       | 26.5 ± 0.73 μs      | 1.19 ± 0.14                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                                 | 0.0833 ± 0.0062 ms  | 0.0736 ± 0.083 ms   | 1.13 ± 1.3                 |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                            | 1.86 ± 0.25 ms      | 1.23 ± 0.5 ms       | 1.51 ± 0.65                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                            | 0.0615 ± 0.0031 ms  | 0.0345 ± 0.0014 ms  | 1.78 ± 0.12                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                              | 0.317 ± 0.016 ms    | 0.337 ± 0.44 ms     | 0.939 ± 1.2                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                             | 0.365 ± 0.3 ms      | 0.375 ± 0.3 ms      | 0.975 ± 1.1                |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                                | 7.69 ± 1.8 ms       | 7.87 ± 0.071 ms     | 0.976 ± 0.23               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                           | 0.0345 ± 0.00062 s  | 0.035 ± 0.00011 s   | 0.987 ± 0.018              |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                                 | 1.63 ± 0.1 ms       | 0.294 ± 0.045 ms    | 5.56 ± 0.92                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                                    | 0.0718 ± 0.017 s    | 0.0328 ± 0.014 s    | 2.19 ± 1.1                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 1.38 ± 0.046 ms     | 0.336 ± 0.016 ms    | 4.11 ± 0.23                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 30.4 ± 12 μs        | 10.1 ± 6.4 μs       | 3.02 ± 2.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 0.423 ± 0.057 ms    | 0.281 ± 0.42 ms     | 1.5 ± 2.3                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.0605 ± 0.0058 ms  | 17.2 ± 2.6 μs       | 3.52 ± 0.62                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.0604 ± 0.013 ms   | 0.0373 ± 0.0063 ms  | 1.62 ± 0.45                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 0.442 ± 0.017 ms    | 0.39 ± 0.32 ms      | 1.13 ± 0.92                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.109 ± 0.0057 ms   | 0.0552 ± 0.0086 ms  | 1.98 ± 0.32                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 0.594 ± 0.014 ms    | 0.065 ± 0.0027 ms   | 9.14 ± 0.44                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 18.9 ± 9.2 ms       | 10.7 ± 1.6 ms       | 1.77 ± 0.9                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 0.609 ± 0.029 ms    | 0.0905 ± 0.0017 ms  | 6.72 ± 0.35                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.091 ± 0.016 ms    | 0.0521 ± 0.0088 ms  | 1.75 ± 0.42                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 2.78 ± 0.65 ms      | 0.751 ± 0.62 ms     | 3.7 ± 3.2                  |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 0.15 ± 0.03 ms      | 0.0802 ± 0.0038 ms  | 1.87 ± 0.38                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 0.982 ± 0.024 ms    | 0.149 ± 0.011 ms    | 6.6 ± 0.53                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 0.0709 ± 0.0015 s   | 0.0362 ± 0.00013 s  | 1.96 ± 0.041               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 0.842 ± 0.025 ms    | 0.23 ± 0.012 ms     | 3.66 ± 0.23                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 1.07 ± 0.059 ms     | 0.922 ± 0.098 ms    | 1.16 ± 0.14                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.142 ± 0.01 ms     | 0.0914 ± 0.0033 ms  | 1.55 ± 0.12                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.113 ± 0.021 ms    | 0.146 ± 0.017 ms    | 0.775 ± 0.17               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 3.24 ± 0.42 ms      | 3.38 ± 0.063 ms     | 0.958 ± 0.13               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 0.176 ± 0.008 ms    | 0.144 ± 0.0061 ms   | 1.22 ± 0.076               |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 0.107 ± 0.009 ms    | 0.0665 ± 0.0048 ms  | 1.6 ± 0.18                 |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 12.8 ± 2 μs         | 5.28 ± 0.52 μs      | 2.43 ± 0.45                |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 29 ± 2.9 μs         | 25.3 ± 1.6 μs       | 1.15 ± 0.13                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 0.685 ± 0.15 ms     | 0.394 ± 0.1 ms      | 1.74 ± 0.59                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 0.037 ± 0.0027 ms   | 20.8 ± 2.7 μs       | 1.78 ± 0.27                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme forward                     | 0.442 ± 0.024 ms    | 0.293 ± 0.027 ms    | 1.51 ± 0.16                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme reverse                     | 0.111 ± 0.01 ms     | 0.0598 ± 0.003 ms   | 1.86 ± 0.19                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/ForwardDiff                        | 0.0832 ± 0.013 ms   | 0.0671 ± 0.0033 ms  | 1.24 ± 0.2                 |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake forward                   | 1.69 ± 0.18 ms      | 1.47 ± 0.042 ms     | 1.15 ± 0.13                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake reverse                   | 0.145 ± 0.0062 ms   | 0.105 ± 0.0047 ms   | 1.39 ± 0.086               |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward             | 0.422 ± 0.021 ms    | 0.287 ± 0.024 ms    | 1.47 ± 0.14                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse             | 0.0799 ± 0.0046 ms  | 0.0584 ± 0.0032 ms  | 1.37 ± 0.11                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff                | 0.106 ± 0.014 ms    | 0.0596 ± 0.0034 ms  | 1.77 ± 0.26                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward           | 1.58 ± 0.13 ms      | 1.36 ± 0.048 ms     | 1.16 ± 0.11                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse           | 0.126 ± 0.011 ms    | 0.101 ± 0.0045 ms   | 1.25 ± 0.12                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                        | 0.241 ± 0.025 ms    | 0.218 ± 0.018 ms    | 1.1 ± 0.14                 |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                        | 0.0518 ± 0.0014 ms  | 0.0418 ± 0.0034 ms  | 1.24 ± 0.11                |
| AD gradients/Recurrence in Float32/ForwardDiff                                                           | 0.0502 ± 0.0059 ms  | 0.0378 ± 0.0036 ms  | 1.33 ± 0.2                 |
| AD gradients/Recurrence in Float32/Mooncake forward                                                      | 0.823 ± 0.053 ms    | 0.679 ± 0.016 ms    | 1.21 ± 0.083               |
| AD gradients/Recurrence in Float32/Mooncake reverse                                                      | 0.0829 ± 0.0035 ms  | 0.071 ± 0.0045 ms   | 1.17 ± 0.089               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                                   | 0.396 ± 0.048 ms    | 0.361 ± 0.039 ms    | 1.1 ± 0.18                 |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.0718 ± 0.0044 ms  | 0.0385 ± 0.00096 ms | 1.87 ± 0.12                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.068 ± 0.0099 ms   | 0.0876 ± 0.0046 ms  | 0.777 ± 0.12               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 1.4 ± 0.032 ms      | 1.57 ± 0.038 ms     | 0.892 ± 0.03               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.0878 ± 0.0037 ms  | 0.0567 ± 0.0017 ms  | 1.55 ± 0.081               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 0.396 ± 0.04 ms     | 0.291 ± 0.021 ms    | 1.36 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.0581 ± 0.0047 ms  | 0.0535 ± 0.0045 ms  | 1.09 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.0775 ± 0.015 ms   | 0.0487 ± 0.0031 ms  | 1.59 ± 0.33                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 1.1 ± 0.025 ms      | 1.07 ± 0.019 ms     | 1.03 ± 0.03                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 0.0901 ± 0.003 ms   | 0.0804 ± 0.0076 ms  | 1.12 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.0688 ± 0.0014 ms  | 0.0711 ± 0.0034 ms  | 0.967 ± 0.05               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 0.0377 ± 0.0035 ms  | 0.0372 ± 0.0025 ms  | 1.01 ± 0.12                |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 12.8 ± 2.9 μs       | 12.8 ± 2.8 μs       | 1 ± 0.32                   |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 0.216 ± 0.034 ms    | 0.233 ± 0.017 ms    | 0.924 ± 0.16               |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.067 ± 0.0052 ms   | 0.0521 ± 0.0034 ms  | 1.29 ± 0.13                |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 0.332 ± 0.034 ms    | 0.301 ± 0.016 ms    | 1.1 ± 0.13                 |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.0743 ± 0.0052 ms  | 0.0888 ± 0.0041 ms  | 0.837 ± 0.07               |
| AD gradients/Recurrence returning its state/ForwardDiff                                                  | 0.0642 ± 0.011 ms   | 0.0919 ± 0.0043 ms  | 0.699 ± 0.12               |
| AD gradients/Recurrence returning its state/Mooncake forward                                             | 1.67 ± 0.043 ms     | 1.23 ± 0.038 ms     | 1.36 ± 0.055               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                             | 0.118 ± 0.0055 ms   | 0.127 ± 0.0074 ms   | 0.927 ± 0.069              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                              | 0.138 ± 0.014 ms    | 0.119 ± 0.011 ms    | 1.16 ± 0.16                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                              | 27.1 ± 0.77 μs      | 0.0398 ± 0.0011 ms  | 0.683 ± 0.027              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                                 | 26.8 ± 2.2 μs       | 25.8 ± 2.3 μs       | 1.04 ± 0.13                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                            | 0.407 ± 0.12 ms     | 0.353 ± 0.017 ms    | 1.15 ± 0.33                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                            | 0.0521 ± 0.0016 ms  | 0.0533 ± 0.0056 ms  | 0.977 ± 0.11               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                                   | 0.27 ± 0.047 ms     | 0.229 ± 0.013 ms    | 1.18 ± 0.21                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                                   | 0.0759 ± 0.0038 ms  | 0.0429 ± 0.0026 ms  | 1.77 ± 0.14                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                                      | 0.0325 ± 0.0024 ms  | 0.0383 ± 0.0031 ms  | 0.848 ± 0.092              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                                 | 0.813 ± 0.15 ms     | 0.833 ± 0.021 ms    | 0.976 ± 0.19               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                                 | 0.0902 ± 0.0053 ms  | 0.0704 ± 0.0044 ms  | 1.28 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 0.422 ± 0.025 ms    | 0.32 ± 0.016 ms     | 1.32 ± 0.1                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.0894 ± 0.0056 ms  | 0.0538 ± 0.0032 ms  | 1.66 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.0687 ± 0.012 ms   | 0.0626 ± 0.0035 ms  | 1.1 ± 0.21                 |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 1.71 ± 0.052 ms     | 1.56 ± 0.053 ms     | 1.1 ± 0.051                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 0.145 ± 0.0049 ms   | 0.0963 ± 0.0053 ms  | 1.51 ± 0.098               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                                  | 1.1 ± 0.31 ms       | 1.17 ± 0.037 ms     | 0.933 ± 0.27               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                                  | 0.0614 ± 0.0028 ms  | 0.0489 ± 0.0019 ms  | 1.26 ± 0.074               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                                     | 0.134 ± 0.0094 ms   | 0.148 ± 0.018 ms    | 0.907 ± 0.13               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                                | 3.76 ± 0.95 ms      | 3.55 ± 0.49 ms      | 1.06 ± 0.31                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                                | 0.0988 ± 0.0084 ms  | 0.08 ± 0.0058 ms    | 1.23 ± 0.14                |
| Convolution body/BLAS axpy per lag                                                                       | 0.785 ± 0.0041 μs   | 0.787 ± 0.0034 μs   | 0.997 ± 0.0068             |
| Convolution body/native axpy per lag                                                                     | 0.505 ± 0.0066 μs   | 0.497 ± 0.006 μs    | 1.02 ± 0.018               |
| Convolution body/package                                                                                 | 0.785 ± 0.0043 μs   | 0.366 ± 0.0082 μs   | 2.15 ± 0.05                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                                  | 0.071 ± 0.0018 ms   | 0.0512 ± 0.0011 ms  | 1.39 ± 0.046               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                                 | 4.44 ± 0.3 μs       | 4.11 ± 0.28 μs      | 1.08 ± 0.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                                | 2.69 ± 1.6 μs       | 2.1 ± 0.37 μs       | 1.28 ± 0.78                |
| Evaluation/Matrix overview T200_L20_S3                                                                   | 0.0424 ± 0.015 ms   | 22.8 ± 0.89 μs      | 1.86 ± 0.67                |
| Evaluation/Matrix renewal T200_L20_S1                                                                    | 10 ± 1.8 μs         | 10.1 ± 1.7 μs       | 0.992 ± 0.25               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                              | 0.0505 ± 0.0018 ms  | 0.0336 ± 0.00069 ms | 1.5 ± 0.062                |
| AD gradients/Recurrence removals from recent outputs/Enzyme reverse                                      |                     | 0.0417 ± 0.004 ms   |                            |
| Convolution methods/S 1 T 2000 L 32/FFT forward                                                          |                     | 26.9 ± 3.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                           |                     | 0.145 ± 0.0069 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse                   |                     | 0.0538 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/ForwardDiff                              |                     | 0.0454 ± 0.0075 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward                     |                     | 2.54 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake forward                     |                     | 5.5 ± 0.096 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                  |                     | 0.0485 ± 0.0028 ms  |                            |
| Convolution methods/S 1 T 200 L 64/FFT Mooncake gradient                                                 |                     | 24.9 ± 4.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward   |                     | 0.28 ± 0.018 ms     |                            |
| Convolution methods/S 1 T 300 L 60/FFT forward                                                           |                     | 7.84 ± 0.37 μs      |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme reverse                              |                     | 0.0674 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                                      |                     | 0.413 ± 0.019 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                                   |                     | 0.0715 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff                     |                     | 0.0455 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake forward                        |                     | 1.14 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward                      |                     | 0.354 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                                 |                     | 0.865 ± 0.0082 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse        |                     | 18 ± 0.7 μs         |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                              |                     | 1.87 ± 0.038 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                                     |                     | 0.287 ± 0.017 ms    |                            |
| Convolution methods/S 1 T 200 L 64/Direct forward                                                        |                     | 3.29 ± 0.48 μs      |                            |
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                     | 7.58 ± 1 μs         |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                     | 2.22 ± 0.13 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                       |                     | 0.0438 ± 0.0009 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                              |                     | 0.954 ± 0.13 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                              |                     | 0.0738 ± 0.0085 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse               |                     | 0.0754 ± 0.0044 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake forward                         |                     | 1.34 ± 0.059 ms     |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward |                     | 1.34 ± 0.05 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                        |                     | 4.65 ± 0.086 ms     |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake forward                            |                     | 1.96 ± 0.029 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                     | 0.0562 ± 0.003 ms   |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                     | 0.103 ± 0.003 ms    |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/ForwardDiff                                 |                     | 0.0811 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme reverse                          |                     | 0.0571 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff      |                     | 0.0569 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                        |                     | 1.05 ± 0.069 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                          |                     | 0.115 ± 0.0055 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake forward                                  |                     | 1.15 ± 0.019 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                        |                     | 0.223 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse |                     | 0.116 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                              |                     | 0.232 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme forward                 |                     | 0.285 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake reverse         |                     | 0.117 ± 0.0051 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                     | 0.134 ± 0.0052 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                     | 0.0673 ± 0.0017 ms  |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                     | 0.664 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                     | 3.87 ± 0.38 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                     | 0.44 ± 0.018 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                     | 0.0978 ± 0.0032 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                     | 0.223 ± 0.013 ms    |                            |
| AD gradients/Recurrence removals from recent outputs/ForwardDiff                                         |                     | 0.0523 ± 0.0029 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct forward                                                      |                     | 0.0363 ± 0.0031 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                                |                     | 0.0684 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                            |                     | 0.0828 ± 0.0028 ms  |                            |
| Convolution methods/S 50 T 200 L 64/Direct forward                                                       |                     | 0.0918 ± 0.082 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                                |                     | 0.161 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme reverse                           |                     | 0.0415 ± 0.00096 ms |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                                    |                     | 1.93 ± 0.42 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                                   |                     | 1.35 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward            |                     | 2.65 ± 0.076 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                                 |                     | 0.0795 ± 0.0021 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                                |                     | 0.907 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme reverse                 |                     | 0.0597 ± 0.0012 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                           |                     | 1.2 ± 0.041 ms      |                            |
| Convolution methods/S 1 T 2000 L 32/Direct forward                                                       |                     | 10.3 ± 3.1 μs       |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward                      |                     | 0.827 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                       |                     | 1.51 ± 0.035 ms     |                            |
| Convolution methods/S 1 T 300 L 60/Direct forward                                                        |                     | 2.62 ± 0.2 μs       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward                    |                     | 1.7 ± 0.27 μs       |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                              |                     | 1.08 ± 0.024 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                         |                     | 0.0419 ± 0.0035 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                          |                     | 0.568 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/ForwardDiff                    |                     | 0.0613 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                                 |                     | 0.245 ± 0.024 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                                |                     | 0.0461 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                       |                     | 23.9 ± 1.7 μs       |                            |
| Convolution methods/S 1 T 300 L 60/Direct Mooncake gradient                                              |                     | 14.8 ± 0.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                        |                     | 0.0621 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse                 |                     | 0.0542 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse                    |                     | 0.138 ± 0.013 ms    |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                              |                     | 1.13 ± 0.049 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse                  |                     | 0.0369 ± 0.00078 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                                    |                     | 0.623 ± 0.089 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                                 |                     | 0.0382 ± 0.0026 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                             |                     | 0.0798 ± 0.014 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme reverse                                 |                     | 0.115 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                         |                     | 0.0557 ± 0.0042 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                     | 0.659 ± 0.046 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                     | 1.82 ± 0.093 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                     | 0.131 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                     | 0.245 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                     | 0.17 ± 0.0069 ms    |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                     | 0.0639 ± 0.0023 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                     | 0.119 ± 0.0034 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                     | 4.55 ± 0.25 ms      |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                     | 0.0781 ± 0.004 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                     | 0.0317 ± 0.0017 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                     | 0.118 ± 0.0035 ms   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                     | 0.115 ± 0.0088 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                     | 0.0657 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                     | 0.219 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                     | 28.3 ± 2.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                     | 0.0862 ± 0.0068 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                     | 3.59 ± 0.37 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                     | 0.264 ± 0.016 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                     | 0.352 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                     | 0.118 ± 0.0046 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                     | 0.0722 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                     | 1.19 ± 0.075 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                     | 1.04 ± 0.043 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                     | 3.86 ± 0.12 ms      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                     | 18.4 ± 0.66 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                     | 0.0395 ± 0.00089 ms |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                     | 0.07 ± 0.0046 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                     | 0.33 ± 0.038 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                     | 0.155 ± 0.0059 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                     | 0.29 ± 0.026 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                     | 0.43 ± 0.018 ms     |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                     | 14.1 ± 1.5 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                     | 0.263 ± 0.017 ms    |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                     | 1.63 ± 0.3 ms       |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                     | 0.0882 ± 0.0028 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                           |                     | 0.238 ± 0.024 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/ForwardDiff                              |                     | 0.062 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake reverse                     |                     | 0.196 ± 0.016 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                                |                     | 0.244 ± 0.017 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                             |                     | 0.0501 ± 0.0013 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                                   |                     | 0.0489 ± 0.0068 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                       |                     | 0.0824 ± 0.002 ms   |                            |
| Convolution methods/S 1 T 200 L 32/FFT Mooncake gradient                                                 |                     | 27 ± 3 μs           |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme reverse                    |                     | 0.08 ± 0.0021 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                             |                     | 0.063 ± 0.005 ms    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                              |                     | 0.0634 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                         |                     | 0.357 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake reverse                          |                     | 0.127 ± 0.0032 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                     | 0.144 ± 0.0059 ms   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                     | 0.101 ± 0.0065 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                     | 0.147 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                     | 30 ± 0.76 μs        |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                     | 0.0865 ± 0.048 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                     | 0.961 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                     | 0.0355 ± 0.015 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                     | 0.0648 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                     | 0.109 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                     | 0.615 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                     | 1.64 ± 0.057 ms     |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                     | 0.0681 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                     | 1.77 ± 0.28 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                     | 0.0379 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                     | 0.0886 ± 0.0056 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                     | 0.0592 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                     | 0.0928 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                     | 0.0913 ± 0.0025 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                     | 3 ± 0.13 ms         |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                     | 1.65 ± 0.28 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                     | 1.04 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                     | 0.0542 ± 0.0043 ms  |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                     | 0.271 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                     | 0.0435 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                     | 0.0592 ± 0.0016 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                     | 0.113 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme reverse                  |                     | 6.52 ± 0.41 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward                      |                     | 0.236 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                            |                     | 0.04 ± 0.0043 ms    |                            |
| Convolution methods/S 1 T 300 L 60/FFT Mooncake gradient                                                 |                     | 28.2 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme reverse                            |                     | 0.115 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                        |                     | 0.263 ± 0.087 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/ForwardDiff                             |                     | 0.0469 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake forward         |                     | 1.39 ± 0.034 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                            |                     | 0.0778 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                      |                     | 0.0615 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse                      |                     | 0.0587 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                          |                     | 0.331 ± 0.015 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                                |                     | 0.4 ± 0.024 ms      |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                         |                     | 0.043 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake reverse                          |                     | 0.1 ± 0.0036 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/ForwardDiff              |                     | 0.0652 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                               |                     | 0.229 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                                |                     | 0.536 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                                   |                     | 0.371 ± 0.018 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward                  |                     | 16.2 ± 0.66 μs      |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake forward                                    |                     | 1.37 ± 0.023 ms     |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                              |                     | 0.0462 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward              |                     | 0.702 ± 0.067 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                         |                     | 0.158 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                              |                     | 0.14 ± 0.0055 ms    |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake forward                          |                     | 1.35 ± 0.019 ms     |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward                 |                     | 0.252 ± 0.035 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                             |                     | 1 ± 0.12 ms         |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward                    |                     | 0.13 ± 0.014 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff                 |                     | 0.101 ± 0.0074 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake forward                               |                     | 5.65 ± 0.94 ms      |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse            |                     | 0.141 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse                      |                     | 0.0892 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse                |                     | 0.0608 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                                    |                     | 14.2 ± 2.3 μs       |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme forward                                     |                     | 0.195 ± 0.035 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme forward                          |                     | 0.274 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                           |                     | 0.177 ± 0.0069 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                         |                     | 0.0548 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                           |                     | 0.1 ± 0.0062 ms     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                             |                     | 0.926 ± 0.023 ms    |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff                    |                     | 0.0797 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                                    |                     | 0.0411 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff             |                     | 1.88 ± 0.32 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                                 |                     | 0.0722 ± 0.053 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake forward               |                     | 1.23 ± 0.026 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse                |                     | 0.0805 ± 0.0036 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/Direct Mooncake gradient                                             |                     | 0.078 ± 0.001 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                     | 0.1 ± 0.005 ms      |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                     | 0.643 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                     | 0.115 ± 0.0056 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                     | 0.065 ± 0.0016 ms   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                     | 27.9 ± 3.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                     | 0.082 ± 0.005 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                     | 0.884 ± 0.089 ms    |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                     | 0.345 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                     | 0.0804 ± 0.0043 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                     | 0.152 ± 0.0094 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                     | 0.398 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                     | 1.33 ± 0.064 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                     | 0.132 ± 0.0053 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                     | 0.0468 ± 0.0043 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                     | 0.175 ± 0.044 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                     | 3.44 ± 0.13 ms      |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                     | 1.75 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                     | 0.878 ± 0.018 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                     | 0.085 ± 0.0025 ms   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                     | 1.36 ± 0.22 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                     | 0.0631 ± 0.0044 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                     | 1.5 ± 0.026 ms      |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                     | 1.56 ± 0.53 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                     | 0.0792 ± 0.0049 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                     | 0.518 ± 0.045 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                     | 0.879 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                     | 0.159 ± 0.077 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                     | 0.0321 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                     | 0.0592 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                     | 0.0895 ± 0.0025 ms  |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                     | 0.107 ± 0.0051 ms   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                     | 1.62 ± 0.098 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                     | 0.326 ± 0.017 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                     | 0.0532 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                               |                     | 0.0998 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme forward                  |                     | 0.0615 ± 0.025 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake forward                         |                     | 0.842 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                                |                     | 0.163 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward                |                     | 1.06 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                         |                     | 0.0427 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse                      |                     | 0.0888 ± 0.0044 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                           |                     | 0.111 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                              |                     | 2.24 ± 0.058 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                        |                     | 0.0949 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward                  |                     | 1.45 ± 0.048 ms     |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                                |                     | 0.0763 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                                     |                     | 0.0703 ± 0.0041 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme forward                           |                     | 0.277 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward                  |                     | 0.277 ± 0.023 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                                     |                     | 0.0389 ± 0.003 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/FFT Mooncake gradient                                              |                     | 1.3 ± 0.04 ms       |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                                      |                     | 0.0581 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                                      |                     | 0.666 ± 0.014 ms    |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake forward                                   |                     | 0.828 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake reverse                        |                     | 0.105 ± 0.0029 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                             |                     | 0.72 ± 0.018 ms     |                            |
| Convolution methods/S 1 T 200 L 32/FFT forward                                                           |                     | 14.9 ± 4.5 μs       |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                                   |                     | 0.0522 ± 0.0038 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                           |                     | 0.319 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                                  |                     | 2.08 ± 0.041 ms     |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                     | 0.0709 ± 0.006 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                     | 0.0589 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                        |                     | 0.0585 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme forward                           |                     | 0.201 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward     |                     | 1.39 ± 0.022 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                          |                     | 0.15 ± 0.0064 ms    |                            |
| Convolution methods/S 50 T 200 L 64/FFT forward                                                          |                     | 0.142 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff                    |                     | 0.18 ± 0.0075 ms    |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                                     |                     | 1.16 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme forward           |                     | 0.287 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                        |                     | 0.0426 ± 0.006 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff                   |                     | 0.162 ± 0.0096 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward        |                     | 17.3 ± 1.7 μs       |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward               |                     | 1.36 ± 0.021 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                     | 0.487 ± 0.023 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                     | 0.041 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                     | 2.64 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                     | 0.116 ± 0.006 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                     | 0.0653 ± 0.049 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                     | 10.7 ± 0.9 μs       |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                     | 0.0872 ± 0.02 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                     | 0.117 ± 0.0031 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                     | 0.0539 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                     | 0.0857 ± 0.0056 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                     | 0.17 ± 0.12 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                     | 0.0651 ± 0.0018 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                     | 0.0451 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                     | 0.0607 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                     | 0.0926 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                     | 0.154 ± 0.016 ms    |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                     | 29.4 ± 1.4 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                     | 0.0841 ± 0.042 ms   |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                     | 0.0754 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                                    |                     | 0.0617 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                        |                     | 8.2 ± 1.6 μs        |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                             |                     | 0.107 ± 0.0085 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                                 |                     | 0.0715 ± 0.0018 ms  |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse                 |                     | 0.0435 ± 0.0011 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/FFT Mooncake gradient                                                |                     | 0.462 ± 0.81 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/ForwardDiff                               |                     | 0.0878 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                                  |                     | 0.0751 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                       |                     | 0.962 ± 0.081 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake reverse                  |                     | 0.115 ± 0.0086 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme reverse                                    |                     | 0.0559 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                                   |                     | 0.236 ± 0.018 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme reverse                           |                     | 0.059 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse                    |                     | 0.058 ± 0.0013 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                             |                     | 0.0637 ± 0.0069 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/ForwardDiff                       |                     | 0.069 ± 0.0028 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                                |                     | 0.482 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward                 |                     | 0.106 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                        |                     | 0.116 ± 0.0062 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                       |                     | 0.702 ± 0.09 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                                   |                     | 0.0575 ± 0.0037 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                                |                     | 0.0338 ± 0.00084 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward                |                     | 1.31 ± 0.056 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                       |                     | 0.0813 ± 0.0021 ms  |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake reverse                                    |                     | 0.0976 ± 0.0068 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/FFT Mooncake gradient                                               |                     | 0.128 ± 0.014 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                           |                     | 0.0697 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                        |                     | 1.5 ± 0.039 ms      |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                                      |                     | 0.501 ± 0.023 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                           |                     | 0.105 ± 0.017 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                             |                     | 0.0439 ± 0.0053 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                         |                     | 1.08 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake forward                |                     | 0.396 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                                      |                     | 0.0347 ± 0.003 ms   |                            |
| Convolution methods/S 1 T 200 L 32/Direct Mooncake gradient                                              |                     | 13.5 ± 4.5 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                         |                     | 0.0601 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward                 |                     | 0.303 ± 0.044 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                                |                     | 0.0549 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse                 |                     | 0.0786 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                                    |                     | 0.114 ± 0.011 ms    |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme reverse                                     |                     | 0.0333 ± 0.00091 ms |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                           |                     | 0.0337 ± 0.00093 ms |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward               |                     | 3.69 ± 0.047 ms     |                            |
| Convolution methods/S 50 T 200 L 64/Direct Mooncake gradient                                             |                     | 0.472 ± 0.013 ms    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                     | 0.0894 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                     | 0.0966 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                     | 0.0347 ± 0.0033 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                     | 0.101 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                     | 0.13 ± 0.0046 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                     | 0.107 ± 0.0029 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                           |                     | 0.0804 ± 0.007 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                                 |                     | 1.42 ± 0.071 ms     |                            |
| Convolution methods/S 1 T 200 L 32/Direct forward                                                        |                     | 2.62 ± 0.44 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                                    |                     | 1.41 ± 0.05 ms      |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/ForwardDiff                          |                     | 0.423 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                 |                     | 1.47 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/ForwardDiff                               |                     | 0.0662 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward              |                     | 4.46 ± 0.095 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                                   |                     | 0.373 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                                    |                     | 0.0736 ± 0.0029 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme forward                                      |                     | 0.487 ± 0.022 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward                      |                     | 2.2 ± 0.1 ms        |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                                   |                     | 0.122 ± 0.0076 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme forward                                 |                     | 1.63 ± 0.037 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                                |                     | 10.2 ± 0.46 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                                     |                     | 2.7 ± 0.033 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                                |                     | 0.131 ± 0.0078 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                                      |                     | 0.0615 ± 0.0048 ms  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct forward                                                     |                     | 0.941 ± 0.15 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                    |                     | 26.3 ± 0.84 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward                    |                     | 1.14 ± 0.032 ms     |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme reverse                                      |                     | 0.079 ± 0.0019 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/ForwardDiff                                    |                     | 0.296 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward                   |                     | 0.0331 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme forward                            |                     | 0.27 ± 0.021 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme forward                    |                     | 0.579 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                           |                     | 3.68 ± 0.19 ms      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                              |                     | 0.418 ± 0.041 ms    |                            |
| time_to_load                                                                                             | 0.239 ± 0.0014 s    | 0.353 ± 0.0037 s    | 0.675 ± 0.0081             |

|                                                                                                          | v0.1.0                    | 8707c593d80e65...         | v0.1.0 / 8707c593d80e65... |
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
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 9.4 k allocs: 0.381 MB    | 1.31 k allocs: 0.174 MB   | 2.19                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 0.054 k allocs: 0.0376 MB | 0.039 k allocs: 19 kB     | 2.03                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.161 k allocs: 0.0396 MB | 0.152 k allocs: 21 kB     | 1.93                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 0.542 k allocs: 1.69 MB   | 0.422 k allocs: 0.852 MB  | 1.98                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 1.53 k allocs: 0.293 MB   | 0.111 k allocs: 0.0881 MB | 3.33                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 2.71 k allocs: 24.9 MB    | 1.1 k allocs: 12.3 MB     | 2.02                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 5.84 k allocs: 0.353 MB   | 0.111 k allocs: 0.0892 MB | 3.96                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.18 k allocs: 0.0375 MB  | 0.193 k allocs: 27.3 kB   | 1.4                        |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 1.53 k allocs: 0.307 MB   | 0.279 k allocs: 0.126 MB  | 2.43                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 6.2 k allocs: 0.0508 GB   | 5.15 k allocs: 0.0396 GB  | 1.28                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 9.06 k allocs: 0.369 MB   | 0.933 k allocs: 0.145 MB  | 2.55                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 8.54 k allocs: 0.784 MB   | 7.89 k allocs: 0.71 MB    | 1.11                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.652 k allocs: 0.0473 MB | 0.416 k allocs: 0.0331 MB | 1.43                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.713 k allocs: 0.321 MB  | 0.632 k allocs: 0.268 MB  | 1.2                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 0.0394 M allocs: 1.95 MB  | 0.0369 M allocs: 1.81 MB  | 1.07                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 1.69 k allocs: 0.0622 MB  | 1.37 k allocs: 0.062 MB   | 1                          |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 1.13 k allocs: 0.141 MB   | 0.807 k allocs: 0.103 MB  | 1.36                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 0.077 k allocs: 10.4 kB   | 0.091 k allocs: 9.31 kB   | 1.11                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 0.162 k allocs: 0.108 MB  | 0.117 k allocs: 0.0811 MB | 1.33                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 7.39 k allocs: 0.455 MB   | 2.47 k allocs: 0.272 MB   | 1.67                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 0.44 k allocs: 18 kB      | 0.164 k allocs: 11.8 kB   | 1.53                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme forward                     | 3.66 k allocs: 0.234 MB   | 2.91 k allocs: 0.181 MB   | 1.29                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme reverse                     | 0.375 k allocs: 22.1 kB   | 0.27 k allocs: 14 kB      | 1.57                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/ForwardDiff                        | 0.332 k allocs: 0.116 MB  | 0.242 k allocs: 0.0874 MB | 1.33                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake forward                   | 14.5 k allocs: 0.654 MB   | 10.8 k allocs: 0.511 MB   | 1.28                       |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake reverse                   | 1.27 k allocs: 0.042 MB   | 0.885 k allocs: 0.0322 MB | 1.3                        |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward             | 3.66 k allocs: 0.234 MB   | 2.91 k allocs: 0.181 MB   | 1.29                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse             | 0.347 k allocs: 20.2 kB   | 0.27 k allocs: 14 kB      | 1.44                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff                | 0.332 k allocs: 0.116 MB  | 0.242 k allocs: 0.0874 MB | 1.33                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward           | 14.5 k allocs: 0.654 MB   | 10.8 k allocs: 0.511 MB   | 1.28                       |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse           | 1.15 k allocs: 0.0385 MB  | 0.885 k allocs: 0.0322 MB | 1.2                        |
| AD gradients/Recurrence in Float32/Enzyme forward                                                        | 2.77 k allocs: 0.162 MB   | 2.43 k allocs: 0.136 MB   | 1.19                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                        | 0.295 k allocs: 16.2 kB   | 0.211 k allocs: 10.1 kB   | 1.61                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                                           | 0.222 k allocs: 0.0645 MB | 0.182 k allocs: 0.049 MB  | 1.32                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                                      | 11.5 k allocs: 0.443 MB   | 10.1 k allocs: 0.389 MB   | 1.14                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                                      | 1.02 k allocs: 0.033 MB   | 0.693 k allocs: 24.8 kB   | 1.36                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                                   | 3.14 k allocs: 0.279 MB   | 2.95 k allocs: 0.281 MB   | 0.991                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.246 k allocs: 20 kB     | 0.182 k allocs: 13.4 kB   | 1.49                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.303 k allocs: 0.154 MB  | 0.296 k allocs: 0.161 MB  | 0.956                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 17.4 k allocs: 0.834 MB   | 15.8 k allocs: 0.828 MB   | 1.01                       |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.691 k allocs: 26.1 kB   | 0.671 k allocs: 28.1 kB   | 0.928                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 3.18 k allocs: 0.261 MB   | 2.77 k allocs: 0.214 MB   | 1.22                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.233 k allocs: 17.1 kB   | 0.235 k allocs: 15.3 kB   | 1.11                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.29 k allocs: 0.13 MB    | 0.242 k allocs: 0.0952 MB | 1.37                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 15.7 k allocs: 0.716 MB   | 14 k allocs: 0.611 MB     | 1.17                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 1.15 k allocs: 0.0397 MB  | 0.835 k allocs: 0.0319 MB | 1.24                       |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 0.176 k allocs: 7.66 kB   | 0.193 k allocs: 8.34 kB   | 0.918                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 4.09 k allocs: 0.137 MB   | 3.75 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.809 k allocs: 25.5 kB   | 0.679 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 3.31 k allocs: 0.237 MB   | 3.21 k allocs: 0.212 MB   | 1.12                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.336 k allocs: 21.5 kB   | 0.311 k allocs: 17.2 kB   | 1.25                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                                  | 0.287 k allocs: 0.125 MB  | 0.262 k allocs: 0.102 MB  | 1.23                       |
| AD gradients/Recurrence returning its state/Mooncake forward                                             | 15.9 k allocs: 0.718 MB   | 12.5 k allocs: 0.584 MB   | 1.23                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                             | 1.16 k allocs: 0.0393 MB  | 0.936 k allocs: 0.0344 MB | 1.14                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                              | 1.5 k allocs: 0.132 MB    | 1.25 k allocs: 0.104 MB   | 1.27                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                              | 0.198 k allocs: 15.6 kB   | 0.237 k allocs: 19.3 kB   | 0.809                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                                 | 0.174 k allocs: 0.0836 MB | 0.138 k allocs: 0.0622 MB | 1.34                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                            | 5.38 k allocs: 0.321 MB   | 4.41 k allocs: 0.264 MB   | 1.22                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                            | 0.39 k allocs: 16.1 kB    | 0.466 k allocs: 24.5 kB   | 0.659                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                                   | 2.74 k allocs: 0.209 MB   | 2.38 k allocs: 0.168 MB   | 1.24                       |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                                   | 0.382 k allocs: 21.7 kB   | 0.203 k allocs: 12.4 kB   | 1.75                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                                      | 0.237 k allocs: 0.105 MB  | 0.192 k allocs: 0.0755 MB | 1.39                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                                 | 12.3 k allocs: 0.571 MB   | 10.9 k allocs: 0.487 MB   | 1.17                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                                 | 1.02 k allocs: 0.0353 MB  | 0.713 k allocs: 27.8 kB   | 1.3                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 3.74 k allocs: 0.297 MB   | 3.35 k allocs: 0.252 MB   | 1.18                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.375 k allocs: 23.9 kB   | 0.259 k allocs: 17.5 kB   | 1.37                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.338 k allocs: 0.149 MB  | 0.284 k allocs: 0.114 MB  | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 19.4 k allocs: 0.879 MB   | 14.8 k allocs: 0.69 MB    | 1.27                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 1.35 k allocs: 0.046 MB   | 0.925 k allocs: 0.0356 MB | 1.29                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                                  | 10.7 k allocs: 0.915 MB   | 9.37 k allocs: 0.762 MB   | 1.2                        |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                                  | 0.383 k allocs: 25 kB     | 0.234 k allocs: 18 kB     | 1.39                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                                     | 0.886 k allocs: 0.384 MB  | 0.733 k allocs: 0.275 MB  | 1.4                        |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                                | 0.0515 M allocs: 2.58 MB  | 0.0464 M allocs: 2.29 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                                | 0.863 k allocs: 0.033 MB  | 0.837 k allocs: 0.0341 MB | 0.967                      |
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
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward                     |                           | 23.2 k allocs: 1.14 MB    |                            |
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
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                           | 22  allocs: 13.9 kB       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                           | 22.8 k allocs: 1.11 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                       |                           | 0.225 k allocs: 14.8 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                              |                           | 13.9 k allocs: 0.592 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                              |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse               |                           | 0.619 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake forward                         |                           | 11.9 k allocs: 0.608 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward |                           | 11 k allocs: 0.519 MB     |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                        |                           | 0.0411 M allocs: 2.11 MB  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake forward                            |                           | 21.8 k allocs: 1.1 MB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                           | 0.556 k allocs: 24.4 kB   |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                           | 1.04 k allocs: 0.0414 MB  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/ForwardDiff                                 |                           | 0.464 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme reverse                          |                           | 0.275 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff      |                           | 0.247 k allocs: 0.088 MB  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                        |                           | 9.61 k allocs: 0.79 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                          |                           | 0.45 k allocs: 0.163 MB   |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake forward                                  |                           | 11.8 k allocs: 0.634 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                        |                           | 2.44 k allocs: 0.165 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse |                           | 0.829 k allocs: 29.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                              |                           | 2.49 k allocs: 0.14 MB    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme forward                 |                           | 3.02 k allocs: 0.224 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake reverse         |                           | 0.829 k allocs: 29.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                           | 1.03 k allocs: 0.0388 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                           | 0.33 k allocs: 18.7 kB    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                           | 5.65 k allocs: 0.455 MB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                           | 0.053 k allocs: 3.42 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                           | 4.61 k allocs: 0.325 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                           | 0.984 k allocs: 0.0375 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                           | 2.38 k allocs: 0.163 MB   |                            |
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
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                           | 5.77 k allocs: 0.433 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                           | 21.2 k allocs: 0.957 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                           | 0.621 k allocs: 0.0488 MB |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                           | 2.34 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                           | 0.675 k allocs: 0.0356 MB |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                           | 0.633 k allocs: 27.1 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                           | 1.26 k allocs: 0.0517 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                           | 31  allocs: 1.23 MB       |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                           | 0.801 k allocs: 31.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                           | 0.23 k allocs: 0.0895 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                           | 1 k allocs: 0.0334 MB     |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                           | 1.21 k allocs: 0.049 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                           | 0.542 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                           | 1.89 k allocs: 0.175 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                           | 0.14 k allocs: 0.0463 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                           | 0.38 k allocs: 0.137 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                           | 0.097 k allocs: 5.78 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                           | 2.45 k allocs: 0.172 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                           | 5.28 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                           | 0.963 k allocs: 0.0351 MB |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                           | 0.287 k allocs: 17.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                           | 11.5 k allocs: 0.524 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                           | 0.0472 M allocs: 2.33 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                           | 0.201 k allocs: 9.69 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                           | 0.334 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                           | 2.91 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                           | 1.09 k allocs: 0.0351 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                           | 25  allocs: 0.581 MB      |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                           | 4.52 k allocs: 0.319 MB   |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                           | 22  allocs: 14 kB         |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                           | 2.85 k allocs: 0.214 MB   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                           | 22.8 k allocs: 0.978 MB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                           | 0.757 k allocs: 0.0321 MB |                            |
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
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                           | 0.587 k allocs: 0.192 MB  |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                           | 1.06 k allocs: 0.0367 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                           | 0.96 k allocs: 31.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                           | 0.129 k allocs: 11.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                           | 0.303 k allocs: 0.161 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                           | 16.9 k allocs: 0.927 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                           | 0.117 k allocs: 0.0811 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                           | 0.298 k allocs: 20.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                           | 5.87 k allocs: 0.443 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                           | 21.5 k allocs: 0.972 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                           | 0.287 k allocs: 17.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                           | 0.217 k allocs: 0.0845 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                           | 0.452 k allocs: 0.237 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                           | 0.479 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                           | 0.389 k allocs: 28.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                           | 0.846 k allocs: 0.0315 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                           | 0.0398 M allocs: 2.03 MB  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                           | 12.4 k allocs: 1.27 MB    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                           | 9.98 k allocs: 0.727 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                           | 2.48 k allocs: 0.195 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                           | 0.202 k allocs: 0.0499 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                           | 0.296 k allocs: 20.3 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                           | 1.18 k allocs: 0.0449 MB  |                            |
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
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                         |                           | 1.11 k allocs: 0.0371 MB  |                            |
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
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                           | 0.899 k allocs: 0.0343 MB |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                           | 0.065 k allocs: 1.14 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                           | 0.834 k allocs: 30.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                           | 0.103 k allocs: 7 kB      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                           | 0.284 k allocs: 22.2 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                           | 9.13 k allocs: 0.678 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                           | 3.13 k allocs: 0.219 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                           | 0.262 k allocs: 0.121 MB  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                           | 1.34 k allocs: 0.069 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                           | 3.96 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                           | 16.6 k allocs: 0.705 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                           | 1.28 k allocs: 0.0528 MB  |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                           | 0.232 k allocs: 0.116 MB  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                           | 30  allocs: 0.124 MB      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                           | 0.0373 M allocs: 1.85 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                           | 18.9 k allocs: 0.832 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                           | 10.3 k allocs: 0.469 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                           | 0.412 k allocs: 27.3 kB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                           | 0.683 k allocs: 22.2 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                           | 17.3 k allocs: 0.816 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                           | 22.1 k allocs: 1.11 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                           | 0.181 k allocs: 0.0406 MB |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                           | 5.3 k allocs: 0.4 MB      |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                           | 10.7 k allocs: 0.424 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                           | 0.75 k allocs: 0.277 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                           | 0.34 k allocs: 23.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                           | 0.371 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                           | 0.825 k allocs: 0.0323 MB |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                           | 0.896 k allocs: 0.0358 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                           | 19.2 k allocs: 0.846 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                           | 2.85 k allocs: 0.222 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                           | 0.274 k allocs: 17.3 kB   |                            |
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
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                                     |                           | 0.212 k allocs: 0.084 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/FFT Mooncake gradient                                              |                           | 0.066 k allocs: 1.5 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                                      |                           | 0.256 k allocs: 16.5 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                                      |                           | 1.16 k allocs: 0.191 MB   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake forward                                   |                           | 9.19 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake reverse                        |                           | 0.84 k allocs: 0.0323 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                             |                           | 6.98 k allocs: 0.527 MB   |                            |
| Convolution methods/S 1 T 200 L 32/FFT forward                                                           |                           | 18  allocs: 13.2 kB       |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                                   |                           | 0.262 k allocs: 0.108 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                           |                           | 4.6 k allocs: 0.345 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                                  |                           | 25.8 k allocs: 1.53 MB    |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                           | 0.203 k allocs: 19.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                           | 0.22 k allocs: 15.8 kB    |                            |
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
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                           | 4.41 k allocs: 0.314 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                           | 30.7 k allocs: 1.42 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                           | 0.331 k allocs: 0.148 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                           | 0.05 k allocs: 9.29 kB    |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                           | 0.332 k allocs: 0.128 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                           | 1.1 k allocs: 0.0455 MB   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                           | 0.317 k allocs: 17.5 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                           | 0.734 k allocs: 0.357 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                           | 0.734 k allocs: 30.7 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                           | 0.458 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                           | 0.214 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                           | 0.847 k allocs: 0.0315 MB |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                           | 0.516 k allocs: 0.0568 MB |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                           | 25  allocs: 0.071 MB      |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                           | 0.262 k allocs: 0.119 MB  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                           | 0.327 k allocs: 21.7 kB   |                            |
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
| AD gradients/Recurrence removals from recent outputs/Mooncake reverse                                    |                           | 0.667 k allocs: 27.7 kB   |                            |
| Convolution methods/S 1 T 2000 L 100/FFT Mooncake gradient                                               |                           | 0.065 k allocs: 0.18 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                           |                           | 0.841 k allocs: 0.0322 MB |                            |
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
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                           | 0.92 k allocs: 0.0365 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                           | 0.61 k allocs: 24.6 kB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                           | 0.442 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                           | 1.06 k allocs: 0.0392 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                           | 1.08 k allocs: 0.0415 MB  |                            |
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

