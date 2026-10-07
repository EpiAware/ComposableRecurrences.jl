|                                                                                             | v0.1.0             | d07c44981cefa3...   | v0.1.0 / d07c44981cefa3... |
|:--------------------------------------------------------------------------------------------|:------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0674 ± 0.0072 ms | 0.0762 ± 0.0086 ms  | 0.885 ± 0.14               |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 30.1 ± 0.6 μs      | 0.0325 ± 0.0013 ms  | 0.927 ± 0.04               |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 10.3 ± 1.9 μs      | 4.99 ± 4.4 μs       | 2.06 ± 1.9                 |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.242 ± 0.048 ms   | 0.177 ± 0.065 ms    | 1.37 ± 0.58                |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.0444 ± 0.0012 ms | 0.0388 ± 0.0054 ms  | 1.14 ± 0.16                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.364 ± 0.019 ms   | 0.372 ± 0.029 ms    | 0.979 ± 0.09               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.0365 ± 0.0016 ms | 0.0334 ± 0.00083 ms | 1.09 ± 0.055               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.0406 ± 0.0039 ms | 0.0465 ± 0.004 ms   | 0.873 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.98 ± 0.2 ms      | 1.11 ± 0.029 ms     | 0.887 ± 0.18               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.0565 ± 0.0089 ms | 0.0386 ± 0.00094 ms | 1.46 ± 0.23                |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.675 ± 0.032 ms   | 0.666 ± 0.16 ms     | 1.01 ± 0.24                |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 30.3 ± 0.97 μs     | 30.7 ± 1.2 μs       | 0.985 ± 0.049              |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0923 ± 0.0068 ms | 0.105 ± 0.023 ms    | 0.878 ± 0.21               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 2.01 ± 0.26 ms     | 1.76 ± 0.33 ms      | 1.14 ± 0.26                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.0483 ± 0.003 ms  | 29.9 ± 1.3 μs       | 1.61 ± 0.12                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.318 ± 0.016 ms   | 0.328 ± 0.56 ms     | 0.969 ± 1.7                |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.501 ± 0.37 ms    | 0.361 ± 0.38 ms     | 1.39 ± 1.8                 |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 8.02 ± 0.31 ms     | 7.71 ± 5.3 ms       | 1.04 ± 0.71                |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 0.0408 ± 0.0011 s  | 0.0385 ± 0.012 s    | 1.06 ± 0.33                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 1.45 ± 0.031 ms    | 0.258 ± 0.011 ms    | 5.62 ± 0.28                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0632 ± 0.0022 s  | 27.4 ± 0.63 ms      | 2.3 ± 0.096                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 1.16 ± 0.035 ms    | 0.332 ± 0.013 ms    | 3.51 ± 0.17                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.0342 ± 0.012 ms  | 13.6 ± 8.2 μs       | 2.51 ± 1.7                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.398 ± 0.031 ms   | 0.352 ± 0.025 ms    | 1.13 ± 0.12                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.0658 ± 0.025 ms  | 18.3 ± 3.5 μs       | 3.59 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.0643 ± 0.015 ms  | 0.0343 ± 0.0022 ms  | 1.88 ± 0.44                |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.451 ± 0.025 ms   | 0.43 ± 0.7 ms       | 1.05 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.104 ± 0.026 ms   | 0.052 ± 0.003 ms    | 2 ± 0.51                   |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.61 ± 0.019 ms    | 0.0916 ± 0.003 ms   | 6.66 ± 0.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 10.7 ± 9.8 ms      | 16.5 ± 0.56 ms      | 0.646 ± 0.59               |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.612 ± 0.044 ms   | 0.11 ± 0.004 ms     | 5.55 ± 0.45                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0889 ± 0.016 ms  | 0.162 ± 0.013 ms    | 0.55 ± 0.11                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 3 ± 0.036 ms       | 0.806 ± 0.75 ms     | 3.72 ± 3.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.142 ± 0.032 ms   | 0.0738 ± 0.004 ms   | 1.93 ± 0.44                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.974 ± 0.02 ms    | 0.196 ± 0.0092 ms   | 4.96 ± 0.25                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 0.0775 ± 0.00079 s | 0.0422 ± 0.02 s     | 1.84 ± 0.86                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.817 ± 0.024 ms   | 0.255 ± 0.011 ms    | 3.2 ± 0.17                 |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.426 ± 0.075 ms   | 0.467 ± 0.063 ms    | 0.912 ± 0.2                |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.0566 ± 0.0023 ms | 0.0399 ± 0.00096 ms | 1.42 ± 0.067               |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0564 ± 0.0091 ms | 0.0901 ± 0.005 ms   | 0.626 ± 0.11               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 1.35 ± 0.24 ms     | 1.69 ± 0.025 ms     | 0.799 ± 0.14               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0725 ± 0.0054 ms | 0.0464 ± 0.0013 ms  | 1.56 ± 0.12                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.392 ± 0.022 ms   | 0.342 ± 0.034 ms    | 1.15 ± 0.13                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.0521 ± 0.0011 ms | 0.0491 ± 0.0011 ms  | 1.06 ± 0.033               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0752 ± 0.015 ms  | 0.0586 ± 0.007 ms   | 1.28 ± 0.3                 |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 1.35 ± 0.29 ms     | 1.15 ± 0.056 ms     | 1.17 ± 0.26                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0773 ± 0.0067 ms | 0.0577 ± 0.0014 ms  | 1.34 ± 0.12                |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0724 ± 0.003 ms  | 0.0703 ± 0.0023 ms  | 1.03 ± 0.054               |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.0391 ± 0.0032 ms | 0.0403 ± 0.0041 ms  | 0.969 ± 0.13               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 14.8 ± 2.8 μs      | 12.4 ± 3.7 μs       | 1.19 ± 0.42                |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.24 ± 0.013 ms    | 0.203 ± 0.018 ms    | 1.18 ± 0.12                |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.0625 ± 0.0043 ms | 0.0476 ± 0.0045 ms  | 1.31 ± 0.15                |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.436 ± 0.059 ms   | 0.312 ± 0.017 ms    | 1.4 ± 0.2                  |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0656 ± 0.0063 ms | 0.0575 ± 0.0014 ms  | 1.14 ± 0.11                |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0717 ± 0.012 ms  | 0.0666 ± 0.0051 ms  | 1.08 ± 0.2                 |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 1.26 ± 0.08 ms     | 1.22 ± 0.034 ms     | 1.03 ± 0.071               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.121 ± 0.0065 ms  | 0.0735 ± 0.0021 ms  | 1.65 ± 0.1                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.147 ± 0.0077 ms  | 0.152 ± 0.012 ms    | 0.968 ± 0.091              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 28.8 ± 3.7 μs      | 0.047 ± 0.0034 ms   | 0.613 ± 0.091              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 0.0317 ± 0.012 ms  | 30.7 ± 2.9 μs       | 1.03 ± 0.39                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.413 ± 0.11 ms    | 0.394 ± 0.013 ms    | 1.05 ± 0.29                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.043 ± 0.0038 ms  | 0.0439 ± 0.0058 ms  | 0.982 ± 0.16               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.264 ± 0.047 ms   | 0.247 ± 0.013 ms    | 1.07 ± 0.2                 |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0659 ± 0.0027 ms | 0.0407 ± 0.00092 ms | 1.62 ± 0.076               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.036 ± 0.0016 ms  | 0.0418 ± 0.0079 ms  | 0.862 ± 0.17               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.771 ± 0.12 ms    | 0.865 ± 0.02 ms     | 0.891 ± 0.14               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0721 ± 0.0075 ms | 0.049 ± 0.0012 ms   | 1.47 ± 0.16                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.535 ± 0.021 ms   | 0.363 ± 0.034 ms    | 1.47 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.079 ± 0.005 ms   | 0.0575 ± 0.0014 ms  | 1.37 ± 0.093               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0755 ± 0.0048 ms | 0.0644 ± 0.0074 ms  | 1.17 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.67 ± 0.13 ms     | 1.45 ± 0.018 ms     | 1.15 ± 0.088               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.113 ± 0.0083 ms  | 0.076 ± 0.0018 ms   | 1.49 ± 0.12                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 1.03 ± 0.32 ms     | 1.23 ± 0.23 ms      | 0.833 ± 0.31               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0605 ± 0.0059 ms | 0.0602 ± 0.0028 ms  | 1.01 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.144 ± 0.0099 ms  | 0.155 ± 0.012 ms    | 0.93 ± 0.098               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 3.37 ± 0.75 ms     | 4.11 ± 0.85 ms      | 0.82 ± 0.25                |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0769 ± 0.005 ms  | 0.0592 ± 0.0045 ms  | 1.3 ± 0.13                 |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0712 ± 0.0016 ms | 0.0613 ± 0.00091 ms | 1.16 ± 0.031               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 4.99 ± 0.29 μs     | 4.6 ± 0.27 μs       | 1.08 ± 0.09                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 3.16 ± 2.9 μs      | 2.51 ± 0.45 μs      | 1.26 ± 1.2                 |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.0557 ± 0.02 ms   | 0.0508 ± 0.0043 ms  | 1.1 ± 0.41                 |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 10.4 ± 2.1 μs      | 10.7 ± 2.1 μs       | 0.975 ± 0.27               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.0504 ± 0.0025 ms | 0.039 ± 0.00097 ms  | 1.29 ± 0.072               |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                    | 0.0503 ± 0.0025 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                    | 14.1 ± 3.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                    | 0.109 ± 0.0031 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                    | 0.0512 ± 0.0043 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                    | 2.53 ± 0.082 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                    | 0.0527 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                    | 0.066 ± 0.0017 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                    | 0.0412 ± 0.0028 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                    | 0.984 ± 0.13 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                    | 0.0355 ± 0.0029 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                    | 0.0513 ± 0.004 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                    | 0.991 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                    | 0.16 ± 0.0036 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                    | 0.338 ± 0.037 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                    | 2.5 ± 0.045 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                    | 0.0445 ± 0.00098 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                    | 0.946 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                    | 0.0489 ± 0.0014 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                    | 0.0661 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                    | 0.0659 ± 0.0021 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                    | 8.93 ± 0.13 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                    | 0.0624 ± 0.0013 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                    | 0.982 ± 0.1 ms      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                    | 0.049 ± 0.0037 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                    | 1.22 ± 0.086 ms     |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                    | 0.133 ± 0.0066 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                    | 0.114 ± 0.0047 ms   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                    | 0.149 ± 0.0071 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                    | 0.456 ± 0.02 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                    | 0.0706 ± 0.0018 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                    | 0.0833 ± 0.0024 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                    | 0.0567 ± 0.0049 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                    | 0.145 ± 0.0049 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                    | 0.157 ± 0.0076 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                    | 1.35 ± 0.022 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                    | 0.0791 ± 0.0059 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                    | 0.181 ± 0.017 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                    | 0.068 ± 0.0014 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                    | 0.0318 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                    | 0.0566 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                    | 0.0782 ± 0.0028 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                    | 1.36 ± 0.045 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                    | 0.319 ± 0.015 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                    | 1.65 ± 0.097 ms     |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                    | 0.0715 ± 0.0015 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                    | 0.0359 ± 0.0031 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                    | 0.277 ± 0.047 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                    | 0.169 ± 0.0069 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                    | 30.7 ± 33 μs        |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                    | 1.51 ± 0.17 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                    | 0.0489 ± 0.0041 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                    | 0.108 ± 0.014 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                    | 0.069 ± 0.0043 ms   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                    | 0.0391 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                    | 0.0746 ± 0.005 ms   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                    | 0.379 ± 0.086 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                    | 0.038 ± 0.00087 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                    | 0.681 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                    | 0.683 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                    | 0.0397 ± 0.0042 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                    | 0.75 ± 0.026 ms     |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                    | 0.424 ± 0.024 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                    | 2.24 ± 0.14 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                    | 0.78 ± 0.055 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                    | 1.77 ± 0.061 ms     |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                    | 0.17 ± 0.0066 ms    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                    | 0.05 ± 0.0011 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                    | 0.103 ± 0.0079 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                    | 0.157 ± 0.0069 ms   |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                    | 0.0501 ± 0.0081 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                    | 0.0952 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                    | 0.0796 ± 0.0049 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                    | 1.23 ± 0.015 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                    | 0.35 ± 0.026 ms     |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                    | 0.398 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                    | 0.0835 ± 0.0021 ms  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                    | 0.251 ± 0.025 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                    | 0.0435 ± 0.0046 ms  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                    | 2.54 ± 0.031 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                    | 1.04 ± 0.061 ms     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                    | 0.11 ± 0.0069 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                    | 10.4 ± 1.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                    | 0.936 ± 0.1 ms      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                    | 4.3 ± 0.087 ms      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                    | 0.0989 ± 0.0074 ms  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                    | 0.115 ± 0.0041 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                    | 0.0598 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                    | 0.38 ± 0.014 ms     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                    | 0.115 ± 0.0038 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                    | 0.497 ± 0.034 ms    |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                    | 0.444 ± 0.028 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                    | 0.0514 ± 0.0021 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                    | 0.0531 ± 0.0089 ms  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                    | 0.0732 ± 0.0027 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                    | 0.246 ± 0.045 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                    | 0.302 ± 0.03 ms     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                    | 0.0659 ± 0.0016 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                    | 0.0507 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                    | 0.065 ± 0.0046 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                    | 12.1 ± 1.8 μs       |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                    | 0.0815 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                    | 0.0493 ± 0.00096 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                    | 0.0746 ± 0.0017 ms  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                    | 0.0847 ± 0.0055 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                    | 0.973 ± 0.13 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                    | 0.246 ± 0.0094 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                    | 0.457 ± 0.062 ms    |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                    | 0.135 ± 0.0091 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                    | 0.073 ± 0.045 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                    | 0.109 ± 0.0099 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                    | 0.0957 ± 0.003 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                    | 0.0929 ± 0.0022 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                    | 0.793 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                    | 31.3 ± 0.78 μs      |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                    | 0.0917 ± 0.0051 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                    | 1.05 ± 0.33 ms      |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                    | 0.0603 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                    | 0.0478 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                    | 0.662 ± 0.088 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                    | 1.59 ± 0.1 ms       |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                    | 1.31 ± 0.041 ms     |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                    | 0.0668 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                    | 0.0902 ± 0.0074 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                    | 0.0442 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                    | 0.0829 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                    | 1.58 ± 0.019 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                    | 3.18 ± 0.12 ms      |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                    | 1.4 ± 0.17 ms       |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                    | 0.0485 ± 0.0034 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                    | 0.0561 ± 0.0017 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                    | 1.04 ± 0.093 ms     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                    | 0.0361 ± 0.0034 ms  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                    | 0.0584 ± 0.0011 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                    | 0.367 ± 0.065 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                    | 0.0585 ± 0.0015 ms  |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                    | 0.0428 ± 0.009 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                    | 0.0633 ± 0.0039 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                    | 0.241 ± 0.033 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                    | 0.0423 ± 0.0065 ms  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                    | 0.0347 ± 0.0016 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                    | 1.19 ± 0.085 ms     |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                    | 0.033 ± 0.0029 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                    | 0.364 ± 0.085 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                    | 0.126 ± 0.01 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                    | 0.116 ± 0.01 ms     |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                    | 0.071 ± 0.0029 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                    | 0.0622 ± 0.0061 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                    | 0.0985 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                    | 1.49 ± 0.04 ms      |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                    | 0.254 ± 0.028 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                    | 0.38 ± 0.037 ms     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                    | 0.0611 ± 0.0012 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                    | 1.09 ± 0.028 ms     |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                    | 0.47 ± 0.069 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                    | 8.39 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                    | 0.399 ± 0.051 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                    | 0.0954 ± 0.0066 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                    | 10.3 ± 1.1 μs       |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                    | 0.0994 ± 0.0032 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                    | 2.85 ± 0.039 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                    | 0.0687 ± 0.0064 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                    | 30.1 ± 3 μs         |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                    | 1.12 ± 0.12 ms      |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                    | 0.0325 ± 0.0013 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                    | 0.153 ± 0.012 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                    | 3.53 ± 0.14 ms      |                            |
| time_to_load                                                                                | 0.234 ± 0.0017 s   | 0.344 ± 0.0032 s    | 0.679 ± 0.008              |

|                                                                                             | v0.1.0                    | d07c44981cefa3...         | v0.1.0 / d07c44981cefa3... |
|:--------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.629 k allocs: 0.0346 MB | 0.629 k allocs: 0.0346 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 0.147 k allocs: 7.97 kB   | 0.152 k allocs: 7.52 kB   | 1.06                       |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 2.99 k allocs: 0.267 MB   | 2.99 k allocs: 0.267 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.15 k allocs: 11.9 kB    | 0.165 k allocs: 11.8 kB   | 1.01                       |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 4.7 k allocs: 0.505 MB    | 4.7 k allocs: 0.505 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 0.122 k allocs: 12.5 kB   | 0.134 k allocs: 10.9 kB   | 1.15                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 3.26 k allocs: 0.495 MB   | 0.558 k allocs: 0.163 MB  | 3.03                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 8.89 k allocs: 0.0511 GB  | 7.45 k allocs: 0.0492 GB  | 1.04                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 9.4 k allocs: 0.381 MB    | 1.34 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.054 k allocs: 0.0376 MB | 0.046 k allocs: 19.2 kB   | 2.01                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 21.4 kB   | 1.89                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 1.53 k allocs: 0.294 MB   | 0.211 k allocs: 0.101 MB  | 2.91                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 2.1 k allocs: 24.8 MB     | 1.8 k allocs: 24.2 MB     | 1.03                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 5.84 k allocs: 0.353 MB   | 0.162 k allocs: 0.1 MB    | 3.51                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.18 k allocs: 0.0375 MB  | 0.222 k allocs: 29.1 kB   | 1.32                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 0.822 k allocs: 1.78 MB   | 0.762 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 1.53 k allocs: 0.308 MB   | 0.388 k allocs: 0.14 MB   | 2.2                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 6.2 k allocs: 0.0508 GB   | 5.62 k allocs: 0.0489 GB  | 1.04                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 9.06 k allocs: 0.369 MB   | 0.994 k allocs: 0.156 MB  | 2.37                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 3.14 k allocs: 0.279 MB   | 3.14 k allocs: 0.314 MB   | 0.886                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.246 k allocs: 20 kB     | 0.214 k allocs: 16.3 kB   | 1.23                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.303 k allocs: 0.154 MB  | 0.331 k allocs: 0.187 MB  | 0.822                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 17.4 k allocs: 0.834 MB   | 16.4 k allocs: 0.894 MB   | 0.934                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.691 k allocs: 26.1 kB   | 0.677 k allocs: 28.7 kB   | 0.909                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 3.18 k allocs: 0.261 MB   | 2.91 k allocs: 0.239 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.233 k allocs: 17.1 kB   | 0.268 k allocs: 18.8 kB   | 0.908                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.29 k allocs: 0.13 MB    | 0.272 k allocs: 0.116 MB  | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 15.7 k allocs: 0.716 MB   | 14.5 k allocs: 0.667 MB   | 1.07                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 1.15 k allocs: 0.0397 MB  | 0.851 k allocs: 0.0331 MB | 1.2                        |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.834 k allocs: 0.0414 MB | 0.79 k allocs: 0.0394 MB  | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.176 k allocs: 7.66 kB   | 0.222 k allocs: 10.1 kB   | 0.759                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 0.07 k allocs: 14.2 kB    | 0.066 k allocs: 13.4 kB   | 1.06                       |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 4.09 k allocs: 0.137 MB   | 3.77 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.809 k allocs: 25.5 kB   | 0.679 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 3.93 k allocs: 0.263 MB   | 3.31 k allocs: 0.237 MB   | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.336 k allocs: 21.5 kB   | 0.394 k allocs: 21.3 kB   | 1.01                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.287 k allocs: 0.125 MB  | 0.287 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 15.9 k allocs: 0.718 MB   | 12.3 k allocs: 0.625 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 1.3 k allocs: 0.0436 MB   | 0.933 k allocs: 0.0356 MB | 1.23                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 1.5 k allocs: 0.132 MB    | 1.34 k allocs: 0.119 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 0.198 k allocs: 15.6 kB   | 0.274 k allocs: 21.2 kB   | 0.735                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 0.174 k allocs: 0.0836 MB | 0.158 k allocs: 0.075 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 5.38 k allocs: 0.321 MB   | 4.64 k allocs: 0.293 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.39 k allocs: 16.1 kB    | 0.472 k allocs: 25.1 kB   | 0.643                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 2.74 k allocs: 0.209 MB   | 2.5 k allocs: 0.189 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.382 k allocs: 21.7 kB   | 0.229 k allocs: 14.4 kB   | 1.51                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.237 k allocs: 0.105 MB  | 0.217 k allocs: 0.0927 MB | 1.13                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 12.3 k allocs: 0.571 MB   | 11.2 k allocs: 0.529 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 1.02 k allocs: 0.0353 MB  | 0.719 k allocs: 28.3 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 4.32 k allocs: 0.329 MB   | 3.48 k allocs: 0.276 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.382 k allocs: 24.6 kB   | 0.367 k allocs: 23.2 kB   | 1.06                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.338 k allocs: 0.149 MB  | 0.314 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.737 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 1.35 k allocs: 0.046 MB   | 0.985 k allocs: 0.039 MB  | 1.18                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 10.7 k allocs: 0.915 MB   | 9.83 k allocs: 0.842 MB   | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.383 k allocs: 25 kB     | 0.276 k allocs: 22 kB     | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.886 k allocs: 0.384 MB  | 0.818 k allocs: 0.338 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 0.0515 M allocs: 2.58 MB  | 0.0474 M allocs: 2.42 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.863 k allocs: 0.033 MB  | 0.841 k allocs: 0.0347 MB | 0.952                      |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.091 k allocs: 0.0452 MB | 0.075 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.04 k allocs: 0.0395 MB  | 0.036 k allocs: 0.0384 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 0.034 k allocs: 7.98 kB   | 0.032 k allocs: 7.77 kB   | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.072 k allocs: 0.0443 MB | 0.056 k allocs: 0.042 MB  | 1.06                       |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.074 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                           | 1.2 k allocs: 0.046 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                           | 0.276 k allocs: 18.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                           | 23.7 k allocs: 1.22 MB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.254 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.748 k allocs: 30.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                           | 0.341 k allocs: 14.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.8 k allocs: 0.749 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                           | 0.933 k allocs: 0.119 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.41 k allocs: 26.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                           | 3.37 k allocs: 0.241 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                           | 23.4 k allocs: 1.19 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                           | 0.254 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                           | 0.623 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                           | 0.042 M allocs: 2.24 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.348 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.56 k allocs: 0.732 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                           | 0.56 k allocs: 24.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                           | 10.1 k allocs: 0.87 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                           | 0.49 k allocs: 0.19 MB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.03 k allocs: 0.0397 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.435 k allocs: 22.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.78 k allocs: 0.355 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.99 k allocs: 0.0381 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.53 k allocs: 0.0356 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.354 k allocs: 16.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.641 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.9 k allocs: 0.662 MB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                           | 0.886 k allocs: 0.342 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.399 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                           | 0.354 k allocs: 26.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                           | 0.409 k allocs: 24.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                           | 19.3 k allocs: 0.913 MB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                           | 16.7 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                           | 0.317 k allocs: 20.8 kB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                           | 0.588 k allocs: 25.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                           | 0.866 k allocs: 0.302 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                           | 0.158 k allocs: 0.075 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                           | 10.5 k allocs: 0.792 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                           | 1.11 k allocs: 0.0594 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                           | 0.307 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                           | 0.252 k allocs: 19.2 kB   |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.161 k allocs: 0.0339 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.64 k allocs: 0.293 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                           | 0.169 k allocs: 12.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                           | 4.93 k allocs: 0.521 MB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 0.722 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                           | 0.181 k allocs: 8.3 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.2 k allocs: 0.565 MB    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                           | 5.96 k allocs: 0.466 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                           | 21.7 k allocs: 1.02 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                           | 0.689 k allocs: 0.036 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                           | 1.26 k allocs: 0.0523 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                           | 0.802 k allocs: 0.298 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.986 k allocs: 0.0334 MB |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                           | 0.514 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                           | 1.26 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                           | 2.57 k allocs: 0.193 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                           | 5.44 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                           | 0.971 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                           | 0.806 k allocs: 0.402 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                           | 31.3 k allocs: 1.5 MB     |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                           | 0.053 k allocs: 11.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                           | 0.0496 M allocs: 2.59 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                           | 1.12 k allocs: 0.0465 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                           | 0.432 k allocs: 29.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                           | 0.36 k allocs: 19.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                           | 3.1 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                           | 1.1 k allocs: 0.0359 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                           | 4.69 k allocs: 0.348 MB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                           | 0.794 k allocs: 0.401 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                           | 0.74 k allocs: 31.2 kB    |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                           | 0.482 k allocs: 0.226 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                           | 0.855 k allocs: 0.0321 MB |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                           | 2.25 k allocs: 0.18 MB    |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                           | 0.67 k allocs: 28.1 kB    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                           | 0.357 k allocs: 19.9 kB   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                           | 0.24 k allocs: 0.06 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                           | 0.45 k allocs: 29.5 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                           | 0.289 k allocs: 18.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                           | 0.818 k allocs: 0.041 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                           | 0.478 k allocs: 0.175 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                           | 2.82 k allocs: 0.519 MB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                           | 3.25 k allocs: 0.322 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                           | 0.632 k allocs: 0.223 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                           | 0.338 k allocs: 0.136 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                           | 1.14 k allocs: 0.0607 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                           | 0.97 k allocs: 0.0321 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                           | 0.929 k allocs: 0.0338 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                           | 7.08 k allocs: 0.55 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                           | 0.135 k allocs: 13.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                           | 0.338 k allocs: 0.187 MB  |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                           | 17.3 k allocs: 0.991 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                           | 0.371 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                           | 6.07 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                           | 22 k allocs: 1.03 MB      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                           | 0.716 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                           | 0.471 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                           | 15.8 k allocs: 0.786 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                           | 0.041 M allocs: 2.14 MB   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                           | 10.3 k allocs: 0.784 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                           | 0.243 k allocs: 17.7 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                           | 0.847 k allocs: 0.0326 MB |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                           | 0.045 k allocs: 0.0318 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                           | 0.343 k allocs: 19.7 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                           | 4.89 k allocs: 0.382 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.352 k allocs: 23.2 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                           | 0.464 k allocs: 0.145 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                           | 0.562 k allocs: 23.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.237 k allocs: 0.0936 MB |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                           | 0.246 k allocs: 16.5 kB   |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                           | 18.2 k allocs: 1.04 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                           | 0.151 k allocs: 6.91 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.947 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                           | 0.482 k allocs: 0.189 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                           | 1.08 k allocs: 0.0402 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.471 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.278 k allocs: 0.116 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                           | 1.14 k allocs: 0.0435 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                           | 20 k allocs: 0.958 MB     |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.99 k allocs: 0.145 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.56 k allocs: 0.284 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                           | 0.348 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                           | 14.7 k allocs: 0.68 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                           | 0.0426 M allocs: 2.27 MB  |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                           | 5.53 k allocs: 0.342 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                           | 0.867 k allocs: 0.0313 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.12 k allocs: 0.0376 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                           | 30.9 k allocs: 1.47 MB    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                           | 0.488 k allocs: 0.146 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                           | 0.207 k allocs: 16 kB     |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                           | 0.363 k allocs: 27.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.34 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                                | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

