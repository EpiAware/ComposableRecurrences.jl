|                                                                                             | v0.1.0             | 9232dcb704f3d8...  | v0.1.0 / 9232dcb704f3d8... |
|:--------------------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0436 ± 0.0056 ms | 0.0469 ± 0.0049 ms | 0.929 ± 0.15               |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 18.1 ± 0.63 μs     | 25.5 ± 1.2 μs      | 0.71 ± 0.042               |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 2.53 ± 0.23 μs     | 3.91 ± 1.5 μs      | 0.649 ± 0.25               |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.14 ± 0.021 ms    | 0.202 ± 0.045 ms   | 0.69 ± 0.19                |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 25.7 ± 1.5 μs      | 22.7 ± 4.6 μs      | 1.13 ± 0.24                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.228 ± 0.011 ms   | 0.24 ± 0.015 ms    | 0.95 ± 0.076               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 22.7 ± 1 μs        | 21.2 ± 0.88 μs     | 1.07 ± 0.065               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 30.8 ± 3.1 μs      | 0.0338 ± 0.0024 ms | 0.911 ± 0.11               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.68 ± 0.16 ms     | 0.676 ± 0.046 ms   | 1.01 ± 0.25                |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 29.5 ± 0.92 μs     | 24.1 ± 0.97 μs     | 1.22 ± 0.062               |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.421 ± 0.063 ms   | 0.457 ± 0.099 ms   | 0.921 ± 0.24               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 18.7 ± 1.9 μs      | 21.5 ± 0.9 μs      | 0.87 ± 0.095               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0586 ± 0.0082 ms | 0.0645 ± 0.0032 ms | 0.909 ± 0.13               |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.16 ± 0.17 ms     | 1.14 ± 0.28 ms     | 1.02 ± 0.29                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 27.9 ± 2.1 μs      | 19.2 ± 2.5 μs      | 1.45 ± 0.22                |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.221 ± 0.033 ms   | 0.269 ± 0.28 ms    | 0.823 ± 0.87               |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.281 ± 0.19 ms    | 0.468 ± 0.19 ms    | 0.599 ± 0.48               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 4.67 ± 0.27 ms     | 7.62 ± 3.2 ms      | 0.612 ± 0.26               |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 15.6 ± 0.38 ms     | 26.4 ± 11 ms       | 0.592 ± 0.24               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 0.666 ± 0.018 ms   | 0.148 ± 0.0057 ms  | 4.5 ± 0.21                 |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0449 ± 0.014 s   | 22.5 ± 0.38 ms     | 1.99 ± 0.62                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 0.611 ± 0.021 ms   | 0.185 ± 0.0057 ms  | 3.31 ± 0.15                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 22.1 ± 8.1 μs      | 8.55 ± 4.3 μs      | 2.58 ± 1.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.846 ± 0.059 ms   | 0.313 ± 0.029 ms   | 2.71 ± 0.31                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.0377 ± 0.0035 ms | 11.1 ± 2 μs        | 3.4 ± 0.68                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.0413 ± 0.0033 ms | 25.9 ± 4.7 μs      | 1.6 ± 0.31                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.95 ± 0.035 ms    | 0.363 ± 0.048 ms   | 2.61 ± 0.36                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.0606 ± 0.004 ms  | 0.0321 ± 0.0023 ms | 1.89 ± 0.18                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.317 ± 0.0078 ms  | 0.0549 ± 0.0021 ms | 5.77 ± 0.26                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 13.5 ± 0.99 ms     | 11.6 ± 6.6 ms      | 1.16 ± 0.66                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.332 ± 0.033 ms   | 0.0651 ± 0.002 ms  | 5.1 ± 0.54                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0574 ± 0.0094 ms | 0.0371 ± 0.0071 ms | 1.55 ± 0.39                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 1.57 ± 0.43 ms     | 0.698 ± 0.43 ms    | 2.24 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.0759 ± 0.011 ms  | 0.0445 ± 0.0029 ms | 1.71 ± 0.27                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.443 ± 0.029 ms   | 0.118 ± 0.0047 ms  | 3.77 ± 0.29                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 29.8 ± 12 ms       | 20.6 ± 13 ms       | 1.45 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.452 ± 0.02 ms    | 0.138 ± 0.0043 ms  | 3.28 ± 0.17                |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.271 ± 0.019 ms   | 0.29 ± 0.022 ms    | 0.934 ± 0.097              |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.0395 ± 0.0038 ms | 25.5 ± 1.2 μs      | 1.55 ± 0.17                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0456 ± 0.0068 ms | 0.0595 ± 0.0043 ms | 0.767 ± 0.13               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 0.837 ± 0.24 ms    | 1.06 ± 0.065 ms    | 0.788 ± 0.23               |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0393 ± 0.002 ms  | 28.3 ± 1.3 μs      | 1.39 ± 0.097               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.256 ± 0.025 ms   | 0.236 ± 0.028 ms   | 1.08 ± 0.17                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.0318 ± 0.0012 ms | 0.033 ± 0.0021 ms  | 0.962 ± 0.072              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0396 ± 0.0089 ms | 0.0383 ± 0.0054 ms | 1.04 ± 0.28                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 0.778 ± 0.064 ms   | 0.738 ± 0.032 ms   | 1.05 ± 0.098               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0455 ± 0.0034 ms | 0.0369 ± 0.0025 ms | 1.23 ± 0.12                |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0499 ± 0.0053 ms | 0.0476 ± 0.0018 ms | 1.05 ± 0.12                |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 24.4 ± 2.9 μs      | 25.8 ± 2.4 μs      | 0.946 ± 0.14               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 9.9 ± 3.2 μs       | 8.14 ± 2.2 μs      | 1.22 ± 0.51                |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.152 ± 0.022 ms   | 0.131 ± 0.017 ms   | 1.16 ± 0.23                |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 29.5 ± 9.5 μs      | 30.5 ± 2.4 μs      | 0.968 ± 0.32               |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.282 ± 0.02 ms    | 0.224 ± 0.016 ms   | 1.26 ± 0.12                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0399 ± 0.0027 ms | 0.0375 ± 0.0013 ms | 1.06 ± 0.081               |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0391 ± 0.007 ms  | 0.0487 ± 0.01 ms   | 0.802 ± 0.22               |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 0.793 ± 0.11 ms    | 0.725 ± 0.027 ms   | 1.09 ± 0.15                |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.0653 ± 0.0036 ms | 0.0445 ± 0.0019 ms | 1.47 ± 0.1                 |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.0926 ± 0.0046 ms | 0.0878 ± 0.0063 ms | 1.06 ± 0.092               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 18.5 ± 2.5 μs      | 24 ± 1.1 μs        | 0.772 ± 0.11               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 21.3 ± 1.9 μs      | 21 ± 14 μs         | 1.01 ± 0.69                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.244 ± 0.015 ms   | 0.167 ± 0.092 ms   | 1.46 ± 0.81                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 24 ± 1.5 μs        | 26.3 ± 3.7 μs      | 0.913 ± 0.14               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.175 ± 0.026 ms   | 0.171 ± 0.014 ms   | 1.02 ± 0.17                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0421 ± 0.0018 ms | 25.6 ± 0.95 μs     | 1.64 ± 0.093               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 25.7 ± 1.9 μs      | 0.0438 ± 0.0052 ms | 0.587 ± 0.082              |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.467 ± 0.082 ms   | 0.498 ± 0.014 ms   | 0.938 ± 0.17               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0426 ± 0.0042 ms | 30.1 ± 1.2 μs      | 1.41 ± 0.15                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.348 ± 0.034 ms   | 0.247 ± 0.02 ms    | 1.41 ± 0.18                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0503 ± 0.0018 ms | 0.0358 ± 0.0012 ms | 1.4 ± 0.069                |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0425 ± 0.0042 ms | 0.0451 ± 0.024 ms  | 0.941 ± 0.52               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 1.04 ± 0.1 ms      | 0.85 ± 0.021 ms    | 1.23 ± 0.13                |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.0644 ± 0.0035 ms | 0.0456 ± 0.002 ms  | 1.41 ± 0.099               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 0.684 ± 0.16 ms    | 0.848 ± 0.23 ms    | 0.807 ± 0.29               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0365 ± 0.0016 ms | 0.0453 ± 0.0028 ms | 0.806 ± 0.061              |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.0944 ± 0.0052 ms | 0.103 ± 0.0067 ms  | 0.916 ± 0.078              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 2.11 ± 0.44 ms     | 2.52 ± 0.37 ms     | 0.838 ± 0.21               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.0484 ± 0.0057 ms | 0.0355 ± 0.0026 ms | 1.36 ± 0.19                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0478 ± 0.0038 ms | 0.0345 ± 0.0011 ms | 1.39 ± 0.12                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 2.87 ± 0.35 μs     | 3.02 ± 0.25 μs     | 0.95 ± 0.14                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 1.59 ± 0.71 μs     | 1.91 ± 0.39 μs     | 0.832 ± 0.41               |
| Evaluation/Matrix overview T200_L20_S3                                                      | 17 ± 9.6 μs        | 28.7 ± 3 μs        | 0.592 ± 0.34               |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 5.74 ± 1.3 μs      | 6.47 ± 1.3 μs      | 0.887 ± 0.27               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 25.1 ± 1.4 μs      | 23.4 ± 12 μs       | 1.07 ± 0.54                |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                    | 0.0629 ± 0.0026 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                    | 0.0337 ± 0.0034 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                    | 1.49 ± 0.047 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                    | 22.9 ± 1.4 μs      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme forward                         |                    | 0.281 ± 0.013 ms   |                            |
| AD gradients/Convolution with gain and add/ForwardDiff                                      |                    | 0.0397 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                    | 0.0357 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                    | 0.543 ± 0.0088 ms  |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                    | 0.959 ± 0.083 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                    | 0.228 ± 0.019 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                    | 2.01 ± 0.1 ms      |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                    | 28.7 ± 0.92 μs     |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                    | 0.486 ± 0.021 ms   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                    | 0.0407 ± 0.0042 ms |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                    | 29.9 ± 1.2 μs      |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                    | 2.94 ± 0.098 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                    | 29.1 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                    | 0.825 ± 0.049 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                    | 0.0866 ± 0.0042 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                    | 0.065 ± 0.0022 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                    | 0.0448 ± 0.0015 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                    | 0.325 ± 0.028 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                    | 0.0412 ± 0.0019 ms |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                    | 0.0367 ± 0.0016 ms |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                    | 0.104 ± 0.007 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                    | 1.34 ± 0.25 ms     |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                    | 0.792 ± 0.046 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                    | 0.0425 ± 0.0012 ms |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake forward                              |                    | 0.801 ± 0.22 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                    | 0.959 ± 0.033 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake reverse            |                    | 22.3 ± 2.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                    | 0.17 ± 0.011 ms    |                            |
| AD gradients/Convolution with gain and add/Enzyme reverse                                   |                    | 0.0394 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                    | 0.0344 ± 0.017 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                    | 0.0466 ± 0.011 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme reverse    |                    | 25.9 ± 1.1 μs      |                            |
| AD gradients/Convolution lag contributions/Mooncake forward                                 |                    | 0.736 ± 0.077 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                    | 24.2 ± 1.2 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                    | 0.443 ± 0.028 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                    | 24.9 ± 2.4 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                    | 0.548 ± 0.058 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                    | 1.06 ± 0.081 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                    | 0.0912 ± 0.0037 ms |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                    | 0.0586 ± 0.0037 ms |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                    | 28.8 ± 4.6 μs      |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                    | 0.0495 ± 0.0031 ms |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                    | 0.23 ± 0.027 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                    | 0.266 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                    | 0.0481 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                    | 0.649 ± 0.036 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                    | 1.03 ± 0.049 ms    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                    | 2.7 ± 0.21 ms      |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Enzyme reverse                         |                    | 23.7 ± 0.91 μs     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                    | 0.0796 ± 0.0032 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                    | 0.24 ± 0.0088 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                    | 0.0639 ± 0.0024 ms |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                    | 0.347 ± 0.024 ms   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                    | 0.168 ± 0.0084 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                    | 1.29 ± 0.015 ms    |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme reverse                                |                    | 0.0323 ± 0.0012 ms |                            |
| AD gradients/Convolution lag contributions/ForwardDiff                                      |                    | 0.0334 ± 0.0031 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                    | 0.0378 ± 0.0015 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                    | 0.0329 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                    | 0.294 ± 0.026 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                    | 0.0818 ± 0.0071 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                    | 0.0555 ± 0.0023 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                    | 19.6 ± 0.93 μs     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                    | 0.0545 ± 0.0049 ms |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Mooncake forward            |                    | 0.643 ± 0.24 ms    |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                    | 0.0388 ± 0.0012 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                    | 0.477 ± 0.041 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                    | 1.02 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                    | 0.0663 ± 0.0058 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                    | 26.4 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                    | 0.055 ± 0.002 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                    | 1.85 ± 0.066 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                    | 0.736 ± 0.033 ms   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                    | 0.038 ± 0.0032 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                    | 0.04 ± 0.0022 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                    | 0.175 ± 0.016 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                    | 27.8 ± 2.8 μs      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                    | 0.192 ± 0.046 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                    | 0.0502 ± 0.0032 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                    | 0.0422 ± 0.019 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                    | 0.257 ± 0.019 ms   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                    | 0.264 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                    | 0.0408 ± 0.0036 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                    | 0.151 ± 0.021 ms   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                    | 0.295 ± 0.12 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                    | 0.0576 ± 0.0024 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                    | 0.103 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                    | 30.3 ± 1.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                    | 8.2 ± 2.4 μs       |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                    | 0.0338 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                    | 0.0393 ± 0.0019 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                    | 0.716 ± 0.085 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                    | 26.3 ± 2.9 μs      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                    | 0.0479 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                    | 0.0393 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                    | 0.0441 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                    | 0.041 ± 0.0024 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                    | 0.694 ± 0.081 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                    | 0.0527 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                    | 0.0337 ± 0.0025 ms |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                    | 0.0507 ± 0.0041 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                    | 0.121 ± 0.011 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                    | 21.9 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                    | 0.0362 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                    | 0.0466 ± 0.0025 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                    | 0.227 ± 0.023 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                    | 0.0469 ± 0.0018 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                    | 0.116 ± 0.054 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                    | 0.748 ± 0.032 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                    | 27.6 ± 4.1 μs      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                    | 0.0686 ± 0.0062 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                    | 0.0528 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                    | 0.232 ± 0.037 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                    | 0.0396 ± 0.0015 ms |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                    | 0.408 ± 0.011 ms   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                    | 0.537 ± 0.065 ms   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                    | 0.252 ± 0.027 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                    | 1.36 ± 0.17 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                    | 0.0332 ± 0.0015 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                    | 0.106 ± 0.0085 ms  |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/ForwardDiff       |                    | 0.046 ± 0.0058 ms  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                    | 0.648 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                    | 0.122 ± 0.0098 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                    | 27.4 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                    | 1.45 ± 0.034 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                    | 0.0655 ± 0.0061 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                    | 7.98 ± 1.2 μs      |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                    | 0.065 ± 0.0065 ms  |                            |
| AD gradients/Convolution lag contributions/Mooncake reverse                                 |                    | 27.5 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                    | 0.0405 ± 0.0016 ms |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                    | 0.121 ± 0.0093 ms  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                    | 31.1 ± 1.2 μs      |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/ForwardDiff                 |                    | 0.0453 ± 0.0061 ms |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake reverse                    |                    | 0.0422 ± 0.0026 ms |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                    | 0.0373 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                    | 6.93 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                    | 0.0522 ± 0.0016 ms |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                    | 0.049 ± 0.002 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                    | 0.0551 ± 0.0066 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                    | 0.765 ± 0.32 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                    | 0.156 ± 0.022 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                    | 0.0492 ± 0.029 ms  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                    | 0.364 ± 0.032 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                    | 0.068 ± 0.0064 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                    | 0.0538 ± 0.0017 ms |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                    | 0.551 ± 0.061 ms   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                    | 28.4 ± 2 μs        |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                    | 22.6 ± 0.97 μs     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                    | 0.791 ± 0.03 ms    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                    | 0.0383 ± 0.0019 ms |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                    | 0.0336 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                    | 0.944 ± 0.028 ms   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme forward                         |                    | 0.371 ± 0.055 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                    | 30.3 ± 2 μs        |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                    | 0.611 ± 0.089 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                    | 23.7 ± 2.6 μs      |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                    | 0.0377 ± 0.0012 ms |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Enzyme forward    |                    | 0.247 ± 0.031 ms   |                            |
| AD gradients/Recurrence ragged Primary kernel/ForwardDiff                                   |                    | 0.0344 ± 0.004 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                    | 0.036 ± 0.0023 ms  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake reverse                       |                    | 0.0512 ± 0.0097 ms |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme reverse              |                    | 22.4 ± 0.99 μs     |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake forward  |                    | 0.748 ± 0.053 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                    | 0.108 ± 0.0094 ms  |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                    | 20.5 ± 1.8 μs      |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                    | 0.0653 ± 0.0016 ms |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                    | 0.0584 ± 0.004 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                    | 0.0404 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Mooncake forward                    |                    | 0.921 ± 0.076 ms   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake forward                       |                    | 0.808 ± 0.077 ms   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                    | 0.69 ± 0.039 ms    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                    | 2.77 ± 0.089 ms    |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme forward                      |                    | 0.266 ± 0.029 ms   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/Mooncake reverse                       |                    | 0.0338 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                    | 0.0542 ± 0.0024 ms |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                    | 7.2 ± 1.2 μs       |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                    | 1.75 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/ForwardDiff                         |                    | 0.0384 ± 0.0037 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                    | 21.7 ± 2.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                    | 0.663 ± 0.067 ms   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                    | 23.3 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                    | 2.13 ± 0.088 ms    |                            |
| time_to_load                                                                                | 0.14 ± 0.00077 s   | 0.233 ± 0.0057 s   | 0.602 ± 0.015              |

|                                                                                             | v0.1.0                    | 9232dcb704f3d8...         | v0.1.0 / 9232dcb704f3d8... |
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
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 9.06 k allocs: 0.369 MB   | 0.992 k allocs: 0.156 MB  | 2.37                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 3.14 k allocs: 0.279 MB   | 3.13 k allocs: 0.314 MB   | 0.887                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.246 k allocs: 20 kB     | 0.212 k allocs: 16.2 kB   | 1.23                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.303 k allocs: 0.154 MB  | 0.317 k allocs: 0.187 MB  | 0.824                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 17.4 k allocs: 0.834 MB   | 16.2 k allocs: 0.89 MB    | 0.938                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.691 k allocs: 26.1 kB   | 0.675 k allocs: 28.7 kB   | 0.911                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 3.18 k allocs: 0.261 MB   | 2.9 k allocs: 0.239 MB    | 1.1                        |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.8 kB   | 0.91                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.29 k allocs: 0.13 MB    | 0.26 k allocs: 0.115 MB   | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 15.7 k allocs: 0.716 MB   | 14.4 k allocs: 0.664 MB   | 1.08                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 1.15 k allocs: 0.0397 MB  | 0.849 k allocs: 0.0331 MB | 1.2                        |
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
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 19.4 k allocs: 0.879 MB   | 15 k allocs: 0.734 MB     | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 1.35 k allocs: 0.046 MB   | 0.983 k allocs: 0.0389 MB | 1.18                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 10.7 k allocs: 0.915 MB   | 9.8 k allocs: 0.841 MB    | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.383 k allocs: 25 kB     | 0.274 k allocs: 21.9 kB   | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.886 k allocs: 0.384 MB  | 0.784 k allocs: 0.337 MB  | 1.14                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 0.0515 M allocs: 2.58 MB  | 0.047 M allocs: 2.41 MB   | 1.07                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.863 k allocs: 0.033 MB  | 0.839 k allocs: 0.0346 MB | 0.953                      |
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
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                           | 0.929 k allocs: 0.119 MB  |                            |
| AD gradients/Convolution with gain and add/Mooncake forward                                 |                           | 22.5 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                           | 3.37 k allocs: 0.241 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                           | 23.2 k allocs: 1.19 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                           | 0.252 k allocs: 17.2 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                           | 14.1 k allocs: 0.628 MB   |                            |
| AD gradients/Convolution with gain and add/Mooncake reverse                                 |                           | 0.88 k allocs: 31.8 kB    |                            |
| AD gradients/NoAdjoint Convolution ragged kernel truncated at the horizon/Mooncake reverse  |                           | 0.623 k allocs: 26.9 kB   |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                           | 0.0417 M allocs: 2.23 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                           | 0.56 k allocs: 24.9 kB    |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                           | 10.1 k allocs: 0.869 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                           | 0.474 k allocs: 0.19 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.03 k allocs: 0.0396 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.433 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.77 k allocs: 0.355 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.988 k allocs: 0.038 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.352 k allocs: 16.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.623 k allocs: 0.225 MB  |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Mooncake forward                       |                           | 23.6 k allocs: 1.09 MB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.8 k allocs: 0.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.397 k allocs: 22.5 kB   |                            |
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
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                           | 2.57 k allocs: 0.193 MB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Enzyme forward                                |                           | 5.43 k allocs: 0.339 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                           | 0.967 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                           | 12.9 k allocs: 0.572 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                           | 11.7 k allocs: 0.564 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                           | 0.0492 M allocs: 2.57 MB  |                            |
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
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                           | 0.369 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                           | 6.05 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                           | 21.8 k allocs: 1.03 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                           | 0.469 k allocs: 30 kB     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                           | 0.0406 M allocs: 2.13 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                           | 10.3 k allocs: 0.783 MB   |                            |
| AD gradients/NoAdjoint Convolution lag contributions/ForwardDiff                            |                           | 0.234 k allocs: 0.249 MB  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.35 k allocs: 23.1 kB    |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.227 k allocs: 0.0934 MB |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.943 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.457 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.266 k allocs: 0.116 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.55 k allocs: 0.284 MB   |                            |
| AD gradients/Convolution lag contributions/Enzyme forward                                   |                           | 2.41 k allocs: 0.34 MB    |                            |
| AD gradients/NoAdjoint Convolution with gain and add/ForwardDiff                            |                           | 0.314 k allocs: 0.163 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.95 k allocs: 0.144 MB   |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.33 k allocs: 0.119 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.07 k allocs: 13.7 kB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.252 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.744 k allocs: 30 kB     |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.77 k allocs: 0.748 MB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.238 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.408 k allocs: 26.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.828 k allocs: 31.4 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.658 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.346 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.53 k allocs: 0.731 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.528 k allocs: 0.0355 MB |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.693 k allocs: 22.5 kB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.183 k allocs: 0.0407 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                           | 0.852 k allocs: 0.341 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                           | 0.354 k allocs: 26.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence ragged Primary kernel/Enzyme reverse                      |                           | 0.407 k allocs: 24.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                           | 0.839 k allocs: 0.0328 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                           | 2.98 k allocs: 0.246 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                           | 0.315 k allocs: 20.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                           | 0.834 k allocs: 0.301 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                           | 10.5 k allocs: 0.792 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                           | 0.246 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                           | 1.11 k allocs: 0.0594 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.161 k allocs: 0.034 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.56 k allocs: 0.291 MB   |                            |
| AD gradients/NoAdjoint Convolution with gain and add/Enzyme reverse                         |                           | 0.242 k allocs: 15.2 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 0.718 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.19 k allocs: 0.565 MB   |                            |
| AD gradients/Convolution ragged kernel truncated at the horizon/Enzyme forward              |                           | 4.78 k allocs: 0.378 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.226 k allocs: 17.3 kB   |                            |
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
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                           | 0.326 k allocs: 0.135 MB  |                            |
| AD gradients/Convolution with gain and add/Enzyme forward                                   |                           | 3.66 k allocs: 0.327 MB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                           | 1.14 k allocs: 0.0607 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                           | 0.925 k allocs: 0.0338 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                           | 7.07 k allocs: 0.55 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/Convolution lag contributions/Enzyme reverse                                   |                           | 0.166 k allocs: 13.5 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                           | 0.712 k allocs: 26.8 kB   |                            |
| AD gradients/Recurrence ragged Primary kernel/Mooncake reverse                              |                           | 0.845 k allocs: 0.0326 MB |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                           | 15.7 k allocs: 0.784 MB   |                            |
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
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                           | 14.6 k allocs: 0.677 MB   |                            |
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

