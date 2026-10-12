|                                                                                                   | v0.1.0              | 312db5a2450629...   | v0.1.0 / 312db5a2450629... |
|:--------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.0669 ± 0.0054 ms  | 0.0672 ± 0.0053 ms  | 0.997 ± 0.11               |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 30.6 ± 0.62 μs      | 30.1 ± 0.74 μs      | 1.02 ± 0.032               |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 9.66 ± 1.6 μs       | 4.37 ± 0.3 μs       | 2.21 ± 0.41                |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 0.239 ± 0.04 ms     | 0.227 ± 0.011 ms    | 1.05 ± 0.18                |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.0531 ± 0.0028 ms  | 0.0385 ± 0.0034 ms  | 1.38 ± 0.14                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 0.25 ± 0.017 ms     | 0.233 ± 0.014 ms    | 1.07 ± 0.097               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.0412 ± 0.0011 ms  | 0.0346 ± 0.00081 ms | 1.19 ± 0.042               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.0344 ± 0.013 ms   | 27.7 ± 1.2 μs       | 1.24 ± 0.47                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 1.08 ± 0.045 ms     | 0.888 ± 0.036 ms    | 1.21 ± 0.071               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.0691 ± 0.0048 ms  | 0.043 ± 0.002 ms    | 1.61 ± 0.13                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 0.337 ± 0.016 ms    | 0.336 ± 0.048 ms    | 1 ± 0.15                   |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 0.0355 ± 0.00072 ms | 0.0339 ± 0.00084 ms | 1.05 ± 0.034               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.0388 ± 0.0018 ms  | 0.0403 ± 0.0032 ms  | 0.964 ± 0.088              |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 1.02 ± 0.11 ms      | 1.03 ± 0.041 ms     | 0.982 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.0695 ± 0.0091 ms  | 0.0433 ± 0.0011 ms  | 1.6 ± 0.21                 |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 0.63 ± 0.029 ms     | 0.579 ± 0.03 ms     | 1.09 ± 0.075               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 29.8 ± 0.73 μs      | 27.5 ± 0.85 μs      | 1.09 ± 0.043               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.0823 ± 0.0065 ms  | 0.0706 ± 0.0073 ms  | 1.17 ± 0.15                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 1.91 ± 0.63 ms      | 1.22 ± 0.11 ms      | 1.56 ± 0.53                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.0619 ± 0.005 ms   | 0.0348 ± 0.0018 ms  | 1.78 ± 0.17                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.334 ± 0.4 ms      | 0.339 ± 0.42 ms     | 0.986 ± 1.7                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.367 ± 0.3 ms      | 0.629 ± 0.3 ms      | 0.584 ± 0.55               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 12.5 ± 4.4 ms       | 7.45 ± 4.5 ms       | 1.67 ± 1.2                 |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 0.0364 ± 0.015 s    | 0.035 ± 0.00023 s   | 1.04 ± 0.41                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 1.42 ± 0.06 ms      | 0.317 ± 0.053 ms    | 4.48 ± 0.78                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 0.0825 ± 0.019 s    | 28.6 ± 8.5 ms       | 2.88 ± 1.1                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 1.33 ± 0.039 ms     | 0.348 ± 0.017 ms    | 3.8 ± 0.21                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 29.9 ± 12 μs        | 11.9 ± 6.9 μs       | 2.51 ± 1.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.41 ± 0.68 ms      | 0.269 ± 0.43 ms     | 1.52 ± 3.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.0602 ± 0.0046 ms  | 17.1 ± 2.5 μs       | 3.52 ± 0.58                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.0637 ± 0.014 ms   | 0.0404 ± 0.0069 ms  | 1.58 ± 0.45                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 0.462 ± 0.58 ms     | 0.435 ± 0.017 ms    | 1.06 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.111 ± 0.016 ms    | 0.0575 ± 0.0031 ms  | 1.93 ± 0.3                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 0.709 ± 0.022 ms    | 0.0869 ± 0.036 ms   | 8.17 ± 3.4                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 19 ± 0.46 ms        | 10.9 ± 1.2 ms       | 1.75 ± 0.19                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 0.62 ± 0.059 ms     | 0.107 ± 0.0021 ms   | 5.81 ± 0.57                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.0929 ± 0.015 ms   | 0.0626 ± 0.0081 ms  | 1.48 ± 0.31                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 2.78 ± 0.037 ms     | 1.32 ± 0.63 ms      | 2.11 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 0.154 ± 0.022 ms    | 0.0832 ± 0.0056 ms  | 1.85 ± 0.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 0.95 ± 0.032 ms     | 0.191 ± 0.0082 ms   | 4.98 ± 0.27                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 0.086 ± 0.0023 s    | 0.0353 ± 0.00012 s  | 2.44 ± 0.066               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 0.849 ± 0.025 ms    | 0.263 ± 0.014 ms    | 3.23 ± 0.2                 |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 1.07 ± 0.03 ms      | 0.913 ± 0.095 ms    | 1.17 ± 0.13                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.143 ± 0.012 ms    | 0.105 ± 0.0031 ms   | 1.37 ± 0.12                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.115 ± 0.0085 ms   | 0.128 ± 0.013 ms    | 0.896 ± 0.11               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 3.59 ± 0.09 ms      | 3.58 ± 0.1 ms       | 1 ± 0.039                  |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 0.178 ± 0.013 ms    | 0.136 ± 0.015 ms    | 1.31 ± 0.17                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 0.26 ± 0.044 ms     | 0.209 ± 0.014 ms    | 1.25 ± 0.23                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.0562 ± 0.0044 ms  | 0.0447 ± 0.0036 ms  | 1.26 ± 0.14                |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.0483 ± 0.02 ms    | 0.0376 ± 0.0037 ms  | 1.28 ± 0.55                |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 0.953 ± 0.056 ms    | 0.679 ± 0.018 ms    | 1.4 ± 0.09                 |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 0.0879 ± 0.0054 ms  | 0.0655 ± 0.0045 ms  | 1.34 ± 0.12                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 0.404 ± 0.051 ms    | 0.377 ± 0.047 ms    | 1.07 ± 0.19                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.0666 ± 0.0058 ms  | 0.0419 ± 0.0011 ms  | 1.59 ± 0.14                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.0692 ± 0.0099 ms  | 0.0874 ± 0.004 ms   | 0.792 ± 0.12               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 1.49 ± 0.078 ms     | 1.65 ± 0.046 ms     | 0.905 ± 0.054              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.0897 ± 0.003 ms   | 0.0565 ± 0.0028 ms  | 1.59 ± 0.096               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 0.376 ± 0.022 ms    | 0.301 ± 0.045 ms    | 1.25 ± 0.2                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.0565 ± 0.0024 ms  | 0.0498 ± 0.0011 ms  | 1.14 ± 0.055               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.0706 ± 0.015 ms   | 0.0523 ± 0.0044 ms  | 1.35 ± 0.3                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 1.27 ± 0.28 ms      | 1.05 ± 0.02 ms      | 1.21 ± 0.27                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 0.0995 ± 0.011 ms   | 0.0689 ± 0.0018 ms  | 1.44 ± 0.16                |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.0704 ± 0.0017 ms  | 0.0692 ± 0.0029 ms  | 1.02 ± 0.049               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.0383 ± 0.0033 ms  | 0.0418 ± 0.0031 ms  | 0.917 ± 0.1                |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 14 ± 1.8 μs         | 11.5 ± 3.9 μs       | 1.23 ± 0.44                |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 0.266 ± 0.018 ms    | 0.198 ± 0.0072 ms   | 1.34 ± 0.1                 |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.072 ± 0.0043 ms   | 0.0559 ± 0.0042 ms  | 1.29 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 0.432 ± 0.045 ms    | 0.289 ± 0.014 ms    | 1.49 ± 0.17                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.0749 ± 0.0074 ms  | 0.0801 ± 0.0053 ms  | 0.935 ± 0.11               |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.059 ± 0.0076 ms   | 0.0601 ± 0.0039 ms  | 0.981 ± 0.14               |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 1.71 ± 0.04 ms      | 1.24 ± 0.042 ms     | 1.38 ± 0.056               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 0.15 ± 0.01 ms      | 0.107 ± 0.0067 ms   | 1.4 ± 0.13                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 0.138 ± 0.0093 ms   | 0.121 ± 0.01 ms     | 1.14 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 28.4 ± 4.3 μs       | 0.0434 ± 0.0012 ms  | 0.654 ± 0.1                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 26.7 ± 2 μs         | 26.4 ± 3.1 μs       | 1.01 ± 0.14                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 0.312 ± 0.024 ms    | 0.363 ± 0.019 ms    | 0.861 ± 0.081              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.0551 ± 0.0018 ms  | 0.0569 ± 0.0063 ms  | 0.969 ± 0.11               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 0.269 ± 0.042 ms    | 0.236 ± 0.016 ms    | 1.14 ± 0.19                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.0767 ± 0.0031 ms  | 0.0479 ± 0.0034 ms  | 1.6 ± 0.13                 |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 31.6 ± 1.7 μs       | 0.0366 ± 0.003 ms   | 0.864 ± 0.086              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 0.809 ± 0.12 ms     | 0.832 ± 0.046 ms    | 0.972 ± 0.15               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 0.0914 ± 0.0063 ms  | 0.0702 ± 0.0058 ms  | 1.3 ± 0.14                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 0.529 ± 0.033 ms    | 0.35 ± 0.018 ms     | 1.51 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.0929 ± 0.0075 ms  | 0.0687 ± 0.0044 ms  | 1.35 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.0683 ± 0.0039 ms  | 0.0603 ± 0.0031 ms  | 1.13 ± 0.087               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 1.97 ± 0.27 ms      | 1.48 ± 0.05 ms      | 1.33 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 0.132 ± 0.0072 ms   | 0.107 ± 0.0068 ms   | 1.24 ± 0.1                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 1.04 ± 0.28 ms      | 1.21 ± 0.21 ms      | 0.856 ± 0.27               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.0665 ± 0.0088 ms  | 0.0585 ± 0.0062 ms  | 1.14 ± 0.19                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.131 ± 0.008 ms    | 0.144 ± 0.021 ms    | 0.908 ± 0.14               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 3.8 ± 0.77 ms       | 3.83 ± 0.66 ms      | 0.991 ± 0.26               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.0993 ± 0.0074 ms  | 0.0706 ± 0.0094 ms  | 1.41 ± 0.21                |
| Convolution body/BLAS axpy per lag                                                                | 0.775 ± 0.0033 μs   | 0.775 ± 0.0033 μs   | 1 ± 0.006                  |
| Convolution body/native axpy per lag                                                              | 0.5 ± 0.0054 μs     | 0.493 ± 0.0063 μs   | 1.01 ± 0.017               |
| Convolution body/package                                                                          | 0.775 ± 0.0034 μs   | 0.359 ± 0.0045 μs   | 2.16 ± 0.029               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.0865 ± 0.017 ms   | 0.0586 ± 0.0011 ms  | 1.48 ± 0.28                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 4.37 ± 0.73 μs      | 4.2 ± 0.31 μs       | 1.04 ± 0.19                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 2.77 ± 1.8 μs       | 2.13 ± 0.39 μs      | 1.3 ± 0.86                 |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.0531 ± 0.0049 ms  | 31.1 ± 0.49 μs      | 1.7 ± 0.16                 |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 9.91 ± 1.8 μs       | 10.2 ± 1.8 μs       | 0.971 ± 0.24               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.0667 ± 0.0036 ms  | 0.0379 ± 0.00063 ms | 1.76 ± 0.1                 |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                     | 0.133 ± 0.0057 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                     | 0.052 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                     | 2.74 ± 0.072 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                     | 0.0482 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                     | 0.412 ± 0.021 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                     | 0.0764 ± 0.016 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                     | 0.0469 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward               |                     | 0.344 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                     | 0.918 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                     | 17.6 ± 0.73 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                     | 1.91 ± 0.041 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                     | 0.31 ± 0.026 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                     | 2.46 ± 0.52 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                     | 0.0494 ± 0.0011 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                     | 0.952 ± 0.05 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                     | 0.0698 ± 0.0077 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                     | 0.0626 ± 0.0017 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                     | 4.85 ± 0.054 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                     | 0.0575 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                     | 1.03 ± 0.026 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                     | 0.122 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                     | 0.236 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                     | 0.234 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                     | 0.136 ± 0.0062 ms   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                 |                     | 0.666 ± 0.047 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                     | 0.0803 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                     | 4.19 ± 0.57 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                     | 0.444 ± 0.018 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                     | 0.0918 ± 0.0057 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                     | 0.229 ± 0.021 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                     | 0.0691 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                     | 0.0833 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                     | 0.158 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                     | 2.03 ± 0.33 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                     | 1.36 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward     |                     | 2.77 ± 0.091 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                     | 0.079 ± 0.0021 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                     | 0.88 ± 0.065 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                     | 1.32 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                     | 0.842 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                     | 1.45 ± 0.032 ms     |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                     | 1.72 ± 0.26 μs      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                       |                     | 1.08 ± 0.063 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                     | 0.0417 ± 0.0043 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                   |                     | 0.564 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                     | 0.248 ± 0.037 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                     | 0.049 ± 0.0012 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                     | 24.3 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                     | 0.0632 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                     | 0.0398 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse             |                     | 0.108 ± 0.0038 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                     | 1.16 ± 0.068 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                     | 0.037 ± 0.00078 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                     | 0.619 ± 0.09 ms     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                     | 0.0403 ± 0.0036 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                      |                     | 0.0704 ± 0.048 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                  |                     | 0.0583 ± 0.0041 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                     | 0.697 ± 0.051 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                     | 1.88 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                     | 0.126 ± 0.0044 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                     | 0.167 ± 0.0076 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                     | 0.122 ± 0.0067 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                     | 0.0765 ± 0.0048 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                     | 31.5 ± 2.5 μs       |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                     | 0.116 ± 0.0042 ms   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                 |                     | 0.12 ± 0.0094 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                     | 0.23 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                     | 27.1 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                            |                     | 0.0852 ± 0.0064 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                     | 10.6 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                     | 0.277 ± 0.029 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                     | 0.359 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                     | 0.103 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                     | 1.18 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                     | 1.04 ± 0.054 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                     | 3.91 ± 0.27 ms      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                     | 17.8 ± 0.77 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                     | 0.0388 ± 0.00083 ms |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                     | 0.0817 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                     | 0.337 ± 0.032 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                     | 0.15 ± 0.0095 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                     | 0.436 ± 0.021 ms    |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                 |                     | 1.67 ± 0.24 ms      |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                     | 0.247 ± 0.027 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                     | 0.241 ± 0.018 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                     | 0.0541 ± 0.0012 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                     | 0.0429 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                     | 0.0799 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                     | 0.0534 ± 0.0012 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                     | 0.0674 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                     | 0.36 ± 0.045 ms     |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                     | 0.155 ± 0.0093 ms   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                       |                     | 0.0981 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                     | 0.128 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                     | 30.6 ± 0.74 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                     | 0.0808 ± 0.0063 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                     | 0.946 ± 0.032 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                     | 0.0673 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                     | 0.626 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                     | 1.71 ± 0.087 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                     | 1.73 ± 0.25 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                     | 0.0383 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                     | 0.0825 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                     | 0.058 ± 0.0015 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                     | 0.0951 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                     | 0.0901 ± 0.0025 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                     | 3.12 ± 0.12 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                     | 1.08 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                     | 0.0521 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                     | 0.0415 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                     | 0.0599 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                     | 0.224 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                     | 0.0421 ± 0.008 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                     | 0.241 ± 0.014 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                     | 0.0777 ± 0.0066 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                     | 0.0567 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                     | 0.0596 ± 0.0087 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                     | 0.346 ± 0.017 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                     | 0.396 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                     | 0.0423 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                     | 0.208 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                         |                     | 0.543 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                     | 0.376 ± 0.015 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                     | 16.4 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                     | 0.0477 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward       |                     | 0.699 ± 0.074 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                     | 0.136 ± 0.007 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                       |                     | 0.139 ± 0.0059 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                     | 0.995 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                     | 0.126 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff          |                     | 0.0969 ± 0.0065 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse     |                     | 0.139 ± 0.0054 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse               |                     | 0.0697 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                     | 0.0591 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                     | 12.3 ± 3.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                     | 0.173 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                     | 0.0543 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                     | 0.0828 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                     | 0.957 ± 0.064 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                     | 0.0392 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                     | 1.93 ± 0.33 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                     | 0.112 ± 0.059 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                     | 0.0789 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                     | 0.0976 ± 0.0091 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                     | 0.0662 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                     | 0.0725 ± 0.0048 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                     | 0.88 ± 0.069 ms     |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                         |                     | 0.338 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                     | 0.403 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward             |                     | 1.38 ± 0.042 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse               |                     | 0.126 ± 0.0051 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                     | 3.62 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                     | 0.831 ± 0.027 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                     | 0.105 ± 0.0052 ms   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                     | 1.89 ± 0.31 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                     | 0.0647 ± 0.0046 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                     | 1.44 ± 0.028 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                     | 0.0816 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                     | 0.871 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                     | 0.171 ± 0.074 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                     | 0.0321 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                     | 0.0591 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                     | 0.0908 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                     | 0.323 ± 0.019 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                     | 0.0563 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                     | 0.0842 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                     | 0.156 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                     | 1.08 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                     | 0.0417 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                     | 0.0871 ± 0.005 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                     | 0.105 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                       |                     | 2.22 ± 0.042 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                 |                     | 0.0978 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                     | 1.5 ± 0.056 ms      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                         |                     | 0.0716 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                     | 0.0699 ± 0.014 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                     | 0.0385 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                     | 0.289 ± 0.063 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                     | 0.0559 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                     | 0.702 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                     | 0.743 ± 0.03 ms     |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                            |                     | 0.0749 ± 0.034 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                     | 0.344 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                     | 2.07 ± 0.036 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                     | 0.0575 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                     | 0.0553 ± 0.0048 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                     | 0.138 ± 0.0087 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                     | 0.0697 ± 0.0068 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                     | 1.3 ± 0.016 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                     | 0.0391 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                     | 0.17 ± 0.018 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                     | 16.6 ± 1.2 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                     | 0.0387 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                     | 2.68 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                     | 0.12 ± 0.0097 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                     | 0.104 ± 0.049 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                     | 10.7 ± 0.73 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                     | 0.123 ± 0.011 ms    |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                     | 0.0532 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                     | 0.078 ± 0.0054 ms   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                     | 0.177 ± 0.045 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                     | 0.0653 ± 0.0032 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                     | 0.0446 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                     | 0.0896 ± 0.0026 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                   |                     | 0.083 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                     | 0.0625 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                     | 7.81 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                     | 0.0925 ± 0.0091 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                     | 0.0708 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                     | 0.0721 ± 0.0087 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                     | 1 ± 0.06 ms         |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                     | 0.245 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                     | 0.0576 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                     | 0.0638 ± 0.0093 ms  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                     | 0.481 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                     | 0.101 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                     | 0.12 ± 0.0069 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                     | 0.71 ± 0.088 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                     | 0.0586 ± 0.0036 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                     | 0.0359 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                     | 1.31 ± 0.057 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                     | 0.082 ± 0.0019 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                     | 0.0706 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                     | 1.57 ± 0.042 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                     | 0.501 ± 0.067 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                    |                     | 0.095 ± 0.012 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                     | 0.052 ± 0.0029 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                     | 1.12 ± 0.083 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                     | 0.0343 ± 0.0031 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                     | 0.0639 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                     | 0.315 ± 0.042 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                     | 0.0559 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                     | 0.0777 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                     | 0.106 ± 0.012 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                     | 0.0354 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                     | 1.19 ± 0.055 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                     | 0.0932 ± 0.0066 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                     | 0.107 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                     | 0.034 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                     | 0.135 ± 0.0078 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                     | 0.117 ± 0.0064 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                     | 0.0756 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                     | 1.43 ± 0.16 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                     | 1.33 ± 0.027 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                     | 1.27 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                     | 4.72 ± 0.069 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                     | 0.378 ± 0.056 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                     | 0.0739 ± 0.0033 ms  |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward               |                     | 2.3 ± 0.13 ms       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                     | 0.113 ± 0.0031 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                     | 10.2 ± 0.94 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                     | 2.83 ± 0.07 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                     | 0.129 ± 0.0071 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                     | 0.0609 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                     | 25.6 ± 0.97 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                     | 1.1 ± 0.069 ms      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                     | 0.0326 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                     | 3.7 ± 0.09 ms       |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                     | 0.42 ± 0.088 ms     |                            |
| time_to_load                                                                                      | 0.236 ± 0.00023 s   | 0.349 ± 0.0012 s    | 0.676 ± 0.0024             |

|                                                                                                   | v0.1.0                    | 312db5a2450629...         | v0.1.0 / 312db5a2450629... |
|:--------------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 0.147 k allocs: 7.97 kB   | 0.157 k allocs: 8.25 kB   | 0.966                      |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 0.042 k allocs: 12.1 kB   | 0.034 k allocs: 6.28 kB   | 1.93                       |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 1.94 k allocs: 0.195 MB   | 1.81 k allocs: 0.171 MB   | 1.14                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.204 k allocs: 18 kB     | 0.164 k allocs: 12.2 kB   | 1.47                       |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.188 k allocs: 0.113 MB  | 0.134 k allocs: 0.046 MB  | 2.47                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 13.7 k allocs: 0.635 MB   | 10.5 k allocs: 0.512 MB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.829 k allocs: 31.1 kB   | 0.583 k allocs: 21.8 kB   | 1.42                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 2.99 k allocs: 0.267 MB   | 2.8 k allocs: 0.241 MB    | 1.11                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 0.15 k allocs: 11.9 kB    | 0.168 k allocs: 12.4 kB   | 0.963                      |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.266 k allocs: 0.133 MB  | 0.242 k allocs: 0.111 MB  | 1.2                        |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 19.8 k allocs: 0.899 MB   | 15.3 k allocs: 0.739 MB   | 1.22                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.682 k allocs: 24.9 kB   | 0.586 k allocs: 22 kB     | 1.14                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 4.7 k allocs: 0.505 MB    | 4.31 k allocs: 0.435 MB   | 1.16                       |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 0.122 k allocs: 12.5 kB   | 0.137 k allocs: 11.3 kB   | 1.11                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.437 k allocs: 0.289 MB  | 0.392 k allocs: 0.234 MB  | 1.24                       |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 0.0319 M allocs: 1.73 MB  | 23.8 k allocs: 1.41 MB    | 1.23                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.542 k allocs: 22.2 kB   | 0.446 k allocs: 19 kB     | 1.17                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 3.26 k allocs: 0.495 MB   | 0.551 k allocs: 0.155 MB  | 3.2                        |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 8.89 k allocs: 0.0511 GB  | 6.97 k allocs: 0.0399 GB  | 1.28                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 9.4 k allocs: 0.381 MB    | 1.33 k allocs: 0.175 MB   | 2.18                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 0.054 k allocs: 0.0376 MB | 0.051 k allocs: 19.4 kB   | 1.98                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.161 k allocs: 0.0396 MB | 0.166 k allocs: 22 kB     | 1.85                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 0.542 k allocs: 1.69 MB   | 0.422 k allocs: 0.852 MB  | 1.98                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 1.53 k allocs: 0.294 MB   | 0.206 k allocs: 0.0914 MB | 3.22                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 2.1 k allocs: 24.8 MB     | 1.1 k allocs: 12.3 MB     | 2.02                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 5.84 k allocs: 0.353 MB   | 0.152 k allocs: 0.0905 MB | 3.9                        |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.18 k allocs: 0.0375 MB  | 0.22 k allocs: 29 kB      | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 1.53 k allocs: 0.308 MB   | 0.381 k allocs: 0.131 MB  | 2.35                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 6.2 k allocs: 0.0508 GB   | 5.15 k allocs: 0.0396 GB  | 1.28                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 9.06 k allocs: 0.369 MB   | 0.989 k allocs: 0.147 MB  | 2.5                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 8.54 k allocs: 0.784 MB   | 7.89 k allocs: 0.71 MB    | 1.11                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.652 k allocs: 0.0473 MB | 0.483 k allocs: 0.0385 MB | 1.23                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.713 k allocs: 0.321 MB  | 0.632 k allocs: 0.268 MB  | 1.2                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 0.0394 M allocs: 1.95 MB  | 0.0369 M allocs: 1.81 MB  | 1.07                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 1.69 k allocs: 0.0622 MB  | 1.38 k allocs: 0.0625 MB  | 0.995                      |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 2.77 k allocs: 0.162 MB   | 2.43 k allocs: 0.136 MB   | 1.19                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.295 k allocs: 16.2 kB   | 0.237 k allocs: 11.8 kB   | 1.37                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.222 k allocs: 0.0645 MB | 0.182 k allocs: 0.049 MB  | 1.32                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 11.5 k allocs: 0.443 MB   | 10.1 k allocs: 0.389 MB   | 1.14                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 1.02 k allocs: 0.033 MB   | 0.693 k allocs: 24.8 kB   | 1.36                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 3.14 k allocs: 0.279 MB   | 2.95 k allocs: 0.281 MB   | 0.991                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.246 k allocs: 20 kB     | 0.208 k allocs: 15.7 kB   | 1.28                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.303 k allocs: 0.154 MB  | 0.296 k allocs: 0.161 MB  | 0.956                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 17.4 k allocs: 0.834 MB   | 15.8 k allocs: 0.828 MB   | 1.01                       |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.691 k allocs: 26.1 kB   | 0.671 k allocs: 28.1 kB   | 0.928                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 3.18 k allocs: 0.261 MB   | 2.77 k allocs: 0.214 MB   | 1.22                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.233 k allocs: 17.1 kB   | 0.262 k allocs: 18.2 kB   | 0.937                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.29 k allocs: 0.13 MB    | 0.242 k allocs: 0.0952 MB | 1.37                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 15.7 k allocs: 0.716 MB   | 14 k allocs: 0.611 MB     | 1.17                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 1.15 k allocs: 0.0397 MB  | 0.843 k allocs: 0.0325 MB | 1.22                       |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.176 k allocs: 7.66 kB   | 0.22 k allocs: 10.1 kB    | 0.761                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 4.09 k allocs: 0.137 MB   | 3.75 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.809 k allocs: 25.5 kB   | 0.679 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 3.93 k allocs: 0.263 MB   | 3.07 k allocs: 0.207 MB   | 1.27                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.336 k allocs: 21.5 kB   | 0.388 k allocs: 20.8 kB   | 1.04                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.287 k allocs: 0.125 MB  | 0.252 k allocs: 0.102 MB  | 1.23                       |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 15.9 k allocs: 0.718 MB   | 11.8 k allocs: 0.566 MB   | 1.27                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 1.3 k allocs: 0.0436 MB   | 0.927 k allocs: 0.035 MB  | 1.25                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 1.5 k allocs: 0.132 MB    | 1.25 k allocs: 0.104 MB   | 1.27                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 0.198 k allocs: 15.6 kB   | 0.268 k allocs: 20.5 kB   | 0.762                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 0.174 k allocs: 0.0836 MB | 0.138 k allocs: 0.0622 MB | 1.34                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 5.38 k allocs: 0.321 MB   | 4.41 k allocs: 0.264 MB   | 1.22                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.39 k allocs: 16.1 kB    | 0.466 k allocs: 24.5 kB   | 0.659                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 2.74 k allocs: 0.209 MB   | 2.38 k allocs: 0.168 MB   | 1.24                       |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.382 k allocs: 21.7 kB   | 0.223 k allocs: 13.8 kB   | 1.57                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 0.237 k allocs: 0.105 MB  | 0.192 k allocs: 0.0755 MB | 1.39                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 12.3 k allocs: 0.571 MB   | 10.9 k allocs: 0.487 MB   | 1.17                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 1.02 k allocs: 0.0353 MB  | 0.713 k allocs: 27.8 kB   | 1.3                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 4.32 k allocs: 0.329 MB   | 3.35 k allocs: 0.252 MB   | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.382 k allocs: 24.6 kB   | 0.361 k allocs: 22.7 kB   | 1.09                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.338 k allocs: 0.149 MB  | 0.284 k allocs: 0.114 MB  | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 19.4 k allocs: 0.879 MB   | 14.8 k allocs: 0.696 MB   | 1.26                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 1.35 k allocs: 0.046 MB   | 0.981 k allocs: 0.0384 MB | 1.2                        |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 10.7 k allocs: 0.915 MB   | 9.37 k allocs: 0.762 MB   | 1.2                        |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.383 k allocs: 25 kB     | 0.27 k allocs: 21.4 kB    | 1.17                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.886 k allocs: 0.384 MB  | 0.733 k allocs: 0.275 MB  | 1.4                        |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 0.0515 M allocs: 2.58 MB  | 0.0464 M allocs: 2.29 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.863 k allocs: 0.033 MB  | 0.837 k allocs: 0.0341 MB | 0.967                      |
| Convolution body/BLAS axpy per lag                                                                | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                                              | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                                          | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.091 k allocs: 0.0452 MB | 0.07 k allocs: 0.0349 MB  | 1.29                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.04 k allocs: 0.0395 MB  | 28  allocs: 29.7 kB       | 1.36                       |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 0.034 k allocs: 7.98 kB   | 30  allocs: 7.72 kB       | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.072 k allocs: 0.0443 MB | 0.051 k allocs: 0.0342 MB | 1.3                        |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                           | 1.19 k allocs: 0.0452 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                           | 0.224 k allocs: 16.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                           | 23.2 k allocs: 1.15 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                           | 0.333 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                           | 0.234 k allocs: 0.0975 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                           | 0.274 k allocs: 0.112 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward               |                           | 3.2 k allocs: 0.221 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                           | 0.913 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                           | 0.103 k allocs: 4.42 kB   |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                           | 3.14 k allocs: 0.211 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                           | 22.8 k allocs: 1.12 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                           | 0.248 k allocs: 16.8 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                           | 13.7 k allocs: 0.586 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                           | 0.619 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                           | 0.0411 M allocs: 2.13 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                           | 0.556 k allocs: 24.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                           | 9.61 k allocs: 0.79 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                           | 0.45 k allocs: 0.163 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                           | 2.44 k allocs: 0.165 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                           | 2.49 k allocs: 0.14 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                           | 1.03 k allocs: 0.0388 MB  |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                 |                           | 5.65 k allocs: 0.455 MB   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                           | 0.429 k allocs: 21.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                           | 0.051 k allocs: 3.39 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                           | 4.61 k allocs: 0.325 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                           | 0.984 k allocs: 0.0375 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                           | 2.38 k allocs: 0.163 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                           | 0.349 k allocs: 16.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                           | 0.699 k allocs: 24.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                           | 0.596 k allocs: 0.195 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                           | 12.4 k allocs: 0.604 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward     |                           | 28 k allocs: 1.28 MB      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                           | 0.346 k allocs: 20.1 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                           | 10.1 k allocs: 0.463 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                           | 18.8 k allocs: 0.873 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                           | 10.8 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                           | 16.2 k allocs: 0.842 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                       |                           | 16 k allocs: 0.671 MB     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                           | 0.586 k allocs: 25 kB     |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                   |                           | 4.49 k allocs: 0.326 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                           | 2.16 k allocs: 0.165 MB   |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                           | 0.233 k allocs: 16.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                           | 0.138 k allocs: 0.0622 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                           | 0.272 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse             |                           | 1.09 k allocs: 0.0364 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                           | 0.163 k allocs: 11.3 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                           | 4.54 k allocs: 0.451 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                           | 0.177 k allocs: 8.16 kB   |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                      |                           | 0.356 k allocs: 0.135 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                  |                           | 0.282 k allocs: 0.109 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                           | 5.77 k allocs: 0.433 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                           | 21.2 k allocs: 0.957 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                           | 0.589 k allocs: 0.0409 MB |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                           | 0.675 k allocs: 0.0356 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                           | 1.26 k allocs: 0.0517 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                           | 0.801 k allocs: 31.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                           | 0.226 k allocs: 0.0894 MB |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                           | 0.982 k allocs: 0.033 MB  |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                 |                           | 1.21 k allocs: 0.049 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                           | 1.89 k allocs: 0.175 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                           | 0.14 k allocs: 0.0463 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                            |                           | 0.38 k allocs: 0.137 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                           | 0.186 k allocs: 9.88 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                           | 2.45 k allocs: 0.172 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                           | 5.28 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                           | 0.963 k allocs: 0.0351 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                           | 11.5 k allocs: 0.524 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                           | 0.0472 M allocs: 2.33 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                           | 0.201 k allocs: 9.69 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                           | 0.426 k allocs: 28.6 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                           | 2.91 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                           | 1.09 k allocs: 0.0351 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                           | 4.52 k allocs: 0.319 MB   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                 |                           | 22.8 k allocs: 0.978 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                           | 2.16 k allocs: 0.165 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                           | 2.48 k allocs: 0.174 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                           | 0.351 k allocs: 19.4 kB   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                           | 0.202 k allocs: 0.248 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                           | 0.662 k allocs: 27.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                           | 0.251 k allocs: 16.5 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                           | 0.335 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                           | 3.05 k allocs: 0.289 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                           | 0.587 k allocs: 0.192 MB  |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                       |                           | 1.06 k allocs: 0.0367 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                           | 0.96 k allocs: 31.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                           | 0.129 k allocs: 11.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                           | 0.303 k allocs: 0.161 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                           | 16.9 k allocs: 0.927 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                           | 0.309 k allocs: 20.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                           | 5.87 k allocs: 0.443 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                           | 21.5 k allocs: 0.972 MB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                           | 0.217 k allocs: 0.0845 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                           | 0.452 k allocs: 0.237 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                           | 0.479 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                           | 0.417 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                           | 0.846 k allocs: 0.0315 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                           | 0.0398 M allocs: 2.03 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                           | 9.98 k allocs: 0.727 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                           | 0.202 k allocs: 0.0499 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                           | 0.296 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                           | 2.48 k allocs: 0.174 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                           | 0.212 k allocs: 0.0765 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                           | 0.581 k allocs: 0.198 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                           | 0.436 k allocs: 0.15 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                           | 0.266 k allocs: 0.0965 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                           | 0.754 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                           | 3.42 k allocs: 0.26 MB    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                           | 0.266 k allocs: 0.0989 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                           | 3.83 k allocs: 0.134 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                         |                           | 4.58 k allocs: 0.341 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                           | 1.08 k allocs: 0.22 MB    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                           | 0.235 k allocs: 14.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward       |                           | 5.75 k allocs: 0.473 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                           | 1.11 k allocs: 0.0371 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                       |                           | 1.2 k allocs: 0.0449 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                           | 8.01 k allocs: 0.733 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                           | 1.25 k allocs: 0.104 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff          |                           | 0.464 k allocs: 0.179 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse     |                           | 1.21 k allocs: 0.0456 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse               |                           | 0.286 k allocs: 16.7 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                           | 0.619 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                           | 0.064 k allocs: 13.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                           | 1.37 k allocs: 0.054 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                           | 0.74 k allocs: 29.5 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                           | 9.37 k allocs: 0.695 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                           | 0.324 k allocs: 0.147 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                           | 0.356 k allocs: 23.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                           | 0.834 k allocs: 30.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                           | 0.289 k allocs: 18.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                           | 9.13 k allocs: 0.678 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                         |                           | 3.13 k allocs: 0.219 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                           | 3.96 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward             |                           | 16.6 k allocs: 0.705 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse               |                           | 1.28 k allocs: 0.0528 MB  |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                           | 0.0373 M allocs: 1.85 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                           | 10.3 k allocs: 0.469 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                           | 0.524 k allocs: 0.035 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                           | 0.683 k allocs: 22.2 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                           | 17.3 k allocs: 0.816 MB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                           | 0.181 k allocs: 0.0406 MB |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                           | 10.7 k allocs: 0.424 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                           | 0.75 k allocs: 0.277 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                           | 0.34 k allocs: 23.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                           | 0.371 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                           | 0.825 k allocs: 0.0323 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                           | 2.85 k allocs: 0.222 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                           | 0.312 k allocs: 18.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                           | 0.311 k allocs: 19.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                           | 0.786 k allocs: 0.261 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                           | 10.1 k allocs: 0.736 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                           | 0.226 k allocs: 0.0894 MB |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                           | 0.749 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                           | 1.09 k allocs: 0.0546 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                       |                           | 23.5 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                 |                           | 0.416 k allocs: 30.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                           | 17.6 k allocs: 0.831 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                         |                           | 0.317 k allocs: 15.8 kB   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                           | 0.212 k allocs: 0.084 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                           | 4.41 k allocs: 0.263 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                           | 0.256 k allocs: 16.5 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                           | 1.16 k allocs: 0.191 MB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                           | 6.98 k allocs: 0.527 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                            |                           | 0.262 k allocs: 0.108 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                           | 4.6 k allocs: 0.345 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                           | 25.8 k allocs: 1.53 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                           | 0.22 k allocs: 15.8 kB    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                           | 0.221 k allocs: 14.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                           | 0.722 k allocs: 0.258 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                           | 0.49 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                           | 1.25 k allocs: 0.115 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                           | 0.21 k allocs: 14.2 kB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                           | 0.746 k allocs: 0.357 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                           | 30.7 k allocs: 1.42 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                           | 0.331 k allocs: 0.148 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                           | 0.05 k allocs: 9.29 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                           | 1.11 k allocs: 0.046 MB   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                           | 0.317 k allocs: 17.5 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                           | 0.734 k allocs: 0.357 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                           | 0.734 k allocs: 30.7 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                           | 0.458 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                           | 0.847 k allocs: 0.0315 MB |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                   |                           | 0.332 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                           | 0.39 k allocs: 0.0646 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                           | 0.042 k allocs: 6.62 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                           | 0.396 k allocs: 27.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                           | 0.812 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                           | 0.443 k allocs: 0.151 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                           | 2.81 k allocs: 0.504 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                           | 0.292 k allocs: 19.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                           | 0.29 k allocs: 0.114 MB   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                           | 1.11 k allocs: 0.0559 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                           | 0.911 k allocs: 0.0332 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                           | 6.86 k allocs: 0.512 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                           | 0.166 k allocs: 13.5 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                           | 16.3 k allocs: 0.8 MB     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                           | 0.708 k allocs: 26 kB     |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                           | 0.841 k allocs: 0.0322 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                           | 15.1 k allocs: 0.711 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                           | 3.77 k allocs: 0.332 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                    |                           | 0.436 k allocs: 0.176 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                           | 0.239 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                           | 0.069 k allocs: 0.0332 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                           | 0.337 k allocs: 19.1 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                           | 4.71 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                           | 0.434 k allocs: 0.13 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                           | 0.558 k allocs: 22.9 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                           | 1.13 k allocs: 0.0395 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                           | 0.249 k allocs: 16.7 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                           | 17.9 k allocs: 0.98 MB    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                           | 0.92 k allocs: 0.0365 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                           | 0.442 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                           | 1.08 k allocs: 0.0394 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                           | 1.14 k allocs: 0.043 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                           | 0.343 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                           | 19.6 k allocs: 0.917 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                           | 14.8 k allocs: 0.965 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                           | 14.7 k allocs: 0.659 MB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                           | 0.0417 M allocs: 2.15 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                           | 5.37 k allocs: 0.323 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                           | 0.632 k allocs: 25.9 kB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward               |                           | 27.1 k allocs: 1.2 MB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                           | 0.855 k allocs: 30.9 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                           | 0.049 k allocs: 9.18 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                           | 30.3 k allocs: 1.39 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                           | 0.641 k allocs: 0.27 MB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                           | 0.458 k allocs: 0.131 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                           | 0.153 k allocs: 13.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                           | 13.7 k allocs: 0.586 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                           | 0.349 k allocs: 24.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                           | 0.0419 M allocs: 2.16 MB  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                           | 3.87 k allocs: 0.311 MB   |                            |
| time_to_load                                                                                      | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

