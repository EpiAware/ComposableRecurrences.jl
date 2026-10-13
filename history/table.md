|                                                                                                          | v0.1.0             | 61637c460ff92d...   | v0.1.0 / 61637c460ff92d... |
|:---------------------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                               | 0.0546 ± 0.004 ms  | 0.0547 ± 0.0057 ms  | 1 ± 0.13                   |
| AD gradients/Convolution delay with history/Enzyme reverse                                               | 24.1 ± 0.61 μs     | 22.5 ± 0.62 μs      | 1.07 ± 0.04                |
| AD gradients/Convolution delay with history/ForwardDiff                                                  | 8.63 ± 1.5 μs      | 6.18 ± 1.7 μs       | 1.4 ± 0.45                 |
| AD gradients/Convolution delay with history/Mooncake forward                                             | 0.191 ± 0.029 ms   | 0.193 ± 0.0064 ms   | 0.99 ± 0.16                |
| AD gradients/Convolution delay with history/Mooncake reverse                                             | 0.0355 ± 0.0011 ms | 27.9 ± 0.75 μs      | 1.27 ± 0.053               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                                  | 0.209 ± 0.015 ms   | 0.209 ± 0.016 ms    | 0.998 ± 0.1                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                                  | 0.0326 ± 0.0011 ms | 24.8 ± 0.72 μs      | 1.32 ± 0.059               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                                     | 0.0363 ± 0.0082 ms | 30.7 ± 2.5 μs       | 1.18 ± 0.28                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                                | 0.806 ± 0.044 ms   | 0.705 ± 0.01 ms     | 1.14 ± 0.064               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                                | 0.0438 ± 0.0021 ms | 29.9 ± 0.87 μs      | 1.46 ± 0.081               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                            | 0.282 ± 0.009 ms   | 0.29 ± 0.02 ms      | 0.973 ± 0.075              |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                            | 28 ± 0.91 μs       | 27.2 ± 0.82 μs      | 1.03 ± 0.046               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                               | 0.0482 ± 0.016 ms  | 0.046 ± 0.0032 ms   | 1.05 ± 0.36                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                          | 1 ± 0.019 ms       | 0.85 ± 0.035 ms     | 1.18 ± 0.053               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                          | 0.0428 ± 0.0027 ms | 31 ± 0.87 μs        | 1.38 ± 0.096               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                              | 0.535 ± 0.071 ms   | 0.485 ± 0.017 ms    | 1.1 ± 0.15                 |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                              | 23.9 ± 1.3 μs      | 20.4 ± 0.92 μs      | 1.17 ± 0.084               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                                 | 0.0828 ± 0.0058 ms | 0.0737 ± 0.07 ms    | 1.12 ± 1.1                 |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                            | 1.55 ± 0.17 ms     | 1.07 ± 0.44 ms      | 1.45 ± 0.62                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                            | 0.0351 ± 0.0011 ms | 25 ± 1.6 μs         | 1.4 ± 0.1                  |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                              | 0.372 ± 0.02 ms    | 0.413 ± 0.38 ms     | 0.901 ± 0.82               |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                             | 0.448 ± 0.25 ms    | 0.421 ± 0.25 ms     | 1.07 ± 0.88                |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                                | 13 ± 3.8 ms        | 9.39 ± 0.05 ms      | 1.38 ± 0.41                |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                           | 0.0435 ± 0.013 s   | 0.0318 ± 0.00011 s  | 1.37 ± 0.4                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                                 | 1.3 ± 0.093 ms     | 0.236 ± 0.045 ms    | 5.49 ± 1.1                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                                    | 0.0583 ± 0.0035 s  | 0.0336 ± 0.0045 s   | 1.73 ± 0.25                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 0.949 ± 0.064 ms   | 0.25 ± 0.0095 ms    | 3.8 ± 0.29                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 29.1 ± 3.2 μs      | 8.68 ± 5.1 μs       | 3.35 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 1.94 ± 0.079 ms    | 0.359 ± 0.38 ms     | 5.4 ± 5.7                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.0538 ± 0.0033 ms | 15 ± 2.3 μs         | 3.59 ± 0.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.0528 ± 0.0057 ms | 29.8 ± 5.2 μs       | 1.77 ± 0.36                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 1.47 ± 0.017 ms    | 0.465 ± 0.25 ms     | 3.17 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.0835 ± 0.0043 ms | 0.0415 ± 0.0028 ms  | 2.01 ± 0.17                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 0.519 ± 0.063 ms   | 0.0575 ± 0.027 ms   | 9.02 ± 4.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 27.2 ± 5.9 ms      | 11.6 ± 4 ms         | 2.34 ± 0.95                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 0.489 ± 0.016 ms   | 0.0788 ± 0.0019 ms  | 6.2 ± 0.25                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.0618 ± 0.012 ms  | 0.0465 ± 0.0056 ms  | 1.33 ± 0.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 2 ± 0.58 ms        | 1 ± 0.53 ms         | 2 ± 1.2                    |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 0.113 ± 0.012 ms   | 0.0593 ± 0.014 ms   | 1.91 ± 0.49                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 0.741 ± 0.042 ms   | 0.117 ± 0.014 ms    | 6.31 ± 0.85                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 0.0396 ± 0.013 s   | 0.0394 ± 0.00022 s  | 1 ± 0.32                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 0.647 ± 0.026 ms   | 0.176 ± 0.0053 ms   | 3.67 ± 0.18                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 0.884 ± 0.024 ms   | 0.807 ± 0.069 ms    | 1.1 ± 0.098                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.104 ± 0.009 ms   | 0.0632 ± 0.0018 ms  | 1.65 ± 0.15                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.109 ± 0.011 ms   | 0.132 ± 0.067 ms    | 0.826 ± 0.43               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 2.24 ± 0.23 ms     | 2.43 ± 0.16 ms      | 0.923 ± 0.11               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 0.116 ± 0.0033 ms  | 0.0952 ± 0.011 ms   | 1.22 ± 0.14                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 0.0881 ± 0.0049 ms | 0.0725 ± 0.011 ms   | 1.22 ± 0.2                 |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 10.9 ± 1.9 μs      | 4.52 ± 0.65 μs      | 2.41 ± 0.54                |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 30.7 ± 5.7 μs      | 22.2 ± 2.4 μs       | 1.38 ± 0.3                 |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 0.55 ± 0.037 ms    | 0.321 ± 0.089 ms    | 1.71 ± 0.49                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 28.7 ± 1.6 μs      | 16.6 ± 2.2 μs       | 1.72 ± 0.25                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme forward                     | 0.35 ± 0.019 ms    | 0.249 ± 0.017 ms    | 1.4 ± 0.12                 |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme reverse                     | 0.0634 ± 0.005 ms  | 0.0442 ± 0.0026 ms  | 1.44 ± 0.14                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/ForwardDiff                        | 0.0668 ± 0.0049 ms | 0.0633 ± 0.0037 ms  | 1.05 ± 0.1                 |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake forward                   | 1.19 ± 0.027 ms    | 1.1 ± 0.067 ms      | 1.07 ± 0.07                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake reverse                   | 0.0922 ± 0.005 ms  | 0.0672 ± 0.0036 ms  | 1.37 ± 0.1                 |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward             | 0.336 ± 0.023 ms   | 0.264 ± 0.028 ms    | 1.27 ± 0.16                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse             | 0.0528 ± 0.004 ms  | 0.0424 ± 0.0025 ms  | 1.25 ± 0.12                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff                | 0.0696 ± 0.0087 ms | 0.0542 ± 0.0031 ms  | 1.28 ± 0.18                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward           | 0.96 ± 0.12 ms     | 0.956 ± 0.01 ms     | 1 ± 0.12                   |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse           | 0.0821 ± 0.0037 ms | 0.0642 ± 0.0031 ms  | 1.28 ± 0.084               |
| AD gradients/Recurrence in Float32/Enzyme forward                                                        | 0.199 ± 0.016 ms   | 0.185 ± 0.014 ms    | 1.08 ± 0.12                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                        | 0.0405 ± 0.0026 ms | 0.0345 ± 0.003 ms   | 1.17 ± 0.13                |
| AD gradients/Recurrence in Float32/ForwardDiff                                                           | 26.7 ± 21 μs       | 0.0447 ± 0.0041 ms  | 0.596 ± 0.46               |
| AD gradients/Recurrence in Float32/Mooncake forward                                                      | 0.69 ± 0.05 ms     | 0.543 ± 0.018 ms    | 1.27 ± 0.1                 |
| AD gradients/Recurrence in Float32/Mooncake reverse                                                      | 0.0555 ± 0.0029 ms | 0.0479 ± 0.0057 ms  | 1.16 ± 0.15                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                                   | 0.326 ± 0.032 ms   | 0.337 ± 0.025 ms    | 0.969 ± 0.12               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.0649 ± 0.0064 ms | 30.6 ± 1.1 μs       | 2.12 ± 0.22                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.0655 ± 0.0077 ms | 0.0756 ± 0.0044 ms  | 0.867 ± 0.11               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 1.1 ± 0.012 ms     | 1.37 ± 0.07 ms      | 0.807 ± 0.042              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.0558 ± 0.0025 ms | 0.0398 ± 0.0027 ms  | 1.4 ± 0.11                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 0.32 ± 0.024 ms    | 0.247 ± 0.019 ms    | 1.3 ± 0.14                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.0416 ± 0.003 ms  | 0.0383 ± 0.005 ms   | 1.09 ± 0.16                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.0856 ± 0.037 ms  | 0.0488 ± 0.0042 ms  | 1.75 ± 0.78                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 0.911 ± 0.022 ms   | 0.89 ± 0.035 ms     | 1.02 ± 0.048               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 0.0601 ± 0.002 ms  | 0.0475 ± 0.0048 ms  | 1.26 ± 0.13                |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.0564 ± 0.0019 ms | 0.0602 ± 0.0041 ms  | 0.938 ± 0.071              |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 29.8 ± 3.6 μs      | 29 ± 2.2 μs         | 1.03 ± 0.15                |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 10.9 ± 2.9 μs      | 0.0534 ± 0.0032 ms  | 0.204 ± 0.055              |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 0.175 ± 0.019 ms   | 0.172 ± 0.0089 ms   | 1.02 ± 0.12                |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.0488 ± 0.0037 ms | 0.0347 ± 0.0024 ms  | 1.41 ± 0.14                |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 0.272 ± 0.023 ms   | 0.264 ± 0.02 ms     | 1.03 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.0502 ± 0.0034 ms | 0.0866 ± 0.0028 ms  | 0.58 ± 0.043               |
| AD gradients/Recurrence returning its state/ForwardDiff                                                  | 0.0537 ± 0.0074 ms | 0.0684 ± 0.0032 ms  | 0.785 ± 0.11               |
| AD gradients/Recurrence returning its state/Mooncake forward                                             | 1.22 ± 0.033 ms    | 0.899 ± 0.023 ms    | 1.36 ± 0.051               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                             | 0.0757 ± 0.0023 ms | 0.108 ± 0.0048 ms   | 0.699 ± 0.037              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                              | 0.116 ± 0.0078 ms  | 0.108 ± 0.0087 ms   | 1.07 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                              | 21.7 ± 0.78 μs     | 29 ± 1.3 μs         | 0.751 ± 0.043              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                                 | 26.8 ± 1.6 μs      | 24.6 ± 2.5 μs       | 1.09 ± 0.13                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                            | 0.348 ± 0.11 ms    | 0.302 ± 0.021 ms    | 1.15 ± 0.37                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                            | 0.0338 ± 0.002 ms  | 0.039 ± 0.0043 ms   | 0.868 ± 0.11               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                                   | 0.23 ± 0.037 ms    | 0.216 ± 0.029 ms    | 1.06 ± 0.23                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                                   | 0.0526 ± 0.0026 ms | 0.0319 ± 0.0024 ms  | 1.65 ± 0.15                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                                      | 0.0323 ± 0.0022 ms | 0.0328 ± 0.0028 ms  | 0.986 ± 0.11               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                                 | 0.674 ± 0.12 ms    | 0.649 ± 0.012 ms    | 1.04 ± 0.19                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                                 | 0.0595 ± 0.0062 ms | 0.0457 ± 0.0032 ms  | 1.3 ± 0.16                 |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 0.341 ± 0.022 ms   | 0.284 ± 0.01 ms     | 1.2 ± 0.089                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.0618 ± 0.0034 ms | 0.043 ± 0.0033 ms   | 1.44 ± 0.14                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.0613 ± 0.0092 ms | 0.0547 ± 0.0038 ms  | 1.12 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 1.22 ± 0.13 ms     | 1.12 ± 0.038 ms     | 1.09 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 0.0861 ± 0.0022 ms | 0.0666 ± 0.005 ms   | 1.29 ± 0.1                 |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                                  | 0.834 ± 0.27 ms    | 1.1 ± 0.13 ms       | 0.759 ± 0.26               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                                  | 0.0467 ± 0.002 ms  | 0.0371 ± 0.0012 ms  | 1.26 ± 0.068               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                                     | 0.128 ± 0.0066 ms  | 0.139 ± 0.02 ms     | 0.924 ± 0.14               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                                | 3.12 ± 0.69 ms     | 3.11 ± 0.59 ms      | 1 ± 0.29                   |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                                | 0.0643 ± 0.0065 ms | 0.0508 ± 0.004 ms   | 1.26 ± 0.16                |
| Convolution body/BLAS axpy per lag                                                                       | 0.721 ± 0.0055 μs  | 0.716 ± 0.0063 μs   | 1.01 ± 0.012               |
| Convolution body/native axpy per lag                                                                     | 0.426 ± 0.0079 μs  | 0.422 ± 0.0092 μs   | 1.01 ± 0.029               |
| Convolution body/package                                                                                 | 0.719 ± 0.0055 μs  | 0.328 ± 0.0077 μs   | 2.2 ± 0.054                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                                  | 0.0541 ± 0.001 ms  | 0.0421 ± 0.00083 ms | 1.28 ± 0.035               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                                 | 3.94 ± 0.21 μs     | 3.89 ± 0.39 μs      | 1.01 ± 0.12                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                                | 2.71 ± 1.5 μs      | 2.03 ± 0.37 μs      | 1.33 ± 0.76                |
| Evaluation/Matrix overview T200_L20_S3                                                                   | 0.0457 ± 0.0035 ms | 20.9 ± 1.6 μs       | 2.19 ± 0.24                |
| Evaluation/Matrix renewal T200_L20_S1                                                                    | 8.06 ± 1.8 μs      | 8.81 ± 1.8 μs       | 0.915 ± 0.28               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                              | 0.0399 ± 0.0048 ms | 27.4 ± 0.74 μs      | 1.46 ± 0.18                |
| AD gradients/Recurrence removals from recent outputs/Enzyme reverse                                      |                    | 0.037 ± 0.0031 ms   |                            |
| Convolution methods/S 1 T 2000 L 32/FFT forward                                                          |                    | 21.2 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                           |                    | 0.0857 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse                   |                    | 0.0383 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/ForwardDiff                              |                    | 0.0429 ± 0.0076 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward                     |                    | 1.87 ± 0.064 ms     |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake forward                     |                    | 4.43 ± 0.25 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                  |                    | 29.5 ± 0.89 μs      |                            |
| Convolution methods/S 1 T 200 L 64/FFT Mooncake gradient                                                 |                    | 22.5 ± 3.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward   |                    | 0.261 ± 0.032 ms    |                            |
| Convolution methods/S 1 T 300 L 60/FFT forward                                                           |                    | 7.31 ± 0.48 μs      |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme reverse                              |                    | 0.0504 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                                      |                    | 0.352 ± 0.014 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                                   |                    | 0.0691 ± 0.0092 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff                     |                    | 0.0435 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake forward                        |                    | 0.894 ± 0.059 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward                      |                    | 0.318 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                                 |                    | 0.69 ± 0.0089 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse        |                    | 13.8 ± 0.48 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                              |                    | 1.46 ± 0.019 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                                     |                    | 0.246 ± 0.013 ms    |                            |
| Convolution methods/S 1 T 200 L 64/Direct forward                                                        |                    | 3.06 ± 0.59 μs      |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake reverse                                       |                    | 0.0755 ± 0.012 ms   |                            |
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                    | 6.99 ± 0.97 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                    | 2.08 ± 0.12 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                       |                    | 0.0339 ± 0.00084 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                              |                    | 0.868 ± 0.26 ms     |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                              |                    | 0.0466 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse               |                    | 0.0678 ± 0.0037 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake forward                         |                    | 0.946 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward |                    | 0.929 ± 0.016 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                        |                    | 3.36 ± 0.034 ms     |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake forward                            |                    | 1.46 ± 0.084 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                    | 0.038 ± 0.0025 ms   |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                    | 0.0702 ± 0.0051 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/ForwardDiff                                 |                    | 0.0748 ± 0.0056 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme reverse                          |                    | 0.0414 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff      |                    | 0.053 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                        |                    | 0.986 ± 0.053 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                          |                    | 0.124 ± 0.0053 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake forward                                  |                    | 0.896 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                        |                    | 0.208 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse |                    | 0.0749 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                              |                    | 0.193 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme forward                 |                    | 0.249 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake reverse         |                    | 0.0825 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                    | 0.0861 ± 0.0021 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                    | 0.0503 ± 0.00099 ms |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                    | 0.575 ± 0.071 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                    | 3.06 ± 0.31 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                    | 0.371 ± 0.012 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                    | 0.0597 ± 0.0056 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                    | 0.205 ± 0.019 ms    |                            |
| AD gradients/Recurrence protected pool in Float32/ForwardDiff                                            |                    | 0.104 ± 0.0052 ms   |                            |
| AD gradients/Recurrence removals from recent outputs/ForwardDiff                                         |                    | 0.0507 ± 0.0032 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct forward                                                      |                    | 0.0326 ± 0.0027 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                                |                    | 0.045 ± 0.0011 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                            |                    | 0.0519 ± 0.0023 ms  |                            |
| Convolution methods/S 50 T 200 L 64/Direct forward                                                       |                    | 0.0769 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                                |                    | 0.143 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme reverse                           |                    | 0.0336 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                                    |                    | 1.46 ± 0.25 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                                   |                    | 1.01 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward            |                    | 1.87 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake reverse                             |                    | 0.0999 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                                 |                    | 0.0519 ± 0.0012 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                                |                    | 0.625 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme reverse                 |                    | 0.0462 ± 0.0012 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                           |                    | 0.919 ± 0.067 ms    |                            |
| Convolution methods/S 1 T 2000 L 32/Direct forward                                                       |                    | 8.2 ± 1 μs          |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward                      |                    | 0.707 ± 0.029 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                       |                    | 1.29 ± 0.047 ms     |                            |
| Convolution methods/S 1 T 300 L 60/Direct forward                                                        |                    | 2.49 ± 0.46 μs      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward                    |                    | 1.51 ± 0.35 μs      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                              |                    | 0.905 ± 0.093 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                         |                    | 27.4 ± 1.6 μs       |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                          |                    | 0.473 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/ForwardDiff                    |                    | 0.056 ± 0.0038 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                                 |                    | 0.209 ± 0.045 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                                |                    | 0.0362 ± 0.00097 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                       |                    | 23 ± 13 μs          |                            |
| Convolution methods/S 1 T 300 L 60/Direct Mooncake gradient                                              |                    | 13.3 ± 0.77 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                        |                    | 0.0576 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse                 |                    | 0.0622 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse                    |                    | 0.0843 ± 0.017 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                              |                    | 0.92 ± 0.056 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse                  |                    | 29.1 ± 0.77 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                                    |                    | 0.509 ± 0.056 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                                 |                    | 31.5 ± 3.2 μs       |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                             |                    | 0.0689 ± 0.0097 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme reverse                                 |                    | 0.0857 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                         |                    | 0.0497 ± 0.0038 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                    | 0.53 ± 0.025 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                    | 1.46 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                    | 0.0871 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                    | 0.232 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                    | 0.129 ± 0.0041 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                    | 0.0379 ± 0.0012 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                    | 0.0733 ± 0.0021 ms  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                    | 3.83 ± 0.25 ms      |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                    | 0.0474 ± 0.003 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                    | 0.0319 ± 0.0046 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                    | 0.0677 ± 0.0019 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                    | 0.0841 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                    | 0.0451 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                    | 0.195 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                    | 28.5 ± 2.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                    | 0.0805 ± 0.004 ms   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                    | 3.25 ± 0.54 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                    | 0.22 ± 0.015 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                    | 0.345 ± 0.043 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                    | 0.069 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                    | 0.0529 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                    | 0.828 ± 0.093 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                    | 0.794 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                    | 3.08 ± 0.17 ms      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                    | 14 ± 0.69 μs        |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                    | 29.8 ± 0.85 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                    | 0.0523 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                    | 0.315 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                    | 0.0933 ± 0.0025 ms  |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                    | 0.521 ± 0.13 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                    | 0.377 ± 0.026 ms    |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                    | 12.8 ± 1.4 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                    | 0.232 ± 0.014 ms    |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                    | 1.41 ± 0.12 ms      |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                    | 0.0583 ± 0.0017 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                           |                    | 0.204 ± 0.02 ms     |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/ForwardDiff                              |                    | 0.0547 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake reverse                     |                    | 0.14 ± 0.0086 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                                |                    | 0.202 ± 0.0072 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                             |                    | 0.0368 ± 0.00092 ms |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                                   |                    | 0.0514 ± 0.0067 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                       |                    | 0.0521 ± 0.002 ms   |                            |
| Convolution methods/S 1 T 200 L 32/FFT Mooncake gradient                                                 |                    | 23.9 ± 3.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme reverse                    |                    | 0.0597 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                             |                    | 0.0403 ± 0.0012 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                              |                    | 0.0456 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                         |                    | 0.33 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake reverse                          |                    | 0.0864 ± 0.0068 ms  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme forward                               |                    | 0.528 ± 0.03 ms     |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                    | 0.159 ± 0.0068 ms   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                    | 0.0711 ± 0.0071 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                    | 0.0941 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                    | 24.3 ± 0.87 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                    | 0.0763 ± 0.039 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                    | 0.821 ± 0.035 ms    |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                    | 26.8 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                    | 0.0487 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                    | 0.0763 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                    | 0.555 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                    | 1.3 ± 0.061 ms      |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                    | 0.0493 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                    | 1.5 ± 0.35 μs       |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                    | 0.0341 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                    | 0.0828 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                    | 0.0362 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                    | 0.0699 ± 0.0056 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                    | 0.06 ± 0.0016 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                    | 2.4 ± 0.076 ms      |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                    | 1.41 ± 0.039 ms     |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                    | 0.91 ± 0.085 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                    | 0.051 ± 0.0043 ms   |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                    | 0.252 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                    | 0.0448 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                    | 0.0443 ± 0.0013 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                    | 0.0762 ± 0.0059 ms  |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme forward                                         |                    | 0.481 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme reverse                  |                    | 8.13 ± 1.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward                      |                    | 0.215 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                            |                    | 31.2 ± 8.2 μs       |                            |
| Convolution methods/S 1 T 300 L 60/FFT Mooncake gradient                                                 |                    | 25.6 ± 1.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme reverse                            |                    | 0.0735 ± 0.0063 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                        |                    | 0.224 ± 0.085 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/ForwardDiff                             |                    | 0.0453 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake forward         |                    | 1.03 ± 0.062 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                            |                    | 0.109 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                      |                    | 0.0608 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse                      |                    | 0.0488 ± 0.0083 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                          |                    | 0.289 ± 0.011 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                                |                    | 0.326 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                         |                    | 0.0422 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake reverse                          |                    | 0.078 ± 0.0061 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/ForwardDiff              |                    | 0.0617 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                               |                    | 0.165 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                                |                    | 0.456 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                                   |                    | 0.309 ± 0.017 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward                  |                    | 15.9 ± 1.8 μs       |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake forward                                    |                    | 1.16 ± 0.038 ms     |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                              |                    | 0.0409 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward              |                    | 0.656 ± 0.049 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                         |                    | 0.0813 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                              |                    | 0.0976 ± 0.0066 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake forward                          |                    | 1.12 ± 0.019 ms     |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward                 |                    | 0.235 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                             |                    | 0.922 ± 0.13 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward                    |                    | 0.125 ± 0.0067 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff                 |                    | 0.0911 ± 0.0045 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake forward                               |                    | 4.19 ± 0.98 ms      |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse            |                    | 0.0943 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse                      |                    | 0.0591 ± 0.0094 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse                |                    | 0.0393 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                                    |                    | 11.6 ± 1.9 μs       |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme forward                                     |                    | 0.194 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme forward                          |                    | 0.237 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                           |                    | 0.112 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                         |                    | 0.0411 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                           |                    | 0.0544 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                             |                    | 0.817 ± 0.016 ms    |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff                    |                    | 0.0683 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                                    |                    | 0.037 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff             |                    | 1.21 ± 0.28 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                                 |                    | 0.0599 ± 0.048 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake forward               |                    | 0.964 ± 0.046 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse                |                    | 0.0602 ± 0.0024 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/Direct Mooncake gradient                                             |                    | 0.0656 ± 0.00083 ms |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                    | 0.06 ± 0.0016 ms    |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                    | 1.95 ± 1.7 ms       |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                    | 0.0637 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                    | 0.0525 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                    | 21.6 ± 2.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                    | 0.0552 ± 0.0043 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                    | 0.831 ± 0.1 ms      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                    | 0.293 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                    | 0.0676 ± 0.0035 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                    | 0.101 ± 0.005 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                    | 0.38 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                    | 0.99 ± 0.045 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                    | 0.081 ± 0.0023 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                    | 0.0428 ± 0.0041 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                    | 0.166 ± 0.062 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                    | 2.43 ± 0.14 ms      |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                    | 1.3 ± 0.037 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                    | 0.631 ± 0.011 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                    | 0.0586 ± 0.0013 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                    | 1.32 ± 0.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                    | 0.0456 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme reverse                               |                    | 0.0835 ± 0.0074 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                    | 1.12 ± 0.019 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                    | 1.13 ± 0.083 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                    | 0.0616 ± 0.0043 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                    | 0.434 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                    | 0.683 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                    | 0.156 ± 0.068 ms    |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/ForwardDiff                                  |                    | 0.105 ± 0.0044 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                    | 27.3 ± 1.1 μs       |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                    | 0.0431 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                    | 0.0619 ± 0.0035 ms  |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                    | 0.0583 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                    | 1.25 ± 0.053 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                    | 0.278 ± 0.033 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                    | 0.0391 ± 0.0037 ms  |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme reverse                                         |                    | 0.0484 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                               |                    | 0.0719 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme forward                  |                    | 0.0628 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake forward                         |                    | 0.695 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                                |                    | 0.15 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward                |                    | 0.887 ± 0.081 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                         |                    | 0.0459 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse                      |                    | 0.0551 ± 0.003 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                           |                    | 0.0802 ± 0.0074 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                              |                    | 1.61 ± 0.056 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                        |                    | 0.08 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward                  |                    | 1.09 ± 0.07 ms      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                                |                    | 0.0515 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                                     |                    | 0.0573 ± 0.0045 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme forward                           |                    | 0.267 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward                  |                    | 0.222 ± 0.1 ms      |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake forward                                       |                    | 1.9 ± 0.15 ms       |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                                     |                    | 0.0362 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                                      |                    | 0.0443 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                                      |                    | 0.56 ± 0.011 ms     |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake forward                                   |                    | 0.671 ± 0.012 ms    |                            |
| Convolution methods/S 1 T 20000 L 500/FFT Mooncake gradient                                              |                    | 1.05 ± 0.043 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake reverse                        |                    | 0.072 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                             |                    | 0.661 ± 0.052 ms    |                            |
| Convolution methods/S 1 T 200 L 32/FFT forward                                                           |                    | 8.38 ± 2 μs         |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                                   |                    | 0.0475 ± 0.0042 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                           |                    | 0.316 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                                  |                    | 1.7 ± 0.028 ms      |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                    | 0.0454 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                    | 0.0459 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                        |                    | 0.0402 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme forward                           |                    | 0.177 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward     |                    | 1.1 ± 0.012 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                          |                    | 0.137 ± 0.0064 ms   |                            |
| Convolution methods/S 50 T 200 L 64/FFT forward                                                          |                    | 0.284 ± 0.14 ms     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff                    |                    | 0.125 ± 0.0084 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                                     |                    | 0.844 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme forward           |                    | 0.245 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                        |                    | 0.0365 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff                   |                    | 0.164 ± 0.0074 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward        |                    | 14.2 ± 0.76 μs      |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward               |                    | 1.1 ± 0.011 ms      |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                    | 0.416 ± 0.02 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                    | 0.0381 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                    | 1.95 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                    | 0.0952 ± 0.0083 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                    | 0.0632 ± 0.042 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                    | 9.28 ± 0.56 μs      |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                    | 0.0766 ± 0.011 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                    | 0.0837 ± 0.0086 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                    | 0.0341 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                    | 0.0609 ± 0.015 ms   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                    | 0.162 ± 0.087 ms    |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake forward                             |                    | 1.87 ± 0.11 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                    | 0.0406 ± 0.0013 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                    | 0.0465 ± 0.006 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                    | 0.0485 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                    | 0.0574 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                    | 0.106 ± 0.0098 ms   |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                    | 0.0622 ± 0.022 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                    | 0.0478 ± 0.0048 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                    | 0.0565 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                                    |                    | 0.0558 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                        |                    | 7.17 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                             |                    | 0.071 ± 0.005 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                                 |                    | 0.0608 ± 0.0017 ms  |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse                 |                    | 0.0334 ± 0.00082 ms |                            |
| Convolution methods/S 1 T 2000 L 32/FFT Mooncake gradient                                                |                    | 0.127 ± 0.36 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/ForwardDiff                               |                    | 0.0896 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                                  |                    | 0.0744 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                       |                    | 0.813 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake reverse                  |                    | 0.0805 ± 0.0057 ms  |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme reverse                                    |                    | 0.0402 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                                   |                    | 0.193 ± 0.024 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme reverse                           |                    | 0.0421 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse                    |                    | 0.0435 ± 0.00094 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                             |                    | 0.0547 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/ForwardDiff                       |                    | 0.0646 ± 0.0032 ms  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                                |                    | 0.44 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward                 |                    | 0.0814 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                        |                    | 0.0784 ± 0.0061 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                       |                    | 0.685 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                                   |                    | 0.0403 ± 0.0037 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                                |                    | 25.5 ± 0.74 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward                |                    | 1.03 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                       |                    | 0.0535 ± 0.0028 ms  |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake reverse                                    |                    | 0.104 ± 0.02 ms     |                            |
| Convolution methods/S 1 T 2000 L 100/FFT Mooncake gradient                                               |                    | 0.112 ± 0.063 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                           |                    | 0.0431 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                        |                    | 1.14 ± 0.069 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                                      |                    | 0.425 ± 0.016 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                           |                    | 0.115 ± 0.0046 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                             |                    | 0.0329 ± 0.0021 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                         |                    | 0.734 ± 0.14 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake forward                |                    | 0.353 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                                      |                    | 30.8 ± 2.7 μs       |                            |
| Convolution methods/S 1 T 200 L 32/Direct Mooncake gradient                                              |                    | 11.6 ± 1.7 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                         |                    | 0.0463 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward                 |                    | 0.297 ± 0.033 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                                |                    | 0.0545 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse                 |                    | 0.0477 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                                    |                    | 0.0721 ± 0.011 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme reverse                                     |                    | 25.7 ± 0.74 μs      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                           |                    | 25.6 ± 0.95 μs      |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward               |                    | 1.56 ± 0.088 ms     |                            |
| Convolution methods/S 50 T 200 L 64/Direct Mooncake gradient                                             |                    | 0.405 ± 0.23 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                    | 0.0576 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                    | 0.065 ± 0.0016 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                    | 26.5 ± 2.5 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                    | 0.0922 ± 0.0069 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                    | 0.0971 ± 0.0068 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                    | 0.069 ± 0.0017 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                           |                    | 0.0528 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                                 |                    | 1.05 ± 0.095 ms     |                            |
| Convolution methods/S 1 T 200 L 32/Direct forward                                                        |                    | 2.53 ± 0.7 μs       |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                                    |                    | 1.04 ± 0.026 ms     |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/ForwardDiff                          |                    | 0.304 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                 |                    | 0.99 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/ForwardDiff                               |                    | 0.0509 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward              |                    | 3.51 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                                   |                    | 0.354 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                                    |                    | 0.0504 ± 0.0037 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme forward                                      |                    | 0.414 ± 0.02 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward                      |                    | 1.67 ± 0.088 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                                   |                    | 0.0714 ± 0.0032 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme forward                                 |                    | 1.38 ± 0.027 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                                |                    | 8.86 ± 0.52 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                                     |                    | 1.98 ± 0.027 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                                |                    | 0.122 ± 0.0069 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                                      |                    | 0.058 ± 0.0043 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/Direct forward                                                     |                    | 0.767 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                    |                    | 20.7 ± 1.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward                    |                    | 0.796 ± 0.098 ms    |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme reverse                                      |                    | 0.0556 ± 0.0034 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/ForwardDiff                                    |                    | 0.277 ± 0.041 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward                   |                    | 28.9 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme forward                            |                    | 0.26 ± 0.021 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme forward                    |                    | 0.465 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                           |                    | 3.2 ± 0.092 ms      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                              |                    | 0.383 ± 0.046 ms    |                            |
| time_to_load                                                                                             | 0.186 ± 0.0007 s   | 0.278 ± 0.0017 s    | 0.669 ± 0.0049             |

|                                                                                                          | v0.1.0                    | 61637c460ff92d...         | v0.1.0 / 61637c460ff92d... |
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
| AD gradients/Recurrence protected pool in Float32/Mooncake reverse                                       |                           | 1.1 k allocs: 0.0415 MB   |                            |
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                           | 22  allocs: 13.9 kB       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                           | 22.8 k allocs: 1.1 MB     |                            |
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
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                           | 0.984 k allocs: 0.0375 MB |                            |
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
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                           | 0.336 k allocs: 21.4 kB   |                            |
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
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                           | 0.296 k allocs: 20.3 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                           | 1.18 k allocs: 0.0449 MB  |                            |
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
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                           | 0.896 k allocs: 0.0358 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                           | 19.2 k allocs: 0.846 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                           | 2.85 k allocs: 0.222 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                           | 0.274 k allocs: 17.3 kB   |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme reverse                                         |                           | 0.337 k allocs: 18.5 kB   |                            |
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
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                           | 1.1 k allocs: 0.0444 MB   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                           | 0.317 k allocs: 17.5 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                           | 0.734 k allocs: 0.357 MB  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake forward                             |                           | 23.2 k allocs: 0.95 MB    |                            |
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

