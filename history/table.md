|                                                                                             | v0.1.0              | 26e41d7009278e...   | v0.1.0 / 26e41d7009278e... |
|:--------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0546 ± 0.0045 ms  | 0.0561 ± 0.0072 ms  | 0.973 ± 0.15               |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 24.4 ± 0.7 μs       | 24.5 ± 1.3 μs       | 0.996 ± 0.059              |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 8.24 ± 3.1 μs       | 3.76 ± 2 μs         | 2.19 ± 1.4                 |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.192 ± 0.031 ms    | 0.185 ± 0.054 ms    | 1.04 ± 0.35                |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.0368 ± 0.0032 ms  | 28.8 ± 1.9 μs       | 1.28 ± 0.14                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                     | 0.209 ± 0.01 ms     | 0.221 ± 0.023 ms    | 0.947 ± 0.11               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                     | 0.0337 ± 0.0011 ms  | 27.4 ± 0.98 μs      | 1.23 ± 0.059               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                        | 0.035 ± 0.0041 ms   | 0.0347 ± 0.0056 ms  | 1.01 ± 0.2                 |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                   | 0.809 ± 0.015 ms    | 0.737 ± 0.02 ms     | 1.1 ± 0.036                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                   | 0.0448 ± 0.0032 ms  | 31 ± 0.96 μs        | 1.44 ± 0.11                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.29 ± 0.014 ms     | 0.299 ± 0.014 ms    | 0.968 ± 0.066              |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 28.9 ± 0.81 μs      | 26.7 ± 0.92 μs      | 1.08 ± 0.048               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.0424 ± 0.012 ms   | 0.0425 ± 0.0038 ms  | 0.999 ± 0.29               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.761 ± 0.061 ms    | 0.882 ± 0.032 ms    | 0.863 ± 0.075              |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.0454 ± 0.0037 ms  | 31.2 ± 0.88 μs      | 1.45 ± 0.13                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.542 ± 0.025 ms    | 0.54 ± 0.041 ms     | 1 ± 0.089                  |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 24.7 ± 1.1 μs       | 22.3 ± 1.4 μs       | 1.11 ± 0.084               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0844 ± 0.005 ms   | 0.0811 ± 0.0086 ms  | 1.04 ± 0.13                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.57 ± 0.18 ms      | 1.14 ± 0.43 ms      | 1.37 ± 0.54                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.0359 ± 0.0023 ms  | 26.7 ± 2.4 μs       | 1.34 ± 0.15                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.379 ± 0.018 ms    | 0.744 ± 0.25 ms     | 0.51 ± 0.17                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.644 ± 0.25 ms     | 0.655 ± 0.27 ms     | 0.983 ± 0.55               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 9.46 ± 0.23 ms      | 13.2 ± 4 ms         | 0.718 ± 0.22               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 0.0319 ± 0.012 s    | 0.0439 ± 0.012 s    | 0.727 ± 0.34               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 1.03 ± 0.2 ms       | 0.261 ± 0.01 ms     | 3.94 ± 0.79                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0571 ± 0.0086 s   | 0.05 ± 0.0027 s     | 1.14 ± 0.18                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 0.927 ± 0.04 ms     | 0.276 ± 0.011 ms    | 3.36 ± 0.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 27.8 ± 5.5 μs       | 11 ± 6.1 μs         | 2.51 ± 1.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 1.33 ± 0.55 ms      | 0.441 ± 0.61 ms     | 3.01 ± 4.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.0536 ± 0.0034 ms  | 16.7 ± 2.4 μs       | 3.21 ± 0.51                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.0532 ± 0.012 ms   | 29.3 ± 6.7 μs       | 1.82 ± 0.58                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 1.48 ± 0.017 ms     | 0.488 ± 0.033 ms    | 3.03 ± 0.21                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.0846 ± 0.0043 ms  | 0.043 ± 0.0026 ms   | 1.97 ± 0.15                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.499 ± 0.025 ms    | 0.0752 ± 0.0057 ms  | 6.63 ± 0.6                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 26.8 ± 4.5 ms       | 15.1 ± 0.78 ms      | 1.78 ± 0.31                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.491 ± 0.053 ms    | 0.0917 ± 0.0027 ms  | 5.36 ± 0.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0709 ± 0.012 ms   | 0.0514 ± 0.0062 ms  | 1.38 ± 0.28                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 2.02 ± 0.58 ms      | 1.51 ± 0.57 ms      | 1.33 ± 0.63                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.116 ± 0.017 ms    | 0.0587 ± 0.0087 ms  | 1.98 ± 0.41                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.71 ± 0.023 ms     | 0.324 ± 0.018 ms    | 2.19 ± 0.14                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 0.0394 ± 0.011 s    | 0.0442 ± 0.00038 s  | 0.891 ± 0.24               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.663 ± 0.038 ms    | 0.202 ± 0.0075 ms   | 3.28 ± 0.22                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                          | 0.9 ± 0.028 ms      | 0.813 ± 0.076 ms    | 1.11 ± 0.11                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                          | 0.102 ± 0.0054 ms   | 0.0681 ± 0.0019 ms  | 1.5 ± 0.09                 |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                             | 0.113 ± 0.0076 ms   | 0.121 ± 0.0084 ms   | 0.928 ± 0.09               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                        | 2.4 ± 0.11 ms       | 2.41 ± 0.035 ms     | 0.996 ± 0.048              |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                        | 0.125 ± 0.0063 ms   | 0.0905 ± 0.0093 ms  | 1.38 ± 0.16                |
| AD gradients/Recurrence in Float32/Enzyme forward                                           | 0.208 ± 0.032 ms    | 0.185 ± 0.024 ms    | 1.12 ± 0.23                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                           | 0.0408 ± 0.00089 ms | 0.0353 ± 0.0028 ms  | 1.15 ± 0.095               |
| AD gradients/Recurrence in Float32/ForwardDiff                                              | 0.043 ± 0.0036 ms   | 0.0448 ± 0.0033 ms  | 0.959 ± 0.11               |
| AD gradients/Recurrence in Float32/Mooncake forward                                         | 0.726 ± 0.037 ms    | 0.568 ± 0.037 ms    | 1.28 ± 0.11                |
| AD gradients/Recurrence in Float32/Mooncake reverse                                         | 0.0545 ± 0.0014 ms  | 0.0454 ± 0.0032 ms  | 1.2 ± 0.091                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.329 ± 0.033 ms    | 0.366 ± 0.039 ms    | 0.898 ± 0.13               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.0466 ± 0.0027 ms  | 0.0322 ± 0.001 ms   | 1.45 ± 0.094               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0666 ± 0.011 ms   | 0.0801 ± 0.0043 ms  | 0.832 ± 0.14               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 1.13 ± 0.02 ms      | 1.35 ± 0.071 ms     | 0.837 ± 0.046              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0547 ± 0.0014 ms  | 0.038 ± 0.0013 ms   | 1.44 ± 0.061               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.324 ± 0.03 ms     | 0.278 ± 0.045 ms    | 1.17 ± 0.22                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.0441 ± 0.0033 ms  | 0.0379 ± 0.0012 ms  | 1.16 ± 0.095               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0863 ± 0.036 ms   | 0.0536 ± 0.0043 ms  | 1.61 ± 0.68                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 1.05 ± 0.086 ms     | 0.842 ± 0.058 ms    | 1.24 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.062 ± 0.0023 ms   | 0.046 ± 0.0013 ms   | 1.35 ± 0.063               |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.057 ± 0.0019 ms   | 0.057 ± 0.0026 ms   | 1 ± 0.056                  |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.0317 ± 0.0027 ms  | 0.0322 ± 0.003 ms   | 0.984 ± 0.13               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 11.4 ± 3.8 μs       | 9.89 ± 3 μs         | 1.15 ± 0.52                |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.178 ± 0.011 ms    | 0.168 ± 0.029 ms    | 1.06 ± 0.2                 |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.0521 ± 0.0036 ms  | 0.0392 ± 0.0038 ms  | 1.33 ± 0.16                |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.339 ± 0.041 ms    | 0.266 ± 0.018 ms    | 1.28 ± 0.18                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0515 ± 0.0034 ms  | 0.0466 ± 0.0013 ms  | 1.11 ± 0.078               |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0541 ± 0.0092 ms  | 0.0591 ± 0.0038 ms  | 0.914 ± 0.17               |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 0.968 ± 0.014 ms    | 0.939 ± 0.022 ms    | 1.03 ± 0.029               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.0969 ± 0.0077 ms  | 0.0606 ± 0.002 ms   | 1.6 ± 0.14                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.12 ± 0.0076 ms    | 0.117 ± 0.011 ms    | 1.02 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 23.6 ± 3.1 μs       | 30.1 ± 1.2 μs       | 0.784 ± 0.11               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 28.6 ± 3.6 μs       | 25.3 ± 1.6 μs       | 1.13 ± 0.16                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.258 ± 0.013 ms    | 0.321 ± 0.014 ms    | 0.802 ± 0.054              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.0349 ± 0.0014 ms  | 0.0354 ± 0.0032 ms  | 0.986 ± 0.097              |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.216 ± 0.027 ms    | 0.211 ± 0.026 ms    | 1.02 ± 0.18                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0557 ± 0.0033 ms  | 0.0322 ± 0.00092 ms | 1.73 ± 0.11                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.0329 ± 0.0019 ms  | 0.0354 ± 0.0087 ms  | 0.928 ± 0.23               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.627 ± 0.079 ms    | 0.683 ± 0.017 ms    | 0.918 ± 0.12               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0636 ± 0.011 ms   | 0.0398 ± 0.0012 ms  | 1.6 ± 0.27                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.437 ± 0.025 ms    | 0.308 ± 0.024 ms    | 1.42 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0637 ± 0.0027 ms  | 0.0462 ± 0.0013 ms  | 1.38 ± 0.071               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0602 ± 0.0039 ms  | 0.0601 ± 0.0081 ms  | 1 ± 0.15                   |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.38 ± 0.24 ms      | 1.17 ± 0.027 ms     | 1.18 ± 0.21                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.0995 ± 0.0085 ms  | 0.0629 ± 0.0023 ms  | 1.58 ± 0.15                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 0.85 ± 0.26 ms      | 1.11 ± 0.25 ms      | 0.764 ± 0.29               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.05 ± 0.006 ms     | 0.0429 ± 0.0034 ms  | 1.17 ± 0.17                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.131 ± 0.0075 ms   | 0.147 ± 0.011 ms    | 0.887 ± 0.082              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 3.07 ± 0.65 ms      | 3.22 ± 0.49 ms      | 0.953 ± 0.25               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0675 ± 0.0072 ms  | 0.0473 ± 0.0023 ms  | 1.43 ± 0.17                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0537 ± 0.001 ms   | 0.0473 ± 0.001 ms   | 1.13 ± 0.032               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 4.6 ± 0.35 μs       | 3.92 ± 0.28 μs      | 1.17 ± 0.12                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 2.76 ± 1.6 μs       | 2.16 ± 0.42 μs      | 1.28 ± 0.77                |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.0443 ± 0.0055 ms  | 0.0409 ± 0.014 ms   | 1.08 ± 0.4                 |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 7.88 ± 1.8 μs       | 8.56 ± 1.9 μs       | 0.92 ± 0.29                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.0531 ± 0.0035 ms  | 31 ± 0.83 μs        | 1.71 ± 0.12                |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                     | 0.0896 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                     | 0.0424 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                     | 2.07 ± 0.045 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                     | 0.0343 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                     | 0.357 ± 0.014 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                     | 0.0436 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                     | 0.0478 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                     | 0.776 ± 0.008 ms    |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                     | 1.13 ± 0.42 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                     | 0.293 ± 0.036 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                     | 1.75 ± 0.18 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                     | 0.0354 ± 0.00093 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                     | 0.654 ± 0.1 ms      |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                     | 0.048 ± 0.0059 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                     | 0.04 ± 0.0014 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                     | 3.76 ± 0.15 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                     | 0.0395 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                     | 1.01 ± 0.083 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                     | 0.114 ± 0.0082 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward           |                     | 0.213 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                 |                     | 0.202 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                     | 0.093 ± 0.0028 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                     | 0.0566 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                     | 0.387 ± 0.026 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                     | 0.0573 ± 0.0017 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                     | 0.214 ± 0.026 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                     | 0.0469 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                               |                     | 0.0557 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                     | 0.134 ± 0.0053 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                     | 1.6 ± 0.3 ms        |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                     | 1.04 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                     | 0.0542 ± 0.0012 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                     | 0.683 ± 0.063 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                     | 1.08 ± 0.08 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward         |                     | 0.672 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                     | 1.26 ± 0.05 ms      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                     | 28 ± 1 μs           |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                     | 0.224 ± 0.028 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                     | 0.0387 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                     | 26.2 ± 6.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                     | 0.0649 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                     | 31 ± 1 μs           |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                     | 0.984 ± 0.086 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                     | 30 ± 0.88 μs        |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                     | 0.557 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                     | 31.5 ± 3.1 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                     | 0.625 ± 0.035 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                     | 1.41 ± 0.27 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                |                     | 0.0873 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                     | 0.133 ± 0.0042 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                     | 0.0792 ± 0.0075 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                     | 0.0459 ± 0.0027 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                     | 0.0403 ± 0.035 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                     | 0.0732 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward           |                     | 0.223 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff              |                     | 31.1 ± 2.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                     | 0.24 ± 0.018 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                     | 0.328 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                     | 0.0686 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                     | 0.842 ± 0.042 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                     | 0.723 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                     | 3.21 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                     | 30.2 ± 0.77 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                     | 0.0617 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                     | 0.305 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                     | 0.0934 ± 0.0031 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                     | 0.42 ± 0.061 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                     | 0.221 ± 0.027 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                     | 0.221 ± 0.023 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                     | 0.0394 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                     | 0.0444 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                     | 0.0523 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                     | 0.0396 ± 0.00095 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                     | 0.364 ± 0.036 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                     | 0.109 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                     | 0.079 ± 0.0027 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                     | 24.1 ± 0.75 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                     | 0.0747 ± 0.0038 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                     | 0.843 ± 0.3 ms      |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                     | 0.0476 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                     | 0.554 ± 0.06 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                     | 1.3 ± 0.085 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff              |                     | 0.0376 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                     | 0.0914 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                     | 0.0361 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                     | 0.0698 ± 0.0026 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                     | 2.49 ± 0.1 ms       |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                     | 0.94 ± 0.068 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                     | 0.0536 ± 0.0079 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                    |                     | 30.3 ± 18 μs        |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                     | 0.0467 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                     | 0.207 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                     | 0.0349 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                     | 0.262 ± 0.063 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                     | 0.063 ± 0.0024 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                     | 0.0543 ± 0.0076 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse         |                     | 0.0414 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                     | 0.315 ± 0.029 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                     | 0.331 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                     | 0.0591 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                     | 0.205 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                     | 0.384 ± 0.045 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                 |                     | 0.0391 ± 0.0025 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                     | 0.0825 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                |                     | 0.849 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                     | 0.12 ± 0.011 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                     | 0.0395 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                     | 11.2 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse              |                     | 0.113 ± 0.0035 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                     | 0.0414 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                     | 0.0526 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                     | 0.863 ± 0.094 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                     | 0.0342 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                     | 0.0595 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                     | 0.056 ± 0.0015 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                     | 0.0546 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                     | 0.0487 ± 0.0011 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                     | 0.882 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward              |                     | 2.62 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                     | 0.657 ± 0.022 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                     | 0.0692 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                     | 0.0465 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                     | 0.0631 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                               |                     | 0.739 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                     | 0.152 ± 0.0077 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                     | 27.8 ± 1.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                     | 0.0444 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                     | 0.0598 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                     | 0.284 ± 0.015 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                     |                     | 0.0372 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                     | 0.0585 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                     | 0.149 ± 0.072 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                     | 0.945 ± 0.085 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                     | 0.0662 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse         |                     | 0.0514 ± 0.0017 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                     | 0.0892 ± 0.0091 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                     | 0.0548 ± 0.0036 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                     | 0.039 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                     | 0.32 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                     | 0.188 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                     | 0.579 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                     | 0.625 ± 0.05 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                     | 0.304 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                     | 1.92 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                     | 0.0406 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                     | 0.0372 ± 0.00097 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                     | 0.136 ± 0.0053 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                     | 0.0679 ± 0.0099 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                     | 0.967 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse           |                     | 31.5 ± 0.85 μs      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                     | 0.168 ± 0.0095 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                     | 0.0402 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                     | 2.03 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                     | 0.0928 ± 0.0083 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                     | 9.27 ± 1.4 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                     | 0.0968 ± 0.033 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                     | 0.0376 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                     | 0.0477 ± 0.0011 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                     | 0.175 ± 0.024 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                     | 0.0422 ± 0.0014 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                     | 0.0532 ± 0.0091 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                     | 0.0578 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                     | 0.0513 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                     | 9.72 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                     | 0.0662 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                     | 0.0605 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                     | 0.0741 ± 0.006 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                     | 0.925 ± 0.15 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                     | 0.2 ± 0.0076 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                     | 0.0605 ± 0.03 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                     | 0.433 ± 0.07 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                     | 0.0866 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                     | 0.073 ± 0.0021 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                     | 0.643 ± 0.078 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                     | 0.0385 ± 0.0025 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                     | 28.6 ± 0.92 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                     | 1.07 ± 0.046 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                     | 0.0528 ± 0.0016 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                     | 0.0447 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                     | 1.15 ± 0.028 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                     | 0.55 ± 0.053 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                     | 0.0403 ± 0.003 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                     | 0.82 ± 0.079 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                     | 28.8 ± 2.8 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                     | 0.0467 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                     | 0.305 ± 0.055 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                     | 0.0437 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                     | 0.0531 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                     | 0.0652 ± 0.013 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                     | 27.4 ± 1 μs         |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                     | 0.957 ± 0.033 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                     | 0.109 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                     | 26.9 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                     | 0.097 ± 0.007 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                     | 0.082 ± 0.0066 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                     | 0.0488 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                     | 1.18 ± 0.032 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                     | 1.07 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                     | 0.984 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                     | 3.63 ± 0.062 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                     | 0.338 ± 0.053 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                     | 0.0476 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                     | 0.0759 ± 0.0023 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                     | 9.43 ± 1.1 μs       |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                     | 2.3 ± 0.14 ms       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                   |                     | 0.107 ± 0.0044 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                     | 0.0639 ± 0.02 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                     | 22.8 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                     | 0.889 ± 0.13 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                     | 28.4 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                     | 2.79 ± 0.1 ms       |                            |
| time_to_load                                                                                | 0.183 ± 0.00034 s   | 0.274 ± 0.0031 s    | 0.668 ± 0.0077             |

|                                                                                             | v0.1.0                    | 26e41d7009278e...         | v0.1.0 / 26e41d7009278e... |
|:--------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 0.147 k allocs: 7.97 kB   | 0.157 k allocs: 8.25 kB   | 0.966                      |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                     | 1.94 k allocs: 0.195 MB   | 1.94 k allocs: 0.195 MB   | 1                          |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                     | 0.204 k allocs: 18 kB     | 0.166 k allocs: 12.6 kB   | 1.43                       |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                        | 0.188 k allocs: 0.113 MB  | 0.188 k allocs: 0.113 MB  | 1                          |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                   | 13.7 k allocs: 0.635 MB   | 10.8 k allocs: 0.558 MB   | 1.14                       |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                   | 0.829 k allocs: 31.1 kB   | 0.585 k allocs: 22.2 kB   | 1.4                        |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 2.99 k allocs: 0.267 MB   | 2.99 k allocs: 0.267 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.15 k allocs: 11.9 kB    | 0.17 k allocs: 12.7 kB    | 0.942                      |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 4.7 k allocs: 0.505 MB    | 4.7 k allocs: 0.505 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 0.122 k allocs: 12.5 kB   | 0.139 k allocs: 11.6 kB   | 1.08                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 3.26 k allocs: 0.495 MB   | 0.556 k allocs: 0.163 MB  | 3.03                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 8.89 k allocs: 0.0511 GB  | 7.26 k allocs: 0.0492 GB  | 1.04                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 9.4 k allocs: 0.381 MB    | 1.34 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.054 k allocs: 0.0376 MB | 0.051 k allocs: 19.4 kB   | 1.98                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.161 k allocs: 0.0396 MB | 0.166 k allocs: 22 kB     | 1.85                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 1.53 k allocs: 0.294 MB   | 0.214 k allocs: 0.101 MB  | 2.9                        |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 2.1 k allocs: 24.8 MB     | 1.7 k allocs: 24.2 MB     | 1.03                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 5.84 k allocs: 0.353 MB   | 0.16 k allocs: 0.1 MB     | 3.51                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.18 k allocs: 0.0375 MB  | 0.22 k allocs: 29 kB      | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 2.31 k allocs: 0.0849 MB  | 0.67 k allocs: 0.0404 MB  | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 1.53 k allocs: 0.308 MB   | 0.386 k allocs: 0.14 MB   | 2.2                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 6.2 k allocs: 0.0508 GB   | 5.43 k allocs: 0.0489 GB  | 1.04                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 9.06 k allocs: 0.369 MB   | 0.994 k allocs: 0.156 MB  | 2.37                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                          | 8.54 k allocs: 0.784 MB   | 8.1 k allocs: 0.748 MB    | 1.05                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                          | 0.652 k allocs: 0.0473 MB | 0.487 k allocs: 0.0391 MB | 1.21                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                             | 0.713 k allocs: 0.321 MB  | 0.659 k allocs: 0.298 MB  | 1.08                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                        | 0.0394 M allocs: 1.95 MB  | 0.0373 M allocs: 1.89 MB  | 1.03                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                        | 1.69 k allocs: 0.0622 MB  | 1.38 k allocs: 0.0631 MB  | 0.986                      |
| AD gradients/Recurrence in Float32/Enzyme forward                                           | 2.77 k allocs: 0.162 MB   | 2.54 k allocs: 0.148 MB   | 1.09                       |
| AD gradients/Recurrence in Float32/Enzyme reverse                                           | 0.295 k allocs: 16.2 kB   | 0.241 k allocs: 12.2 kB   | 1.33                       |
| AD gradients/Recurrence in Float32/ForwardDiff                                              | 0.222 k allocs: 0.0645 MB | 0.192 k allocs: 0.0578 MB | 1.11                       |
| AD gradients/Recurrence in Float32/Mooncake forward                                         | 11.5 k allocs: 0.443 MB   | 10.3 k allocs: 0.411 MB   | 1.08                       |
| AD gradients/Recurrence in Float32/Mooncake reverse                                         | 1.02 k allocs: 0.033 MB   | 0.697 k allocs: 25.1 kB   | 1.34                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 3.14 k allocs: 0.279 MB   | 3.13 k allocs: 0.314 MB   | 0.887                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.246 k allocs: 20 kB     | 0.212 k allocs: 16.2 kB   | 1.23                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.303 k allocs: 0.154 MB  | 0.317 k allocs: 0.187 MB  | 0.824                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 17.4 k allocs: 0.834 MB   | 16.2 k allocs: 0.89 MB    | 0.938                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.691 k allocs: 26.1 kB   | 0.675 k allocs: 28.7 kB   | 0.911                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 3.18 k allocs: 0.261 MB   | 2.9 k allocs: 0.239 MB    | 1.1                        |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.8 kB   | 0.91                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.29 k allocs: 0.13 MB    | 0.26 k allocs: 0.115 MB   | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 15.7 k allocs: 0.716 MB   | 14.3 k allocs: 0.658 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 1.15 k allocs: 0.0397 MB  | 0.847 k allocs: 0.0331 MB | 1.2                        |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.176 k allocs: 7.66 kB   | 0.22 k allocs: 10 kB      | 0.762                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 4.09 k allocs: 0.137 MB   | 3.73 k allocs: 0.131 MB   | 1.05                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.809 k allocs: 25.5 kB   | 0.677 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 3.93 k allocs: 0.263 MB   | 3.3 k allocs: 0.237 MB    | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.336 k allocs: 21.5 kB   | 0.392 k allocs: 21.3 kB   | 1.01                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.287 k allocs: 0.125 MB  | 0.277 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 15.9 k allocs: 0.718 MB   | 12.2 k allocs: 0.623 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 1.3 k allocs: 0.0436 MB   | 0.931 k allocs: 0.0355 MB | 1.23                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 1.5 k allocs: 0.132 MB    | 1.33 k allocs: 0.119 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 0.198 k allocs: 15.6 kB   | 0.272 k allocs: 21.2 kB   | 0.737                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 0.174 k allocs: 0.0836 MB | 0.15 k allocs: 0.0748 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 5.38 k allocs: 0.321 MB   | 4.56 k allocs: 0.291 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.39 k allocs: 16.1 kB    | 0.47 k allocs: 25 kB      | 0.645                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 2.74 k allocs: 0.209 MB   | 2.5 k allocs: 0.189 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.382 k allocs: 21.7 kB   | 0.227 k allocs: 14.3 kB   | 1.51                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.237 k allocs: 0.105 MB  | 0.207 k allocs: 0.0924 MB | 1.14                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 12.3 k allocs: 0.571 MB   | 11.1 k allocs: 0.527 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 1.02 k allocs: 0.0353 MB  | 0.717 k allocs: 28.3 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 4.32 k allocs: 0.329 MB   | 3.48 k allocs: 0.275 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.382 k allocs: 24.6 kB   | 0.365 k allocs: 23.2 kB   | 1.06                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.338 k allocs: 0.149 MB  | 0.302 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.742 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 1.35 k allocs: 0.046 MB   | 0.985 k allocs: 0.0389 MB | 1.18                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 10.7 k allocs: 0.915 MB   | 9.8 k allocs: 0.841 MB    | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.383 k allocs: 25 kB     | 0.274 k allocs: 21.9 kB   | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.886 k allocs: 0.384 MB  | 0.784 k allocs: 0.337 MB  | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 0.0515 M allocs: 2.58 MB  | 0.0472 M allocs: 2.44 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.863 k allocs: 0.033 MB  | 0.841 k allocs: 0.0346 MB | 0.952                      |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.091 k allocs: 0.0452 MB | 0.073 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.04 k allocs: 0.0395 MB  | 0.034 k allocs: 0.0383 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 0.034 k allocs: 7.98 kB   | 30  allocs: 7.72 kB       | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.072 k allocs: 0.0443 MB | 0.054 k allocs: 0.0419 MB | 1.06                       |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                           | 1.2 k allocs: 0.0459 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                           | 0.276 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                           | 23.5 k allocs: 1.21 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                           | 0.337 k allocs: 14.5 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                           | 0.282 k allocs: 0.161 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                           | 0.919 k allocs: 0.119 MB  |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                           | 3.37 k allocs: 0.241 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                           | 23.2 k allocs: 1.19 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                           | 0.252 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                           | 0.623 k allocs: 26.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                           | 0.0417 M allocs: 2.23 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                           | 0.56 k allocs: 24.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                           | 10 k allocs: 0.87 MB      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                           | 0.474 k allocs: 0.19 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward           |                           | 2.54 k allocs: 0.185 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                 |                           | 2.61 k allocs: 0.152 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.03 k allocs: 0.0396 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.433 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.77 k allocs: 0.355 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.988 k allocs: 0.038 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                           | 2.48 k allocs: 0.183 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.352 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                               |                           | 0.703 k allocs: 24.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.623 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.8 k allocs: 0.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.397 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                           | 10.3 k allocs: 0.499 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                           | 19.1 k allocs: 0.91 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward         |                           | 11 k allocs: 0.568 MB     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                           | 16.5 k allocs: 0.904 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                           | 0.588 k allocs: 25.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                           | 0.233 k allocs: 16.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                           | 0.15 k allocs: 0.0748 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                           | 0.297 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                           | 0.252 k allocs: 19 kB     |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                           | 0.169 k allocs: 12.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                           | 4.93 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                           | 0.179 k allocs: 8.25 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                           | 5.95 k allocs: 0.466 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                           | 21.5 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                |                           | 0.641 k allocs: 0.0434 MB |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                           | 0.685 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                           | 1.26 k allocs: 0.0522 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                           | 0.805 k allocs: 0.0314 MB |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward           |                           | 2.02 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff              |                           | 0.194 k allocs: 0.114 MB  |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                           | 2.57 k allocs: 0.193 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                           | 5.43 k allocs: 0.339 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                           | 0.967 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                           | 11.7 k allocs: 0.564 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                           | 0.048 M allocs: 2.48 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                           | 0.43 k allocs: 29.1 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                           | 3.1 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                           | 1.09 k allocs: 0.0358 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                           | 4.68 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                           | 0.355 k allocs: 19.8 kB   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                           | 0.202 k allocs: 0.248 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                           | 0.666 k allocs: 28 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                           | 0.287 k allocs: 18.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                           | 3.23 k allocs: 0.322 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                           | 0.614 k allocs: 0.222 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                           | 0.966 k allocs: 0.032 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                           | 0.133 k allocs: 12.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                           | 0.324 k allocs: 0.187 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                           | 17.3 k allocs: 0.991 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                           | 0.361 k allocs: 23.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                           | 6.05 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                           | 21.8 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff              |                           | 0.232 k allocs: 0.1 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                           | 0.469 k allocs: 30 kB     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                           | 0.0406 M allocs: 2.13 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                           | 10.3 k allocs: 0.783 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                    |                           | 0.212 k allocs: 0.0587 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.348 k allocs: 23 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.227 k allocs: 0.0934 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.943 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.457 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.284 k allocs: 0.117 MB  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse         |                           | 0.758 k allocs: 29.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.55 k allocs: 0.284 MB   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                           | 0.314 k allocs: 0.163 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.95 k allocs: 0.144 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.89 k allocs: 0.274 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                 |                           | 0.287 k allocs: 16.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                |                           | 8.22 k allocs: 0.772 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.33 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.07 k allocs: 13.7 kB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse              |                           | 1.37 k allocs: 0.0547 MB  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.252 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.744 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.77 k allocs: 0.748 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.408 k allocs: 26.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.346 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.53 k allocs: 0.731 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward              |                           | 0.0377 M allocs: 1.93 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                           | 10.5 k allocs: 0.505 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.528 k allocs: 0.0355 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.693 k allocs: 22.5 kB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.183 k allocs: 0.0407 MB |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                               |                           | 10.9 k allocs: 0.446 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                           | 0.801 k allocs: 0.339 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                           | 0.354 k allocs: 26.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                           | 0.407 k allocs: 24.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                           | 0.829 k allocs: 0.033 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                           | 2.98 k allocs: 0.246 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                     |                           | 0.316 k allocs: 19.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                           | 0.315 k allocs: 20.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                           | 0.834 k allocs: 0.301 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                           | 10.5 k allocs: 0.792 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse         |                           | 0.753 k allocs: 27 kB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                           | 1.11 k allocs: 0.0594 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.161 k allocs: 0.034 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                           | 0.227 k allocs: 0.0997 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.56 k allocs: 0.291 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                           | 0.242 k allocs: 15.2 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 0.718 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.19 k allocs: 0.565 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                           | 0.225 k allocs: 15.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                           | 0.77 k allocs: 0.298 MB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                           | 0.514 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse           |                           | 0.196 k allocs: 14 kB     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                           | 0.782 k allocs: 0.401 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                           | 31.1 k allocs: 1.49 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                           | 0.053 k allocs: 11.4 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                           | 1.11 k allocs: 0.0465 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                           | 0.358 k allocs: 19.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                           | 0.77 k allocs: 0.401 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                           | 0.738 k allocs: 31.1 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                           | 0.482 k allocs: 0.226 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                           | 0.851 k allocs: 0.032 MB  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                           | 0.24 k allocs: 0.06 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                           | 0.448 k allocs: 29.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                           | 0.814 k allocs: 0.0409 MB |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                           | 0.464 k allocs: 0.175 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                           | 2.81 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                           | 0.308 k allocs: 0.135 MB  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                           | 1.14 k allocs: 0.0607 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                           | 0.915 k allocs: 0.034 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                           | 7.07 k allocs: 0.55 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                           | 0.166 k allocs: 13.5 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                           | 0.712 k allocs: 26.8 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                           | 0.845 k allocs: 0.0326 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                           | 15.3 k allocs: 0.756 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                           | 3.77 k allocs: 0.332 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                           | 0.243 k allocs: 17.7 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                           | 0.047 k allocs: 0.0318 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                           | 0.341 k allocs: 19.6 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                           | 4.89 k allocs: 0.382 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                           | 0.452 k allocs: 0.145 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                           | 0.562 k allocs: 23.7 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                           | 1.04 k allocs: 0.0369 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                           | 0.251 k allocs: 17 kB     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                           | 18.2 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                           | 0.466 k allocs: 0.188 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                           | 0.151 k allocs: 6.98 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                           | 1.08 k allocs: 0.0401 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                           | 1.14 k allocs: 0.0435 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                           | 0.346 k allocs: 17.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                           | 19.9 k allocs: 0.954 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                           | 14.8 k allocs: 0.965 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                           | 15 k allocs: 0.706 MB     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                           | 0.0423 M allocs: 2.26 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                           | 5.52 k allocs: 0.342 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                           | 0.632 k allocs: 25.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                           | 0.863 k allocs: 32 kB     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                           | 30.7 k allocs: 1.46 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                   |                           | 0.668 k allocs: 0.3 MB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                           | 0.476 k allocs: 0.146 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                           | 0.205 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                           | 0.363 k allocs: 27.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                           | 0.0427 M allocs: 2.26 MB  |                            |
| time_to_load                                                                                | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

