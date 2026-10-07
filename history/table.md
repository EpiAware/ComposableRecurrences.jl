|                                                                                             | v0.1.0             | e2b053c41db5bc...  | v0.1.0 / e2b053c41db5bc... |
|:--------------------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.0419 ± 0.0036 ms | 0.0436 ± 0.0043 ms | 0.96 ± 0.13                |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 18.3 ± 0.63 μs     | 21 ± 2.1 μs        | 0.873 ± 0.091              |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 2.58 ± 0.58 μs     | 6.49 ± 1.2 μs      | 0.398 ± 0.12               |
| AD gradients/Convolution delay with history/Mooncake forward                                | 0.136 ± 0.026 ms   | 0.119 ± 0.019 ms   | 1.14 ± 0.29                |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 26.8 ± 2.2 μs      | 24.2 ± 1.8 μs      | 1.11 ± 0.12                |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 0.228 ± 0.013 ms   | 0.224 ± 0.018 ms   | 1.02 ± 0.099               |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 21.5 ± 0.71 μs     | 19.3 ± 0.92 μs     | 1.12 ± 0.065               |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 30.1 ± 2 μs        | 0.0318 ± 0.0036 ms | 0.947 ± 0.12               |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 0.657 ± 0.18 ms    | 0.637 ± 0.072 ms   | 1.03 ± 0.3                 |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 28.5 ± 2.2 μs      | 22 ± 0.82 μs       | 1.3 ± 0.11                 |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 0.399 ± 0.082 ms   | 0.413 ± 0.11 ms    | 0.964 ± 0.33               |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 17.8 ± 0.7 μs      | 17.7 ± 0.83 μs     | 1 ± 0.061                  |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.0603 ± 0.0035 ms | 0.0635 ± 0.0085 ms | 0.95 ± 0.14                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 1.09 ± 0.22 ms     | 1.02 ± 0.09 ms     | 1.07 ± 0.24                |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 25.7 ± 1.5 μs      | 19 ± 2.6 μs        | 1.36 ± 0.2                 |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.243 ± 0.0082 ms  | 0.242 ± 0.03 ms    | 1 ± 0.13                   |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.266 ± 0.18 ms    | 0.266 ± 0.19 ms    | 0.998 ± 0.98               |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 4.45 ± 3.1 ms      | 4.43 ± 2.9 ms      | 1 ± 0.96                   |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 15.4 ± 9.9 ms      | 15.2 ± 10 ms       | 1.02 ± 0.93                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 0.785 ± 0.14 ms    | 0.21 ± 0.0064 ms   | 3.74 ± 0.69                |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 0.0519 ± 0.00089 s | 0.0331 ± 0.012 s   | 1.57 ± 0.58                |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 0.573 ± 0.015 ms   | 0.175 ± 0.0057 ms  | 3.27 ± 0.14                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 21.5 ± 2.4 μs      | 4.61 ± 3.8 μs      | 4.67 ± 3.9                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.842 ± 0.032 ms   | 0.3 ± 0.043 ms     | 2.8 ± 0.41                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.036 ± 0.0034 ms  | 11.5 ± 1.8 μs      | 3.14 ± 0.58                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.0385 ± 0.0034 ms | 30.2 ± 3.9 μs      | 1.28 ± 0.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.952 ± 0.035 ms   | 0.399 ± 0.15 ms    | 2.39 ± 0.89                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.0554 ± 0.0042 ms | 29.8 ± 2 μs        | 1.86 ± 0.19                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 0.329 ± 0.0098 ms  | 0.0505 ± 0.0033 ms | 6.51 ± 0.47                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 21.3 ± 6.1 ms      | 10.7 ± 5.9 ms      | 2 ± 1.3                    |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 0.319 ± 0.03 ms    | 0.0621 ± 0.0029 ms | 5.14 ± 0.55                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.0539 ± 0.008 ms  | 0.0436 ± 0.0055 ms | 1.24 ± 0.24                |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 1.11 ± 0.41 ms     | 0.646 ± 0.049 ms   | 1.71 ± 0.64                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 0.0726 ± 0.0082 ms | 0.0424 ± 0.0023 ms | 1.71 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 0.462 ± 0.029 ms   | 0.106 ± 0.0027 ms  | 4.34 ± 0.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 29.6 ± 11 ms       | 19.9 ± 13 ms       | 1.48 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 0.439 ± 0.018 ms   | 0.137 ± 0.0046 ms  | 3.2 ± 0.17                 |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 0.251 ± 0.016 ms   | 0.282 ± 0.011 ms   | 0.892 ± 0.065              |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.0356 ± 0.0018 ms | 24.9 ± 0.97 μs     | 1.43 ± 0.09                |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.0447 ± 0.028 ms  | 0.0509 ± 0.0055 ms | 0.878 ± 0.56               |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 0.641 ± 0.089 ms   | 0.985 ± 0.067 ms   | 0.651 ± 0.1                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.0368 ± 0.002 ms  | 27.4 ± 1.8 μs      | 1.34 ± 0.11                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 0.242 ± 0.018 ms   | 0.242 ± 0.024 ms   | 0.998 ± 0.12               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 31.5 ± 2.6 μs      | 0.0368 ± 0.0016 ms | 0.855 ± 0.08               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.0579 ± 0.019 ms  | 0.0762 ± 0.018 ms  | 0.76 ± 0.31                |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 0.745 ± 0.018 ms   | 0.969 ± 0.025 ms   | 0.769 ± 0.027              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 0.0406 ± 0.0023 ms | 0.0336 ± 0.0025 ms | 1.21 ± 0.11                |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.0447 ± 0.0016 ms | 0.0469 ± 0.0019 ms | 0.953 ± 0.051              |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 23.8 ± 2.5 μs      | 25.2 ± 2.1 μs      | 0.946 ± 0.13               |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 8.48 ± 2 μs        | 7.13 ± 1.4 μs      | 1.19 ± 0.35                |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 0.147 ± 0.02 ms    | 0.125 ± 0.014 ms   | 1.17 ± 0.21                |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 26.8 ± 1.3 μs      | 28.2 ± 2.5 μs      | 0.949 ± 0.097              |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 0.261 ± 0.013 ms   | 0.206 ± 0.018 ms   | 1.26 ± 0.13                |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.0403 ± 0.0031 ms | 0.0345 ± 0.0012 ms | 1.17 ± 0.1                 |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.0367 ± 0.0088 ms | 0.0475 ± 0.021 ms  | 0.772 ± 0.39               |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 0.779 ± 0.048 ms   | 0.675 ± 0.018 ms   | 1.15 ± 0.078               |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 0.0596 ± 0.0068 ms | 0.0409 ± 0.0014 ms | 1.46 ± 0.17                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 0.0888 ± 0.0058 ms | 0.0873 ± 0.006 ms  | 1.02 ± 0.097               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 16.8 ± 1.8 μs      | 22.8 ± 1.1 μs      | 0.737 ± 0.086              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 22.2 ± 15 μs       | 0.034 ± 0.017 ms   | 0.651 ± 0.53               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 0.246 ± 0.029 ms   | 0.165 ± 0.076 ms   | 1.49 ± 0.71                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 22.1 ± 0.89 μs     | 25 ± 2 μs          | 0.886 ± 0.08               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 0.169 ± 0.03 ms    | 0.168 ± 0.016 ms   | 1.01 ± 0.21                |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.0389 ± 0.0017 ms | 23.7 ± 0.82 μs     | 1.64 ± 0.09                |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 24.3 ± 2.4 μs      | 23.6 ± 4.8 μs      | 1.03 ± 0.23                |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 0.448 ± 0.082 ms   | 0.476 ± 0.013 ms   | 0.939 ± 0.17               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 0.0425 ± 0.0072 ms | 27.9 ± 1 μs        | 1.53 ± 0.27                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 0.328 ± 0.028 ms   | 0.241 ± 0.026 ms   | 1.36 ± 0.19                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.0464 ± 0.0012 ms | 0.0336 ± 0.0012 ms | 1.38 ± 0.062               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.0394 ± 0.0028 ms | 0.0405 ± 0.0041 ms | 0.972 ± 0.12               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 0.951 ± 0.063 ms   | 0.816 ± 0.023 ms   | 1.17 ± 0.084               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 0.0613 ± 0.0063 ms | 0.0424 ± 0.0014 ms | 1.45 ± 0.16                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 0.674 ± 0.16 ms    | 0.863 ± 0.18 ms    | 0.781 ± 0.24               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.0377 ± 0.0042 ms | 0.036 ± 0.0045 ms  | 1.05 ± 0.18                |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.0937 ± 0.0061 ms | 0.0976 ± 0.0074 ms | 0.961 ± 0.096              |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 2.06 ± 0.42 ms     | 2.15 ± 0.44 ms     | 0.959 ± 0.28               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.043 ± 0.0031 ms  | 0.0349 ± 0.0046 ms | 1.23 ± 0.18                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.0376 ± 0.0089 ms | 0.0325 ± 0.0011 ms | 1.16 ± 0.28                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 2.71 ± 0.26 μs     | 2.78 ± 0.21 μs     | 0.975 ± 0.12               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 1.52 ± 0.5 μs      | 1.87 ± 0.45 μs     | 0.814 ± 0.33               |
| Evaluation/Matrix overview T200_L20_S3                                                      | 26.8 ± 3 μs        | 26.9 ± 3.3 μs      | 0.997 ± 0.17               |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 5.6 ± 1.5 μs       | 6.25 ± 1.3 μs      | 0.896 ± 0.31               |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 26.3 ± 3.9 μs      | 0.0317 ± 0.011 ms  | 0.83 ± 0.32                |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                    | 28.2 ± 1.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                    | 7.92 ± 2.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                    | 0.0613 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                    | 30.1 ± 2.8 μs      |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                    | 1.52 ± 0.073 ms    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                    | 31.2 ± 1.4 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                    | 0.0373 ± 0.0017 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                    | 22.2 ± 2.2 μs      |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                    | 0.682 ± 0.056 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                    | 24.6 ± 2.4 μs      |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                    | 0.0332 ± 0.0042 ms |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                    | 0.513 ± 0.024 ms   |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                    | 0.0698 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                    | 0.229 ± 0.023 ms   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                    | 1.51 ± 0.11 ms     |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                    | 27 ± 1.3 μs        |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                    | 0.66 ± 0.11 ms     |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                    | 0.0367 ± 0.0013 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                    | 0.0557 ± 0.0021 ms |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                    | 3.18 ± 0.067 ms    |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                    | 0.0381 ± 0.0023 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                    | 0.673 ± 0.06 ms    |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                    | 26.8 ± 2.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                    | 0.807 ± 0.062 ms   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                    | 0.0818 ± 0.0074 ms |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                    | 0.0624 ± 0.0023 ms |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                    | 0.0772 ± 0.0057 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                    | 0.306 ± 0.022 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                    | 0.0386 ± 0.0014 ms |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                    | 0.116 ± 0.0052 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                    | 31.4 ± 2.1 μs      |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                    | 0.0424 ± 0.0016 ms |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                    | 0.0808 ± 0.0067 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                    | 0.791 ± 0.054 ms   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                    | 0.0459 ± 0.0035 ms |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                    | 0.114 ± 0.017 ms   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                    | 0.0415 ± 0.002 ms  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                    | 21.6 ± 1.3 μs      |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                    | 0.043 ± 0.0018 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                    | 0.212 ± 0.028 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                    | 0.916 ± 0.041 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                    | 0.0467 ± 0.0011 ms |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                    | 0.17 ± 0.016 ms    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                    | 0.104 ± 0.0088 ms  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                    | 19.9 ± 17 μs       |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                    | 0.846 ± 0.032 ms   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                    | 25.2 ± 4.2 μs      |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                    | 0.0598 ± 0.0043 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                    | 0.0405 ± 0.0055 ms |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                    | 0.0455 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                    | 0.208 ± 0.02 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                    | 22.2 ± 0.75 μs     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                    | 0.408 ± 0.048 ms   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                    | 0.388 ± 0.013 ms   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                    | 23.4 ± 2 μs        |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                    | 0.496 ± 0.053 ms   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                    | 1.39 ± 0.27 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                    | 0.493 ± 0.027 ms   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                    | 0.705 ± 0.25 ms    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                    | 0.0888 ± 0.0042 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                    | 29.4 ± 1.2 μs      |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                    | 0.0546 ± 0.0069 ms |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                    | 0.1 ± 0.0081 ms    |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                    | 30.3 ± 6 μs        |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                    | 0.0503 ± 0.0025 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                    | 0.611 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                    | 0.217 ± 0.02 ms    |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                    | 0.0498 ± 0.0028 ms |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                    | 0.178 ± 0.0052 ms  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                    | 25.4 ± 2 μs        |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                    | 1.49 ± 0.098 ms    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                    | 0.617 ± 0.18 ms    |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                    | 0.0619 ± 0.017 ms  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                    | 7.01 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                    | 0.616 ± 0.058 ms   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                    | 2.48 ± 0.12 ms     |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                    | 0.0627 ± 0.0059 ms |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                    | 0.0515 ± 0.0035 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                    | 0.0365 ± 0.0012 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                    | 0.225 ± 0.0069 ms  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                    | 0.0646 ± 0.0026 ms |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                    | 0.308 ± 0.025 ms   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                    | 0.117 ± 0.012 ms   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                    | 29.9 ± 1.7 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                    | 0.162 ± 0.0087 ms  |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                    | 0.187 ± 0.025 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                    | 0.0371 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                    | 0.0364 ± 0.0033 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                    | 6.83 ± 1.1 μs      |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                    | 0.0497 ± 0.0014 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                    | 29.5 ± 1 μs        |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                    | 0.0473 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                    | 0.0545 ± 0.0079 ms |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                    | 0.667 ± 0.12 ms    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                    | 0.198 ± 0.019 ms   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                    | 0.274 ± 0.014 ms   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                    | 0.124 ± 0.0078 ms  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                    | 0.0422 ± 0.0046 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                    | 0.0691 ± 0.012 ms  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                    | 0.0519 ± 0.0022 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                    | 0.0518 ± 0.0015 ms |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                    | 0.653 ± 0.12 ms    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                    | 18.4 ± 0.94 μs     |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                    | 0.0459 ± 0.0047 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                    | 0.0371 ± 0.0018 ms |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                    | 26.8 ± 2 μs        |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                    | 0.444 ± 0.041 ms   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                    | 0.99 ± 0.12 ms     |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                    | 0.771 ± 0.066 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                    | 0.0378 ± 0.002 ms  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                    | 0.0677 ± 0.0062 ms |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                    | 24 ± 1 μs          |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                    | 0.0512 ± 0.0023 ms |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                    | 0.881 ± 0.03 ms    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                    | 1.82 ± 0.056 ms    |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                    | 0.778 ± 0.017 ms   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                    | 28.9 ± 2.6 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                    | 0.628 ± 0.038 ms   |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                    | 23 ± 2.3 μs        |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                    | 0.0341 ± 0.001 ms  |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                    | 0.0341 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                    | 0.0348 ± 0.0021 ms |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                    | 0.166 ± 0.012 ms   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                    | 24.4 ± 2.8 μs      |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                    | 19.2 ± 1.7 μs      |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                    | 0.187 ± 0.05 ms    |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                    | 0.0861 ± 0.0087 ms |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                    | 0.0674 ± 0.0041 ms |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                    | 0.0434 ± 0.003 ms  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                    | 0.0402 ± 0.018 ms  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                    | 0.054 ± 0.0022 ms  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                    | 0.148 ± 0.022 ms   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                    | 0.257 ± 0.03 ms    |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                    | 0.0367 ± 0.0012 ms |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                    | 0.636 ± 0.02 ms    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                    | 0.281 ± 0.1 ms     |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                    | 3.3 ± 0.17 ms      |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                    | 0.0525 ± 0.0029 ms |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                    | 6.64 ± 1.1 μs      |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                    | 0.0562 ± 0.002 ms  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                    | 1.57 ± 0.043 ms    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                    | 18 ± 2.2 μs        |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                    | 0.668 ± 0.11 ms    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                    | 22.9 ± 1.2 μs      |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                    | 0.0926 ± 0.0088 ms |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                    | 2.03 ± 0.079 ms    |                            |
| time_to_load                                                                                | 0.14 ± 0.0044 s    | 0.222 ± 0.004 s    | 0.631 ± 0.023              |

|                                                                                             | v0.1.0                    | e2b053c41db5bc...         | v0.1.0 / e2b053c41db5bc... |
|:--------------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                                  | 0.631 k allocs: 0.0348 MB | 0.631 k allocs: 0.0348 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                                  | 0.147 k allocs: 7.97 kB   | 0.152 k allocs: 7.52 kB   | 1.06                       |
| AD gradients/Convolution delay with history/ForwardDiff                                     | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                                | 4.19 k allocs: 0.138 MB   | 3.29 k allocs: 0.116 MB   | 1.19                       |
| AD gradients/Convolution delay with history/Mooncake reverse                                | 0.699 k allocs: 22.1 kB   | 0.557 k allocs: 17.8 kB   | 1.24                       |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme forward               | 2.99 k allocs: 0.268 MB   | 2.99 k allocs: 0.268 MB   | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Enzyme reverse               | 0.15 k allocs: 11.9 kB    | 0.165 k allocs: 11.8 kB   | 1.01                       |
| AD gradients/Convolution time-varying kernel indexed by output/ForwardDiff                  | 0.266 k allocs: 0.133 MB  | 0.266 k allocs: 0.133 MB  | 1                          |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake forward             | 19.8 k allocs: 0.899 MB   | 15.7 k allocs: 0.789 MB   | 1.14                       |
| AD gradients/Convolution time-varying kernel indexed by output/Mooncake reverse             | 0.682 k allocs: 24.9 kB   | 0.588 k allocs: 22.2 kB   | 1.12                       |
| AD gradients/Convolution time-varying kernel/Enzyme forward                                 | 4.7 k allocs: 0.506 MB    | 4.7 k allocs: 0.506 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                                 | 0.122 k allocs: 12.5 kB   | 0.134 k allocs: 10.9 kB   | 1.15                       |
| AD gradients/Convolution time-varying kernel/ForwardDiff                                    | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                               | 0.0319 M allocs: 1.73 MB  | 24.5 k allocs: 1.54 MB    | 1.12                       |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                               | 0.542 k allocs: 22.2 kB   | 0.448 k allocs: 19.4 kB   | 1.14                       |
| AD gradients/Loop Matrix conv_fixed T200_L20_S1/ForwardDiff                                 | 0.23 k allocs: 1.18 MB    | 0.23 k allocs: 1.18 MB    | 1                          |
| AD gradients/Loop Matrix delay_fixed T200_L20_S1/ForwardDiff                                | 0.302 k allocs: 0.806 MB  | 0.302 k allocs: 0.806 MB  | 1                          |
| AD gradients/Loop Matrix overview T200_L20_S3/ForwardDiff                                   | 0.853 k allocs: 12.3 MB   | 0.853 k allocs: 12.3 MB   | 1                          |
| AD gradients/Loop Matrix strata_mixing T200_L20_S5/ForwardDiff                              | 3.9 k allocs: 0.0393 GB   | 3.9 k allocs: 0.0393 GB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                                    | 3.26 k allocs: 0.495 MB   | 0.557 k allocs: 0.164 MB  | 3.02                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                                       | 8.89 k allocs: 0.0511 GB  | 7.45 k allocs: 0.0492 GB  | 1.04                       |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                                  | 9.4 k allocs: 0.381 MB    | 1.33 k allocs: 0.183 MB   | 2.08                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                                   | 0.054 k allocs: 0.0376 MB | 0.046 k allocs: 19.2 kB   | 2.01                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                                      | 0.344 k allocs: 1.93 MB   | 0.344 k allocs: 1.93 MB   | 1                          |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                                 | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 24.3 kB   | 2.61                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                                  | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 21.4 kB   | 1.89                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                                     | 0.542 k allocs: 1.69 MB   | 0.542 k allocs: 1.69 MB   | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                                | 0.874 k allocs: 0.0721 MB | 0.572 k allocs: 0.0314 MB | 2.3                        |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                                     | 1.53 k allocs: 0.294 MB   | 0.208 k allocs: 0.101 MB  | 2.91                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                                        | 2.1 k allocs: 24.8 MB     | 1.8 k allocs: 24.2 MB     | 1.03                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                                   | 5.84 k allocs: 0.353 MB   | 0.154 k allocs: 0.1 MB    | 3.52                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                                      | 0.18 k allocs: 0.0375 MB  | 0.217 k allocs: 28.7 kB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                         | 0.822 k allocs: 1.78 MB   | 0.762 k allocs: 1.74 MB   | 1.02                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                                    | 2.31 k allocs: 0.0849 MB  | 0.672 k allocs: 0.0405 MB | 2.1                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                                | 1.53 k allocs: 0.308 MB   | 0.384 k allocs: 0.14 MB   | 2.21                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                                   | 6.2 k allocs: 0.0508 GB   | 5.62 k allocs: 0.0489 GB  | 1.04                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                              | 9.06 k allocs: 0.369 MB   | 0.99 k allocs: 0.156 MB   | 2.37                       |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                                      | 3.15 k allocs: 0.279 MB   | 3.15 k allocs: 0.315 MB   | 0.887                      |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                                      | 0.246 k allocs: 20 kB     | 0.212 k allocs: 16.1 kB   | 1.24                       |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                         | 0.303 k allocs: 0.154 MB  | 0.331 k allocs: 0.187 MB  | 0.822                      |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                                    | 17.4 k allocs: 0.834 MB   | 16.4 k allocs: 0.894 MB   | 0.934                      |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                                    | 0.691 k allocs: 26.1 kB   | 0.659 k allocs: 27.7 kB   | 0.943                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward                | 3.18 k allocs: 0.262 MB   | 2.91 k allocs: 0.239 MB   | 1.09                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse                | 0.233 k allocs: 17.1 kB   | 0.266 k allocs: 18.6 kB   | 0.918                      |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff                   | 0.29 k allocs: 0.13 MB    | 0.272 k allocs: 0.116 MB  | 1.13                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward              | 15.7 k allocs: 0.716 MB   | 14.5 k allocs: 0.667 MB   | 1.07                       |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse              | 1.15 k allocs: 0.0397 MB  | 0.841 k allocs: 0.0324 MB | 1.23                       |
| AD gradients/Recurrence renewal/Enzyme forward                                              | 0.836 k allocs: 0.0416 MB | 0.792 k allocs: 0.0396 MB | 1.05                       |
| AD gradients/Recurrence renewal/Enzyme reverse                                              | 0.176 k allocs: 7.66 kB   | 0.217 k allocs: 9.72 kB   | 0.788                      |
| AD gradients/Recurrence renewal/ForwardDiff                                                 | 0.07 k allocs: 14.2 kB    | 0.066 k allocs: 13.4 kB   | 1.06                       |
| AD gradients/Recurrence renewal/Mooncake forward                                            | 4.09 k allocs: 0.137 MB   | 3.77 k allocs: 0.132 MB   | 1.04                       |
| AD gradients/Recurrence renewal/Mooncake reverse                                            | 0.809 k allocs: 25.5 kB   | 0.679 k allocs: 22.5 kB   | 1.13                       |
| AD gradients/Recurrence returning its state/Enzyme forward                                  | 3.93 k allocs: 0.263 MB   | 3.31 k allocs: 0.237 MB   | 1.11                       |
| AD gradients/Recurrence returning its state/Enzyme reverse                                  | 0.336 k allocs: 21.5 kB   | 0.39 k allocs: 21 kB      | 1.02                       |
| AD gradients/Recurrence returning its state/ForwardDiff                                     | 0.287 k allocs: 0.125 MB  | 0.287 k allocs: 0.125 MB  | 1                          |
| AD gradients/Recurrence returning its state/Mooncake forward                                | 15.9 k allocs: 0.718 MB   | 12.3 k allocs: 0.625 MB   | 1.15                       |
| AD gradients/Recurrence returning its state/Mooncake reverse                                | 1.3 k allocs: 0.0436 MB   | 0.929 k allocs: 0.0353 MB | 1.24                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward                 | 1.5 k allocs: 0.132 MB    | 1.34 k allocs: 0.118 MB   | 1.11                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse                 | 0.198 k allocs: 15.6 kB   | 0.273 k allocs: 20.7 kB   | 0.753                      |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff                    | 0.174 k allocs: 0.0836 MB | 0.158 k allocs: 0.075 MB  | 1.12                       |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward               | 5.38 k allocs: 0.321 MB   | 4.64 k allocs: 0.293 MB   | 1.1                        |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse               | 0.39 k allocs: 16.1 kB    | 0.472 k allocs: 24.9 kB   | 0.648                      |
| AD gradients/Recurrence sparse coupling/Enzyme forward                                      | 2.74 k allocs: 0.209 MB   | 2.51 k allocs: 0.19 MB    | 1.1                        |
| AD gradients/Recurrence sparse coupling/Enzyme reverse                                      | 0.382 k allocs: 21.7 kB   | 0.227 k allocs: 14.2 kB   | 1.52                       |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                         | 0.237 k allocs: 0.105 MB  | 0.217 k allocs: 0.0927 MB | 1.13                       |
| AD gradients/Recurrence sparse coupling/Mooncake forward                                    | 12.3 k allocs: 0.571 MB   | 11.2 k allocs: 0.529 MB   | 1.08                       |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                                    | 1.02 k allocs: 0.0353 MB  | 0.717 k allocs: 28.2 kB   | 1.28                       |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme forward                       | 4.33 k allocs: 0.33 MB    | 3.48 k allocs: 0.276 MB   | 1.2                        |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                       | 0.382 k allocs: 24.6 kB   | 0.363 k allocs: 22.8 kB   | 1.08                       |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                          | 0.338 k allocs: 0.149 MB  | 0.314 k allocs: 0.134 MB  | 1.11                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward                     | 19.4 k allocs: 0.879 MB   | 15.1 k allocs: 0.737 MB   | 1.19                       |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse                     | 1.35 k allocs: 0.046 MB   | 0.981 k allocs: 0.0386 MB | 1.19                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward                     | 10.7 k allocs: 0.917 MB   | 9.83 k allocs: 0.844 MB   | 1.09                       |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse                     | 0.383 k allocs: 25 kB     | 0.274 k allocs: 21.7 kB   | 1.15                       |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                        | 0.886 k allocs: 0.384 MB  | 0.818 k allocs: 0.338 MB  | 1.13                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward                   | 0.0515 M allocs: 2.58 MB  | 0.0474 M allocs: 2.42 MB  | 1.06                       |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse                   | 0.863 k allocs: 0.033 MB  | 0.826 k allocs: 0.0336 MB | 0.981                      |
| Evaluation/Matrix bvd_patch T200_L20_S5                                                     | 0.091 k allocs: 0.0452 MB | 0.075 k allocs: 0.0427 MB | 1.06                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                                    | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                                   | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                                      | 0.04 k allocs: 0.0395 MB  | 0.036 k allocs: 0.0384 MB | 1.03                       |
| Evaluation/Matrix renewal T200_L20_S1                                                       | 0.034 k allocs: 7.98 kB   | 0.032 k allocs: 7.77 kB   | 1.03                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                                 | 0.072 k allocs: 0.0443 MB | 0.056 k allocs: 0.042 MB  | 1.06                       |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake reverse   |                           | 0.623 k allocs: 23.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                       |                           | 0.074 k allocs: 13.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake reverse              |                           | 1.21 k allocs: 0.0457 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme reverse      |                           | 0.278 k allocs: 18.8 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake forward        |                           | 24.2 k allocs: 1.25 MB    |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme reverse                            |                           | 0.254 k allocs: 19.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake reverse              |                           | 0.748 k allocs: 30.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake reverse     |                           | 0.341 k allocs: 14.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme forward                |                           | 9.8 k allocs: 0.751 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/ForwardDiff                       |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/ForwardDiff        |                           | 0.298 k allocs: 0.134 MB  |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse                    |                           | 0.933 k allocs: 0.119 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme reverse   |                           | 0.418 k allocs: 26.7 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme forward                        |                           | 3.38 k allocs: 0.242 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake forward                  |                           | 23.3 k allocs: 1.18 MB    |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme reverse                          |                           | 0.252 k allocs: 17.1 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake forward                 |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse    |                           | 0.832 k allocs: 31.5 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme forward                        |                           | 0.66 k allocs: 0.0361 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake forward           |                           | 0.0418 M allocs: 2.23 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Enzyme reverse                        |                           | 0.348 k allocs: 21.9 kB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Enzyme forward                          |                           | 9.56 k allocs: 0.733 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake reverse              |                           | 0.551 k allocs: 24.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme forward           |                           | 10.1 k allocs: 0.872 MB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/ForwardDiff             |                           | 0.514 k allocs: 0.191 MB  |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Mooncake reverse        |                           | 1.04 k allocs: 0.0394 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme reverse             |                           | 0.432 k allocs: 22.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme forward                  |                           | 4.79 k allocs: 0.356 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake reverse                          |                           | 0.986 k allocs: 0.0379 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme reverse                          |                           | 0.53 k allocs: 0.0355 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                                  |                           | 0.697 k allocs: 22.6 kB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme reverse                   |                           | 0.355 k allocs: 16.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/ForwardDiff                   |                           | 0.668 k allocs: 0.227 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake forward                      |                           | 12.9 k allocs: 0.662 MB   |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                            |                           | 0.185 k allocs: 0.0408 MB |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/ForwardDiff              |                           | 0.886 k allocs: 0.342 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme reverse                    |                           | 0.399 k allocs: 22.5 kB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme forward                |                           | 0.356 k allocs: 26.6 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake reverse         |                           | 0.843 k allocs: 0.0329 MB |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward      |                           | 2.99 k allocs: 0.247 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake forward                          |                           | 16.7 k allocs: 0.908 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Enzyme reverse                  |                           | 0.319 k allocs: 20.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Enzyme forward                    |                           | 2.25 k allocs: 0.181 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/ForwardDiff                   |                           | 0.866 k allocs: 0.302 MB  |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/ForwardDiff          |                           | 0.158 k allocs: 0.075 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Enzyme forward   |                           | 10.5 k allocs: 0.793 MB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/ForwardDiff            |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Mooncake forward              |                           | 1.11 k allocs: 0.0587 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/ForwardDiff                           |                           | 0.307 k allocs: 0.126 MB  |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                        |                           | 0.161 k allocs: 0.0339 MB |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Mooncake forward     |                           | 4.64 k allocs: 0.293 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme reverse     |                           | 0.169 k allocs: 12.1 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme forward                       |                           | 4.93 k allocs: 0.522 MB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                         |                           | 0.722 k allocs: 0.196 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                                    |                           | 0.181 k allocs: 8.3 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme forward                |                           | 7.21 k allocs: 0.566 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake forward                     |                           | 26.5 k allocs: 1.66 MB    |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme forward                    |                           | 5.97 k allocs: 0.467 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Mooncake forward                          |                           | 21.6 k allocs: 1.01 MB    |                            |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                          |                           | 0.689 k allocs: 0.036 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse      |                           | 0.228 k allocs: 17.4 kB   |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake reverse                        |                           | 1.26 k allocs: 0.0518 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/ForwardDiff                             |                           | 0.802 k allocs: 0.298 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/ForwardDiff                      |                           | 0.254 k allocs: 0.105 MB  |                            |
| AD gradients/Recurrence returning its state after its seed/Mooncake reverse                 |                           | 0.984 k allocs: 0.0333 MB |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                        |                           | 1.27 k allocs: 0.13 MB    |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Enzyme forward                            |                           | 2.58 k allocs: 0.194 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake reverse                |                           | 0.981 k allocs: 0.0359 MB |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/ForwardDiff      |                           | 0.842 k allocs: 0.403 MB  |                            |
| AD gradients/Recurrence seeded on a growth path/ForwardDiff                                 |                           | 0.246 k allocs: 0.101 MB  |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Mooncake forward              |                           | 0.0319 M allocs: 1.54 MB  |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake forward                  |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse                      |                           | 0.812 k allocs: 0.0708 MB |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/ForwardDiff         |                           | 0.056 k allocs: 11.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake forward                          |                           | 11.8 k allocs: 0.567 MB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Mooncake forward         |                           | 0.0496 M allocs: 2.59 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/Mooncake reverse                  |                           | 1.11 k allocs: 0.046 MB   |                            |
| AD gradients/Recurrence vaccination into a protected pool/Enzyme reverse                    |                           | 0.429 k allocs: 28.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme reverse         |                           | 0.36 k allocs: 19.9 kB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Enzyme forward     |                           | 3.1 k allocs: 0.275 MB    |                            |
| AD gradients/NoAdjoint Recurrence seeded on a growth path/Mooncake reverse                  |                           | 1.1 k allocs: 0.0359 MB   |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme forward                            |                           | 4.69 k allocs: 0.349 MB   |                            |
| AD gradients/Recurrence population varying over time with births/ForwardDiff                |                           | 0.794 k allocs: 0.401 MB  |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake reverse                        |                           | 0.738 k allocs: 31 kB     |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme forward                              |                           | 2.25 k allocs: 0.181 MB   |                            |
| AD gradients/Recurrence returning its state after its seed/Enzyme forward                   |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Mooncake reverse                          |                           | 0.67 k allocs: 28.1 kB    |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Mooncake reverse                       |                           | 0.24 k allocs: 0.06 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/ForwardDiff                           |                           | 0.05 k allocs: 12.4 kB    |                            |
| AD gradients/NoAdjoint Recurrence Derived modifier parameters/Enzyme reverse                |                           | 0.47 k allocs: 31.3 kB    |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Enzyme reverse                |                           | 0.289 k allocs: 18.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                                    |                           | 0.82 k allocs: 0.0411 MB  |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/ForwardDiff                     |                           | 0.499 k allocs: 0.176 MB  |                            |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                          |                           | 2.83 k allocs: 0.52 MB    |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake forward                      |                           | 3.52 k allocs: 0.129 MB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/Enzyme forward                            |                           | 3.25 k allocs: 0.323 MB   |                            |
| AD gradients/Recurrence Derived modifier parameters/ForwardDiff                             |                           | 0.632 k allocs: 0.223 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/ForwardDiff                |                           | 0.338 k allocs: 0.136 MB  |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake forward    |                           | 1.18 k allocs: 0.0635 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake reverse       |                           | 0.97 k allocs: 0.0321 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake reverse           |                           | 0.929 k allocs: 0.0338 MB |                            |
| AD gradients/Recurrence Derived modifier parameters/Enzyme forward                          |                           | 7.09 k allocs: 0.551 MB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Enzyme reverse                       |                           | 0.135 k allocs: 13.3 kB   |                            |
| AD gradients/NoAdjoint Recurrence pairwise kernel/ForwardDiff                               |                           | 0.338 k allocs: 0.187 MB  |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme reverse             |                           | 0.371 k allocs: 23.3 kB   |                            |
| AD gradients/NoAdjoint Convolution delay with history/Mooncake reverse                      |                           | 0.64 k allocs: 21.1 kB    |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme forward          |                           | 6.08 k allocs: 0.477 MB   |                            |
| AD gradients/NoAdjoint Recurrence grouped totals (Allocate)/Mooncake forward                |                           | 22.4 k allocs: 1.06 MB    |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel indexed by output/Mooncake forward   |                           | 16.7 k allocs: 0.849 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/Mooncake reverse                          |                           | 0.716 k allocs: 26.9 kB   |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/ForwardDiff                          |                           | 0.497 k allocs: 0.292 MB  |                            |
| AD gradients/NoAdjoint Convolution time-varying kernel/Mooncake reverse                     |                           | 0.483 k allocs: 21.1 kB   |                            |
| AD gradients/NoAdjoint Recurrence vaccination into a protected pool/Enzyme reverse          |                           | 0.479 k allocs: 30.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Mooncake forward           |                           | 15.8 k allocs: 0.786 MB   |                            |
| AD gradients/Recurrence Primary time-varying kernel/Mooncake forward                        |                           | 0.041 M allocs: 2.14 MB   |                            |
| AD gradients/Recurrence population varying over time with births/Enzyme forward             |                           | 10.3 k allocs: 0.785 MB   |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/Enzyme reverse                |                           | 0.245 k allocs: 18 kB     |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake forward                            |                           | 13 k allocs: 0.574 MB     |                            |
| AD gradients/NoAdjoint Matrix conv_fixed T200_L20_S1/Enzyme reverse                         |                           | 0.045 k allocs: 0.0318 MB |                            |
| AD gradients/Recurrence grouped totals (Allocate)/Enzyme reverse                            |                           | 0.341 k allocs: 19.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence time-varying kernel and coupling/Enzyme reverse           |                           | 0.352 k allocs: 23.2 kB   |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Mooncake reverse    |                           | 0.572 k allocs: 23.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Enzyme forward         |                           | 2.69 k allocs: 0.196 MB   |                            |
| AD gradients/NoAdjoint Recurrence sparse coupling/ForwardDiff                               |                           | 0.237 k allocs: 0.0936 MB |                            |
| AD gradients/NoAdjoint Convolution delay with history/Enzyme reverse                        |                           | 0.151 k allocs: 6.91 kB   |                            |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                           |                           | 0.947 k allocs: 0.228 MB  |                            |
| AD gradients/Recurrence vaccination into a protected pool/ForwardDiff                       |                           | 0.482 k allocs: 0.189 MB  |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake reverse |                           | 1.09 k allocs: 0.0404 MB  |                            |
| AD gradients/Recurrence grouped totals (Allocate)/ForwardDiff                               |                           | 0.471 k allocs: 0.174 MB  |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff         |                           | 0.278 k allocs: 0.116 MB  |                            |
| AD gradients/Recurrence population varying over time with births/Mooncake reverse           |                           | 1.13 k allocs: 0.0432 MB  |                            |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                                  |                           | 3.99 k allocs: 0.145 MB   |                            |
| AD gradients/NoAdjoint Recurrence strata, coupling and depletion/Enzyme forward             |                           | 3.56 k allocs: 0.284 MB   |                            |
| AD gradients/Recurrence seeded on a growth path/Enzyme reverse                              |                           | 0.347 k allocs: 17.4 kB   |                            |
| AD gradients/NoAdjoint Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward    |                           | 14.7 k allocs: 0.68 MB    |                            |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse                      |                           | 1.9 k allocs: 0.274 MB    |                            |
| AD gradients/NoAdjoint Recurrence population varying over time with births/Mooncake forward |                           | 0.0434 M allocs: 2.33 MB  |                            |
| AD gradients/NoAdjoint Recurrence returning its state/Mooncake reverse                      |                           | 0.867 k allocs: 0.0313 MB |                            |
| AD gradients/Recurrence Transform with per-stratum parameters/ForwardDiff                   |                           | 0.052 k allocs: 11.3 kB   |                            |
| AD gradients/Recurrence seeded on a growth path/Mooncake reverse                            |                           | 1.11 k allocs: 0.0376 MB  |                            |
| AD gradients/Recurrence Derived modifier parameters/Mooncake forward                        |                           | 30.8 k allocs: 1.46 MB    |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme reverse       |                           | 0.207 k allocs: 15.9 kB   |                            |
| AD gradients/NoAdjoint Recurrence returning its state after its seed/Mooncake forward       |                           | 14.2 k allocs: 0.63 MB    |                            |
| AD gradients/NoAdjoint Recurrence Transform with per-stratum parameters/Enzyme forward      |                           | 0.366 k allocs: 27.5 kB   |                            |
| AD gradients/NoAdjoint Recurrence scalar modifier field, mixed eltypes/Enzyme forward       |                           | 1.34 k allocs: 0.118 MB   |                            |
| AD gradients/NoAdjoint Recurrence Primary time-varying kernel/Mooncake forward              |                           | 0.0431 M allocs: 2.27 MB  |                            |
| time_to_load                                                                                | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

