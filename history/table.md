|                                                                                                          | v0.1.0              | 40decc113cc3df...   | v0.1.0 / 40decc113cc3df... |
|:---------------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                               | 0.0656 ± 0.0068 ms  | 0.0628 ± 0.0076 ms  | 1.04 ± 0.17                |
| AD gradients/Convolution delay with history/Enzyme reverse                                               | 30.3 ± 0.56 μs      | 27.9 ± 0.64 μs      | 1.09 ± 0.032               |
| AD gradients/Convolution delay with history/ForwardDiff                                                  | 9.69 ± 1.6 μs       | 7.75 ± 1.8 μs       | 1.25 ± 0.35                |
| AD gradients/Convolution delay with history/Mooncake forward                                             | 0.224 ± 0.042 ms    | 0.231 ± 0.01 ms     | 0.971 ± 0.19               |
| AD gradients/Convolution delay with history/Mooncake reverse                                             | 0.0512 ± 0.0018 ms  | 0.038 ± 0.00099 ms  | 1.35 ± 0.058               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                                  | 0.24 ± 0.015 ms     | 0.235 ± 0.021 ms    | 1.02 ± 0.11                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                                  | 0.0408 ± 0.0013 ms  | 0.0363 ± 0.0041 ms  | 1.13 ± 0.13                |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                                     | 0.036 ± 0.0041 ms   | 29.4 ± 1.4 μs       | 1.22 ± 0.15                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                                | 0.982 ± 0.026 ms    | 0.886 ± 0.013 ms    | 1.11 ± 0.033               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                                | 0.0642 ± 0.0041 ms  | 0.0417 ± 0.0011 ms  | 1.54 ± 0.1                 |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                            | 0.329 ± 0.017 ms    | 0.328 ± 0.055 ms    | 1 ± 0.17                   |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                            | 0.0354 ± 0.00088 ms | 0.0489 ± 0.0039 ms  | 0.724 ± 0.061              |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                               | 0.0382 ± 0.0036 ms  | 0.421 ± 0.016 ms    | 0.0908 ± 0.0093            |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                          | 1.24 ± 0.02 ms      | 1.11 ± 0.043 ms     | 1.11 ± 0.046               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                          | 0.0654 ± 0.0049 ms  | 0.0504 ± 0.0036 ms  | 1.3 ± 0.13                 |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                              | 0.624 ± 0.03 ms     | 0.58 ± 0.023 ms     | 1.08 ± 0.067               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                              | 30.4 ± 1.6 μs       | 25.8 ± 0.76 μs      | 1.18 ± 0.07                |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                                 | 0.0799 ± 0.0059 ms  | 0.0751 ± 0.083 ms   | 1.06 ± 1.2                 |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                            | 1.83 ± 0.17 ms      | 1.24 ± 0.51 ms      | 1.47 ± 0.62                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                            | 0.0566 ± 0.0024 ms  | 0.0343 ± 0.0019 ms  | 1.65 ± 0.11                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                              | 0.321 ± 0.043 ms    | 0.344 ± 0.42 ms     | 0.931 ± 1.1                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                             | 0.364 ± 0.29 ms     | 0.372 ± 0.3 ms      | 0.979 ± 1.1                |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                                | 7.63 ± 0.13 ms      | 7.65 ± 0.18 ms      | 0.998 ± 0.029              |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                           | 0.035 ± 0.00026 s   | 0.058 ± 0.00013 s   | 0.603 ± 0.0046             |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                                 | 1.49 ± 0.036 ms     | 0.292 ± 0.014 ms    | 5.09 ± 0.27                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                                    | 0.0618 ± 0.018 s    | 31.4 ± 14 ms        | 1.97 ± 1                   |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 1.33 ± 0.04 ms      | 0.314 ± 0.015 ms    | 4.24 ± 0.24                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 29.3 ± 12 μs        | 9.5 ± 6.2 μs        | 3.09 ± 2.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 0.405 ± 0.028 ms    | 0.282 ± 0.43 ms     | 1.43 ± 2.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.0577 ± 0.02 ms    | 15.8 ± 2.3 μs       | 3.66 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.0609 ± 0.013 ms   | 0.0371 ± 0.0064 ms  | 1.64 ± 0.46                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 0.461 ± 0.025 ms    | 0.395 ± 0.31 ms     | 1.17 ± 0.93                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.108 ± 0.0061 ms   | 0.0545 ± 0.008 ms   | 1.99 ± 0.31                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 0.656 ± 0.013 ms    | 0.0651 ± 0.013 ms   | 10.1 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 19 ± 1.1 ms         | 10.9 ± 0.55 ms      | 1.75 ± 0.14                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 0.596 ± 0.041 ms    | 0.0907 ± 0.0025 ms  | 6.58 ± 0.49                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.0956 ± 0.015 ms   | 0.0525 ± 0.009 ms   | 1.82 ± 0.42                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 2.75 ± 0.035 ms     | 0.754 ± 0.64 ms     | 3.65 ± 3.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 0.148 ± 0.032 ms    | 0.0774 ± 0.0037 ms  | 1.91 ± 0.42                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 0.914 ± 0.015 ms    | 0.154 ± 0.011 ms    | 5.94 ± 0.44                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 0.0712 ± 0.00097 s  | 0.0358 ± 0.00033 s  | 1.99 ± 0.033               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 0.846 ± 0.022 ms    | 0.225 ± 0.011 ms    | 3.76 ± 0.22                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 1.06 ± 0.079 ms     | 1.02 ± 0.11 ms      | 1.04 ± 0.14                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.141 ± 0.0079 ms   | 0.133 ± 0.0061 ms   | 1.06 ± 0.077               |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.112 ± 0.02 ms     | 1.2 ± 0.019 ms      | 0.0934 ± 0.017             |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 3.18 ± 0.44 ms      | 3.44 ± 0.093 ms     | 0.925 ± 0.13               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 0.185 ± 0.011 ms    | 0.146 ± 0.01 ms     | 1.27 ± 0.12                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 0.105 ± 0.0072 ms   | 0.0648 ± 0.0052 ms  | 1.62 ± 0.17                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 12.6 ± 1.9 μs       | 4.65 ± 0.46 μs      | 2.71 ± 0.49                |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 28.6 ± 6.1 μs       | 26.9 ± 2.2 μs       | 1.06 ± 0.24                |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 0.662 ± 0.035 ms    | 0.395 ± 0.12 ms     | 1.67 ± 0.5                 |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 0.0367 ± 0.0013 ms  | 15.9 ± 0.79 μs      | 2.31 ± 0.14                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme forward                     | 0.443 ± 0.022 ms    | 0.295 ± 0.027 ms    | 1.5 ± 0.16                 |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Enzyme reverse                     | 0.109 ± 0.0075 ms   | 0.0607 ± 0.0031 ms  | 1.8 ± 0.15                 |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/ForwardDiff                        | 0.0773 ± 0.0085 ms  | 0.0921 ± 0.0044 ms  | 0.839 ± 0.1                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake forward                   | 1.53 ± 0.19 ms      | 1.37 ± 0.025 ms     | 1.11 ± 0.14                |
| AD gradients/Recurrence depletion with a differentiated heterogeneity/Mooncake reverse                   | 0.143 ± 0.0052 ms   | 0.0941 ± 0.0047 ms  | 1.52 ± 0.093               |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward             | 0.425 ± 0.024 ms    | 0.285 ± 0.028 ms    | 1.49 ± 0.17                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse             | 0.0938 ± 0.0059 ms  | 0.0607 ± 0.0031 ms  | 1.55 ± 0.13                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff                | 0.0781 ± 0.024 ms   | 0.0602 ± 0.0034 ms  | 1.3 ± 0.4                  |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward           | 1.46 ± 0.17 ms      | 1.31 ± 0.023 ms     | 1.11 ± 0.13                |
| AD gradients/Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse           | 0.126 ± 0.0061 ms   | 0.0909 ± 0.004 ms   | 1.39 ± 0.091               |
| AD gradients/Recurrence in Float32/Enzyme forward                                                        | 0.242 ± 0.033 ms    | 0.211 ± 0.017 ms    | 1.14 ± 0.18                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                        | 0.0504 ± 0.0016 ms  | 0.0422 ± 0.0027 ms  | 1.19 ± 0.085               |
| AD gradients/Recurrence in Float32/ForwardDiff                                                           | 0.0473 ± 0.022 ms   | 0.0385 ± 0.0035 ms  | 1.23 ± 0.58                |
| AD gradients/Recurrence in Float32/Mooncake forward                                                      | 0.813 ± 0.044 ms    | 0.728 ± 0.037 ms    | 1.12 ± 0.083               |
| AD gradients/Recurrence in Float32/Mooncake reverse                                                      | 0.0864 ± 0.0024 ms  | 0.067 ± 0.004 ms    | 1.29 ± 0.085               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                                   | 0.386 ± 0.044 ms    | 0.356 ± 0.045 ms    | 1.08 ± 0.18                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.0732 ± 0.0048 ms  | 0.0391 ± 0.00089 ms | 1.87 ± 0.13                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.0694 ± 0.013 ms   | 0.0862 ± 0.0049 ms  | 0.806 ± 0.16               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 1.38 ± 0.029 ms     | 1.64 ± 0.036 ms     | 0.838 ± 0.025              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.0905 ± 0.004 ms   | 0.053 ± 0.0017 ms   | 1.71 ± 0.094               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 0.397 ± 0.024 ms    | 0.283 ± 0.019 ms    | 1.4 ± 0.13                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.0572 ± 0.0053 ms  | 0.0522 ± 0.0048 ms  | 1.1 ± 0.14                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.0674 ± 0.014 ms   | 0.0496 ± 0.0038 ms  | 1.36 ± 0.31                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 2.35 ± 0.45 ms      | 1.09 ± 0.035 ms     | 2.16 ± 0.42                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 0.0919 ± 0.0088 ms  | 0.0758 ± 0.0061 ms  | 1.21 ± 0.15                |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.0679 ± 0.0013 ms  | 0.0674 ± 0.0021 ms  | 1.01 ± 0.036               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 0.0371 ± 0.0034 ms  | 0.0368 ± 0.0026 ms  | 1.01 ± 0.12                |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 13.3 ± 3.3 μs       | 11.8 ± 4.7 μs       | 1.12 ± 0.53                |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 0.22 ± 0.02 ms      | 0.221 ± 0.017 ms    | 0.997 ± 0.12               |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.068 ± 0.0051 ms   | 0.0495 ± 0.0039 ms  | 1.38 ± 0.15                |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 0.329 ± 0.035 ms    | 0.287 ± 0.015 ms    | 1.15 ± 0.14                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.0736 ± 0.0039 ms  | 0.0713 ± 0.0029 ms  | 1.03 ± 0.069               |
| AD gradients/Recurrence returning its state/ForwardDiff                                                  | 0.0646 ± 0.01 ms    | 0.0596 ± 0.0035 ms  | 1.08 ± 0.18                |
| AD gradients/Recurrence returning its state/Mooncake forward                                             | 1.64 ± 0.03 ms      | 1.12 ± 0.031 ms     | 1.47 ± 0.049               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                             | 0.116 ± 0.0058 ms   | 0.0975 ± 0.005 ms   | 1.19 ± 0.085               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                              | 0.133 ± 0.0099 ms   | 0.12 ± 0.011 ms     | 1.11 ± 0.13                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                              | 26.9 ± 0.77 μs      | 0.0399 ± 0.0013 ms  | 0.673 ± 0.029              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                                 | 26.7 ± 1.4 μs       | 26.1 ± 2.7 μs       | 1.02 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                            | 0.4 ± 0.11 ms       | 0.373 ± 0.021 ms    | 1.07 ± 0.31                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                            | 0.0517 ± 0.0037 ms  | 0.048 ± 0.006 ms    | 1.08 ± 0.16                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                                   | 0.262 ± 0.029 ms    | 0.23 ± 0.015 ms     | 1.14 ± 0.15                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                                   | 0.0757 ± 0.003 ms   | 0.047 ± 0.0032 ms   | 1.61 ± 0.13                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                                      | 31.3 ± 1.6 μs       | 0.045 ± 0.0039 ms   | 0.694 ± 0.07               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                                 | 0.804 ± 0.15 ms     | 0.837 ± 0.027 ms    | 0.96 ± 0.18                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                                 | 0.0893 ± 0.0066 ms  | 0.0695 ± 0.0044 ms  | 1.29 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 0.41 ± 0.024 ms     | 0.331 ± 0.017 ms    | 1.24 ± 0.096               |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.0931 ± 0.0074 ms  | 0.0548 ± 0.003 ms   | 1.7 ± 0.16                 |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.0684 ± 0.012 ms   | 0.0653 ± 0.0037 ms  | 1.05 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 2.49 ± 0.044 ms     | 1.74 ± 0.029 ms     | 1.43 ± 0.035               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 0.133 ± 0.004 ms    | 0.0965 ± 0.0051 ms  | 1.38 ± 0.084               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                                  | 1.11 ± 0.31 ms      | 1.17 ± 0.035 ms     | 0.951 ± 0.27               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                                  | 0.0626 ± 0.0056 ms  | 0.0508 ± 0.0052 ms  | 1.23 ± 0.17                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                                     | 0.128 ± 0.0066 ms   | 0.147 ± 0.019 ms    | 0.867 ± 0.12               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                                | 3.68 ± 0.83 ms      | 3.74 ± 0.53 ms      | 0.985 ± 0.26               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                                | 0.0944 ± 0.0089 ms  | 0.0671 ± 0.0021 ms  | 1.41 ± 0.14                |
| Convolution body/BLAS axpy per lag                                                                       | 0.78 ± 0.0034 μs    | 0.779 ± 0.0036 μs   | 1 ± 0.0064                 |
| Convolution body/native axpy per lag                                                                     | 0.497 ± 0.0066 μs   | 0.492 ± 0.0053 μs   | 1.01 ± 0.017               |
| Convolution body/package                                                                                 | 0.78 ± 0.0035 μs    | 0.362 ± 0.006 μs    | 2.15 ± 0.037               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                                  | 0.0886 ± 0.0038 ms  | 0.0509 ± 0.001 ms   | 1.74 ± 0.082               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                                 | 4.14 ± 0.29 μs      | 4.12 ± 0.29 μs      | 1 ± 0.1                    |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                                | 2.71 ± 1.5 μs       | 2.13 ± 0.39 μs      | 1.27 ± 0.76                |
| Evaluation/Matrix overview T200_L20_S3                                                                   | 0.0542 ± 0.0034 ms  | 21.2 ± 1.4 μs       | 2.55 ± 0.23                |
| Evaluation/Matrix renewal T200_L20_S1                                                                    | 9.92 ± 1.8 μs       | 10.1 ± 1.7 μs       | 0.978 ± 0.24               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                              | 0.0669 ± 0.0036 ms  | 0.0332 ± 0.00068 ms | 2.01 ± 0.12                |
| AD gradients/Recurrence removals from recent outputs/Enzyme reverse                                      |                     | 0.0416 ± 0.003 ms   |                            |
| Convolution methods/S 1 T 2000 L 32/FFT forward                                                          |                     | 27.3 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                           |                     | 0.146 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse                   |                     | 0.0609 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/ForwardDiff                              |                     | 0.0402 ± 0.0076 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward                     |                     | 2.48 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake forward                     |                     | 5.56 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                  |                     | 0.0434 ± 0.00098 ms |                            |
| Convolution methods/S 1 T 200 L 64/FFT Mooncake gradient                                                 |                     | 24.8 ± 3.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme forward   |                     | 0.278 ± 0.019 ms    |                            |
| Convolution methods/S 1 T 300 L 60/FFT forward                                                           |                     | 7.92 ± 0.4 μs       |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme reverse                              |                     | 0.0683 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                                      |                     | 0.412 ± 0.019 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                                   |                     | 0.0703 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff                     |                     | 0.0462 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake forward                        |                     | 1.11 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward                      |                     | 0.403 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                                 |                     | 0.858 ± 0.008 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse        |                     | 18.2 ± 0.57 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                              |                     | 1.87 ± 0.028 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                                     |                     | 0.278 ± 0.017 ms    |                            |
| Convolution methods/S 1 T 200 L 64/Direct forward                                                        |                     | 3.24 ± 0.49 μs      |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake reverse                                       |                     | 0.1 ± 0.0033 ms     |                            |
| Convolution methods/S 1 T 200 L 64/FFT forward                                                           |                     | 7.71 ± 0.99 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                               |                     | 2.69 ± 0.095 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake reverse            |                     | 0.42 ± 0.054 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                       |                     | 0.0591 ± 0.0045 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                              |                     | 1.21 ± 0.33 ms      |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                              |                     | 0.0648 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse               |                     | 0.0607 ± 0.0016 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake forward                         |                     | 1.27 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake forward |                     | 1.23 ± 0.039 ms     |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                        |                     | 4.57 ± 0.14 ms      |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake forward                            |                     | 1.9 ± 0.037 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                     | 0.0538 ± 0.0041 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                     | 0.0914 ± 0.0026 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/ForwardDiff                                 |                     | 0.0842 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme reverse                          |                     | 0.0647 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/ForwardDiff      |                     | 0.0601 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                        |                     | 1.04 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                          |                     | 0.122 ± 0.006 ms    |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake forward                                  |                     | 1.11 ± 0.019 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                        |                     | 0.228 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Mooncake reverse |                     | 0.113 ± 0.0051 ms   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                              |                     | 0.231 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme forward                 |                     | 0.288 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake reverse         |                     | 0.116 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                     | 0.143 ± 0.016 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                     | 0.0665 ± 0.0013 ms  |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                     | 0.652 ± 0.052 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                     | 3.48 ± 0.32 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                     | 0.449 ± 0.019 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                     | 0.085 ± 0.0026 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                     | 0.217 ± 0.014 ms    |                            |
| AD gradients/Recurrence protected pool in Float32/ForwardDiff                                            |                     | 0.116 ± 0.0051 ms   |                            |
| AD gradients/Recurrence removals from recent outputs/ForwardDiff                                         |                     | 0.053 ± 0.0033 ms   |                            |
| Convolution methods/S 1 T 2000 L 100/Direct forward                                                      |                     | 0.0366 ± 0.0033 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                                |                     | 0.0674 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                            |                     | 0.0925 ± 0.0057 ms  |                            |
| Convolution methods/S 50 T 200 L 64/Direct forward                                                       |                     | 0.172 ± 0.068 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                                |                     | 0.211 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme reverse                           |                     | 0.0433 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                                    |                     | 1.8 ± 0.35 ms       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                                   |                     | 1.2 ± 0.022 ms      |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward            |                     | 2.65 ± 0.047 ms     |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake reverse                             |                     | 0.185 ± 0.0085 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                                 |                     | 0.0885 ± 0.002 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                                |                     | 0.923 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Enzyme reverse                 |                     | 0.0621 ± 0.0012 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                           |                     | 1.15 ± 0.054 ms     |                            |
| Convolution methods/S 1 T 2000 L 32/Direct forward                                                       |                     | 10 ± 0.58 μs        |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward                      |                     | 0.822 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                       |                     | 1.5 ± 0.033 ms      |                            |
| Convolution methods/S 1 T 300 L 60/Direct forward                                                        |                     | 2.69 ± 0.18 μs      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward                    |                     | 1.76 ± 0.33 μs      |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake forward                              |                     | 1.01 ± 0.1 ms       |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                         |                     | 0.0406 ± 0.0015 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme forward                                          |                     | 0.55 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/ForwardDiff                    |                     | 0.0623 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                                 |                     | 0.242 ± 0.025 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                                |                     | 0.046 ± 0.00099 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                       |                     | 23.7 ± 1.7 μs       |                            |
| Convolution methods/S 1 T 300 L 60/Direct Mooncake gradient                                              |                     | 14.6 ± 0.49 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                        |                     | 0.0622 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse                 |                     | 0.0402 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse                    |                     | 0.167 ± 0.01 ms     |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                              |                     | 1.18 ± 0.063 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse                  |                     | 0.0377 ± 0.00087 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                                    |                     | 0.611 ± 0.074 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                                 |                     | 0.0392 ± 0.0028 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                             |                     | 0.0702 ± 0.012 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme reverse                                 |                     | 0.121 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                         |                     | 0.109 ± 0.0049 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                     | 0.62 ± 0.051 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                     | 2.03 ± 0.083 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                     | 0.138 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                     | 0.243 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                     | 0.164 ± 0.0064 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                     | 0.0546 ± 0.0021 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                     | 0.104 ± 0.0027 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                     | 4.4 ± 0.21 ms       |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                     | 0.075 ± 0.0042 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                     | 0.0336 ± 0.0053 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                     | 0.112 ± 0.0033 ms   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                     | 0.101 ± 0.005 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                     | 0.065 ± 0.0019 ms   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                     | 0.212 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                     | 26.9 ± 2 μs         |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                     | 0.082 ± 0.0049 ms   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                     | 3.79 ± 0.75 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                     | 0.26 ± 0.027 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                     | 0.352 ± 0.035 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                     | 0.122 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                     | 0.0717 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake forward            |                     | 8.5 ± 0.11 ms       |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/ForwardDiff                           |                     | 0.161 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                     | 1.14 ± 0.092 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                     | 1.03 ± 0.017 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                     | 3.69 ± 0.11 ms      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                     | 13.2 ± 0.78 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                     | 0.0408 ± 0.0009 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                     | 0.0675 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                     | 0.33 ± 0.034 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                     | 0.143 ± 0.0056 ms   |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                     | 0.296 ± 0.025 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                     | 0.445 ± 0.02 ms     |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                     | 14.1 ± 1.7 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                     | 0.263 ± 0.016 ms    |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                     | 1.57 ± 0.045 ms     |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                     | 0.073 ± 0.0016 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                           |                     | 0.24 ± 0.025 ms     |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/ForwardDiff                              |                     | 0.0648 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Mooncake reverse                     |                     | 0.185 ± 0.011 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                                |                     | 0.24 ± 0.018 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                             |                     | 0.0502 ± 0.0012 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                                   |                     | 0.0501 ± 0.0057 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                       |                     | 0.0811 ± 0.002 ms   |                            |
| Convolution methods/S 1 T 200 L 32/FFT Mooncake gradient                                                 |                     | 27.1 ± 3 μs         |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme reverse                    |                     | 0.0827 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                             |                     | 0.0968 ± 0.0046 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                              |                     | 0.0644 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                         |                     | 0.364 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake reverse                          |                     | 0.151 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme forward                               |                     | 0.657 ± 0.064 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                     | 0.151 ± 0.0072 ms   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                     | 0.139 ± 0.0068 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                     | 0.172 ± 0.0082 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                     | 30 ± 0.69 μs        |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                     | 0.093 ± 0.061 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                     | 0.954 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                     | 0.033 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                     | 0.0671 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                     | 0.109 ± 0.0029 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                     | 0.623 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                     | 1.83 ± 0.065 ms     |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                     | 0.0722 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                     | 1.69 ± 0.25 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                     | 0.0418 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                     | 0.0878 ± 0.006 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                     | 0.0562 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                     | 0.0999 ± 0.0061 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                     | 0.0903 ± 0.0022 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                     | 3.16 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                     | 1.62 ± 0.21 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                     | 1.04 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                     | 0.0528 ± 0.0041 ms  |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                     | 0.262 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                     | 0.042 ± 0.0035 ms   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme reverse              |                     | 0.179 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                     | 0.068 ± 0.0061 ms   |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                     | 0.101 ± 0.0041 ms   |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme forward                                         |                     | 0.561 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme reverse                  |                     | 9.92 ± 4.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward                      |                     | 0.395 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                            |                     | 0.0409 ± 0.0056 ms  |                            |
| Convolution methods/S 1 T 300 L 60/FFT Mooncake gradient                                                 |                     | 28.6 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme reverse                            |                     | 0.131 ± 0.0074 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                        |                     | 0.24 ± 0.019 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/ForwardDiff                             |                     | 0.0487 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake forward         |                     | 1.31 ± 0.03 ms      |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                            |                     | 0.0835 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                      |                     | 0.0552 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse                      |                     | 0.0638 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                          |                     | 0.342 ± 0.018 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                                |                     | 0.402 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                         |                     | 0.0422 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake reverse                          |                     | 0.111 ± 0.0057 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/ForwardDiff              |                     | 0.0661 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                               |                     | 0.219 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Enzyme forward                                |                     | 0.527 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                                   |                     | 0.363 ± 0.027 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward                  |                     | 16.2 ± 0.74 μs      |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake forward                                    |                     | 1.34 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                              |                     | 0.0541 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Enzyme forward              |                     | 0.69 ± 0.047 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                         |                     | 0.144 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake reverse                              |                     | 0.134 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake forward                          |                     | 1.35 ± 0.025 ms     |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward                 |                     | 0.247 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                             |                     | 1.01 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward                    |                     | 0.195 ± 0.0084 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/ForwardDiff                 |                     | 0.1 ± 0.0055 ms     |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake forward                               |                     | 5.73 ± 1.5 ms       |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake reverse            |                     | 0.142 ± 0.0045 ms   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme reverse                      |                     | 0.111 ± 0.0054 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse                |                     | 0.0605 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                                    |                     | 16 ± 3.3 μs         |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme forward                                     |                     | 0.197 ± 0.034 ms    |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme forward                        |                     | 0.951 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Enzyme forward                          |                     | 0.266 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                           |                     | 0.159 ± 0.0061 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                         |                     | 0.0611 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                           |                     | 0.141 ± 0.0067 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                             |                     | 0.975 ± 0.035 ms    |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff                    |                     | 0.0817 ± 0.0056 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                                    |                     | 0.0431 ± 0.023 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff             |                     | 1.33 ± 0.23 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                                 |                     | 0.0641 ± 0.056 ms   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake forward               |                     | 1.24 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse                |                     | 0.0795 ± 0.0016 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/Direct Mooncake gradient                                             |                     | 0.0775 ± 0.0012 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                     | 0.0945 ± 0.0051 ms  |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                     | 0.638 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                     | 0.0927 ± 0.0062 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                     | 0.0652 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                     | 27.9 ± 2.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                     | 0.0716 ± 0.0048 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                     | 0.888 ± 0.055 ms    |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                     | 0.478 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                     | 0.0806 ± 0.04 ms    |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                     | 0.139 ± 0.0087 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                     | 0.398 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                     | 1.91 ± 0.08 ms      |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                     | 0.116 ± 0.0032 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                     | 0.0462 ± 0.0047 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                     | 0.171 ± 0.058 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                     | 3.37 ± 0.1 ms       |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                     | 1.83 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                     | 0.878 ± 0.02 ms     |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                     | 0.0866 ± 0.0026 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                     | 1.37 ± 0.25 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                     | 0.0615 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme reverse                               |                     | 0.135 ± 0.0064 ms   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                     | 1.46 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                     | 1.93 ± 0.44 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                     | 0.0787 ± 0.0048 ms  |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                     | 0.513 ± 0.036 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                     | 0.856 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                     | 0.171 ± 0.046 ms    |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/ForwardDiff                                  |                     | 0.136 ± 0.0067 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                     | 0.0319 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                     | 0.0606 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                     | 0.0863 ± 0.0025 ms  |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                     | 0.0942 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                     | 1.65 ± 0.083 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                     | 0.352 ± 0.02 ms     |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                     | 0.0573 ± 0.0035 ms  |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme reverse                                         |                     | 0.0711 ± 0.0083 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake forward                      |                     | 8.98 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                               |                     | 0.174 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme forward                  |                     | 0.0603 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake forward                         |                     | 0.836 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                                |                     | 0.425 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward                |                     | 1.04 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                         |                     | 0.146 ± 0.0052 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse                      |                     | 0.0862 ± 0.0041 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                           |                     | 0.107 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                              |                     | 2.18 ± 0.096 ms     |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                        |                     | 0.102 ± 0.0026 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward                  |                     | 1.37 ± 0.085 ms     |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                                |                     | 0.108 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                                     |                     | 0.0697 ± 0.0041 ms  |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme forward                           |                     | 0.279 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward                  |                     | 0.347 ± 0.11 ms     |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake forward                                       |                     | 2.48 ± 0.068 ms     |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                                     |                     | 0.0405 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                                      |                     | 0.0556 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                                      |                     | 0.62 ± 0.014 ms     |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake forward                                   |                     | 0.821 ± 0.019 ms    |                            |
| Convolution methods/S 1 T 20000 L 500/FFT Mooncake gradient                                              |                     | 1.28 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake reverse                        |                     | 0.107 ± 0.0029 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                             |                     | 0.734 ± 0.017 ms    |                            |
| Convolution methods/S 1 T 200 L 32/FFT forward                                                           |                     | 10.3 ± 6.7 μs       |                            |
| AD gradients/Recurrence routes folded on scaled identities/ForwardDiff                                   |                     | 0.136 ± 0.0065 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                           |                     | 0.328 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                                  |                     | 2.23 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                     | 0.0575 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                     | 0.057 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme forward              |                     | 0.969 ± 0.19 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                        |                     | 0.0642 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme forward                           |                     | 0.196 ± 0.037 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward     |                     | 1.36 ± 0.026 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                          |                     | 0.158 ± 0.011 ms    |                            |
| Convolution methods/S 50 T 200 L 64/FFT forward                                                          |                     | 0.143 ± 0.0084 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff                    |                     | 0.0723 ± 0.0073 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                                     |                     | 1.16 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme forward           |                     | 0.287 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                        |                     | 0.0453 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff                   |                     | 0.161 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward        |                     | 16.1 ± 0.69 μs      |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward               |                     | 1.34 ± 0.021 ms     |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake reverse                      |                     | 0.147 ± 0.007 ms    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                     | 0.516 ± 0.021 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                     | 0.0412 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                     | 2.53 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                     | 0.116 ± 0.0068 ms   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/ForwardDiff                 |                     | 0.217 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                     | 10.7 ± 0.57 μs      |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                     | 0.0648 ± 0.048 ms   |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                     | 0.0889 ± 0.018 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                     | 0.1 ± 0.0068 ms     |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                     | 0.0536 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                     | 0.0972 ± 0.0052 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                     | 0.175 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake forward                             |                     | 2.43 ± 0.065 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                     | 0.0902 ± 0.0017 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                     | 0.0597 ± 0.014 ms   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                     | 0.0614 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                     | 0.0863 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                     | 0.149 ± 0.015 ms    |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                     | 30.3 ± 1.3 μs       |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                     | 0.0482 ± 0.0035 ms  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                     | 0.0761 ± 0.0066 ms  |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme reverse                        |                     | 0.107 ± 0.0054 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                                    |                     | 0.062 ± 0.004 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                        |                     | 8.2 ± 1.7 μs        |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                             |                     | 0.113 ± 0.0063 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                                 |                     | 0.0877 ± 0.0044 ms  |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse                 |                     | 0.0432 ± 0.0009 ms  |                            |
| Convolution methods/S 1 T 2000 L 32/FFT Mooncake gradient                                                |                     | 0.417 ± 0.73 ms     |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/ForwardDiff                               |                     | 0.154 ± 0.0083 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                                  |                     | 0.14 ± 0.007 ms     |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                       |                     | 0.885 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake reverse                  |                     | 0.112 ± 0.0063 ms   |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme reverse                                    |                     | 0.0586 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                                   |                     | 0.243 ± 0.022 ms    |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme reverse                           |                     | 0.0605 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse                    |                     | 0.0593 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                             |                     | 0.072 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/ForwardDiff                       |                     | 0.0702 ± 0.0031 ms  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                                |                     | 0.482 ± 0.025 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward                 |                     | 0.102 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                        |                     | 0.116 ± 0.0059 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                       |                     | 0.702 ± 0.065 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                                   |                     | 0.0569 ± 0.0035 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                                |                     | 0.0339 ± 0.0008 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward                |                     | 1.36 ± 0.046 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                       |                     | 0.0812 ± 0.0017 ms  |                            |
| AD gradients/Recurrence removals from recent outputs/Mooncake reverse                                    |                     | 0.0709 ± 0.0044 ms  |                            |
| Convolution methods/S 1 T 2000 L 100/FFT Mooncake gradient                                               |                     | 0.128 ± 0.011 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                           |                     | 0.0645 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                        |                     | 1.71 ± 0.035 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                                      |                     | 0.491 ± 0.042 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/ForwardDiff                           |                     | 0.11 ± 0.053 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                             |                     | 0.0446 ± 0.0028 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                         |                     | 1.08 ± 0.037 ms     |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake forward                |                     | 0.388 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                                      |                     | 0.0344 ± 0.0029 ms  |                            |
| Convolution methods/S 1 T 200 L 32/Direct Mooncake gradient                                              |                     | 12.2 ± 1.6 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                         |                     | 0.0798 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward                 |                     | 0.303 ± 0.05 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                                |                     | 0.056 ± 0.006 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse                 |                     | 0.0731 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                                    |                     | 0.103 ± 0.0073 ms   |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme reverse                                     |                     | 0.0328 ± 0.00076 ms |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                           |                     | 0.0333 ± 0.00085 ms |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward               |                     | 1.16 ± 0.078 ms     |                            |
| Convolution methods/S 50 T 200 L 64/Direct Mooncake gradient                                             |                     | 0.472 ± 0.014 ms    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                     | 0.0861 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                     | 0.0953 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                     | 0.0334 ± 0.0028 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                     | 0.101 ± 0.003 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                     | 0.125 ± 0.0045 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                     | 0.101 ± 0.0023 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                           |                     | 0.0894 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                                 |                     | 1.38 ± 0.069 ms     |                            |
| Convolution methods/S 1 T 200 L 32/Direct forward                                                        |                     | 2.54 ± 0.41 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                                    |                     | 1.51 ± 0.056 ms     |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/ForwardDiff                          |                     | 0.332 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                 |                     | 6.66 ± 0.073 ms     |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/ForwardDiff                               |                     | 0.0533 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward              |                     | 4.43 ± 0.055 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                                   |                     | 0.373 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                                    |                     | 0.0734 ± 0.003 ms   |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme forward                                      |                     | 0.476 ± 0.022 ms    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake forward                      |                     | 2.19 ± 0.093 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                                   |                     | 0.115 ± 0.0061 ms   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme forward                                 |                     | 1.61 ± 0.042 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                                |                     | 10.5 ± 0.6 μs       |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                                     |                     | 2.68 ± 0.042 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                                |                     | 0.138 ± 0.0068 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                                      |                     | 0.0628 ± 0.0049 ms  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct forward                                                     |                     | 0.946 ± 0.17 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                    |                     | 25.9 ± 0.66 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward                    |                     | 2.36 ± 0.18 ms      |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme reverse                                      |                     | 0.0796 ± 0.0019 ms  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/ForwardDiff                                    |                     | 0.284 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward                   |                     | 0.0325 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme forward                            |                     | 0.266 ± 0.02 ms     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme forward                    |                     | 0.545 ± 0.029 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                           |                     | 5.92 ± 0.081 ms     |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                              |                     | 0.412 ± 0.062 ms    |                            |
| time_to_load                                                                                             | 0.236 ± 0.0023 s    | 0.347 ± 0.0037 s    | 0.68 ± 0.0098              |

|                                                                                                          | v0.1.0                    | 40decc113cc3df...         | v0.1.0 / 40decc113cc3df... |
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
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                                 | 3.25 k allocs: 0.494 MB   | 0.43 k allocs: 0.14 MB    | 3.52                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                                    | 8.89 k allocs: 0.0511 GB  | 6.97 k allocs: 0.0399 GB  | 1.28                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                               | 9.4 k allocs: 0.381 MB    | 1.25 k allocs: 0.161 MB   | 2.36                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                                | 0.054 k allocs: 0.0376 MB | 0.039 k allocs: 19 kB     | 2.03                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                                   | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                              | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                               | 0.161 k allocs: 0.0396 MB | 0.152 k allocs: 21 kB     | 1.93                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                                  | 0.542 k allocs: 1.69 MB   | 0.422 k allocs: 0.852 MB  | 1.98                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                             | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                                  | 1.53 k allocs: 0.293 MB   | 0.108 k allocs: 0.0879 MB | 3.33                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                                     | 2.71 k allocs: 24.9 MB    | 1.1 k allocs: 12.3 MB     | 2.02                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                                | 5.84 k allocs: 0.353 MB   | 0.087 k allocs: 0.0883 MB | 4                          |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                                   | 0.18 k allocs: 0.0375 MB  | 0.186 k allocs: 25.5 kB   | 1.5                        |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                                      | 0.822 k allocs: 1.78 MB   | 0.722 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                                 | 2.31 k allocs: 0.0849 MB  | 0.654 k allocs: 0.0381 MB | 2.23                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                             | 1.53 k allocs: 0.307 MB   | 0.276 k allocs: 0.126 MB  | 2.45                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                                | 6.2 k allocs: 0.0508 GB   | 5.15 k allocs: 0.0396 GB  | 1.28                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                           | 9.06 k allocs: 0.369 MB   | 0.903 k allocs: 0.143 MB  | 2.59                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                       | 8.54 k allocs: 0.784 MB   | 7.89 k allocs: 0.71 MB    | 1.11                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                       | 0.652 k allocs: 0.0473 MB | 0.412 k allocs: 0.0323 MB | 1.46                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                          | 0.713 k allocs: 0.321 MB  | 0.632 k allocs: 0.268 MB  | 1.2                        |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                                     | 0.0394 M allocs: 1.95 MB  | 0.0369 M allocs: 1.81 MB  | 1.07                       |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                                     | 1.69 k allocs: 0.0622 MB  | 1.29 k allocs: 0.0531 MB  | 1.17                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme forward                            | 1.13 k allocs: 0.141 MB   | 0.807 k allocs: 0.103 MB  | 1.36                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Enzyme reverse                            | 0.077 k allocs: 10.4 kB   | 0.079 k allocs: 8.2 kB    | 1.26                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/ForwardDiff                               | 0.162 k allocs: 0.108 MB  | 0.117 k allocs: 0.0811 MB | 1.33                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake forward                          | 7.39 k allocs: 0.455 MB   | 2.47 k allocs: 0.272 MB   | 1.67                       |
| AD gradients/Recurrence array-field and scalar-field modifiers/Mooncake reverse                          | 0.44 k allocs: 18 kB      | 0.109 k allocs: 9.08 kB   | 1.98                       |
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
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                                   | 0.246 k allocs: 20 kB     | 0.18 k allocs: 13 kB      | 1.54                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                                      | 0.303 k allocs: 0.154 MB  | 0.296 k allocs: 0.161 MB  | 0.956                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                                 | 17.4 k allocs: 0.834 MB   | 15.8 k allocs: 0.828 MB   | 1.01                       |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                                 | 0.691 k allocs: 26.1 kB   | 0.64 k allocs: 25.8 kB    | 1.01                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                             | 3.18 k allocs: 0.261 MB   | 2.77 k allocs: 0.214 MB   | 1.22                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                             | 0.233 k allocs: 17.1 kB   | 0.228 k allocs: 14.7 kB   | 1.16                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                                | 0.29 k allocs: 0.13 MB    | 0.242 k allocs: 0.0952 MB | 1.37                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                           | 15.7 k allocs: 0.716 MB   | 14 k allocs: 0.611 MB     | 1.17                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                           | 1.15 k allocs: 0.0397 MB  | 0.8 k allocs: 30 kB       | 1.36                       |
| AD gradients/Recurrence renewal/Enzyme forward                                                           | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                           | 0.176 k allocs: 7.66 kB   | 0.186 k allocs: 8 kB      | 0.957                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                              | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                         | 4.09 k allocs: 0.137 MB   | 3.75 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                         | 0.809 k allocs: 25.5 kB   | 0.661 k allocs: 21.6 kB   | 1.18                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                               | 3.31 k allocs: 0.237 MB   | 3.21 k allocs: 0.21 MB    | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                               | 0.336 k allocs: 21.5 kB   | 0.308 k allocs: 16.8 kB   | 1.28                       |
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
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                                    | 3.74 k allocs: 0.297 MB   | 3.35 k allocs: 0.248 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                                    | 0.375 k allocs: 23.9 kB   | 0.256 k allocs: 16.8 kB   | 1.42                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                       | 0.338 k allocs: 0.149 MB  | 0.284 k allocs: 0.113 MB  | 1.31                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                                  | 19.4 k allocs: 0.879 MB   | 14.8 k allocs: 0.689 MB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                                  | 1.35 k allocs: 0.046 MB   | 0.895 k allocs: 0.0336 MB | 1.37                       |
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
| AD gradients/Recurrence removals from recent outputs/Enzyme reverse                                      |                           | 0.199 k allocs: 13 kB     |                            |
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
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme reverse                              |                           | 0.355 k allocs: 19.9 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                                      |                           | 2.51 k allocs: 0.347 MB   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                                   |                           | 0.234 k allocs: 0.0975 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff                     |                           | 0.274 k allocs: 0.112 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/Mooncake forward                        |                           | 12 k allocs: 0.643 MB     |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Enzyme forward                      |                           | 3.2 k allocs: 0.221 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                                 |                           | 0.904 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse        |                           | 0.103 k allocs: 4.42 kB   |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                              |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                                     |                           | 3.14 k allocs: 0.209 MB   |                            |
| Convolution methods/S 1 T 200 L 64/Direct forward                                                        |                           | 6  allocs: 4.91 kB        |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake reverse                                       |                           | 1.02 k allocs: 0.0361 MB  |                            |
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
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                           |                           | 0.533 k allocs: 22.2 kB   |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Mooncake reverse                            |                           | 0.997 k allocs: 0.0389 MB |                            |
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
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse                     |                           | 1.03 k allocs: 0.0379 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                          |                           | 0.327 k allocs: 18.2 kB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme forward                        |                           | 5.65 k allocs: 0.455 MB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse          |                           | 0.053 k allocs: 3.42 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                               |                           | 4.61 k allocs: 0.325 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                       |                           | 0.952 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                                  |                           | 2.38 k allocs: 0.163 MB   |                            |
| AD gradients/Recurrence protected pool in Float32/ForwardDiff                                            |                           | 0.418 k allocs: 0.0893 MB |                            |
| AD gradients/Recurrence removals from recent outputs/ForwardDiff                                         |                           | 0.227 k allocs: 0.108 MB  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct forward                                                      |                           | 9  allocs: 0.046 MB       |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                                |                           | 0.336 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                            |                           | 0.699 k allocs: 24.2 kB   |                            |
| Convolution methods/S 50 T 200 L 64/Direct forward                                                       |                           | 9  allocs: 0.229 MB       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                                |                           | 0.596 k allocs: 0.195 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme reverse                           |                           | 0.177 k allocs: 16.5 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                                    |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                                   |                           | 12.4 k allocs: 0.599 MB   |                            |
| AD gradients/NoAdjoint Recurrence routes in a buffer deeper than the kernels/Mooncake forward            |                           | 28 k allocs: 1.28 MB      |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake reverse                             |                           | 1.03 k allocs: 0.036 MB   |                            |
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
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                        |                           | 0.272 k allocs: 0.102 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse                 |                           | 0.248 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake reverse                    |                           | 1.09 k allocs: 0.0364 MB  |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                              |                           | 13.9 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse                  |                           | 0.163 k allocs: 11.3 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                                    |                           | 4.54 k allocs: 0.451 MB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                                 |                           | 0.177 k allocs: 8.16 kB   |                            |
| AD gradients/Recurrence routes, dense and sparse/ForwardDiff                                             |                           | 0.356 k allocs: 0.135 MB  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme reverse                                 |                           | 0.539 k allocs: 0.0517 MB |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/ForwardDiff                         |                           | 0.282 k allocs: 0.109 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                                 |                           | 5.77 k allocs: 0.419 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                       |                           | 21.2 k allocs: 0.957 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                             |                           | 0.621 k allocs: 0.0488 MB |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme forward       |                           | 2.34 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                       |                           | 0.675 k allocs: 0.0356 MB |                            |
| AD gradients/Recurrence capacity, stock with overflow/Mooncake reverse                                   |                           | 0.556 k allocs: 23.6 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                                     |                           | 1.19 k allocs: 0.0457 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct Mooncake gradient                                           |                           | 31  allocs: 1.23 MB       |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                                |                           | 0.783 k allocs: 31.1 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                                   |                           | 0.23 k allocs: 0.0895 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                              |                           | 0.982 k allocs: 0.0327 MB |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake reverse                                        |                           | 1.17 k allocs: 0.0441 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake reverse                         |                           | 0.542 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                        |                           | 1.89 k allocs: 0.175 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                           |                           | 0.14 k allocs: 0.0463 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/ForwardDiff                                   |                           | 0.38 k allocs: 0.137 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse                    |                           | 0.088 k allocs: 5.27 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                         |                           | 2.45 k allocs: 0.172 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                             |                           | 5.28 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                             |                           | 0.963 k allocs: 0.0351 MB |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme reverse           |                           | 0.287 k allocs: 17.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Mooncake forward            |                           | 0.0406 M allocs: 2.34 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/ForwardDiff                           |                           | 1.8 k allocs: 0.209 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                               |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                       |                           | 11.5 k allocs: 0.524 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward                      |                           | 0.0472 M allocs: 2.33 MB  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse                  |                           | 0.113 k allocs: 5.33 kB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                                      |                           | 0.15 k allocs: 12.8 kB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                                 |                           | 0.331 k allocs: 20.6 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward                  |                           | 2.91 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                               |                           | 1.09 k allocs: 0.0351 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/FFT forward                                                        |                           | 25  allocs: 0.581 MB      |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                         |                           | 4.52 k allocs: 0.319 MB   |                            |
| Convolution methods/S 1 T 200 L 64/Direct Mooncake gradient                                              |                           | 22  allocs: 14 kB         |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme forward                                    |                           | 2.85 k allocs: 0.214 MB   |                            |
| AD gradients/Recurrence routes, dense and sparse/Mooncake forward                                        |                           | 22.8 k allocs: 0.978 MB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse               |                           | 0.632 k allocs: 27.1 kB   |                            |
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
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme forward                               |                           | 5.87 k allocs: 0.357 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                          |                           | 0.587 k allocs: 0.192 MB  |                            |
| AD gradients/Recurrence routes folded on scaled identities/Mooncake reverse                              |                           | 1.05 k allocs: 0.0361 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse                    |                           | 0.96 k allocs: 31.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                                    |                           | 0.129 k allocs: 11.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                            |                           | 0.303 k allocs: 0.161 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                         |                           | 16.9 k allocs: 0.927 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/ForwardDiff                     |                           | 0.117 k allocs: 0.0811 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                          |                           | 0.298 k allocs: 19.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with smoothly truncated draws/Mooncake reverse               |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                       |                           | 5.87 k allocs: 0.428 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                             |                           | 21.5 k allocs: 0.972 MB   |                            |
| AD gradients/NoAdjoint Recurrence floored depletion with a differentiated heterogeneity/Enzyme reverse   |                           | 0.287 k allocs: 17.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward          |                           | 0.063 k allocs: 3.91 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                           |                           | 0.217 k allocs: 0.0845 MB |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                       |                           | 0.452 k allocs: 0.237 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                                  |                           | 0.479 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                       |                           | 0.391 k allocs: 27.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse                  |                           | 0.846 k allocs: 0.0315 MB |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                                     |                           | 0.0398 M allocs: 2.03 MB  |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme forward                       |                           | 12.4 k allocs: 1.27 MB    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                          |                           | 9.98 k allocs: 0.717 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                         |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/Recurrence removals from recent outputs/Enzyme forward                                      |                           | 2.48 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                                 |                           | 0.202 k allocs: 0.0499 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme reverse              |                           | 0.713 k allocs: 0.0512 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                        |                           | 0.296 k allocs: 20.3 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake reverse                                    |                           | 1.1 k allocs: 0.04 MB     |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme forward                                         |                           | 5.77 k allocs: 0.348 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme reverse                  |                           | 0.059 k allocs: 8.95 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward                      |                           | 2.48 k allocs: 0.174 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                            |                           | 0.212 k allocs: 0.0765 MB |                            |
| Convolution methods/S 1 T 300 L 60/FFT Mooncake gradient                                                 |                           | 0.065 k allocs: 0.0462 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme reverse                            |                           | 0.363 k allocs: 25.7 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                        |                           | 0.581 k allocs: 0.198 MB  |                            |
| AD gradients/NoAdjoint Recurrence depletion with truncated draws/ForwardDiff                             |                           | 0.267 k allocs: 0.12 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Mooncake forward         |                           | 11 k allocs: 0.519 MB     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                            |                           | 0.436 k allocs: 0.15 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                      |                           | 0.266 k allocs: 0.0965 MB |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse                      |                           | 0.754 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                          |                           | 3.42 k allocs: 0.255 MB   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                                |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                         |                           | 0.266 k allocs: 0.0989 MB |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Mooncake reverse                          |                           | 0.631 k allocs: 23.8 kB   |                            |
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
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse                |                           | 0.333 k allocs: 24.4 kB   |                            |
| Convolution methods/S 1 T 2000 L 32/Direct Mooncake gradient                                             |                           | 30  allocs: 0.123 MB      |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Mooncake reverse                         |                           | 0.831 k allocs: 0.0319 MB |                            |
| Convolution methods/S 50 T 200 L 64/FFT Mooncake gradient                                                |                           | 0.065 k allocs: 1.14 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                 |                           | 0.834 k allocs: 30.6 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                                     |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake reverse                |                           | 0.103 k allocs: 7 kB      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                                     |                           | 0.28 k allocs: 18.3 kB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                       |                           | 9.13 k allocs: 0.678 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme forward                                |                           | 3.13 k allocs: 0.219 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/ForwardDiff          |                           | 0.262 k allocs: 0.121 MB  |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Mooncake reverse                               |                           | 1.27 k allocs: 0.0604 MB  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward                    |                           | 3.96 k allocs: 0.32 MB    |                            |
| AD gradients/NoAdjoint Recurrence routes folded on scaled identities/Mooncake forward                    |                           | 16.6 k allocs: 0.705 MB   |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Mooncake reverse                      |                           | 1.24 k allocs: 0.0482 MB  |                            |
| AD gradients/Recurrence capacity, stock with overflow/ForwardDiff                                        |                           | 0.232 k allocs: 0.116 MB  |                            |
| Convolution methods/S 1 T 2000 L 100/Direct Mooncake gradient                                            |                           | 30  allocs: 0.124 MB      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                           |                           | 0.0373 M allocs: 1.85 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs/Mooncake forward                                    |                           | 18.9 k allocs: 0.832 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward                      |                           | 10.3 k allocs: 0.469 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                       |                           | 0.408 k allocs: 26.6 kB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                       |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                               |                           | 0.683 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Enzyme reverse                               |                           | 0.394 k allocs: 25.5 kB   |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                            |                           | 17.3 k allocs: 0.816 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake forward                  |                           | 22.1 k allocs: 1.11 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                         |                           | 0.181 k allocs: 0.0406 MB |                            |
| AD gradients/Recurrence capacity, weekly budget with a queue/Enzyme forward                              |                           | 5.3 k allocs: 0.4 MB      |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                            |                           | 10.7 k allocs: 0.424 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                           |                           | 0.75 k allocs: 0.277 MB   |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/ForwardDiff                                  |                           | 0.426 k allocs: 0.0904 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                             |                           | 0.34 k allocs: 23.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                                   |                           | 0.371 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse                      |                           | 0.825 k allocs: 0.0323 MB |                            |
| AD gradients/Recurrence depletion with truncated draws/Mooncake reverse                                  |                           | 0.832 k allocs: 0.0337 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Mooncake forward                          |                           | 19.2 k allocs: 0.846 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                   |                           | 2.85 k allocs: 0.222 MB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                                  |                           | 0.274 k allocs: 17.3 kB   |                            |
| AD gradients/Recurrence protected pool in Float32/Enzyme reverse                                         |                           | 0.334 k allocs: 17.9 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake forward                      |                           | 0.0403 M allocs: 2.33 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                               |                           | 0.288 k allocs: 20.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Enzyme forward                  |                           | 0.807 k allocs: 0.103 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Mooncake forward                         |                           | 9.19 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                                |                           | 0.786 k allocs: 0.261 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward                |                           | 10.1 k allocs: 0.725 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                         |                           | 0.226 k allocs: 0.0894 MB |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse                      |                           | 0.749 k allocs: 26.2 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                           |                           | 1.09 k allocs: 0.0546 MB  |                            |
| AD gradients/NoAdjoint Recurrence routes, dense and sparse/Mooncake forward                              |                           | 23.5 k allocs: 1.04 MB    |                            |
| AD gradients/Recurrence routes in a buffer deeper than the kernels/Enzyme reverse                        |                           | 0.409 k allocs: 28.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward                  |                           | 17.6 k allocs: 0.831 MB   |                            |
| AD gradients/Recurrence routes folded on scaled identities/Enzyme reverse                                |                           | 0.288 k allocs: 14.4 kB   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                                     |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme forward                           |                           | 2.95 k allocs: 0.221 MB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward                  |                           | 4.41 k allocs: 0.263 MB   |                            |
| AD gradients/Recurrence protected pool in Float32/Mooncake forward                                       |                           | 22.8 k allocs: 0.929 MB   |                            |
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
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme reverse                            |                           | 0.203 k allocs: 19.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                   |                           | 0.22 k allocs: 15.8 kB    |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/Enzyme forward              |                           | 7.52 k allocs: 0.72 MB    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                        |                           | 0.221 k allocs: 14.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, stock with overflow/Enzyme forward                           |                           | 2.02 k allocs: 0.183 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward     |                           | 10.2 k allocs: 0.584 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                          |                           | 0.722 k allocs: 0.258 MB  |                            |
| Convolution methods/S 50 T 200 L 64/FFT forward                                                          |                           | 25  allocs: 0.441 MB      |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff                    |                           | 0.49 k allocs: 0.2 MB     |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                                     |                           | 1.25 k allocs: 0.114 MB   |                            |
| AD gradients/NoAdjoint Recurrence depletion with a differentiated heterogeneity/Enzyme forward           |                           | 2.97 k allocs: 0.184 MB   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                        |                           | 0.21 k allocs: 14.2 kB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff                   |                           | 0.746 k allocs: 0.357 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward        |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Mooncake forward               |                           | 10.2 k allocs: 0.585 MB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Mooncake reverse                      |                           | 1.37 k allocs: 0.0708 MB  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/Enzyme forward                            |                           | 4.41 k allocs: 0.314 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                              |                           | 0.226 k allocs: 0.0887 MB |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                           |                           | 30.7 k allocs: 1.42 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                                   |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs across strata/ForwardDiff                 |                           | 1.8 k allocs: 0.21 MB     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff                      |                           | 0.05 k allocs: 9.29 kB    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                       |                           | 0.331 k allocs: 0.148 MB  |                            |
| AD gradients/Recurrence feedback from recent outputs/ForwardDiff                                         |                           | 0.332 k allocs: 0.128 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                               |                           | 1.02 k allocs: 0.039 MB   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                              |                           | 0.6 k allocs: 24.6 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse                      |                           | 0.317 k allocs: 17.5 kB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                             |                           | 0.734 k allocs: 0.356 MB  |                            |
| AD gradients/NoAdjoint Recurrence protected pool in Float32/Mooncake forward                             |                           | 23.2 k allocs: 0.95 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                                     |                           | 0.715 k allocs: 29.3 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                              |                           | 0.458 k allocs: 0.199 MB  |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse       |                           | 0.214 k allocs: 18.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                                 |                           | 0.847 k allocs: 0.0315 MB |                            |
| AD gradients/NoAdjoint Recurrence ward with competing flows (Flows)/Enzyme reverse                       |                           | 0.516 k allocs: 0.0568 MB |                            |
| Convolution methods/S 1 T 2000 L 100/FFT forward                                                         |                           | 25  allocs: 0.071 MB      |                            |
| AD gradients/Recurrence depletion with truncated draws/ForwardDiff                                       |                           | 0.262 k allocs: 0.119 MB  |                            |
| AD gradients/Recurrence routes, dense and sparse/Enzyme reverse                                          |                           | 0.323 k allocs: 21.2 kB   |                            |
| AD gradients/Recurrence feedback from recent outputs across strata/Enzyme reverse                        |                           | 0.841 k allocs: 0.0565 MB |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                                    |                           | 0.39 k allocs: 0.0646 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                        |                           | 0.042 k allocs: 6.62 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                             |                           | 0.396 k allocs: 27.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                                 |                           | 0.812 k allocs: 0.0408 MB |                            |
| AD gradients/Recurrence capacity, dropped overflow after a truncated draw/Enzyme reverse                 |                           | 0.237 k allocs: 16.5 kB   |                            |
| Convolution methods/S 1 T 2000 L 32/FFT Mooncake gradient                                                |                           | 0.065 k allocs: 0.142 MB  |                            |
| AD gradients/NoAdjoint Recurrence feedback from recent outputs/ForwardDiff                               |                           | 0.338 k allocs: 0.129 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                                  |                           | 0.443 k allocs: 0.151 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                       |                           | 2.4 k allocs: 0.46 MB     |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Mooncake reverse                  |                           | 1.01 k allocs: 0.0387 MB  |                            |
| AD gradients/Recurrence depletion with truncated draws/Enzyme reverse                                    |                           | 0.265 k allocs: 15.8 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                                   |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/Recurrence depletion with smoothly truncated draws/Enzyme reverse                           |                           | 0.272 k allocs: 15.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse                    |                           | 0.292 k allocs: 19.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                             |                           | 0.29 k allocs: 0.114 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/ForwardDiff                       |                           | 0.471 k allocs: 0.2 MB    |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                                |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward                 |                           | 1.11 k allocs: 0.0559 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                        |                           | 0.902 k allocs: 0.0329 MB |                            |
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
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                             |                           | 0.211 k allocs: 14.6 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                         |                           | 12.7 k allocs: 0.543 MB   |                            |
| AD gradients/NoAdjoint Recurrence array-field and scalar-field modifiers/Mooncake forward                |                           | 2.47 k allocs: 0.272 MB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                                      |                           | 0.069 k allocs: 0.0332 MB |                            |
| Convolution methods/S 1 T 200 L 32/Direct Mooncake gradient                                              |                           | 22  allocs: 13.8 kB       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                         |                           | 0.303 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward                 |                           | 4.71 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                                |                           | 0.434 k allocs: 0.13 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse                 |                           | 0.558 k allocs: 22.9 kB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                                    |                           | 1.13 k allocs: 0.0395 MB  |                            |
| AD gradients/Recurrence capacity, stock with overflow/Enzyme reverse                                     |                           | 0.201 k allocs: 13.2 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                           |                           | 0.239 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward               |                           | 17.9 k allocs: 0.98 MB    |                            |
| Convolution methods/S 50 T 200 L 64/Direct Mooncake gradient                                             |                           | 30  allocs: 0.612 MB      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                            |                           | 0.897 k allocs: 0.0348 MB |                            |
| AD gradients/NoAdjoint Recurrence capacity, dropped overflow after a truncated draw/Mooncake reverse     |                           | 0.61 k allocs: 24.6 kB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                                     |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                                    |                           | 0.442 k allocs: 0.16 MB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse              |                           | 1.06 k allocs: 0.0389 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                        |                           | 1.06 k allocs: 0.0403 MB  |                            |
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
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                                   |                           | 0.849 k allocs: 30.7 kB   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/Enzyme forward                                 |                           | 12.2 k allocs: 1.24 MB    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                                |                           | 0.049 k allocs: 9.18 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                                     |                           | 30.3 k allocs: 1.39 MB    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                                |                           | 0.641 k allocs: 0.27 MB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                                      |                           | 0.458 k allocs: 0.131 MB  |                            |
| Convolution methods/S 1 T 20000 L 500/Direct forward                                                     |                           | 9  allocs: 0.458 MB       |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                    |                           | 0.153 k allocs: 13.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward                    |                           | 13.7 k allocs: 0.586 MB   |                            |
| AD gradients/Recurrence feedback from recent outputs/Enzyme reverse                                      |                           | 0.352 k allocs: 20.8 kB   |                            |
| AD gradients/Recurrence ward with competing flows (Flows)/ForwardDiff                                    |                           | 1.22 k allocs: 0.39 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward                   |                           | 0.349 k allocs: 24.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence removals from recent outputs/Enzyme forward                            |                           | 2.48 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence capacity, weekly budget with a queue/Enzyme forward                    |                           | 5.39 k allocs: 0.407 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                           |                           | 0.0419 M allocs: 2.16 MB  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                              |                           | 3.87 k allocs: 0.311 MB   |                            |
| time_to_load                                                                                             | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

