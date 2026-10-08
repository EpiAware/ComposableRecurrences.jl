|                                                                                             | v0.1.0              | d117c956f25586...   | v0.1.0 / d117c956f25586... |
|:--------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0688 ± 0.0055 ms  | 0.065 ± 0.0067 ms   | 1.06 ± 0.14                |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 29.8 ± 0.57 μs      | 30.4 ± 1.2 μs       | 0.981 ± 0.042              |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 9.3 ± 1.6 μs        | 4.38 ± 1.7 μs       | 2.12 ± 0.91                |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.236 ± 0.039 ms    | 0.171 ± 0.055 ms    | 1.38 ± 0.5                 |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.052 ± 0.0025 ms   | 0.041 ± 0.0068 ms   | 1.27 ± 0.22                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                     | 0.245 ± 0.0088 ms   | 0.25 ± 0.02 ms      | 0.981 ± 0.088              |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                     | 0.0413 ± 0.00086 ms | 0.0339 ± 0.00078 ms | 1.22 ± 0.038               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                        | 0.0341 ± 0.0016 ms  | 0.0348 ± 0.0014 ms  | 0.981 ± 0.061              |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                   | 0.9 ± 0.24 ms       | 0.932 ± 0.023 ms    | 0.965 ± 0.25               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                   | 0.0637 ± 0.0018 ms  | 0.0425 ± 0.0021 ms  | 1.5 ± 0.084                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.329 ± 0.015 ms    | 0.334 ± 0.018 ms    | 0.986 ± 0.07               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.0368 ± 0.0014 ms  | 0.0336 ± 0.00083 ms | 1.09 ± 0.048               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.0373 ± 0.0025 ms  | 0.0444 ± 0.0035 ms  | 0.839 ± 0.087              |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.968 ± 0.086 ms    | 1.11 ± 0.033 ms     | 0.874 ± 0.082              |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.0692 ± 0.0043 ms  | 0.0436 ± 0.0012 ms  | 1.59 ± 0.11                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.621 ± 0.032 ms    | 0.637 ± 0.041 ms    | 0.976 ± 0.08               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 30.3 ± 1.1 μs       | 27.2 ± 0.81 μs      | 1.11 ± 0.052               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0791 ± 0.0061 ms  | 0.0769 ± 0.006 ms   | 1.03 ± 0.11                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.83 ± 0.32 ms      | 1.64 ± 0.43 ms      | 1.12 ± 0.35                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.0567 ± 0.0038 ms  | 0.0373 ± 0.0029 ms  | 1.52 ± 0.16                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.319 ± 0.017 ms    | 0.711 ± 0.42 ms     | 0.448 ± 0.27               |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.361 ± 0.29 ms     | 0.642 ± 0.3 ms      | 0.563 ± 0.53               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 7.72 ± 4.7 ms       | 11.9 ± 4.4 ms       | 0.651 ± 0.46               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 0.0353 ± 0.00047 s  | 0.0494 ± 0.012 s    | 0.714 ± 0.18               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 1.43 ± 0.039 ms     | 0.276 ± 0.014 ms    | 5.18 ± 0.3                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0577 ± 0.02 s     | 26.2 ± 18 ms        | 2.2 ± 1.7                  |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 1.22 ± 0.016 ms     | 0.352 ± 0.017 ms    | 3.46 ± 0.18                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 29 ± 12 μs          | 12.1 ± 7.1 μs       | 2.4 ± 1.7                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.395 ± 0.013 ms    | 0.37 ± 0.71 ms      | 1.07 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.059 ± 0.0045 ms   | 17.3 ± 2.6 μs       | 3.42 ± 0.57                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.059 ± 0.013 ms    | 0.0397 ± 0.0075 ms  | 1.49 ± 0.43                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.441 ± 0.014 ms    | 0.411 ± 0.035 ms    | 1.07 ± 0.097               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.109 ± 0.011 ms    | 0.0577 ± 0.0031 ms  | 1.89 ± 0.22                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.688 ± 0.021 ms    | 0.0858 ± 0.0026 ms  | 8.03 ± 0.34                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 18.8 ± 0.69 ms      | 15 ± 8.5 ms         | 1.25 ± 0.71                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.617 ± 0.06 ms     | 0.107 ± 0.0035 ms   | 5.79 ± 0.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0869 ± 0.016 ms   | 0.0552 ± 0.0096 ms  | 1.57 ± 0.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 2.69 ± 0.028 ms     | 1.33 ± 0.64 ms      | 2.02 ± 0.96                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.149 ± 0.028 ms    | 0.082 ± 0.0039 ms   | 1.82 ± 0.35                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.89 ± 0.058 ms     | 0.578 ± 0.07 ms     | 1.54 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 0.069 ± 0.0034 s    | 0.0413 ± 0.018 s    | 1.67 ± 0.74                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.864 ± 0.028 ms    | 0.261 ± 0.014 ms    | 3.3 ± 0.21                 |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                          | 1.06 ± 0.025 ms     | 0.905 ± 0.098 ms    | 1.17 ± 0.13                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                          | 0.142 ± 0.0073 ms   | 0.0944 ± 0.0028 ms  | 1.5 ± 0.089                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                             | 0.114 ± 0.0085 ms   | 0.135 ± 0.016 ms    | 0.847 ± 0.12               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                        | 3.39 ± 0.11 ms      | 3.57 ± 0.15 ms      | 0.95 ± 0.051               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                        | 0.175 ± 0.0097 ms   | 0.132 ± 0.0072 ms   | 1.33 ± 0.1                 |
| AD gradients/Recurrence in Float32/Enzyme forward                                           | 0.253 ± 0.034 ms    | 0.22 ± 0.022 ms     | 1.15 ± 0.2                 |
| AD gradients/Recurrence in Float32/Enzyme reverse                                           | 0.0552 ± 0.004 ms   | 0.0453 ± 0.0028 ms  | 1.22 ± 0.12                |
| AD gradients/Recurrence in Float32/ForwardDiff                                              | 0.0494 ± 0.009 ms   | 0.0409 ± 0.0036 ms  | 1.21 ± 0.24                |
| AD gradients/Recurrence in Float32/Mooncake forward                                         | 0.92 ± 0.06 ms      | 0.707 ± 0.04 ms     | 1.3 ± 0.11                 |
| AD gradients/Recurrence in Float32/Mooncake reverse                                         | 0.087 ± 0.0049 ms   | 0.0655 ± 0.004 ms   | 1.33 ± 0.11                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.393 ± 0.077 ms    | 0.421 ± 0.057 ms    | 0.934 ± 0.22               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.078 ± 0.0066 ms   | 0.0415 ± 0.0012 ms  | 1.88 ± 0.17                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0743 ± 0.017 ms   | 0.0897 ± 0.0047 ms  | 0.828 ± 0.19               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 1.36 ± 0.026 ms     | 1.7 ± 0.024 ms      | 0.804 ± 0.019              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0883 ± 0.0034 ms  | 0.056 ± 0.0018 ms   | 1.58 ± 0.08                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.371 ± 0.024 ms    | 0.317 ± 0.041 ms    | 1.17 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.056 ± 0.0048 ms   | 0.0498 ± 0.0014 ms  | 1.12 ± 0.1                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0669 ± 0.011 ms   | 0.0518 ± 0.0037 ms  | 1.29 ± 0.23                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 1.36 ± 0.22 ms      | 1.1 ± 0.029 ms      | 1.24 ± 0.21                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0919 ± 0.004 ms   | 0.0697 ± 0.003 ms   | 1.32 ± 0.08                |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0708 ± 0.0015 ms  | 0.0672 ± 0.0023 ms  | 1.05 ± 0.042               |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.0389 ± 0.003 ms   | 0.0403 ± 0.0035 ms  | 0.965 ± 0.11               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 13 ± 1.9 μs         | 11 ± 3.4 μs         | 1.19 ± 0.4                 |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.235 ± 0.018 ms    | 0.204 ± 0.021 ms    | 1.15 ± 0.15                |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.0714 ± 0.0043 ms  | 0.0544 ± 0.0039 ms  | 1.31 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.441 ± 0.052 ms    | 0.29 ± 0.019 ms     | 1.52 ± 0.21                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0709 ± 0.0059 ms  | 0.0674 ± 0.0018 ms  | 1.05 ± 0.092               |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0703 ± 0.043 ms   | 0.0595 ± 0.0038 ms  | 1.18 ± 0.73                |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 1.37 ± 0.094 ms     | 1.24 ± 0.029 ms     | 1.1 ± 0.081                |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.144 ± 0.0076 ms   | 0.0943 ± 0.0027 ms  | 1.53 ± 0.092               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.143 ± 0.012 ms    | 0.132 ± 0.013 ms    | 1.08 ± 0.14                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 28.4 ± 4.2 μs       | 0.0441 ± 0.0013 ms  | 0.644 ± 0.098              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 26.7 ± 3.2 μs       | 25.3 ± 2.7 μs       | 1.06 ± 0.17                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.318 ± 0.13 ms     | 0.38 ± 0.018 ms     | 0.838 ± 0.35               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.0566 ± 0.0029 ms  | 0.0552 ± 0.0066 ms  | 1.03 ± 0.13                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.267 ± 0.04 ms     | 0.236 ± 0.03 ms     | 1.13 ± 0.22                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0771 ± 0.0045 ms  | 0.0456 ± 0.0035 ms  | 1.69 ± 0.16                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.032 ± 0.0018 ms   | 0.0361 ± 0.0035 ms  | 0.886 ± 0.1                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.798 ± 0.1 ms      | 0.878 ± 0.035 ms    | 0.909 ± 0.12               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0874 ± 0.0061 ms  | 0.0702 ± 0.0042 ms  | 1.24 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.535 ± 0.031 ms    | 0.35 ± 0.031 ms     | 1.53 ± 0.16                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0953 ± 0.0069 ms  | 0.0637 ± 0.002 ms   | 1.5 ± 0.12                 |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0685 ± 0.0037 ms  | 0.0612 ± 0.0058 ms  | 1.12 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.82 ± 0.28 ms      | 1.55 ± 0.046 ms     | 1.17 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.13 ± 0.0042 ms    | 0.0938 ± 0.0026 ms  | 1.39 ± 0.059               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 1.09 ± 0.27 ms      | 1.09 ± 0.25 ms      | 1 ± 0.33                   |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0625 ± 0.0068 ms  | 0.0533 ± 0.002 ms   | 1.17 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.13 ± 0.0084 ms    | 0.149 ± 0.011 ms    | 0.872 ± 0.084              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 3.86 ± 0.79 ms      | 4 ± 0.73 ms         | 0.966 ± 0.26               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0963 ± 0.0055 ms  | 0.0758 ± 0.01 ms    | 1.27 ± 0.18                |
| Convolution body/BLAS axpy per lag                                                          | 0.773 ± 0.0036 μs   | 0.781 ± 0.0033 μs   | 0.99 ± 0.0062              |
| Convolution body/native axpy per lag                                                        | 0.494 ± 0.0047 μs   | 0.503 ± 0.0063 μs   | 0.982 ± 0.016              |
| Convolution body/package                                                                    | 0.773 ± 0.0032 μs   | 0.369 ± 0.006 μs    | 2.09 ± 0.035               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0715 ± 0.0016 ms  | 0.0638 ± 0.0014 ms  | 1.12 ± 0.035               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 4.89 ± 0.25 μs      | 3.96 ± 0.31 μs      | 1.24 ± 0.12                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 2.69 ± 1.6 μs       | 2.06 ± 0.35 μs      | 1.3 ± 0.81                 |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.0525 ± 0.0042 ms  | 0.0442 ± 0.015 ms   | 1.19 ± 0.41                |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 9.79 ± 1.7 μs       | 9.86 ± 1.8 μs       | 0.993 ± 0.25               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.0657 ± 0.0036 ms  | 0.0393 ± 0.00077 ms | 1.67 ± 0.097               |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                     | 0.132 ± 0.0036 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                     | 0.0531 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                     | 2.73 ± 0.03 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                     | 0.0503 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                     | 0.408 ± 0.019 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                     | 0.0384 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                     | 0.0477 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                     | 1.03 ± 0.011 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                     | 1.61 ± 0.52 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                     | 0.334 ± 0.041 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                     | 2.47 ± 0.09 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                     | 0.0461 ± 0.0013 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                     | 0.966 ± 0.12 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                     | 0.0675 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                     | 0.0619 ± 0.0015 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                     | 5.06 ± 0.09 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                     | 0.0587 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                     | 1.06 ± 0.079 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                     | 0.121 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward           |                     | 0.243 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                 |                     | 0.244 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                     | 0.134 ± 0.0035 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                     | 0.0799 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                     | 0.436 ± 0.023 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                     | 0.0878 ± 0.0029 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                     | 0.244 ± 0.035 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                     | 0.0694 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                               |                     | 0.0854 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                     | 0.151 ± 0.0069 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                     | 2.74 ± 0.23 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                     | 1.44 ± 0.027 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                     | 0.0801 ± 0.0025 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                     | 0.868 ± 0.026 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                     | 1.33 ± 0.033 ms     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward         |                     | 0.867 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                     | 1.52 ± 0.061 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                     | 0.0414 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                     | 0.258 ± 0.037 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                     | 0.0493 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                     | 0.0496 ± 0.026 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                     | 0.065 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                     | 0.04 ± 0.00094 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                     | 1.16 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                     | 0.0376 ± 0.00079 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                     | 0.653 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                     | 0.0401 ± 0.0036 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                     | 0.688 ± 0.052 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                     | 1.87 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                |                     | 0.126 ± 0.0044 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                     | 0.171 ± 0.0062 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                     | 0.117 ± 0.0062 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                     | 0.0676 ± 0.0026 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                     | 0.0401 ± 0.039 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                     | 0.117 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward           |                     | 0.253 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff              |                     | 0.037 ± 0.047 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                     | 0.28 ± 0.015 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                     | 0.379 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                     | 0.103 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                     | 1.17 ± 0.036 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                     | 0.884 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                     | 4.11 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                     | 0.0385 ± 0.00086 ms |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                     | 0.08 ± 0.0027 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                     | 0.349 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                     | 0.151 ± 0.0067 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                     | 0.464 ± 0.054 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                     | 0.248 ± 0.038 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                     | 0.256 ± 0.016 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                     | 0.0534 ± 0.0014 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                     | 0.0456 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                     | 0.0793 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                     | 0.0531 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                     | 0.41 ± 0.058 ms     |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                     | 0.156 ± 0.0099 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                     | 0.124 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                     | 30.6 ± 0.74 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                     | 0.0825 ± 0.004 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                     | 1.02 ± 0.098 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                     | 0.0633 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                     | 0.62 ± 0.08 ms      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                     | 1.68 ± 0.05 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff              |                     | 0.0393 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                     | 0.0937 ± 0.0061 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                     | 0.0576 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                     | 0.0943 ± 0.0023 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                     | 3.17 ± 0.093 ms     |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                     | 1.11 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                     | 0.05 ± 0.0042 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                    |                     | 25.7 ± 23 μs        |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                     | 0.0604 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                     | 0.232 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                     | 0.035 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                     | 0.364 ± 0.017 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                     | 0.0724 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                     | 0.0585 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse         |                     | 0.0598 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                     | 0.357 ± 0.032 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                     | 0.386 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                     | 0.102 ± 0.0035 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                     | 0.258 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                     | 0.483 ± 0.048 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                 |                     | 0.0502 ± 0.0012 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                     | 0.132 ± 0.0046 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                |                     | 1.02 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                     | 0.136 ± 0.0092 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                     | 0.0602 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                     | 13.1 ± 2.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse              |                     | 0.17 ± 0.0092 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                     | 0.0545 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                     | 0.0823 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                     | 0.953 ± 0.091 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                     | 0.0344 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                     | 0.0811 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                     | 0.0861 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                     | 0.065 ± 0.0018 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                     | 0.0706 ± 0.0022 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                     | 0.899 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward              |                     | 3.72 ± 0.092 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                     | 0.867 ± 0.045 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                     | 0.101 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                     | 0.0682 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                     | 0.0803 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                               |                     | 0.893 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                     | 0.157 ± 0.012 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                     | 31.4 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                     | 0.0606 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                     | 0.0922 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                     | 0.321 ± 0.016 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                     |                     | 0.0505 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                     | 0.0841 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                     | 0.153 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                     | 1.11 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                     | 0.0455 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse         |                     | 0.0811 ± 0.002 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                     | 0.123 ± 0.008 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                     | 0.0688 ± 0.0043 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                     | 0.0424 ± 0.03 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                     | 0.366 ± 0.072 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                     | 0.173 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                     | 0.715 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                     | 0.731 ± 0.023 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                     | 0.342 ± 0.029 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                     | 2.21 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                     | 0.0543 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                     | 0.0511 ± 0.0067 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                     | 0.142 ± 0.0059 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                     | 0.0714 ± 0.0069 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                     | 1.3 ± 0.015 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse           |                     | 0.0409 ± 0.00082 ms |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                     | 0.175 ± 0.015 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                     | 0.0421 ± 0.033 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                     | 2.71 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                     | 0.118 ± 0.0066 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                     | 10.5 ± 1.5 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                     | 0.129 ± 0.0064 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                     | 0.0511 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                     | 0.069 ± 0.0014 ms   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                     | 0.334 ± 0.17 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                     | 0.0649 ± 0.0023 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                     | 0.0479 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                     | 0.0898 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                     | 0.0622 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                     | 10.9 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                     | 0.0932 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                     | 0.0712 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                     | 0.0772 ± 0.0061 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                     | 1.01 ± 0.08 ms      |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                     | 0.264 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                     | 0.0618 ± 0.038 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                     | 0.496 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                     | 0.116 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                     | 0.109 ± 0.0038 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                     | 0.765 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                     | 0.0581 ± 0.0036 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                     | 0.035 ± 0.00091 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                     | 1.32 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                     | 0.0834 ± 0.0027 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                     | 0.0682 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                     | 1.56 ± 0.032 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                     | 0.757 ± 0.066 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                     | 0.0516 ± 0.003 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                     | 1.15 ± 0.073 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                     | 0.0341 ± 0.0031 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                     | 0.0629 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                     | 0.351 ± 0.065 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                     | 0.0524 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                     | 0.0765 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                     | 0.106 ± 0.0068 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                     | 0.0359 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                     | 1.2 ± 0.063 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                     | 0.119 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                     | 0.0345 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                     | 0.14 ± 0.0071 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                     | 0.119 ± 0.0087 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                     | 0.0713 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                     | 1.55 ± 0.064 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                     | 1.32 ± 0.041 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                     | 1.32 ± 0.038 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                     | 5.14 ± 0.091 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                     | 0.395 ± 0.052 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                     | 0.0731 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                     | 0.116 ± 0.0047 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                     | 11 ± 1 μs           |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                     | 3.02 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                   |                     | 0.114 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                     | 0.0658 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                     | 28.6 ± 3.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                     | 1.23 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                     | 0.032 ± 0.001 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                     | 3.67 ± 0.11 ms      |                            |
| time_to_load                                                                                | 0.24 ± 0.0025 s     | 0.351 ± 0.0025 s    | 0.684 ± 0.0087             |

|                                                                                             | v0.1.0                    | d117c956f25586...         | v0.1.0 / d117c956f25586... |
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
| Convolution body/BLAS axpy per lag                                                          | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                                        | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                                    | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
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
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.991 k allocs: 0.231 MB  |                            |
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
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                           | 0.227 k allocs: 0.0997 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.56 k allocs: 0.291 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                           | 0.26 k allocs: 17 kB      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 1.17 k allocs: 0.21 MB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.19 k allocs: 0.565 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                           | 0.225 k allocs: 15.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                           | 0.77 k allocs: 0.298 MB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                           | 0.514 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse           |                           | 0.214 k allocs: 15.1 kB   |                            |
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
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                           | 0.39 k allocs: 0.0646 MB  |                            |
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
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                           | 0.067 k allocs: 0.0331 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                           | 0.341 k allocs: 19.6 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                           | 4.89 k allocs: 0.382 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                           | 0.452 k allocs: 0.145 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                           | 0.562 k allocs: 23.7 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                           | 1.13 k allocs: 0.0395 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                           | 0.251 k allocs: 17 kB     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                           | 18.2 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                           | 0.466 k allocs: 0.188 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                           | 0.157 k allocs: 7.34 kB   |                            |
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

