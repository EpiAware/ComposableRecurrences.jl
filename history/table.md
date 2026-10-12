|                                                                                                   | v0.1.0              | 7d70afa479d050...   | v0.1.0 / 7d70afa479d050... |
|:--------------------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                        | 0.0541 ± 0.0054 ms  | 0.0517 ± 0.0057 ms  | 1.05 ± 0.16                |
| AD gradients/Convolution delay with history/Enzyme reverse                                        | 23.5 ± 0.54 μs      | 25.6 ± 1.7 μs       | 0.916 ± 0.064              |
| AD gradients/Convolution delay with history/ForwardDiff                                           | 8.53 ± 1.5 μs       | 4.57 ± 4.9 μs       | 1.87 ± 2                   |
| AD gradients/Convolution delay with history/Mooncake forward                                      | 0.202 ± 0.03 ms     | 0.187 ± 0.0065 ms   | 1.08 ± 0.17                |
| AD gradients/Convolution delay with history/Mooncake reverse                                      | 0.0347 ± 0.00075 ms | 0.0334 ± 0.0036 ms  | 1.04 ± 0.11                |
| AD gradients/Convolution per-stratum kernel with history/Enzyme forward                           | 0.215 ± 0.013 ms    | 0.209 ± 0.011 ms    | 1.03 ± 0.085               |
| AD gradients/Convolution per-stratum kernel with history/Enzyme reverse                           | 0.0326 ± 0.00089 ms | 26.7 ± 0.82 μs      | 1.22 ± 0.05                |
| AD gradients/Convolution per-stratum kernel with history/ForwardDiff                              | 0.0361 ± 0.0033 ms  | 0.0318 ± 0.0042 ms  | 1.13 ± 0.18                |
| AD gradients/Convolution per-stratum kernel with history/Mooncake forward                         | 0.708 ± 0.18 ms     | 0.72 ± 0.027 ms     | 0.984 ± 0.25               |
| AD gradients/Convolution per-stratum kernel with history/Mooncake reverse                         | 0.0434 ± 0.0024 ms  | 31 ± 1.2 μs         | 1.4 ± 0.095                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward                     | 0.29 ± 0.011 ms     | 0.305 ± 0.015 ms    | 0.953 ± 0.06               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse                     | 28 ± 0.77 μs        | 26.3 ± 0.79 μs      | 1.07 ± 0.043               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                        | 0.0392 ± 0.0023 ms  | 0.0416 ± 0.0041 ms  | 0.943 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward                   | 0.81 ± 0.085 ms     | 0.905 ± 0.061 ms    | 0.896 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse                   | 0.0439 ± 0.0029 ms  | 30.4 ± 1.5 μs       | 1.45 ± 0.12                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                       | 0.55 ± 0.034 ms     | 0.523 ± 0.03 ms     | 1.05 ± 0.089               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                       | 23.5 ± 0.7 μs       | 21.2 ± 0.82 μs      | 1.11 ± 0.054               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                          | 0.0781 ± 0.0053 ms  | 0.0768 ± 0.0051 ms  | 1.02 ± 0.096               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                                     | 1.6 ± 0.14 ms       | 1.01 ± 0.41 ms      | 1.58 ± 0.65                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                                     | 0.0367 ± 0.0025 ms  | 25.4 ± 2.5 μs       | 1.45 ± 0.17                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                       | 0.363 ± 0.012 ms    | 0.726 ± 0.37 ms     | 0.501 ± 0.25               |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                      | 0.643 ± 0.25 ms     | 0.645 ± 0.29 ms     | 0.997 ± 0.59               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                         | 13 ± 3.8 ms         | 11.4 ± 4.2 ms       | 1.14 ± 0.53                |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                                    | 0.0445 ± 0.0016 s   | 0.0461 ± 0.014 s    | 0.965 ± 0.29               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                          | 1.11 ± 0.22 ms      | 0.255 ± 0.0089 ms   | 4.37 ± 0.88                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                             | 0.0568 ± 0.00029 s  | 0.0498 ± 0.0016 s   | 1.14 ± 0.038               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                        | 0.913 ± 0.021 ms    | 0.268 ± 0.0098 ms   | 3.41 ± 0.15                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                         | 27 ± 3.4 μs         | 10.6 ± 6.1 μs       | 2.54 ± 1.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                            | 1.31 ± 0.56 ms      | 0.43 ± 0.58 ms      | 3.04 ± 4.3                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                       | 0.053 ± 0.0033 ms   | 15.4 ± 2.4 μs       | 3.43 ± 0.57                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                        | 0.0516 ± 0.012 ms   | 27.5 ± 2.7 μs       | 1.87 ± 0.47                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                           | 1.47 ± 0.014 ms     | 0.473 ± 0.49 ms     | 3.1 ± 3.2                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                      | 0.0832 ± 0.0041 ms  | 0.0425 ± 0.0026 ms  | 1.96 ± 0.15                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                           | 0.564 ± 0.04 ms     | 0.0739 ± 0.0064 ms  | 7.64 ± 0.85                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                              | 27.5 ± 0.53 ms      | 15.3 ± 0.63 ms      | 1.79 ± 0.081               |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                         | 0.494 ± 0.019 ms    | 0.0901 ± 0.0022 ms  | 5.48 ± 0.25                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                            | 0.0636 ± 0.013 ms   | 0.0484 ± 0.0059 ms  | 1.32 ± 0.31                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                               | 2.02 ± 0.57 ms      | 0.998 ± 0.61 ms     | 2.02 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                          | 0.113 ± 0.014 ms    | 0.0578 ± 0.0081 ms  | 1.95 ± 0.37                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                      | 0.704 ± 0.062 ms    | 0.149 ± 0.0041 ms   | 4.74 ± 0.44                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                         | 0.0537 ± 0.016 s    | 0.0433 ± 0.00053 s  | 1.24 ± 0.36                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                                    | 0.649 ± 0.019 ms    | 0.203 ± 0.0075 ms   | 3.19 ± 0.15                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme forward                                | 0.892 ± 0.027 ms    | 0.806 ± 0.068 ms    | 1.11 ± 0.099               |
| AD gradients/Recurrence Redistribute, Add and Clamp/Enzyme reverse                                | 0.104 ± 0.0095 ms   | 0.0676 ± 0.0016 ms  | 1.54 ± 0.15                |
| AD gradients/Recurrence Redistribute, Add and Clamp/ForwardDiff                                   | 0.108 ± 0.0057 ms   | 0.113 ± 0.011 ms    | 0.955 ± 0.1                |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake forward                              | 2.44 ± 0.14 ms      | 2.43 ± 0.041 ms     | 1 ± 0.061                  |
| AD gradients/Recurrence Redistribute, Add and Clamp/Mooncake reverse                              | 0.115 ± 0.0033 ms   | 0.0862 ± 0.0066 ms  | 1.33 ± 0.11                |
| AD gradients/Recurrence in Float32/Enzyme forward                                                 | 0.201 ± 0.014 ms    | 0.189 ± 0.02 ms     | 1.06 ± 0.14                |
| AD gradients/Recurrence in Float32/Enzyme reverse                                                 | 0.0395 ± 0.00079 ms | 0.0349 ± 0.0025 ms  | 1.13 ± 0.085               |
| AD gradients/Recurrence in Float32/ForwardDiff                                                    | 0.0441 ± 0.0038 ms  | 0.0437 ± 0.0032 ms  | 1.01 ± 0.11                |
| AD gradients/Recurrence in Float32/Mooncake forward                                               | 0.741 ± 0.035 ms    | 0.563 ± 0.039 ms    | 1.32 ± 0.11                |
| AD gradients/Recurrence in Float32/Mooncake reverse                                               | 0.0533 ± 0.0013 ms  | 0.0441 ± 0.0033 ms  | 1.21 ± 0.096               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                            | 0.33 ± 0.035 ms     | 0.358 ± 0.034 ms    | 0.921 ± 0.13               |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                            | 0.0452 ± 0.0026 ms  | 0.0329 ± 0.0016 ms  | 1.37 ± 0.1                 |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                               | 0.0651 ± 0.012 ms   | 0.0754 ± 0.0041 ms  | 0.862 ± 0.16               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                          | 1.2 ± 0.071 ms      | 1.34 ± 0.02 ms      | 0.895 ± 0.054              |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                          | 0.0536 ± 0.0012 ms  | 0.0377 ± 0.0012 ms  | 1.42 ± 0.057               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                      | 0.313 ± 0.031 ms    | 0.272 ± 0.027 ms    | 1.15 ± 0.16                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                      | 0.0409 ± 0.001 ms   | 0.0375 ± 0.0011 ms  | 1.09 ± 0.042               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                         | 0.0564 ± 0.0095 ms  | 0.0495 ± 0.0054 ms  | 1.14 ± 0.23                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward                    | 1.05 ± 0.089 ms     | 0.845 ± 0.058 ms    | 1.24 ± 0.14                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse                    | 0.062 ± 0.0033 ms   | 0.046 ± 0.0019 ms   | 1.35 ± 0.09                |
| AD gradients/Recurrence renewal/Enzyme forward                                                    | 0.0568 ± 0.0013 ms  | 0.0555 ± 0.0017 ms  | 1.02 ± 0.039               |
| AD gradients/Recurrence renewal/Enzyme reverse                                                    | 30.6 ± 2.4 μs       | 0.0322 ± 0.0028 ms  | 0.953 ± 0.11               |
| AD gradients/Recurrence renewal/ForwardDiff                                                       | 11 ± 3.1 μs         | 9.61 ± 2.7 μs       | 1.15 ± 0.45                |
| AD gradients/Recurrence renewal/Mooncake forward                                                  | 0.205 ± 0.014 ms    | 0.164 ± 0.022 ms    | 1.25 ± 0.19                |
| AD gradients/Recurrence renewal/Mooncake reverse                                                  | 0.05 ± 0.0037 ms    | 0.0376 ± 0.0033 ms  | 1.33 ± 0.15                |
| AD gradients/Recurrence returning its state/Enzyme forward                                        | 0.342 ± 0.036 ms    | 0.257 ± 0.018 ms    | 1.33 ± 0.17                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                        | 0.0533 ± 0.0039 ms  | 0.0462 ± 0.0012 ms  | 1.15 ± 0.089               |
| AD gradients/Recurrence returning its state/ForwardDiff                                           | 0.0574 ± 0.035 ms   | 0.057 ± 0.0053 ms   | 1.01 ± 0.62                |
| AD gradients/Recurrence returning its state/Mooncake forward                                      | 1.02 ± 0.016 ms     | 0.938 ± 0.021 ms    | 1.08 ± 0.03                |
| AD gradients/Recurrence returning its state/Mooncake reverse                                      | 0.0958 ± 0.0059 ms  | 0.0583 ± 0.0016 ms  | 1.64 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                       | 0.117 ± 0.012 ms    | 0.111 ± 0.0063 ms   | 1.06 ± 0.12                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                       | 23.1 ± 3.2 μs       | 29 ± 0.92 μs        | 0.798 ± 0.11               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                          | 28.1 ± 3.9 μs       | 23.2 ± 1.3 μs       | 1.21 ± 0.18                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward                     | 0.297 ± 0.07 ms     | 0.305 ± 0.01 ms     | 0.973 ± 0.23               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse                     | 0.0341 ± 0.0012 ms  | 0.0328 ± 0.0045 ms  | 1.04 ± 0.15                |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                            | 0.218 ± 0.037 ms    | 0.205 ± 0.024 ms    | 1.06 ± 0.22                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                            | 0.0515 ± 0.002 ms   | 0.0321 ± 0.0022 ms  | 1.61 ± 0.13                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                               | 31.2 ± 1.8 μs       | 0.0332 ± 0.0058 ms  | 0.94 ± 0.17                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                          | 0.674 ± 0.1 ms      | 0.674 ± 0.032 ms    | 1 ± 0.16                   |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                          | 0.0601 ± 0.0061 ms  | 0.0389 ± 0.0014 ms  | 1.55 ± 0.17                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                             | 0.441 ± 0.02 ms     | 0.299 ± 0.027 ms    | 1.48 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                             | 0.063 ± 0.0019 ms   | 0.045 ± 0.0011 ms   | 1.4 ± 0.053                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                                | 0.0585 ± 0.0025 ms  | 0.0572 ± 0.0068 ms  | 1.02 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                           | 1.34 ± 0.2 ms       | 1.13 ± 0.016 ms     | 1.18 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                           | 0.0885 ± 0.0085 ms  | 0.0606 ± 0.0025 ms  | 1.46 ± 0.15                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                           | 0.831 ± 0.3 ms      | 1.07 ± 0.29 ms      | 0.776 ± 0.35               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                           | 0.0462 ± 0.0041 ms  | 0.0433 ± 0.0041 ms  | 1.07 ± 0.14                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                              | 0.125 ± 0.006 ms    | 0.141 ± 0.0094 ms   | 0.884 ± 0.072              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                         | 3.22 ± 0.71 ms      | 3.23 ± 0.62 ms      | 0.998 ± 0.29               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                         | 0.0652 ± 0.006 ms   | 0.0467 ± 0.0021 ms  | 1.4 ± 0.14                 |
| Convolution body/BLAS axpy per lag                                                                | 0.691 ± 0.0062 μs   | 0.706 ± 0.0054 μs   | 0.98 ± 0.012               |
| Convolution body/native axpy per lag                                                              | 0.423 ± 0.0057 μs   | 0.417 ± 0.006 μs    | 1.01 ± 0.02                |
| Convolution body/package                                                                          | 0.69 ± 0.0062 μs    | 0.329 ± 0.0089 μs   | 2.1 ± 0.06                 |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                           | 0.0527 ± 0.0011 ms  | 0.048 ± 0.00094 ms  | 1.1 ± 0.032                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                          | 3.84 ± 0.3 μs       | 3.75 ± 0.33 μs      | 1.02 ± 0.12                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                         | 2.65 ± 1.6 μs       | 2.02 ± 0.38 μs      | 1.31 ± 0.84                |
| Evaluation/Matrix overview T200_L20_S3                                                            | 0.0438 ± 0.0057 ms  | 0.0396 ± 0.014 ms   | 1.11 ± 0.41                |
| Evaluation/Matrix renewal T200_L20_S1                                                             | 7.87 ± 1.7 μs       | 8.33 ± 1.7 μs       | 0.945 ± 0.28               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                       | 0.0535 ± 0.004 ms   | 31 ± 0.84 μs        | 1.73 ± 0.14                |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse                    |                     | 0.0855 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse            |                     | 0.0423 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward              |                     | 2.01 ± 0.048 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse           |                     | 0.0327 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                               |                     | 0.349 ± 0.0099 ms   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                            |                     | 0.042 ± 0.052 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff              |                     | 0.0461 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                          |                     | 0.832 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse |                     | 13.5 ± 0.42 μs      |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                       |                     | 1.52 ± 0.37 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                              |                     | 0.286 ± 0.025 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                        |                     | 1.85 ± 0.24 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                                |                     | 0.0352 ± 0.00083 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                       |                     | 0.67 ± 0.11 ms      |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                       |                     | 0.0538 ± 0.009 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse        |                     | 0.0389 ± 0.0012 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward                 |                     | 3.62 ± 0.085 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse                    |                     | 0.0388 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward                 |                     | 0.995 ± 0.057 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff                   |                     | 0.115 ± 0.0059 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward                 |                     | 0.205 ± 0.026 ms    |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme forward                                       |                     | 0.204 ± 0.022 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse              |                     | 0.0909 ± 0.0032 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse                   |                     | 0.0561 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse   |                     | 3.17 ± 0.44 μs      |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                        |                     | 0.37 ± 0.026 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                                |                     | 0.0559 ± 0.0015 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                           |                     | 0.213 ± 0.027 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                         |                     | 0.0448 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake reverse                                     |                     | 0.0531 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                         |                     | 0.13 ± 0.0046 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                             |                     | 1.44 ± 0.26 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                            |                     | 1.04 ± 0.0096 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                          |                     | 0.054 ± 0.0011 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                         |                     | 0.657 ± 0.017 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                                    |                     | 1.07 ± 0.052 ms     |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake forward               |                     | 0.68 ± 0.024 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                                |                     | 1.28 ± 0.058 ms     |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme forward             |                     | 1.5 ± 0.34 μs       |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse                  |                     | 27.9 ± 0.91 μs      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                          |                     | 0.226 ± 0.03 ms     |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                         |                     | 0.0384 ± 0.00099 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff                |                     | 24.7 ± 21 μs        |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                                 |                     | 0.0605 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse          |                     | 30.7 ± 0.95 μs      |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                       |                     | 0.965 ± 0.084 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse           |                     | 29.4 ± 0.77 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                             |                     | 0.551 ± 0.018 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                          |                     | 31 ± 3.1 μs         |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                          |                     | 0.577 ± 0.02 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                                |                     | 1.42 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme reverse                      |                     | 0.0885 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                                |                     | 0.137 ± 0.0044 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                              |                     | 0.0802 ± 0.0041 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                         |                     | 0.0442 ± 0.0023 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                            |                     | 0.0386 ± 0.0077 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                       |                     | 0.0702 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme forward                 |                     | 0.212 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/ForwardDiff                    |                     | 29.3 ± 2.2 μs       |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Enzyme reverse             |                     | 8.09 ± 0.81 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                                  |                     | 0.245 ± 0.022 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                      |                     | 0.321 ± 0.029 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                      |                     | 0.0668 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                        |                     | 0.839 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                                |                     | 0.711 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward               |                     | 3.14 ± 0.12 ms      |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake reverse           |                     | 14.4 ± 1.3 μs       |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                               |                     | 29.5 ± 0.68 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                          |                     | 0.0594 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward           |                     | 0.303 ± 0.0095 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                        |                     | 0.0911 ± 0.0025 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                                  |                     | 0.4 ± 0.034 ms      |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                                    |                     | 0.22 ± 0.03 ms      |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                         |                     | 0.212 ± 0.0094 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                      |                     | 0.0391 ± 0.001 ms   |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                            |                     | 0.0441 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                                |                     | 0.0517 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                      |                     | 0.0394 ± 0.00084 ms |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme reverse                       |                     | 0.0477 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                                  |                     | 0.358 ± 0.043 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                                   |                     | 0.105 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse             |                     | 0.0766 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                             |                     | 23.8 ± 0.67 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                                     |                     | 0.0711 ± 0.0034 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward                  |                     | 0.857 ± 0.093 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse                   |                     | 0.0472 ± 0.00099 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward                |                     | 0.533 ± 0.062 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                      |                     | 1.29 ± 0.062 ms     |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Enzyme forward   |                     | 1.49 ± 0.32 μs      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff                    |                     | 0.0367 ± 0.0041 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                                |                     | 0.0881 ± 0.0051 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                           |                     | 0.0353 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse                |                     | 0.069 ± 0.0016 ms   |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake reverse           |                     | 0.0606 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                              |                     | 2.5 ± 0.11 ms       |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward                   |                     | 0.918 ± 0.088 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                                  |                     | 0.0511 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/ForwardDiff                                          |                     | 30.1 ± 18 μs        |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse                 |                     | 0.0467 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward               |                     | 0.204 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                                     |                     | 0.0326 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                                 |                     | 0.235 ± 0.012 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                                     |                     | 0.0598 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff               |                     | 0.0517 ± 0.0064 ms  |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Mooncake reverse               |                     | 0.0398 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward                   |                     | 0.302 ± 0.029 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                         |                     | 0.33 ± 0.0099 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                                  |                     | 0.0463 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                        |                     | 0.19 ± 0.018 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                            |                     | 0.362 ± 0.014 ms    |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/Mooncake forward           |                     | 13.4 ± 0.75 μs      |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Enzyme reverse                                       |                     | 0.0396 ± 0.0026 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                                  |                     | 0.0788 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Enzyme forward                      |                     | 0.827 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward             |                     | 0.118 ± 0.0072 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse         |                     | 0.0395 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                             |                     | 11.1 ± 3 μs         |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake reverse                    |                     | 0.116 ± 0.0074 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                                  |                     | 0.0412 ± 0.0009 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse                    |                     | 0.0519 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                      |                     | 0.838 ± 0.096 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                             |                     | 0.0328 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/ForwardDiff      |                     | 1.21 ± 0.27 μs      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/ForwardDiff                          |                     | 0.0537 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse         |                     | 0.0594 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse          |                     | 0.054 ± 0.002 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                              |                     | 0.0522 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                              |                     | 0.0491 ± 0.0011 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                                |                     | 0.836 ± 0.088 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme forward             |                     | 0.375 ± 0.044 ms    |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/Mooncake forward                    |                     | 2.59 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward               |                     | 0.658 ± 0.015 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                                |                     | 0.0665 ± 0.0025 ms  |                            |
| AD gradients/Recurrence empty pool with a differentiated heterogeneity/ForwardDiff                |                     | 1.12 ± 0.29 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                        |                     | 0.0447 ± 0.0032 ms  |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake forward                     |                     | 1.19 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                                  |                     | 0.0625 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence in Float32/Mooncake forward                                     |                     | 0.698 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff                    |                     | 0.148 ± 0.0068 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                      |                     | 27.6 ± 1.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                            |                     | 0.0448 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse               |                     | 0.0573 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward            |                     | 0.28 ± 0.014 ms     |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                           |                     | 0.0384 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                        |                     | 0.0568 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                         |                     | 0.209 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward         |                     | 0.92 ± 0.058 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff                  |                     | 0.0405 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse               |                     | 0.0494 ± 0.0012 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward                    |                     | 0.0877 ± 0.0045 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Mooncake forward           |                     | 1.14 ± 0.021 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                              |                     | 0.0533 ± 0.0032 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                              |                     | 0.0365 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward           |                     | 0.295 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                               |                     | 0.0448 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                               |                     | 0.588 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                      |                     | 0.612 ± 0.044 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward                    |                     | 0.3 ± 0.029 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                           |                     | 1.81 ± 0.085 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse            |                     | 0.0397 ± 0.00096 ms |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse                 |                     | 0.0367 ± 0.00086 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                                   |                     | 0.134 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff             |                     | 0.065 ± 0.0053 ms   |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                              |                     | 0.999 ± 0.0088 ms   |                            |
| AD gradients/NoAdjoint Convolution per-stratum kernel with history/Enzyme reverse                 |                     | 0.0324 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff            |                     | 0.151 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence empty pool with a differentiated heterogeneity/Mooncake forward |                     | 13.5 ± 0.74 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                       |                     | 0.0375 ± 0.0033 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward                    |                     | 2.02 ± 0.044 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                            |                     | 0.0864 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/ForwardDiff                |                     | 0.0587 ± 0.01 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff               |                     | 8.82 ± 1.2 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                        |                     | 0.0798 ± 0.0034 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                       |                     | 0.0367 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse               |                     | 0.0484 ± 0.0011 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                      |                     | 0.157 ± 0.014 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                              |                     | 0.04 ± 0.0012 ms    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                       |                     | 0.0499 ± 0.0094 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                          |                     | 0.0576 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                             |                     | 0.055 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                                 |                     | 10.4 ± 1.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                      |                     | 0.0662 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                          |                     | 0.0593 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                           |                     | 0.0676 ± 0.0057 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                                |                     | 0.856 ± 0.063 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                            |                     | 0.209 ± 0.027 ms    |                            |
| AD gradients/NoAdjoint Recurrence with a buffer deeper than the kernel/Enzyme reverse             |                     | 0.0462 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                      |                     | 0.0563 ± 0.034 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                         |                     | 0.424 ± 0.035 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward          |                     | 0.0885 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse                 |                     | 0.0715 ± 0.0017 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                                |                     | 0.635 ± 0.073 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                            |                     | 0.0382 ± 0.0025 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                         |                     | 27.1 ± 0.85 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward         |                     | 1.07 ± 0.078 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                                |                     | 0.0528 ± 0.0023 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                                    |                     | 0.0442 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward                 |                     | 1.15 ± 0.02 ms      |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                               |                     | 1.28 ± 0.074 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                      |                     | 0.0385 ± 0.0026 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                                  |                     | 0.818 ± 0.082 ms    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                               |                     | 29.8 ± 2.6 μs       |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                                  |                     | 0.0459 ± 0.00094 ms |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward          |                     | 0.307 ± 0.051 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                         |                     | 0.0411 ± 0.0099 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse          |                     | 0.0506 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                             |                     | 0.0663 ± 0.0079 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse                    |                     | 26.9 ± 0.87 μs      |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward        |                     | 0.966 ± 0.068 ms    |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Mooncake reverse                     |                     | 0.0576 ± 0.0015 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                             |                     | 0.111 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                              |                     | 26.5 ± 2.5 μs       |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse       |                     | 0.0953 ± 0.0058 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse                 |                     | 0.0805 ± 0.0043 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                                    |                     | 0.0483 ± 0.00095 ms |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                          |                     | 1.18 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                             |                     | 1.04 ± 0.055 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward          |                     | 0.955 ± 0.011 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward       |                     | 3.58 ± 0.048 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                            |                     | 0.333 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                             |                     | 0.0464 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                            |                     | 0.0741 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                         |                     | 8.82 ± 0.79 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                              |                     | 2.2 ± 0.088 ms      |                            |
| AD gradients/NoAdjoint Recurrence Redistribute, Add and Clamp/ForwardDiff                         |                     | 0.11 ± 0.0039 ms    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                               |                     | 0.0583 ± 0.016 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse             |                     | 22.8 ± 2.2 μs       |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward             |                     | 0.886 ± 0.14 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward            |                     | 28 ± 1.1 μs         |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward                    |                     | 2.78 ± 0.11 ms      |                            |
| AD gradients/Recurrence with a buffer deeper than the kernel/Enzyme forward                       |                     | 0.372 ± 0.013 ms    |                            |
| time_to_load                                                                                      | 0.181 ± 0.00011 s   | 0.268 ± 0.00077 s   | 0.677 ± 0.002              |

|                                                                                                   | v0.1.0                    | 7d70afa479d050...         | v0.1.0 / 7d70afa479d050... |
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

