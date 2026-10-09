|                                                                                                   | v0.1.0              | 0c59e91674a68b...   | v0.1.0 / 0c59e91674a68b... |
|:--------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.0666 ± 0.0045 ms  | 0.0646 ± 0.0063 ms  | 1.03 ± 0.12                |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 0.0326 ± 0.0006 ms  | 30.9 ± 1.2 μs       | 1.05 ± 0.047               |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 9.7 ± 1.7 μs        | 4.21 ± 0.41 μs      | 2.3 ± 0.46                 |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 0.223 ± 0.037 ms    | 0.228 ± 0.05 ms     | 0.98 ± 0.27                |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.052 ± 0.0032 ms   | 0.0437 ± 0.0064 ms  | 1.19 ± 0.19                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 0.257 ± 0.021 ms    | 0.252 ± 0.011 ms    | 1.02 ± 0.095               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.0433 ± 0.00095 ms | 0.0345 ± 0.00078 ms | 1.25 ± 0.039               |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.0343 ± 0.0016 ms  | 0.0333 ± 0.0024 ms  | 1.03 ± 0.088               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 1 ± 0.22 ms         | 0.906 ± 0.034 ms    | 1.1 ± 0.25                 |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.0639 ± 0.0027 ms  | 0.0436 ± 0.001 ms   | 1.47 ± 0.071               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 0.329 ± 0.016 ms    | 0.337 ± 0.02 ms     | 0.975 ± 0.074              |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 0.0386 ± 0.00073 ms | 0.0341 ± 0.00078 ms | 1.13 ± 0.034               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.0385 ± 0.002 ms   | 0.0418 ± 0.0032 ms  | 0.922 ± 0.084              |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 0.988 ± 0.11 ms     | 1.09 ± 0.043 ms     | 0.907 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.0643 ± 0.0072 ms  | 0.0439 ± 0.0011 ms  | 1.46 ± 0.17                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 0.625 ± 0.028 ms    | 0.614 ± 0.033 ms    | 1.02 ± 0.072               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 0.0316 ± 0.00094 ms | 27.9 ± 0.81 μs      | 1.14 ± 0.047               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.08 ± 0.0045 ms    | 0.0704 ± 0.0088 ms  | 1.14 ± 0.16                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 1.86 ± 0.48 ms      | 1.24 ± 0.095 ms     | 1.5 ± 0.4                  |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.0596 ± 0.003 ms   | 0.0343 ± 0.001 ms   | 1.74 ± 0.1                 |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.316 ± 0.015 ms    | 0.724 ± 0.43 ms     | 0.436 ± 0.26               |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.366 ± 0.3 ms      | 0.643 ± 0.3 ms      | 0.569 ± 0.53               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 7.46 ± 4.5 ms       | 11.7 ± 4.5 ms       | 0.635 ± 0.45               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 0.0509 ± 0.015 s    | 0.0497 ± 0.011 s    | 1.02 ± 0.38                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 1.41 ± 0.02 ms      | 0.324 ± 0.05 ms     | 4.36 ± 0.67                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 0.0762 ± 0.0012 s   | 0.0447 ± 0.0076 s   | 1.7 ± 0.29                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 1.29 ± 0.038 ms     | 0.348 ± 0.017 ms    | 3.71 ± 0.21                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 29.7 ± 12 μs        | 11.8 ± 6.7 μs       | 2.52 ± 1.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 0.399 ± 0.014 ms    | 0.366 ± 0.68 ms     | 1.09 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.0597 ± 0.004 ms   | 16.1 ± 2.3 μs       | 3.7 ± 0.58                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.0618 ± 0.013 ms   | 0.0405 ± 0.0073 ms  | 1.53 ± 0.43                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 0.452 ± 0.017 ms    | 0.413 ± 0.018 ms    | 1.09 ± 0.064               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.108 ± 0.012 ms    | 0.0578 ± 0.0084 ms  | 1.87 ± 0.34                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 0.704 ± 0.015 ms    | 0.0848 ± 0.0021 ms  | 8.31 ± 0.27                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 18.7 ± 0.4 ms       | 7.37 ± 1.4 ms       | 2.54 ± 0.48                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 0.608 ± 0.061 ms    | 0.104 ± 0.0028 ms   | 5.84 ± 0.61                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.0861 ± 0.015 ms   | 0.0606 ± 0.0095 ms  | 1.42 ± 0.34                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 2.7 ± 0.031 ms      | 1.32 ± 0.62 ms      | 2.05 ± 0.97                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 0.143 ± 0.022 ms    | 0.0801 ± 0.0036 ms  | 1.79 ± 0.28                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 0.936 ± 0.021 ms    | 0.193 ± 0.0075 ms   | 4.84 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 0.0692 ± 0.0028 s   | 0.0396 ± 0.00026 s  | 1.75 ± 0.071               |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 0.833 ± 0.019 ms    | 0.259 ± 0.013 ms    | 3.22 ± 0.18                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 1.1 ± 0.057 ms      | 0.913 ± 0.094 ms    | 1.2 ± 0.14                 |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.145 ± 0.011 ms    | 0.101 ± 0.003 ms    | 1.44 ± 0.12                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.118 ± 0.0074 ms   | 0.135 ± 0.0099 ms   | 0.873 ± 0.085              |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 3.58 ± 0.53 ms      | 3.55 ± 0.092 ms     | 1.01 ± 0.15                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 0.171 ± 0.0064 ms   | 0.133 ± 0.014 ms    | 1.28 ± 0.14                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 0.25 ± 0.025 ms     | 0.21 ± 0.02 ms      | 1.19 ± 0.16                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.0607 ± 0.0042 ms  | 0.046 ± 0.0027 ms   | 1.32 ± 0.12                |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.0412 ± 0.021 ms   | 0.0414 ± 0.0036 ms  | 0.996 ± 0.52               |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 0.921 ± 0.042 ms    | 0.697 ± 0.043 ms    | 1.32 ± 0.1                 |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 0.0886 ± 0.0065 ms  | 0.0686 ± 0.0042 ms  | 1.29 ± 0.12                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 0.407 ± 0.05 ms     | 0.403 ± 0.053 ms    | 1.01 ± 0.18                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.0669 ± 0.003 ms   | 0.0423 ± 0.00089 ms | 1.58 ± 0.079               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.067 ± 0.008 ms    | 0.0883 ± 0.0039 ms  | 0.759 ± 0.096              |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 1.4 ± 0.023 ms      | 1.67 ± 0.025 ms     | 0.836 ± 0.018              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.0867 ± 0.0018 ms  | 0.0567 ± 0.0021 ms  | 1.53 ± 0.066               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 0.378 ± 0.024 ms    | 0.322 ± 0.032 ms    | 1.17 ± 0.14                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.058 ± 0.0014 ms   | 0.0506 ± 0.0012 ms  | 1.15 ± 0.039               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.071 ± 0.014 ms    | 0.0525 ± 0.0035 ms  | 1.35 ± 0.28                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 1.39 ± 0.14 ms      | 1.1 ± 0.017 ms      | 1.26 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 0.0911 ± 0.0057 ms  | 0.0688 ± 0.0025 ms  | 1.32 ± 0.096               |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.0729 ± 0.0018 ms  | 0.0681 ± 0.0017 ms  | 1.07 ± 0.037               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.0419 ± 0.003 ms   | 0.0423 ± 0.0033 ms  | 0.99 ± 0.1                 |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 13 ± 3.1 μs         | 11.1 ± 1.9 μs       | 1.17 ± 0.34                |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 0.229 ± 0.016 ms    | 0.201 ± 0.021 ms    | 1.14 ± 0.14                |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.0703 ± 0.004 ms   | 0.0553 ± 0.0039 ms  | 1.27 ± 0.11                |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 0.419 ± 0.041 ms    | 0.29 ± 0.019 ms     | 1.44 ± 0.17                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.0754 ± 0.0065 ms  | 0.0723 ± 0.003 ms   | 1.04 ± 0.1                 |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.067 ± 0.034 ms    | 0.0624 ± 0.0044 ms  | 1.07 ± 0.55                |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 1.37 ± 0.14 ms      | 1.25 ± 0.029 ms     | 1.1 ± 0.11                 |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 0.143 ± 0.0096 ms   | 0.0925 ± 0.0031 ms  | 1.54 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 0.14 ± 0.007 ms     | 0.13 ± 0.0069 ms    | 1.08 ± 0.079               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 29.6 ± 4.1 μs       | 0.0441 ± 0.0012 ms  | 0.673 ± 0.096              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 26.6 ± 2.3 μs       | 23.6 ± 2.3 μs       | 1.13 ± 0.15                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 0.304 ± 0.024 ms    | 0.39 ± 0.019 ms     | 0.779 ± 0.072              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.0553 ± 0.0016 ms  | 0.0536 ± 0.0043 ms  | 1.03 ± 0.089               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 0.265 ± 0.045 ms    | 0.235 ± 0.026 ms    | 1.13 ± 0.23                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.0774 ± 0.0022 ms  | 0.049 ± 0.0034 ms   | 1.58 ± 0.12                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 31.2 ± 1.9 μs       | 0.0367 ± 0.0035 ms  | 0.851 ± 0.096              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 0.808 ± 0.13 ms     | 0.884 ± 0.039 ms    | 0.913 ± 0.15               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 0.0897 ± 0.006 ms   | 0.0707 ± 0.0054 ms  | 1.27 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 0.535 ± 0.023 ms    | 0.361 ± 0.024 ms    | 1.48 ± 0.12                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.0997 ± 0.0079 ms  | 0.0645 ± 0.0022 ms  | 1.55 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.0673 ± 0.0028 ms  | 0.0636 ± 0.0061 ms  | 1.06 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 1.84 ± 0.29 ms      | 1.6 ± 0.064 ms      | 1.15 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 0.127 ± 0.0036 ms   | 0.0927 ± 0.0022 ms  | 1.38 ± 0.051               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 1.22 ± 0.26 ms      | 1.15 ± 0.24 ms      | 1.06 ± 0.32                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.066 ± 0.006 ms    | 0.0548 ± 0.0018 ms  | 1.21 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.127 ± 0.0069 ms   | 0.144 ± 0.008 ms    | 0.881 ± 0.068              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 3.81 ± 0.86 ms      | 4.13 ± 0.78 ms      | 0.922 ± 0.27               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.0948 ± 0.0061 ms  | 0.0764 ± 0.006 ms   | 1.24 ± 0.13                |
| Convolution body/BLAS axpy per lag                                                                | 0.776 ± 0.0031 μs   | 0.779 ± 0.0031 μs   | 0.997 ± 0.0057             |
| Convolution body/native axpy per lag                                                              | 0.496 ± 0.0058 μs   | 0.496 ± 0.0071 μs   | 0.998 ± 0.018              |
| Convolution body/package                                                                          | 0.776 ± 0.0034 μs   | 0.366 ± 0.0078 μs   | 2.12 ± 0.046               |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.0716 ± 0.0015 ms  | 0.0635 ± 0.0012 ms  | 1.13 ± 0.031               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 4.18 ± 0.23 μs      | 3.98 ± 0.23 μs      | 1.05 ± 0.084               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 2.68 ± 1.6 μs       | 2.09 ± 0.36 μs      | 1.28 ± 0.81                |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.0506 ± 0.017 ms   | 0.044 ± 0.015 ms    | 1.15 ± 0.55                |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 9.96 ± 1.8 μs       | 9.91 ± 1.8 μs       | 1.01 ± 0.26                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.0499 ± 0.0018 ms  | 0.0394 ± 0.00075 ms | 1.27 ± 0.052               |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                     | 0.131 ± 0.0041 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                     | 0.0537 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                     | 2.77 ± 0.035 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                     | 0.0488 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                     | 0.417 ± 0.018 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                     | 0.0376 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                     | 0.0481 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                     | 0.952 ± 0.0068 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                     | 17.1 ± 0.45 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                     | 1.58 ± 0.52 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                     | 0.327 ± 0.042 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                     | 2.39 ± 0.13 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                     | 0.0477 ± 0.0012 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                     | 0.93 ± 0.12 ms      |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                     | 0.0679 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                     | 0.0611 ± 0.0015 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                     | 4.9 ± 0.045 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                     | 0.0583 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                     | 1.09 ± 0.042 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                     | 0.124 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                     | 0.246 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                     | 0.244 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                     | 0.133 ± 0.004 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                     | 0.0826 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                     | 3.74 ± 0.43 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                     | 0.452 ± 0.021 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                     | 0.0884 ± 0.003 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                     | 0.246 ± 0.034 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                     | 0.0696 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                     | 0.0868 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                     | 0.152 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                     | 1.89 ± 0.46 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                     | 1.45 ± 0.021 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                     | 0.0838 ± 0.002 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                     | 0.883 ± 0.02 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                     | 1.33 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                     | 0.839 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                     | 1.56 ± 0.053 ms     |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                     | 1.63 ± 0.25 μs      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                     | 0.0418 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                     | 0.254 ± 0.039 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                     | 0.0508 ± 0.00092 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                     | 23.9 ± 3.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                     | 0.0673 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                     | 0.0409 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                     | 1.14 ± 0.084 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                     | 0.0377 ± 0.0008 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                     | 0.66 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                     | 0.0408 ± 0.0035 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                     | 0.699 ± 0.03 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                     | 1.9 ± 0.49 ms       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                     | 0.129 ± 0.0036 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                     | 0.171 ± 0.0062 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                     | 0.118 ± 0.0063 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                     | 0.0687 ± 0.0022 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                     | 0.0388 ± 0.0076 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                     | 0.113 ± 0.0026 ms   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                     | 0.252 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                     | 31.5 ± 14 μs        |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                     | 11.1 ± 1.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                     | 0.28 ± 0.015 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                     | 0.381 ± 0.05 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                     | 0.105 ± 0.0042 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                     | 1.18 ± 0.065 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                     | 0.899 ± 0.28 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                     | 4.14 ± 0.1 ms       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                     | 19.1 ± 1.4 μs       |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                     | 0.0388 ± 0.00081 ms |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                     | 0.0839 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                     | 0.355 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                     | 0.146 ± 0.005 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                     | 0.468 ± 0.049 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                     | 0.247 ± 0.04 ms     |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                     | 0.254 ± 0.027 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                     | 0.0537 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                     | 0.047 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                     | 0.0789 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                     | 0.0547 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                     | 0.4 ± 0.062 ms      |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                     | 0.149 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                     | 0.124 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                     | 31 ± 0.68 μs        |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                     | 0.0848 ± 0.0042 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                     | 0.989 ± 0.15 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                     | 0.0638 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                     | 0.636 ± 0.09 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                     | 1.72 ± 0.049 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                     | 1.66 ± 0.28 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                     | 0.0385 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                     | 0.0908 ± 0.006 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                     | 0.0579 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                     | 0.102 ± 0.0023 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                     | 3.26 ± 0.09 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                     | 1.15 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                     | 0.0552 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                     | 0.0478 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                     | 0.0612 ± 0.0036 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                     | 0.233 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                     | 0.034 ± 0.0076 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                     | 0.276 ± 0.012 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                     | 0.0748 ± 0.016 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                     | 0.0593 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                     | 0.0604 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                     | 0.367 ± 0.033 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                     | 0.383 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                     | 0.047 ± 0.0021 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                     | 0.248 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                     | 0.481 ± 0.021 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                     | 15.4 ± 0.64 μs      |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                     | 0.0505 ± 0.0013 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                     | 0.132 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                     | 1.01 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                     | 0.139 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                     | 0.0607 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                     | 12.6 ± 2.3 μs       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                     | 0.167 ± 0.0096 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                     | 0.0567 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                     | 0.083 ± 0.0023 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                     | 1.01 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                     | 0.0347 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                     | 1.25 ± 0.24 μs      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                     | 0.0814 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                     | 0.0849 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                     | 0.0664 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                     | 0.0709 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                     | 0.939 ± 0.091 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                     | 3.63 ± 0.87 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                     | 0.868 ± 0.024 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                     | 0.104 ± 0.0031 ms   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                     | 1.28 ± 0.22 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                     | 0.068 ± 0.0046 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                     | 0.0809 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                     | 0.916 ± 0.056 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                     | 0.166 ± 0.013 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                     | 0.0324 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                     | 0.0618 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                     | 0.092 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                     | 0.331 ± 0.016 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                     | 0.0497 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                     | 0.0894 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                     | 0.242 ± 0.077 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                     | 1.18 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                     | 0.0445 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                     | 0.0783 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                     | 0.116 ± 0.0058 ms   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                     | 0.0688 ± 0.0039 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                     | 0.0421 ± 0.031 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                     | 0.375 ± 0.056 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                     | 0.0583 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                     | 0.725 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                     | 0.73 ± 0.018 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                     | 0.343 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                     | 2.22 ± 0.055 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                     | 0.0621 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                     | 0.0559 ± 0.0043 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                     | 0.14 ± 0.0055 ms    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                     | 0.0713 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                     | 1.29 ± 0.016 ms     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                     | 0.0406 ± 0.00085 ms |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                     | 0.172 ± 0.0075 ms   |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                     | 15.3 ± 0.65 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                     | 0.0417 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                     | 2.69 ± 0.049 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                     | 0.114 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                     | 10.1 ± 1.2 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                     | 0.127 ± 0.0088 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                     | 0.056 ± 0.0029 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                     | 0.0749 ± 0.0021 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                     | 0.187 ± 0.15 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                     | 0.0655 ± 0.0029 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                     | 0.0483 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                     | 0.09 ± 0.002 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                     | 0.0626 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                     | 11.1 ± 1.6 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                     | 0.096 ± 0.0025 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                     | 0.0752 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                     | 0.077 ± 0.0047 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                     | 1.04 ± 0.051 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                     | 0.256 ± 0.0083 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                     | 0.0632 ± 0.039 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                     | 0.509 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                     | 0.118 ± 0.0092 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                     | 0.107 ± 0.0034 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                     | 0.763 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                     | 0.0582 ± 0.0033 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                     | 0.036 ± 0.00091 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                     | 1.38 ± 0.033 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                     | 0.081 ± 0.0016 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                     | 0.0689 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                     | 1.57 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                     | 0.893 ± 0.056 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                     | 0.0525 ± 0.0032 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                     | 1.15 ± 0.075 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                     | 0.0344 ± 0.003 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                     | 0.0654 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                     | 0.341 ± 0.072 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                     | 0.0555 ± 0.015 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                     | 0.0764 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                     | 0.0993 ± 0.016 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                     | 0.0357 ± 0.00087 ms |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                     | 1.17 ± 0.071 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                     | 0.117 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                     | 0.0351 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                     | 0.137 ± 0.0067 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                     | 0.117 ± 0.0085 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                     | 0.0766 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                     | 1.55 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                     | 1.38 ± 0.039 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                     | 1.41 ± 0.029 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                     | 4.83 ± 0.11 ms      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                     | 0.394 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                     | 0.0725 ± 0.0027 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                     | 0.111 ± 0.0023 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                     | 10.8 ± 0.85 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                     | 2.9 ± 0.14 ms       |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                     | 0.113 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                     | 0.0647 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                     | 28.3 ± 2.9 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                     | 1.23 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                     | 0.0328 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                     | 3.75 ± 0.18 ms      |                            |
| time_to_load                                                                                      | 0.234 ± 0.00056 s   | 0.348 ± 0.0012 s    | 0.671 ± 0.0028             |

|                                                                                                   | v0.1.0                    | 0c59e91674a68b...         | v0.1.0 / 0c59e91674a68b... |
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
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.691 k allocs: 26.1 kB   | 0.675 k allocs: 28.7 kB   | 0.911                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 3.18 k allocs: 0.261 MB   | 2.9 k allocs: 0.239 MB    | 1.1                        |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.8 kB   | 0.91                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.29 k allocs: 0.13 MB    | 0.26 k allocs: 0.115 MB   | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 15.7 k allocs: 0.716 MB   | 14.3 k allocs: 0.658 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 1.15 k allocs: 0.0397 MB  | 0.847 k allocs: 0.0331 MB | 1.2                        |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.834 k allocs: 0.0414 MB | 0.786 k allocs: 0.0393 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 0.176 k allocs: 7.66 kB   | 0.22 k allocs: 10 kB      | 0.762                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 0.07 k allocs: 14.2 kB    | 0.062 k allocs: 13.3 kB   | 1.07                       |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 4.09 k allocs: 0.137 MB   | 3.73 k allocs: 0.131 MB   | 1.05                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.809 k allocs: 25.5 kB   | 0.677 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 3.93 k allocs: 0.263 MB   | 3.3 k allocs: 0.237 MB    | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.336 k allocs: 21.5 kB   | 0.392 k allocs: 21.3 kB   | 1.01                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.287 k allocs: 0.125 MB  | 0.277 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 15.9 k allocs: 0.718 MB   | 12.2 k allocs: 0.623 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 1.3 k allocs: 0.0436 MB   | 0.931 k allocs: 0.0355 MB | 1.23                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 1.5 k allocs: 0.132 MB    | 1.33 k allocs: 0.119 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 0.198 k allocs: 15.6 kB   | 0.272 k allocs: 21.2 kB   | 0.737                      |
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
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                           | 0.433 k allocs: 22.1 kB   |                            |
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
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                           | 0.186 k allocs: 9.86 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                           | 2.57 k allocs: 0.193 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                           | 5.43 k allocs: 0.339 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                           | 0.967 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                           | 11.7 k allocs: 0.564 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                           | 0.048 M allocs: 2.48 MB   |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                           | 0.201 k allocs: 9.67 kB   |                            |
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
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                           | 0.408 k allocs: 26.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                           | 0.346 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                           | 9.53 k allocs: 0.731 MB   |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                           | 0.0377 M allocs: 1.93 MB  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                           | 10.5 k allocs: 0.505 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                           | 0.528 k allocs: 0.0355 MB |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                           | 23  allocs: 2.38 kB       |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                           | 0.693 k allocs: 22.5 kB   |                            |
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
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                           | 0.183 k allocs: 0.0353 MB |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                           | 0.227 k allocs: 0.0997 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                           | 4.56 k allocs: 0.291 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                           | 0.26 k allocs: 17 kB      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                           | 1.17 k allocs: 0.21 MB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                           | 7.19 k allocs: 0.565 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                           | 0.225 k allocs: 15.8 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                           | 0.77 k allocs: 0.298 MB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                           | 0.514 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                           | 0.214 k allocs: 15.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                           | 0.782 k allocs: 0.401 MB  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                           | 0.173 k allocs: 10.4 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                           | 31.1 k allocs: 1.49 MB    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                           | 0.812 k allocs: 0.0708 MB |                            |
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
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                           | 0.466 k allocs: 0.188 MB  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                           | 0.157 k allocs: 7.34 kB   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                           | 1.08 k allocs: 0.0401 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                           | 1.14 k allocs: 0.0435 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                           | 0.346 k allocs: 17.3 kB   |                            |
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
| time_to_load                                                                                      | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

