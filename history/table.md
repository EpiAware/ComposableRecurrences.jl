|                                                                                                   | v0.1.0             | 68429cd8f6c46d...   | v0.1.0 / 68429cd8f6c46d... |
|:--------------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.042 ± 0.0039 ms  | 0.0466 ± 0.0056 ms  | 0.903 ± 0.14               |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 18.9 ± 0.62 μs     | 19.6 ± 0.99 μs      | 0.967 ± 0.058              |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 2.69 ± 0.65 μs     | 2.86 ± 1.3 μs       | 0.941 ± 0.48               |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 0.131 ± 0.022 ms   | 0.127 ± 0.038 ms    | 1.04 ± 0.35                |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 26.3 ± 2.2 μs      | 20.7 ± 1.2 μs       | 1.27 ± 0.13                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 0.171 ± 0.01 ms    | 0.162 ± 0.012 ms    | 1.05 ± 0.1                 |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 26.3 ± 1.2 μs      | 21.1 ± 0.75 μs      | 1.25 ± 0.073               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 27.1 ± 1.8 μs      | 25.2 ± 2.4 μs       | 1.07 ± 0.12                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 0.512 ± 0.17 ms    | 0.514 ± 0.018 ms    | 0.996 ± 0.34               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.0322 ± 0.0024 ms | 22.5 ± 0.89 μs      | 1.43 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 0.236 ± 0.022 ms   | 0.236 ± 0.019 ms    | 0.999 ± 0.12               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 23.1 ± 0.99 μs     | 20.1 ± 0.81 μs      | 1.15 ± 0.068               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 31.2 ± 2.2 μs      | 29.5 ± 2.6 μs       | 1.06 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 0.57 ± 0.13 ms     | 0.634 ± 0.048 ms    | 0.898 ± 0.22               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 31 ± 1.8 μs        | 22 ± 1.6 μs         | 1.41 ± 0.13                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 0.381 ± 0.074 ms   | 0.423 ± 0.033 ms    | 0.902 ± 0.19               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 19.3 ± 0.91 μs     | 18.7 ± 1.4 μs       | 1.03 ± 0.092               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.0607 ± 0.0076 ms | 0.0575 ± 0.0038 ms  | 1.06 ± 0.15                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 1.1 ± 0.13 ms      | 1.04 ± 0.13 ms      | 1.06 ± 0.18                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 26 ± 2.1 μs        | 20.7 ± 2.6 μs       | 1.25 ± 0.19                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.258 ± 0.013 ms   | 0.269 ± 0.3 ms      | 0.96 ± 1.1                 |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.262 ± 0.18 ms    | 0.284 ± 0.19 ms     | 0.923 ± 0.88               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 4.87 ± 3 ms        | 7.65 ± 3.4 ms       | 0.637 ± 0.49               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 15.7 ± 10 ms       | 25.6 ± 4.4 ms       | 0.614 ± 0.41               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 0.821 ± 0.082 ms   | 0.151 ± 0.0065 ms   | 5.43 ± 0.59                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 0.0442 ± 0.004 s   | 0.0352 ± 0.013 s    | 1.26 ± 0.47                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 0.626 ± 0.023 ms   | 0.184 ± 0.0077 ms   | 3.4 ± 0.19                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 22.5 ± 2.5 μs      | 5.07 ± 3.8 μs       | 4.43 ± 3.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.872 ± 0.028 ms   | 0.315 ± 0.47 ms     | 2.77 ± 4.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.0389 ± 0.0043 ms | 11.7 ± 2 μs         | 3.32 ± 0.67                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.0425 ± 0.0037 ms | 23.6 ± 4.6 μs       | 1.8 ± 0.39                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 1.02 ± 0.033 ms    | 0.721 ± 0.39 ms     | 1.41 ± 0.76                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.0612 ± 0.005 ms  | 30.7 ± 1.8 μs       | 1.99 ± 0.2                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 0.34 ± 0.0096 ms   | 0.0517 ± 0.0036 ms  | 6.58 ± 0.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 19.7 ± 0.4 ms      | 5.55 ± 6.2 ms       | 3.54 ± 4                   |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 0.337 ± 0.035 ms   | 0.063 ± 0.0028 ms   | 5.36 ± 0.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.057 ± 0.0098 ms  | 0.0397 ± 0.0066 ms  | 1.43 ± 0.34                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 1.13 ± 0.41 ms     | 0.705 ± 0.43 ms     | 1.6 ± 1.1                  |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 0.0725 ± 0.012 ms  | 0.0445 ± 0.0032 ms  | 1.63 ± 0.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 0.467 ± 0.06 ms    | 0.107 ± 0.0061 ms   | 4.36 ± 0.62                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 29.4 ± 13 ms       | 30 ± 0.24 ms        | 0.982 ± 0.42               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 0.435 ± 0.016 ms   | 0.136 ± 0.0044 ms   | 3.2 ± 0.15                 |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 0.725 ± 0.037 ms   | 0.654 ± 0.063 ms    | 1.11 ± 0.12                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.0758 ± 0.0054 ms | 0.0524 ± 0.002 ms   | 1.45 ± 0.12                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.084 ± 0.0063 ms  | 0.0906 ± 0.006 ms   | 0.927 ± 0.093              |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 1.69 ± 0.055 ms    | 1.67 ± 0.041 ms     | 1.01 ± 0.041               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 0.0874 ± 0.0044 ms | 0.0591 ± 0.004 ms   | 1.48 ± 0.12                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 0.17 ± 0.018 ms    | 0.145 ± 0.013 ms    | 1.17 ± 0.16                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.0337 ± 0.0014 ms | 29.1 ± 2.6 μs       | 1.16 ± 0.12                |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.032 ± 0.0059 ms  | 0.0351 ± 0.0042 ms  | 0.912 ± 0.2                |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 0.515 ± 0.011 ms   | 0.405 ± 0.032 ms    | 1.27 ± 0.1                 |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 0.0396 ± 0.0018 ms | 0.0336 ± 0.0029 ms  | 1.18 ± 0.11                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 0.272 ± 0.024 ms   | 0.29 ± 0.013 ms     | 0.937 ± 0.092              |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.0358 ± 0.0011 ms | 26.3 ± 1.7 μs       | 1.36 ± 0.097               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.0489 ± 0.026 ms  | 0.0543 ± 0.0068 ms  | 0.901 ± 0.5                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 0.798 ± 0.015 ms   | 1.04 ± 0.06 ms      | 0.765 ± 0.046              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.0391 ± 0.0013 ms | 27.8 ± 1.1 μs       | 1.41 ± 0.075               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 0.255 ± 0.017 ms   | 0.233 ± 0.033 ms    | 1.09 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.0339 ± 0.0021 ms | 31.4 ± 2 μs         | 1.08 ± 0.097               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.0396 ± 0.0082 ms | 0.0345 ± 0.0076 ms  | 1.15 ± 0.35                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 0.751 ± 0.037 ms   | 0.66 ± 0.046 ms     | 1.14 ± 0.098               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 0.0437 ± 0.0017 ms | 0.035 ± 0.0016 ms   | 1.25 ± 0.075               |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.0477 ± 0.0017 ms | 0.0474 ± 0.002 ms   | 1.01 ± 0.055               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 25.4 ± 2.2 μs      | 25 ± 2.2 μs         | 1.02 ± 0.13                |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 8.9 ± 2.5 μs       | 7.08 ± 2.2 μs       | 1.26 ± 0.53                |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 0.134 ± 0.024 ms   | 0.124 ± 0.015 ms    | 1.08 ± 0.24                |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.0367 ± 0.0027 ms | 29.3 ± 2.6 μs       | 1.25 ± 0.14                |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 0.271 ± 0.02 ms    | 0.209 ± 0.015 ms    | 1.29 ± 0.13                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.0403 ± 0.0014 ms | 0.0363 ± 0.0011 ms  | 1.11 ± 0.051               |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.0387 ± 0.0072 ms | 0.0454 ± 0.0073 ms  | 0.852 ± 0.21               |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 0.762 ± 0.11 ms    | 0.682 ± 0.04 ms     | 1.12 ± 0.18                |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 0.0623 ± 0.0026 ms | 0.0423 ± 0.0014 ms  | 1.47 ± 0.078               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 0.099 ± 0.012 ms   | 0.0842 ± 0.0051 ms  | 1.18 ± 0.16                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 18.5 ± 2.1 μs      | 23 ± 1.2 μs         | 0.803 ± 0.1                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 21 ± 1.7 μs        | 21 ± 15 μs          | 1 ± 0.72                   |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 0.231 ± 0.014 ms   | 0.238 ± 0.018 ms    | 0.971 ± 0.092              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 24.1 ± 1.1 μs      | 23.6 ± 2.2 μs       | 1.03 ± 0.11                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 0.169 ± 0.03 ms    | 0.169 ± 0.018 ms    | 0.996 ± 0.21               |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.0424 ± 0.0057 ms | 25.2 ± 1.1 μs       | 1.69 ± 0.24                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 24.6 ± 2 μs        | 0.0352 ± 0.022 ms   | 0.699 ± 0.44               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 0.454 ± 0.071 ms   | 0.476 ± 0.022 ms    | 0.953 ± 0.16               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 0.0403 ± 0.0093 ms | 29.2 ± 2.2 μs       | 1.38 ± 0.33                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 0.349 ± 0.02 ms    | 0.241 ± 0.029 ms    | 1.45 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.0493 ± 0.0023 ms | 0.0347 ± 0.0013 ms  | 1.42 ± 0.085               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.0394 ± 0.007 ms  | 0.0434 ± 0.025 ms   | 0.907 ± 0.55               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 1.02 ± 0.11 ms     | 0.818 ± 0.029 ms    | 1.24 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 0.0645 ± 0.0062 ms | 0.0432 ± 0.0025 ms  | 1.49 ± 0.17                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 0.676 ± 0.19 ms    | 0.825 ± 0.27 ms     | 0.82 ± 0.35                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.0357 ± 0.0026 ms | 0.037 ± 0.0029 ms   | 0.965 ± 0.1                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.092 ± 0.0063 ms  | 0.105 ± 0.011 ms    | 0.874 ± 0.11               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 2.19 ± 0.38 ms     | 2.29 ± 0.51 ms      | 0.957 ± 0.27               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.0448 ± 0.0044 ms | 0.0339 ± 0.0031 ms  | 1.32 ± 0.18                |
| Convolution body/BLAS axpy per lag                                                                | 0.485 ± 0.0034 μs  | 0.464 ± 0.0049 μs   | 1.05 ± 0.013               |
| Convolution body/native axpy per lag                                                              | 0.395 ± 0.0059 μs  | 0.414 ± 0.0048 μs   | 0.953 ± 0.018              |
| Convolution body/package                                                                          | 0.492 ± 0.0045 μs  | 0.196 ± 0.0011 μs   | 2.5 ± 0.027                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.0387 ± 0.0095 ms | 0.0341 ± 0.00095 ms | 1.13 ± 0.28                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 2.82 ± 0.3 μs      | 2.83 ± 0.24 μs      | 0.996 ± 0.14               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 2.24 ± 0.93 μs     | 1.8 ± 0.46 μs       | 1.24 ± 0.61                |
| Evaluation/Matrix overview T200_L20_S3                                                            | 27.7 ± 3.3 μs      | 27.9 ± 2.9 μs       | 0.99 ± 0.16                |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 5.75 ± 1.3 μs      | 6.43 ± 1.4 μs       | 0.894 ± 0.28               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.0377 ± 0.0033 ms | 22.6 ± 0.75 μs      | 1.67 ± 0.16                |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                    | 0.0578 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                    | 0.0318 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                    | 1.44 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                    | 24.5 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                    | 0.265 ± 0.01 ms     |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                    | 0.0318 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                    | 0.0362 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                    | 0.541 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                    | 9.93 ± 0.8 μs       |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                    | 0.809 ± 0.07 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                    | 0.23 ± 0.022 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                    | 1.45 ± 0.082 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                    | 28.8 ± 0.8 μs       |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                    | 0.508 ± 0.075 ms    |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                    | 0.034 ± 0.0026 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                    | 29.2 ± 1.2 μs       |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                    | 2.86 ± 0.25 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                    | 29.2 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                    | 0.784 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                    | 0.0882 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                    | 0.17 ± 0.016 ms     |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                    | 0.164 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                    | 0.0646 ± 0.0026 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                    | 0.0429 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                    | 3 ± 0.33 μs         |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                    | 0.306 ± 0.031 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                    | 0.0398 ± 0.0013 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                    | 0.166 ± 0.015 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                    | 0.0361 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                    | 0.0366 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                    | 0.0951 ± 0.0065 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                    | 1.15 ± 0.28 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                    | 0.797 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                    | 0.0432 ± 0.0012 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                    | 0.457 ± 0.018 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                    | 0.8 ± 0.073 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                    | 0.501 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                    | 0.899 ± 0.057 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                    | 1.12 ± 0.32 μs      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                    | 20.7 ± 0.96 μs      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                    | 0.17 ± 0.021 ms     |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                    | 30.3 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                    | 0.033 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                    | 0.0481 ± 0.0063 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                    | 25.6 ± 0.99 μs      |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                    | 0.741 ± 0.069 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                    | 24.1 ± 0.76 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                    | 0.426 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                    | 24.4 ± 2.5 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                    | 0.464 ± 0.023 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                    | 0.969 ± 0.043 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                    | 0.0691 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                    | 0.0854 ± 0.0038 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                    | 0.0548 ± 0.0079 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                    | 0.0323 ± 0.0027 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                    | 28.7 ± 7.2 μs       |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                    | 0.0452 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                    | 0.174 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                    | 24.3 ± 2.5 μs       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                    | 6.22 ± 0.89 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                    | 0.187 ± 0.015 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                    | 0.252 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                    | 0.0451 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                    | 0.609 ± 0.046 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                    | 0.48 ± 0.09 ms      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                    | 2.25 ± 0.048 ms     |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                    | 12.7 ± 1.5 μs       |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                    | 24.2 ± 0.83 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                    | 0.0472 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                    | 0.247 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                    | 0.0631 ± 0.0024 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                    | 0.317 ± 0.024 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                    | 0.169 ± 0.017 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                    | 0.169 ± 0.018 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                    | 0.0325 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                    | 0.0324 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                    | 0.0361 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                    | 30.2 ± 1.7 μs       |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                    | 0.0379 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                    | 0.284 ± 0.027 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                    | 0.0839 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                    | 0.0505 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                    | 19.7 ± 0.85 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                    | 0.0516 ± 0.0045 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                    | 0.699 ± 0.045 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                    | 0.0366 ± 0.00099 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                    | 0.47 ± 0.042 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                    | 0.912 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                    | 1.13 ± 0.33 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                    | 26.2 ± 2.8 μs       |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                    | 0.0745 ± 0.072 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                    | 26.1 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                    | 0.0542 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                    | 0.043 ± 0.0015 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                    | 1.82 ± 0.084 ms     |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                    | 0.722 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                    | 0.0382 ± 0.061 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                    | 0.0321 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                    | 0.0386 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                    | 0.162 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                    | 23.6 ± 4 μs         |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                    | 0.178 ± 0.057 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                    | 0.0464 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                    | 0.041 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                    | 29.6 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                    | 0.248 ± 0.021 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                    | 0.263 ± 0.008 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                    | 0.0381 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                    | 0.143 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                    | 0.281 ± 0.078 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                    | 10.5 ± 0.87 μs      |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                    | 30.1 ± 2.1 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                    | 0.0555 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                    | 0.717 ± 0.089 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                    | 0.089 ± 0.0088 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                    | 28.8 ± 1.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                    | 7.87 ± 1.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                    | 0.0772 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                    | 0.0325 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                    | 0.0352 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                    | 0.658 ± 0.069 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                    | 31.4 ± 22 μs        |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                    | 0.942 ± 0.33 μs     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                    | 0.0433 ± 0.025 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                    | 0.0475 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                    | 0.0382 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                    | 0.0434 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                    | 0.0386 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                    | 0.683 ± 0.052 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                    | 0.302 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                    | 1.94 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                    | 0.466 ± 0.015 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                    | 0.0542 ± 0.0032 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                    | 0.931 ± 0.31 μs     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                    | 0.0324 ± 0.0026 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                    | 0.845 ± 0.072 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                    | 0.0485 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                    | 0.501 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                    | 0.112 ± 0.0064 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                    | 22.1 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                    | 0.0374 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                    | 0.0412 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                    | 0.223 ± 0.016 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                    | 30.2 ± 1.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                    | 0.0448 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                    | 0.108 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                    | 0.775 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                    | 31.6 ± 3.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                    | 0.0349 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                    | 0.0657 ± 0.0074 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                    | 0.834 ± 0.061 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                    | 0.0466 ± 0.004 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                    | 27.7 ± 3 μs         |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                    | 0.233 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                    | 0.037 ± 0.0024 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                    | 0.401 ± 0.0097 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                    | 0.494 ± 0.063 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                    | 0.238 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                    | 1.53 ± 0.16 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                    | 0.032 ± 0.0011 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                    | 29.3 ± 1.1 μs       |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                    | 0.104 ± 0.0091 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                    | 0.0412 ± 0.0077 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                    | 0.635 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                    | 25.8 ± 0.92 μs      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                    | 0.119 ± 0.0099 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                    | 10.8 ± 1.2 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                    | 25.9 ± 2.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                    | 1.44 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                    | 0.0684 ± 0.008 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                    | 0.0453 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                    | 7.02 ± 1 μs         |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                    | 0.0638 ± 0.0055 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                    | 26.7 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                    | 0.0368 ± 0.0011 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                    | 0.114 ± 0.0065 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                    | 29.9 ± 1.1 μs       |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                    | 0.0462 ± 0.0063 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                    | 0.041 ± 0.0015 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                    | 0.0389 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                    | 7.28 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                    | 0.0521 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                    | 0.0474 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                    | 0.0509 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                    | 0.653 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                    | 0.152 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                    | 0.0364 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                    | 0.0476 ± 0.026 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                    | 0.343 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                    | 0.064 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                    | 0.0491 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                    | 0.542 ± 0.054 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                    | 28.8 ± 2 μs         |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                    | 21.9 ± 0.83 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                    | 0.771 ± 0.046 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                    | 0.0375 ± 0.0031 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                    | 0.032 ± 0.0016 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                    | 0.794 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                    | 0.531 ± 0.056 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                    | 30.2 ± 2.1 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                    | 0.604 ± 0.048 ms    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                    | 23 ± 2.5 μs         |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                    | 0.037 ± 0.0016 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                    | 0.247 ± 0.036 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                    | 0.0344 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                    | 0.0346 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                    | 0.0535 ± 0.015 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                    | 22.6 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                    | 0.716 ± 0.051 ms    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                    | 0.0428 ± 0.0024 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                    | 0.0799 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                    | 21.1 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                    | 0.0644 ± 0.0019 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                    | 0.0542 ± 0.0033 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                    | 0.039 ± 0.0013 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                    | 0.882 ± 0.079 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                    | 0.766 ± 0.046 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                    | 0.687 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                    | 2.68 ± 0.21 ms      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                    | 0.266 ± 0.038 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                    | 0.0355 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                    | 0.0506 ± 0.0015 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                    | 7.35 ± 1 μs         |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                    | 1.73 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                    | 0.0825 ± 0.0084 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                    | 0.038 ± 0.0094 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                    | 18.2 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                    | 0.618 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                    | 21.9 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                    | 2.02 ± 0.097 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                    | 0.288 ± 0.012 ms    |                            |
| time_to_load                                                                                      | 0.143 ± 0.00082 s  | 0.222 ± 0.0075 s    | 0.643 ± 0.022              |

|                                                                                                   | v0.1.0                    | 68429cd8f6c46d...         | v0.1.0 / 68429cd8f6c46d... |
|:--------------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 0.147 k allocs: 7.97 kB   | 0.157 k allocs: 8.25 kB   | 0.966                      |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 1.94 k allocs: 0.195 MB   | 1.94 k allocs: 0.195 MB   | 1                          |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.204 k allocs: 18 kB     | 0.166 k allocs: 12.6 kB   | 1.43                       |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.188 k allocs: 0.113 MB  | 0.188 k allocs: 0.113 MB  | 1                          |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 13.7 k allocs: 0.635 MB   | 10.8 k allocs: 0.558 MB   | 1.14                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.829 k allocs: 31.1 kB   | 0.585 k allocs: 22.2 kB   | 1.4                        |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 2.99 k allocs: 0.267 MB   | 2.99 k allocs: 0.267 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 0.15 k allocs: 11.9 kB    | 0.17 k allocs: 12.7 kB    | 0.942                      |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 4.7 k allocs: 0.505 MB    | 4.7 k allocs: 0.505 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 0.122 k allocs: 12.5 kB   | 0.139 k allocs: 11.6 kB   | 1.08                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 3.26 k allocs: 0.495 MB   | 0.556 k allocs: 0.163 MB  | 3.03                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 8.89 k allocs: 0.0511 GB  | 7.26 k allocs: 0.0492 GB  | 1.04                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 9.4 k allocs: 0.381 MB    | 1.34 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 0.054 k allocs: 0.0376 MB | 0.051 k allocs: 19.4 kB   | 1.98                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.161 k allocs: 0.0396 MB | 0.166 k allocs: 22 kB     | 1.85                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 1.53 k allocs: 0.294 MB   | 0.214 k allocs: 0.101 MB  | 2.9                        |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 2.1 k allocs: 24.8 MB     | 1.7 k allocs: 24.2 MB     | 1.03                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 5.84 k allocs: 0.353 MB   | 0.16 k allocs: 0.1 MB     | 3.51                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.18 k allocs: 0.0375 MB  | 0.22 k allocs: 29 kB      | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 2.31 k allocs: 0.0849 MB  | 0.67 k allocs: 0.0404 MB  | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 1.53 k allocs: 0.308 MB   | 0.386 k allocs: 0.14 MB   | 2.2                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 6.2 k allocs: 0.0508 GB   | 5.43 k allocs: 0.0489 GB  | 1.04                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 9.06 k allocs: 0.369 MB   | 0.994 k allocs: 0.156 MB  | 2.37                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 8.54 k allocs: 0.784 MB   | 8.1 k allocs: 0.748 MB    | 1.05                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.652 k allocs: 0.0473 MB | 0.487 k allocs: 0.0391 MB | 1.21                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.713 k allocs: 0.321 MB  | 0.659 k allocs: 0.298 MB  | 1.08                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 0.0394 M allocs: 1.95 MB  | 0.0373 M allocs: 1.89 MB  | 1.03                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 1.69 k allocs: 0.0622 MB  | 1.38 k allocs: 0.0631 MB  | 0.986                      |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 2.77 k allocs: 0.162 MB   | 2.54 k allocs: 0.148 MB   | 1.09                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.295 k allocs: 16.2 kB   | 0.241 k allocs: 12.2 kB   | 1.33                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.222 k allocs: 0.0645 MB | 0.192 k allocs: 0.0578 MB | 1.11                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 11.5 k allocs: 0.443 MB   | 10.3 k allocs: 0.411 MB   | 1.08                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 1.02 k allocs: 0.033 MB   | 0.697 k allocs: 25.1 kB   | 1.34                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 3.14 k allocs: 0.279 MB   | 3.13 k allocs: 0.314 MB   | 0.887                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.246 k allocs: 20 kB     | 0.212 k allocs: 16.2 kB   | 1.23                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.303 k allocs: 0.154 MB  | 0.317 k allocs: 0.187 MB  | 0.824                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 17.4 k allocs: 0.834 MB   | 16.2 k allocs: 0.89 MB    | 0.938                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.691 k allocs: 26.1 kB   | 0.675 k allocs: 28.7 kB   | 0.91                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 3.18 k allocs: 0.261 MB   | 2.9 k allocs: 0.239 MB    | 1.1                        |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.8 kB   | 0.909                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.29 k allocs: 0.13 MB    | 0.26 k allocs: 0.115 MB   | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 15.7 k allocs: 0.716 MB   | 14.3 k allocs: 0.658 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 1.15 k allocs: 0.0397 MB  | 0.847 k allocs: 0.0331 MB | 1.2                        |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.176 k allocs: 7.66 kB   | 0.22 k allocs: 10.1 kB    | 0.761                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 4.09 k allocs: 0.137 MB   | 3.73 k allocs: 0.131 MB   | 1.05                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.809 k allocs: 25.5 kB   | 0.677 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 3.93 k allocs: 0.263 MB   | 3.3 k allocs: 0.237 MB    | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.336 k allocs: 21.5 kB   | 0.392 k allocs: 21.3 kB   | 1.01                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.287 k allocs: 0.125 MB  | 0.277 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 15.9 k allocs: 0.718 MB   | 12.2 k allocs: 0.623 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 1.3 k allocs: 0.0436 MB   | 0.931 k allocs: 0.0355 MB | 1.23                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 1.5 k allocs: 0.132 MB    | 1.33 k allocs: 0.119 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 0.198 k allocs: 15.6 kB   | 0.272 k allocs: 21.2 kB   | 0.736                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 0.174 k allocs: 0.0836 MB | 0.15 k allocs: 0.0748 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 5.38 k allocs: 0.321 MB   | 4.56 k allocs: 0.291 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.39 k allocs: 16.1 kB    | 0.47 k allocs: 25 kB      | 0.645                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 2.74 k allocs: 0.209 MB   | 2.5 k allocs: 0.189 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.382 k allocs: 21.7 kB   | 0.227 k allocs: 14.3 kB   | 1.51                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 0.237 k allocs: 0.105 MB  | 0.207 k allocs: 0.0924 MB | 1.14                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 12.3 k allocs: 0.571 MB   | 11.1 k allocs: 0.527 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 1.02 k allocs: 0.0353 MB  | 0.717 k allocs: 28.3 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 4.32 k allocs: 0.329 MB   | 3.48 k allocs: 0.275 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.382 k allocs: 24.6 kB   | 0.365 k allocs: 23.2 kB   | 1.06                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.338 k allocs: 0.149 MB  | 0.302 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.742 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 1.35 k allocs: 0.046 MB   | 0.985 k allocs: 0.0389 MB | 1.18                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 10.7 k allocs: 0.915 MB   | 9.8 k allocs: 0.841 MB    | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.383 k allocs: 25 kB     | 0.274 k allocs: 21.9 kB   | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.886 k allocs: 0.384 MB  | 0.784 k allocs: 0.337 MB  | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 0.0515 M allocs: 2.58 MB  | 0.0472 M allocs: 2.44 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.863 k allocs: 0.033 MB  | 0.841 k allocs: 0.0346 MB | 0.952                      |
| Convolution body/BLAS axpy per lag                                                                | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                                              | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                                          | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.091 k allocs: 0.0452 MB | 0.073 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.04 k allocs: 0.0395 MB  | 0.034 k allocs: 0.0383 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 0.034 k allocs: 7.98 kB   | 30  allocs: 7.72 kB       | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.072 k allocs: 0.0443 MB | 0.054 k allocs: 0.0419 MB | 1.06                       |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                           | 1.2 k allocs: 0.0459 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                           | 0.276 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                           | 23.5 k allocs: 1.21 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                           | 0.337 k allocs: 14.5 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                           | 0.282 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                           | 0.919 k allocs: 0.119 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                           | 0.103 k allocs: 4.42 kB   |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                           | 3.37 k allocs: 0.241 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                           | 23.2 k allocs: 1.19 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                           | 0.252 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                           | 0.623 k allocs: 26.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                           | 0.0417 M allocs: 2.23 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                           | 0.56 k allocs: 24.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                           | 10 k allocs: 0.87 MB      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                           | 0.474 k allocs: 0.19 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                           | 2.54 k allocs: 0.185 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                           | 2.61 k allocs: 0.152 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                           | 1.03 k allocs: 0.0396 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                           | 0.433 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                           | 0.051 k allocs: 3.39 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                           | 4.77 k allocs: 0.355 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                           | 0.988 k allocs: 0.038 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                           | 2.48 k allocs: 0.183 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                           | 0.352 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                           | 0.703 k allocs: 24.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                           | 0.623 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                           | 12.8 k allocs: 0.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                           | 0.397 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                           | 10.3 k allocs: 0.499 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                           | 19.1 k allocs: 0.91 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                           | 11 k allocs: 0.568 MB     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                           | 16.5 k allocs: 0.904 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                           | 0.588 k allocs: 25.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                           | 0.233 k allocs: 16.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                           | 0.15 k allocs: 0.0748 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                           | 0.297 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                           | 0.252 k allocs: 19 kB     |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                           | 0.169 k allocs: 12.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                           | 4.93 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                           | 0.179 k allocs: 8.25 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                           | 5.95 k allocs: 0.466 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                           | 21.5 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                           | 0.641 k allocs: 0.0434 MB |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                           | 0.685 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                           | 1.26 k allocs: 0.0522 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                           | 0.805 k allocs: 0.0314 MB |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                           | 2.02 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                           | 0.194 k allocs: 0.114 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                           | 0.186 k allocs: 9.88 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                           | 2.57 k allocs: 0.193 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                           | 5.43 k allocs: 0.339 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                           | 0.967 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                           | 11.7 k allocs: 0.564 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                           | 0.048 M allocs: 2.48 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                           | 0.201 k allocs: 9.69 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                           | 0.43 k allocs: 29.1 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                           | 3.1 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                           | 1.09 k allocs: 0.0358 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                           | 4.68 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                           | 0.355 k allocs: 19.8 kB   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                           | 0.202 k allocs: 0.248 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                           | 0.666 k allocs: 28 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                           | 0.287 k allocs: 18.4 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                           | 0.339 k allocs: 22.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                           | 3.23 k allocs: 0.322 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                           | 0.614 k allocs: 0.222 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                           | 0.966 k allocs: 0.032 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                           | 0.133 k allocs: 12.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                           | 0.324 k allocs: 0.187 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                           | 17.3 k allocs: 0.991 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                           | 0.361 k allocs: 23.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                           | 6.05 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                           | 21.8 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                           | 0.232 k allocs: 0.1 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                           | 0.469 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                           | 0.85 k allocs: 0.0322 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                           | 0.0406 M allocs: 2.13 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                           | 10.3 k allocs: 0.783 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                           | 0.212 k allocs: 0.0587 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                           | 0.348 k allocs: 23 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                           | 0.227 k allocs: 0.0934 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                           | 0.991 k allocs: 0.231 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                           | 0.457 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                           | 0.284 k allocs: 0.117 MB  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                           | 0.758 k allocs: 29.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                           | 3.55 k allocs: 0.284 MB   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                           | 0.314 k allocs: 0.163 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                           | 3.95 k allocs: 0.144 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                           | 1.89 k allocs: 0.274 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                           | 0.287 k allocs: 16.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                           | 8.22 k allocs: 0.772 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                           | 1.33 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                           | 0.07 k allocs: 13.7 kB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                           | 1.37 k allocs: 0.0547 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                           | 0.252 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                           | 0.744 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                           | 9.77 k allocs: 0.748 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                           | 0.345 k allocs: 0.171 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                           | 0.408 k allocs: 26.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                           | 0.346 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                           | 9.53 k allocs: 0.731 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                           | 4.12 k allocs: 0.348 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                           | 0.0377 M allocs: 1.93 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                           | 10.5 k allocs: 0.505 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                           | 0.528 k allocs: 0.0355 MB |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                           | 0.693 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                           | 17.6 k allocs: 0.87 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                           | 0.183 k allocs: 0.0407 MB |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                           | 10.9 k allocs: 0.446 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                           | 0.801 k allocs: 0.339 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                           | 0.354 k allocs: 26.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                           | 0.407 k allocs: 24.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                           | 0.829 k allocs: 0.033 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                           | 2.98 k allocs: 0.246 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                           | 0.316 k allocs: 19.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                           | 0.315 k allocs: 20.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                           | 0.834 k allocs: 0.301 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                           | 10.5 k allocs: 0.792 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                           | 0.753 k allocs: 27 kB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                           | 1.11 k allocs: 0.0594 MB  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                           | 17.9 k allocs: 0.884 MB   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                           | 0.227 k allocs: 0.0997 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                           | 4.56 k allocs: 0.291 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                           | 0.26 k allocs: 17 kB      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                           | 1.17 k allocs: 0.21 MB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                           | 7.19 k allocs: 0.565 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                           | 0.225 k allocs: 16 kB     |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                           | 0.77 k allocs: 0.298 MB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                           | 0.514 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                           | 0.214 k allocs: 15.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                           | 0.782 k allocs: 0.401 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                           | 31.1 k allocs: 1.49 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                           | 0.352 k allocs: 0.171 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                           | 0.053 k allocs: 11.4 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                           | 1.11 k allocs: 0.0465 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                           | 0.358 k allocs: 19.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                           | 0.77 k allocs: 0.401 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                           | 0.738 k allocs: 31.1 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                           | 0.482 k allocs: 0.226 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                           | 0.851 k allocs: 0.032 MB  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                           | 0.39 k allocs: 0.0646 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                           | 0.448 k allocs: 29.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                           | 0.814 k allocs: 0.0409 MB |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                           | 0.464 k allocs: 0.175 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                           | 2.81 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                           | 0.344 k allocs: 22.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                           | 0.308 k allocs: 0.135 MB  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                           | 1.14 k allocs: 0.0607 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                           | 0.915 k allocs: 0.034 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                           | 7.07 k allocs: 0.55 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                           | 0.166 k allocs: 13.5 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                           | 0.712 k allocs: 26.8 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                           | 0.845 k allocs: 0.0326 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                           | 15.3 k allocs: 0.756 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                           | 3.77 k allocs: 0.332 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                           | 0.243 k allocs: 17.7 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                           | 0.067 k allocs: 0.0331 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                           | 0.341 k allocs: 19.6 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                           | 4.89 k allocs: 0.382 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                           | 0.452 k allocs: 0.145 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                           | 0.562 k allocs: 23.7 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                           | 1.13 k allocs: 0.0395 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                           | 0.251 k allocs: 17 kB     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                           | 18.2 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                           | 0.924 k allocs: 0.0371 MB |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                           | 0.466 k allocs: 0.188 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                           | 1.08 k allocs: 0.0401 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                           | 1.14 k allocs: 0.0435 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                           | 0.346 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                           | 19.9 k allocs: 0.954 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                           | 14.8 k allocs: 0.965 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                           | 15 k allocs: 0.706 MB     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                           | 0.0423 M allocs: 2.26 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                           | 5.52 k allocs: 0.342 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                           | 0.632 k allocs: 25.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                           | 0.863 k allocs: 32 kB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                           | 30.7 k allocs: 1.46 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                           | 0.668 k allocs: 0.3 MB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                           | 0.476 k allocs: 0.146 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                           | 0.205 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                           | 0.363 k allocs: 27.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                           | 0.0427 M allocs: 2.26 MB  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                           | 4.03 k allocs: 0.339 MB   |                            |
| time_to_load                                                                                      | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

