|                                                                                             | v0.1.0             | 51493859c4e6c8...   | v0.1.0 / 51493859c4e6c8... |
|:--------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0686 ± 0.0072 ms | 0.104 ± 0.0085 ms   | 0.657 ± 0.088              |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 29.8 ± 0.64 μs     | 0.0512 ± 0.0024 ms  | 0.582 ± 0.03               |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 9.01 ± 1.5 μs      | 6.55 ± 0.8 μs       | 1.38 ± 0.28                |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.239 ± 0.037 ms   | 0.24 ± 0.06 ms      | 0.996 ± 0.29               |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.0528 ± 0.0032 ms | 0.0417 ± 0.0072 ms  | 1.26 ± 0.23                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.343 ± 0.02 ms    | 0.333 ± 0.018 ms    | 1.03 ± 0.083               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.036 ± 0.0011 ms  | 0.0332 ± 0.00079 ms | 1.09 ± 0.043               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.0366 ± 0.0064 ms | 0.041 ± 0.0028 ms   | 0.893 ± 0.17               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 1.02 ± 0.2 ms      | 1.09 ± 0.021 ms     | 0.942 ± 0.19               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.0614 ± 0.0022 ms | 0.0433 ± 0.0011 ms  | 1.42 ± 0.063               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.628 ± 0.039 ms   | 0.699 ± 0.046 ms    | 0.898 ± 0.082              |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 30.5 ± 0.95 μs     | 0.0468 ± 0.0012 ms  | 0.651 ± 0.027              |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0754 ± 0.0056 ms | 0.0894 ± 0.0093 ms  | 0.844 ± 0.11               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.9 ± 0.47 ms      | 1.46 ± 0.45 ms      | 1.3 ± 0.51                 |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.0613 ± 0.0032 ms | 0.0378 ± 0.0034 ms  | 1.62 ± 0.17                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.304 ± 0.43 ms    | 0.308 ± 0.45 ms     | 0.986 ± 2                  |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.391 ± 0.29 ms    | 0.44 ± 0.31 ms      | 0.887 ± 0.91               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 7.92 ± 4.4 ms      | 7.53 ± 4.6 ms       | 1.05 ± 0.87                |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 0.0366 ± 0.015 s   | 0.0345 ± 0.015 s    | 1.06 ± 0.64                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 1.37 ± 0.06 ms     | 0.269 ± 0.015 ms    | 5.12 ± 0.36                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0592 ± 0.019 s   | 28 ± 1.1 ms         | 2.12 ± 0.69                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 1.21 ± 0.016 ms    | 0.347 ± 0.017 ms    | 3.48 ± 0.18                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 30.7 ± 12 μs       | 12.2 ± 6.8 μs       | 2.52 ± 1.7                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.402 ± 0.7 ms     | 0.346 ± 0.038 ms    | 1.16 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.0602 ± 0.021 ms  | 17.1 ± 2.6 μs       | 3.52 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.0643 ± 0.011 ms  | 0.0389 ± 0.0076 ms  | 1.65 ± 0.42                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.453 ± 0.62 ms    | 0.396 ± 0.022 ms    | 1.14 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.111 ± 0.0072 ms  | 0.0561 ± 0.0092 ms  | 1.97 ± 0.35                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.633 ± 0.019 ms   | 0.103 ± 0.0063 ms   | 6.16 ± 0.42                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 10 ± 8.9 ms        | 15.5 ± 8.5 ms       | 0.647 ± 0.68               |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.618 ± 0.048 ms   | 0.109 ± 0.0025 ms   | 5.66 ± 0.46                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0942 ± 0.016 ms  | 0.0605 ± 0.0076 ms  | 1.56 ± 0.33                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 2.7 ± 0.034 ms     | 0.719 ± 0.63 ms     | 3.76 ± 3.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.149 ± 0.014 ms   | 0.0805 ± 0.0039 ms  | 1.85 ± 0.19                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.783 ± 0.087 ms   | 0.242 ± 0.013 ms    | 3.23 ± 0.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 0.0541 ± 0.019 s   | 0.0352 ± 0.018 s    | 1.54 ± 0.97                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.873 ± 0.048 ms   | 0.264 ± 0.014 ms    | 3.31 ± 0.26                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.429 ± 0.063 ms   | 0.399 ± 0.057 ms    | 1.07 ± 0.22                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.0613 ± 0.0032 ms | 0.0416 ± 0.001 ms   | 1.47 ± 0.084               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0549 ± 0.0091 ms | 0.0907 ± 0.0049 ms  | 0.604 ± 0.11               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 1.36 ± 0.18 ms     | 1.72 ± 0.099 ms     | 0.792 ± 0.11               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0897 ± 0.0069 ms | 0.0549 ± 0.0028 ms  | 1.63 ± 0.15                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.377 ± 0.026 ms   | 0.319 ± 0.04 ms     | 1.18 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.0565 ± 0.0039 ms | 0.0494 ± 0.0011 ms  | 1.14 ± 0.083               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0679 ± 0.014 ms  | 0.058 ± 0.0044 ms   | 1.17 ± 0.25                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 1.15 ± 0.18 ms     | 1.08 ± 0.031 ms     | 1.06 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0928 ± 0.0064 ms | 0.0685 ± 0.0019 ms  | 1.36 ± 0.1                 |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0726 ± 0.0034 ms | 0.0669 ± 0.0018 ms  | 1.09 ± 0.059               |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.0392 ± 0.0034 ms | 0.0398 ± 0.0034 ms  | 0.985 ± 0.12               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 13.4 ± 2 μs        | 10.6 ± 3 μs         | 1.27 ± 0.4                 |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.241 ± 0.012 ms   | 0.196 ± 0.018 ms    | 1.23 ± 0.13                |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.0727 ± 0.0047 ms | 0.0553 ± 0.0046 ms  | 1.32 ± 0.14                |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.449 ± 0.055 ms   | 0.292 ± 0.022 ms    | 1.54 ± 0.22                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0786 ± 0.0059 ms | 0.0653 ± 0.002 ms   | 1.2 ± 0.098                |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0662 ± 0.011 ms  | 0.0597 ± 0.004 ms   | 1.11 ± 0.2                 |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 1.41 ± 0.053 ms    | 1.25 ± 0.022 ms     | 1.13 ± 0.047               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.146 ± 0.0096 ms  | 0.0922 ± 0.0024 ms  | 1.58 ± 0.11                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.142 ± 0.0071 ms  | 0.131 ± 0.0074 ms   | 1.09 ± 0.082               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 27.8 ± 1.7 μs      | 0.0431 ± 0.0013 ms  | 0.645 ± 0.044              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 28.1 ± 2.8 μs      | 27.7 ± 2.5 μs       | 1.01 ± 0.14                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.397 ± 0.09 ms    | 0.388 ± 0.11 ms     | 1.02 ± 0.38                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.0515 ± 0.0018 ms | 0.0521 ± 0.0046 ms  | 0.989 ± 0.095              |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.264 ± 0.04 ms    | 0.232 ± 0.017 ms    | 1.14 ± 0.19                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0749 ± 0.0039 ms | 0.042 ± 0.00096 ms  | 1.78 ± 0.1                 |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.0327 ± 0.0018 ms | 0.0367 ± 0.0048 ms  | 0.892 ± 0.13               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.817 ± 0.17 ms    | 0.858 ± 0.015 ms    | 0.952 ± 0.2                |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0867 ± 0.0062 ms | 0.0594 ± 0.0014 ms  | 1.46 ± 0.11                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.524 ± 0.022 ms   | 0.347 ± 0.034 ms    | 1.51 ± 0.16                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0903 ± 0.0034 ms | 0.0633 ± 0.0019 ms  | 1.43 ± 0.068               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0685 ± 0.0037 ms | 0.0622 ± 0.013 ms   | 1.1 ± 0.24                 |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.88 ± 0.24 ms     | 1.56 ± 0.038 ms     | 1.21 ± 0.16                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.128 ± 0.0068 ms  | 0.0924 ± 0.0026 ms  | 1.38 ± 0.083               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 1.02 ± 0.29 ms     | 1.21 ± 0.21 ms      | 0.843 ± 0.28               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0609 ± 0.0065 ms | 0.0966 ± 0.0071 ms  | 0.63 ± 0.082               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.123 ± 0.011 ms   | 0.176 ± 0.017 ms    | 0.703 ± 0.09               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 3.35 ± 0.83 ms     | 4.7 ± 0.69 ms       | 0.714 ± 0.21               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0944 ± 0.0091 ms | 0.0707 ± 0.0053 ms  | 1.34 ± 0.16                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0723 ± 0.017 ms  | 0.0795 ± 0.0037 ms  | 0.91 ± 0.21                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 4.8 ± 0.27 μs      | 4.1 ± 0.25 μs       | 1.17 ± 0.098               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 3.14 ± 2.5 μs      | 2.31 ± 0.38 μs      | 1.35 ± 1.1                 |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.0525 ± 0.0038 ms | 0.045 ± 0.016 ms    | 1.17 ± 0.43                |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 9.89 ± 1.7 μs      | 9.73 ± 1.7 μs       | 1.02 ± 0.25                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.0702 ± 0.0037 ms | 0.054 ± 0.0033 ms   | 1.3 ± 0.1                  |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                    | 0.126 ± 0.0033 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                    | 0.054 ± 0.0039 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                    | 2.74 ± 0.062 ms     |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                    | 0.0484 ± 0.0044 ms  |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                    | 0.411 ± 0.018 ms    |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                    | 0.111 ± 0.062 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                    | 0.0473 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                    | 0.963 ± 0.008 ms    |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                    | 2.21 ± 0.35 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                    | 0.328 ± 0.037 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                    | 7.69 ± 0.13 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                    | 0.0465 ± 0.001 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                    | 0.947 ± 0.069 ms    |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                    | 0.0781 ± 0.0084 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                    | 0.0614 ± 0.0016 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                    | 5.05 ± 0.078 ms     |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                    | 0.0564 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                    | 1.07 ± 0.095 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                    | 0.124 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme forward           |                    | 0.244 ± 0.032 ms    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                    | 0.129 ± 0.0031 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                    | 0.079 ± 0.0025 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                    | 0.436 ± 0.024 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                    | 0.0868 ± 0.003 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                    | 0.247 ± 0.033 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                    | 0.0651 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                    | 0.149 ± 0.0078 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                    | 2.25 ± 0.41 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                    | 1.43 ± 0.025 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                    | 0.0792 ± 0.0022 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                    | 0.847 ± 0.013 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                    | 1.36 ± 0.08 ms      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                    | 1.54 ± 0.062 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                    | 0.0403 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                    | 0.258 ± 0.036 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                    | 0.105 ± 0.0024 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                    | 27.7 ± 15 μs        |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                    | 0.067 ± 0.0045 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                    | 0.0405 ± 0.0011 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                    | 1.2 ± 0.047 ms      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                    | 0.0372 ± 0.00075 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                    | 0.652 ± 0.031 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                    | 0.0397 ± 0.0037 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                    | 0.831 ± 0.044 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                    | 1.83 ± 0.41 ms      |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                    | 0.171 ± 0.007 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                    | 0.118 ± 0.0062 ms   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                    | 0.0666 ± 0.0023 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                    | 0.0344 ± 0.0067 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                    | 0.107 ± 0.0034 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                    | 0.442 ± 0.029 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                    | 0.382 ± 0.047 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                    | 0.102 ± 0.0032 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                    | 1.18 ± 0.26 ms      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                    | 3.41 ± 0.36 ms      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                    | 4.07 ± 0.098 ms     |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                    | 0.038 ± 0.00092 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                    | 0.222 ± 0.013 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                    | 0.35 ± 0.018 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                    | 0.141 ± 0.0048 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                    | 0.471 ± 0.047 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                    | 0.244 ± 0.037 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                    | 1.16 ± 0.016 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                    | 0.0532 ± 0.0013 ms  |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                    | 0.0453 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                    | 0.0782 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                    | 0.0528 ± 0.001 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                    | 0.396 ± 0.064 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                    | 0.138 ± 0.021 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                    | 0.119 ± 0.0044 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                    | 30.7 ± 0.75 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                    | 0.083 ± 0.0044 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                    | 0.995 ± 0.25 ms     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                    | 0.0641 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                    | 0.624 ± 0.079 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                    | 1.74 ± 0.043 ms     |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/ForwardDiff              |                    | 0.0381 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                    | 0.0897 ± 0.0079 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                    | 0.0572 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                    | 0.0903 ± 0.0024 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                    | 3.1 ± 0.091 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                    | 1.11 ± 0.15 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                    | 0.0508 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                    | 0.0599 ± 0.0035 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                    | 0.237 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                    | 0.0702 ± 0.0064 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                    | 0.298 ± 0.015 ms    |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                    | 0.0643 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                    | 0.0593 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                    | 0.352 ± 0.036 ms    |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                    | 0.386 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                    | 0.0516 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                    | 0.257 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                    | 0.421 ± 0.021 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                    | 0.124 ± 0.0036 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                    | 0.183 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                    | 0.06 ± 0.0058 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                    | 12.6 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                    | 0.053 ± 0.0012 ms   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                    | 0.0797 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                    | 1 ± 0.1 ms          |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                    | 0.0349 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                    | 0.0825 ± 0.0054 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                    | 0.0834 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                    | 0.0654 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                    | 0.0679 ± 0.0014 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                    | 0.953 ± 0.089 ms    |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                    | 0.859 ± 0.013 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                    | 0.0979 ± 0.0053 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                    | 0.0675 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                    | 0.0802 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                    | 0.153 ± 0.0092 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                    | 31.4 ± 0.98 μs      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                    | 0.0607 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                    | 0.0921 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                    | 0.308 ± 0.018 ms    |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme reverse                     |                    | 0.0497 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                    | 0.0788 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                    | 0.157 ± 0.0076 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                    | 1.11 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                    | 0.0436 ± 0.0034 ms  |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake reverse         |                    | 0.0788 ± 0.0022 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                    | 0.119 ± 0.007 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                    | 0.0882 ± 0.0044 ms  |                            |
| AD gradients/Recurrence user coupling without a pullback/ForwardDiff                        |                    | 0.0401 ± 0.018 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                    | 0.315 ± 0.076 ms    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                    | 0.0795 ± 0.0037 ms  |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                    | 0.668 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                    | 0.716 ± 0.03 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                    | 0.339 ± 0.023 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                    | 2.2 ± 0.11 ms       |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                    | 0.054 ± 0.0013 ms   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Enzyme reverse           |                    | 0.0482 ± 0.001 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                    | 0.138 ± 0.006 ms    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                    | 0.0721 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                    | 1.28 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                    | 0.176 ± 0.0088 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                    | 0.0415 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                    | 2.73 ± 0.036 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                    | 0.118 ± 0.0048 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                    | 10.4 ± 1.4 μs       |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                    | 0.116 ± 0.0031 ms   |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                    | 0.0549 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                    | 0.0699 ± 0.0025 ms  |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                    | 0.185 ± 0.023 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                    | 0.0638 ± 0.0025 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                    | 0.0517 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                    | 0.0883 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                    | 0.057 ± 0.0035 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                    | 10.7 ± 1.7 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                    | 0.0914 ± 0.0019 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                    | 0.0711 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                    | 0.0761 ± 0.0047 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                    | 0.936 ± 0.083 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                    | 0.266 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                    | 0.0613 ± 0.038 ms   |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                    | 0.518 ± 0.019 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                    | 0.118 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                    | 0.107 ± 0.0031 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                    | 0.789 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                    | 0.0564 ± 0.0036 ms  |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                    | 0.0351 ± 0.00087 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                    | 1.29 ± 0.063 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                    | 0.0808 ± 0.0027 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                    | 0.0677 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                    | 1.51 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                    | 0.552 ± 0.059 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                    | 0.0509 ± 0.003 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                    | 1.14 ± 0.069 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                    | 0.032 ± 0.0029 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                    | 0.0639 ± 0.0015 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                    | 0.347 ± 0.066 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                    | 0.0409 ± 0.0099 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                    | 0.0755 ± 0.0038 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                    | 0.0993 ± 0.018 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                    | 0.0348 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                    | 1.19 ± 0.065 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                    | 0.372 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                    | 0.0326 ± 0.0026 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                    | 0.14 ± 0.0071 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                    | 0.12 ± 0.0094 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                    | 0.0718 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                    | 1.49 ± 0.17 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                    | 1.32 ± 0.055 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                    | 1.31 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                    | 4.81 ± 0.095 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                    | 0.391 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                    | 0.0717 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                    | 0.11 ± 0.0027 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                    | 10.3 ± 1.1 μs       |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                    | 3.01 ± 0.14 ms      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                    | 0.0639 ± 0.008 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                    | 0.0397 ± 0.0048 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                    | 1.25 ± 0.097 ms     |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                    | 0.0321 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                    | 3.75 ± 0.12 ms      |                            |
| time_to_load                                                                                | 0.239 ± 0.00072 s  | 0.355 ± 0.0061 s    | 0.673 ± 0.012              |

|                                                                                             | v0.1.0                    | 51493859c4e6c8...         | v0.1.0 / 51493859c4e6c8... |
|:--------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 0.147 k allocs: 7.97 kB   | 0.157 k allocs: 8.25 kB   | 0.966                      |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
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
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.03 k allocs: 0.0396 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.433 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.77 k allocs: 0.355 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.988 k allocs: 0.038 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Enzyme forward                     |                           | 2.48 k allocs: 0.183 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.352 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.623 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.8 k allocs: 0.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.397 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake forward                   |                           | 10.3 k allocs: 0.499 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                           | 19.1 k allocs: 0.91 MB    |                            |
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
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                           | 0.685 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                           | 1.26 k allocs: 0.0522 MB  |                            |
| AD gradients/Recurrence user coupling without a pullback/Mooncake reverse                   |                           | 0.805 k allocs: 0.0314 MB |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.984 k allocs: 0.0333 MB |                            |
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
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.348 k allocs: 23 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.227 k allocs: 0.0934 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.943 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.457 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.284 k allocs: 0.117 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.55 k allocs: 0.284 MB   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                           | 0.314 k allocs: 0.163 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.95 k allocs: 0.144 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.89 k allocs: 0.274 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.33 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.07 k allocs: 13.7 kB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.252 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.744 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.77 k allocs: 0.748 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.408 k allocs: 26.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.838 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.346 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.53 k allocs: 0.731 MB   |                            |
| AD gradients/NoAdjoint Recurrence user coupling without a pullback/Mooncake forward         |                           | 10.5 k allocs: 0.505 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.528 k allocs: 0.0355 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.693 k allocs: 22.5 kB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.183 k allocs: 0.0407 MB |                            |
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
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                           | 0.476 k allocs: 0.146 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                           | 0.205 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                           | 0.363 k allocs: 27.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                           | 0.0427 M allocs: 2.26 MB  |                            |
| time_to_load                                                                                | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

