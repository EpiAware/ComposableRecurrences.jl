|                                                                                      | v0.1.0              | c9d13e13545c7e...   | v0.1.0 / c9d13e13545c7e... |
|:-------------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.0614 ± 0.0045 ms  | 0.061 ± 0.0048 ms   | 1.01 ± 0.11                |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 30.2 ± 0.61 μs      | 29.7 ± 0.58 μs      | 1.02 ± 0.029               |
| AD gradients/Convolution delay with history/ForwardDiff                              | 9.1 ± 0.53 μs       | 8.98 ± 0.53 μs      | 1.01 ± 0.085               |
| AD gradients/Convolution delay with history/Mooncake forward                         | 0.239 ± 0.035 ms    | 0.238 ± 0.03 ms     | 1.01 ± 0.19                |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.0498 ± 0.0016 ms  | 0.0494 ± 0.0014 ms  | 1.01 ± 0.043               |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 5.82 ± 0.042 μs     | 5.74 ± 0.043 μs     | 1.01 ± 0.011               |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.0507 ± 0.0018 ms  | 0.0506 ± 0.0011 ms  | 1 ± 0.041                  |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 0.622 ± 0.032 ms    | 0.627 ± 0.028 ms    | 0.993 ± 0.067              |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 30 ± 2.6 μs         | 30.1 ± 2.1 μs       | 0.997 ± 0.11               |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.0747 ± 0.012 ms   | 0.0752 ± 0.11 ms    | 0.993 ± 1.5                |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 1.99 ± 0.22 ms      | 1.99 ± 0.18 ms      | 0.998 ± 0.14               |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.0545 ± 0.0017 ms  | 0.0559 ± 0.0018 ms  | 0.974 ± 0.044              |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 12.8 ± 0.13 μs      | 12.6 ± 0.27 μs      | 1.01 ± 0.024               |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 0.116 ± 0.02 ms     | 0.116 ± 0.018 ms    | 0.999 ± 0.23               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 1.21 ± 0.07 ms      | 1.38 ± 0.32 ms      | 0.881 ± 0.21               |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 1.26 ± 0.13 ms      | 1.33 ± 0.13 ms      | 0.948 ± 0.13               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.0647 ± 0.0055 ms  | 0.0631 ± 0.0054 ms  | 1.03 ± 0.12                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.11 ± 0.0054 ms    | 0.11 ± 0.0056 ms    | 1 ± 0.071                  |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 0.579 ± 0.019 ms    | 0.622 ± 0.11 ms     | 0.93 ± 0.17                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 0.607 ± 0.058 ms    | 0.618 ± 0.075 ms    | 0.982 ± 0.15               |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.102 ± 0.0053 ms   | 0.102 ± 0.005 ms    | 0.997 ± 0.071              |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 0.153 ± 0.03 ms     | 0.149 ± 0.028 ms    | 1.03 ± 0.28                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 0.844 ± 0.082 ms    | 0.895 ± 0.17 ms     | 0.943 ± 0.2                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 0.852 ± 0.12 ms     | 0.953 ± 0.12 ms     | 0.895 ± 0.17               |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 1.22 ± 0.057 ms     | 1.4 ± 0.29 ms       | 0.87 ± 0.18                |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 1.26 ± 0.13 ms      | 1.34 ± 0.12 ms      | 0.936 ± 0.13               |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.067 ± 0.006 ms    | 0.066 ± 0.0055 ms   | 1.02 ± 0.12                |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.118 ± 0.006 ms    | 0.116 ± 0.0067 ms   | 1.02 ± 0.078               |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 0.584 ± 0.02 ms     | 0.618 ± 0.02 ms     | 0.944 ± 0.045              |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 0.609 ± 0.069 ms    | 0.614 ± 0.075 ms    | 0.991 ± 0.17               |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.105 ± 0.0051 ms   | 0.105 ± 0.0053 ms   | 1 ± 0.071                  |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 0.155 ± 0.028 ms    | 0.158 ± 0.028 ms    | 0.984 ± 0.25               |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 0.852 ± 0.078 ms    | 0.857 ± 0.14 ms     | 0.994 ± 0.18               |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 0.864 ± 0.12 ms     | 0.973 ± 0.12 ms     | 0.888 ± 0.17               |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.0739 ± 0.0023 ms  | 0.0734 ± 0.0039 ms  | 1.01 ± 0.062               |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.038 ± 0.00066 ms  | 0.0374 ± 0.00068 ms | 1.01 ± 0.026               |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 13.9 ± 1.3 μs       | 13.8 ± 1.3 μs       | 1.01 ± 0.13                |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 0.238 ± 0.044 ms    | 0.234 ± 0.045 ms    | 1.02 ± 0.27                |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.0604 ± 0.0019 ms  | 0.0598 ± 0.0019 ms  | 1.01 ± 0.046               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 7.4 ± 0.18 μs       | 7.16 ± 0.072 μs     | 1.03 ± 0.027               |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 0.065 ± 0.0034 ms   | 0.0644 ± 0.0021 ms  | 1.01 ± 0.062               |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 0.417 ± 0.024 ms    | 0.423 ± 0.025 ms    | 0.987 ± 0.081              |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.0598 ± 0.0036 ms  | 0.06 ± 0.0038 ms    | 0.997 ± 0.088              |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.0606 ± 0.013 ms   | 0.0581 ± 0.0076 ms  | 1.04 ± 0.26                |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 1.28 ± 0.15 ms      | 1.27 ± 0.091 ms     | 1.01 ± 0.14                |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.0844 ± 0.0024 ms  | 0.0838 ± 0.0029 ms  | 1.01 ± 0.046               |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 0.0337 ± 0.0012 ms  | 0.0392 ± 0.00039 ms | 0.861 ± 0.031              |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 0.422 ± 0.081 ms    | 0.432 ± 0.087 ms    | 0.977 ± 0.27               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 0.371 ± 0.035 ms    | 0.375 ± 0.034 ms    | 0.988 ± 0.13               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.0546 ± 0.0018 ms  | 0.0534 ± 0.0015 ms  | 1.02 ± 0.044               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.0722 ± 0.012 ms   | 0.0743 ± 0.0081 ms  | 0.971 ± 0.19               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 1.25 ± 0.11 ms      | 1.27 ± 0.12 ms      | 0.982 ± 0.13               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 0.0887 ± 0.0039 ms  | 0.0894 ± 0.004 ms   | 0.993 ± 0.062              |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 21.9 ± 0.2 μs       | 22.6 ± 0.21 μs      | 0.97 ± 0.013               |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 0.223 ± 0.054 ms    | 0.22 ± 0.049 ms     | 1.01 ± 0.33                |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.0746 ± 0.0059 ms  | 0.0704 ± 0.0024 ms  | 1.06 ± 0.091               |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.0373 ± 0.00079 ms | 0.0358 ± 0.00065 ms | 1.04 ± 0.029               |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 13.2 ± 1.2 μs       | 13.3 ± 1.1 μs       | 0.993 ± 0.13               |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 0.237 ± 0.044 ms    | 0.239 ± 0.043 ms    | 0.992 ± 0.26               |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.0595 ± 0.0039 ms  | 0.0573 ± 0.0016 ms  | 1.04 ± 0.074               |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 7.76 ± 0.08 μs      | 7.89 ± 0.063 μs     | 0.983 ± 0.013              |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 0.0649 ± 0.0021 ms  | 0.0641 ± 0.0021 ms  | 1.01 ± 0.047               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 0.142 ± 0.0092 ms   | 0.143 ± 0.01 ms     | 0.993 ± 0.095              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 27.4 ± 0.87 μs      | 27.6 ± 0.88 μs      | 0.993 ± 0.045              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 29.3 ± 4.8 μs       | 27.1 ± 8.1 μs       | 1.08 ± 0.37                |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 0.395 ± 0.031 ms    | 0.406 ± 0.03 ms     | 0.974 ± 0.11               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.0503 ± 0.0015 ms  | 0.0511 ± 0.0016 ms  | 0.984 ± 0.043              |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 0.0327 ± 0.00034 ms | 0.0324 ± 0.00024 ms | 1.01 ± 0.013               |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 0.319 ± 0.079 ms    | 0.351 ± 0.067 ms    | 0.908 ± 0.28               |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 0.303 ± 0.023 ms    | 0.311 ± 0.026 ms    | 0.974 ± 0.11               |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.0401 ± 0.011 ms   | 0.0412 ± 0.027 ms   | 0.973 ± 0.68               |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 0.946 ± 0.071 ms    | 0.954 ± 0.096 ms    | 0.991 ± 0.12               |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 0.0836 ± 0.0025 ms  | 0.0844 ± 0.0022 ms  | 0.991 ± 0.039              |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 26.1 ± 1.1 μs       | 23.6 ± 0.5 μs       | 1.11 ± 0.053               |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 0.268 ± 0.056 ms    | 0.264 ± 0.057 ms    | 1.02 ± 0.31                |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.0776 ± 0.0044 ms  | 0.0749 ± 0.0046 ms  | 1.04 ± 0.086               |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.078 ± 0.013 ms    | 0.0806 ± 0.044 ms   | 0.968 ± 0.55               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 1.29 ± 0.096 ms     | 1.3 ± 0.12 ms       | 0.993 ± 0.12               |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 0.0985 ± 0.0051 ms  | 0.0989 ± 0.0042 ms  | 0.996 ± 0.066              |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 0.0372 ± 0.002 ms   | 0.0379 ± 0.0022 ms  | 0.984 ± 0.079              |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 0.342 ± 0.083 ms    | 0.392 ± 0.072 ms    | 0.873 ± 0.27               |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 1.21 ± 0.13 ms      | 1.22 ± 0.14 ms      | 0.99 ± 0.16                |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.0624 ± 0.0039 ms  | 0.0614 ± 0.0035 ms  | 1.02 ± 0.086               |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.141 ± 0.037 ms    | 0.154 ± 0.04 ms     | 0.916 ± 0.34               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 4.09 ± 0.48 ms      | 4.1 ± 0.36 ms       | 0.998 ± 0.14               |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.0918 ± 0.0025 ms  | 0.0916 ± 0.0027 ms  | 1 ± 0.04                   |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 22.2 ± 2.5 μs       | 22 ± 0.25 μs        | 1.01 ± 0.11                |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 0.274 ± 0.055 ms    | 0.271 ± 0.054 ms    | 1.01 ± 0.29                |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.072 ± 0.0014 ms   | 0.0718 ± 0.0012 ms  | 1 ± 0.026                  |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 5.1 ± 0.4 μs        | 5.01 ± 0.4 μs       | 1.02 ± 0.11                |
| Evaluation/Matrix overview T200_L20_S3                                               | 0.0401 ± 0.00099 ms | 0.0392 ± 0.00095 ms | 1.02 ± 0.035               |
| Evaluation/Matrix renewal T200_L20_S1                                                | 9.83 ± 0.72 μs      | 9.63 ± 0.66 μs      | 1.02 ± 0.1                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.0488 ± 0.001 ms   | 0.0486 ± 0.00095 ms | 1 ± 0.029                  |
| time_to_load                                                                         | 0.24 ± 0.0003 s     | 0.236 ± 0.0021 s    | 1.02 ± 0.009               |

|                                                                                      | v0.1.0                    | c9d13e13545c7e...         | v0.1.0 / c9d13e13545c7e... |
|:-------------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Convolution delay with history/Enzyme forward                           | 0.631 k allocs: 0.0348 MB | 0.631 k allocs: 0.0348 MB | 1                          |
| AD gradients/Convolution delay with history/Enzyme reverse                           | 0.147 k allocs: 7.97 kB   | 0.147 k allocs: 7.97 kB   | 1                          |
| AD gradients/Convolution delay with history/ForwardDiff                              | 0.042 k allocs: 12.1 kB   | 0.042 k allocs: 12.1 kB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake forward                         | 4.19 k allocs: 0.138 MB   | 4.19 k allocs: 0.138 MB   | 1                          |
| AD gradients/Convolution delay with history/Mooncake reverse                         | 0.69 k allocs: 22 kB      | 0.69 k allocs: 22 kB      | 1                          |
| AD gradients/Convolution delay with history/ReverseDiff (compiled)                   | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/Convolution delay with history/ReverseDiff (tape)                       | 0.982 k allocs: 0.0362 MB | 0.982 k allocs: 0.0362 MB | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme forward                          | 4.7 k allocs: 0.506 MB    | 4.7 k allocs: 0.506 MB    | 1                          |
| AD gradients/Convolution time-varying kernel/Enzyme reverse                          | 0.122 k allocs: 12.5 kB   | 0.122 k allocs: 12.5 kB   | 1                          |
| AD gradients/Convolution time-varying kernel/ForwardDiff                             | 0.437 k allocs: 0.289 MB  | 0.437 k allocs: 0.289 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake forward                        | 0.0319 M allocs: 1.73 MB  | 0.0319 M allocs: 1.73 MB  | 1                          |
| AD gradients/Convolution time-varying kernel/Mooncake reverse                        | 0.533 k allocs: 22 kB     | 0.533 k allocs: 22 kB     | 1                          |
| AD gradients/Convolution time-varying kernel/ReverseDiff (compiled)                  | 2  allocs: 1.48 kB        | 2  allocs: 1.48 kB        | 1                          |
| AD gradients/Convolution time-varying kernel/ReverseDiff (tape)                      | 2 k allocs: 0.0762 MB     | 2 k allocs: 0.0762 MB     | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                             | 3.26 k allocs: 0.495 MB   | 3.26 k allocs: 0.495 MB   | 1                          |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                           | 9.4 k allocs: 0.381 MB    | 9.4 k allocs: 0.381 MB    | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                           | 0.161 k allocs: 0.0396 MB | 0.161 k allocs: 0.0396 MB | 1                          |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                         | 0.874 k allocs: 0.0721 MB | 0.874 k allocs: 0.0721 MB | 1                          |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                              | 1.53 k allocs: 0.294 MB   | 1.53 k allocs: 0.294 MB   | 1                          |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                            | 5.84 k allocs: 0.353 MB   | 5.84 k allocs: 0.353 MB   | 1                          |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                               | 0.18 k allocs: 0.0375 MB  | 0.18 k allocs: 0.0375 MB  | 1                          |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                             | 2.31 k allocs: 0.0849 MB  | 2.31 k allocs: 0.0849 MB  | 1                          |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                         | 1.53 k allocs: 0.308 MB   | 1.53 k allocs: 0.308 MB   | 1                          |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                       | 9.06 k allocs: 0.369 MB   | 9.06 k allocs: 0.369 MB   | 1                          |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Enzyme reverse                   | 3.28 k allocs: 0.496 MB   | 3.28 k allocs: 0.496 MB   | 1                          |
| AD gradients/NoAdjoint Matrix bvd_patch T200_L20_S5/Mooncake reverse                 | 9.43 k allocs: 0.382 MB   | 9.43 k allocs: 0.382 MB   | 1                          |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Enzyme reverse                 | 0.166 k allocs: 0.0397 MB | 0.166 k allocs: 0.0397 MB | 1                          |
| AD gradients/NoAdjoint Matrix delay_fixed T200_L20_S1/Mooncake reverse               | 0.9 k allocs: 0.073 MB    | 0.9 k allocs: 0.073 MB    | 1                          |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Enzyme reverse                    | 1.53 k allocs: 0.294 MB   | 1.53 k allocs: 0.294 MB   | 1                          |
| AD gradients/NoAdjoint Matrix overview T200_L20_S3/Mooncake reverse                  | 5.84 k allocs: 0.353 MB   | 5.84 k allocs: 0.353 MB   | 1                          |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Enzyme reverse                     | 0.185 k allocs: 0.0377 MB | 0.185 k allocs: 0.0377 MB | 1                          |
| AD gradients/NoAdjoint Matrix renewal T200_L20_S1/Mooncake reverse                   | 2.33 k allocs: 0.086 MB   | 2.33 k allocs: 0.086 MB   | 1                          |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Enzyme reverse               | 1.55 k allocs: 0.309 MB   | 1.55 k allocs: 0.309 MB   | 1                          |
| AD gradients/NoAdjoint Matrix strata_mixing T200_L20_S5/Mooncake reverse             | 9.1 k allocs: 0.371 MB    | 9.1 k allocs: 0.371 MB    | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme forward                             | 0.862 k allocs: 0.0431 MB | 0.862 k allocs: 0.0431 MB | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Enzyme reverse                             | 0.181 k allocs: 7.84 kB   | 0.181 k allocs: 7.84 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ForwardDiff                                | 0.072 k allocs: 14.3 kB   | 0.072 k allocs: 14.3 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake forward                           | 4.17 k allocs: 0.141 MB   | 4.17 k allocs: 0.141 MB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/Mooncake reverse                           | 0.818 k allocs: 26.2 kB   | 0.818 k allocs: 26.2 kB   | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (compiled)                     | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/NoAdjoint Recurrence renewal/ReverseDiff (tape)                         | 1.25 k allocs: 0.045 MB   | 1.25 k allocs: 0.045 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Enzyme forward                               | 3.15 k allocs: 0.279 MB   | 3.15 k allocs: 0.279 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Enzyme reverse                               | 0.246 k allocs: 20 kB     | 0.246 k allocs: 20 kB     | 1                          |
| AD gradients/Recurrence pairwise kernel/ForwardDiff                                  | 0.303 k allocs: 0.154 MB  | 0.303 k allocs: 0.154 MB  | 1                          |
| AD gradients/Recurrence pairwise kernel/Mooncake forward                             | 17.3 k allocs: 0.828 MB   | 17.3 k allocs: 0.828 MB   | 1                          |
| AD gradients/Recurrence pairwise kernel/Mooncake reverse                             | 0.68 k allocs: 25.9 kB    | 0.68 k allocs: 25.9 kB    | 1                          |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (compiled)                       | 2  allocs: 0.75 kB        | 2  allocs: 0.75 kB        | 1                          |
| AD gradients/Recurrence pairwise kernel/ReverseDiff (tape)                           | 5.91 k allocs: 0.223 MB   | 5.91 k allocs: 0.223 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme forward         | 3.18 k allocs: 0.262 MB   | 3.18 k allocs: 0.262 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Enzyme reverse         | 0.233 k allocs: 17.1 kB   | 0.233 k allocs: 17.1 kB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ForwardDiff            | 0.29 k allocs: 0.13 MB    | 0.29 k allocs: 0.13 MB    | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake forward       | 15.7 k allocs: 0.709 MB   | 15.7 k allocs: 0.709 MB   | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/Mooncake reverse       | 1.14 k allocs: 0.0395 MB  | 1.14 k allocs: 0.0395 MB  | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (compiled) | 2  allocs: 0.562 kB       | 2  allocs: 0.562 kB       | 1                          |
| AD gradients/Recurrence per-stratum kernel, Diagonal coupling/ReverseDiff (tape)     | 3.55 k allocs: 0.128 MB   | 3.55 k allocs: 0.128 MB   | 1                          |
| AD gradients/Recurrence renewal/Enzyme forward                                       | 0.836 k allocs: 0.0416 MB | 0.836 k allocs: 0.0416 MB | 1                          |
| AD gradients/Recurrence renewal/Enzyme reverse                                       | 0.176 k allocs: 7.66 kB   | 0.176 k allocs: 7.66 kB   | 1                          |
| AD gradients/Recurrence renewal/ForwardDiff                                          | 0.07 k allocs: 14.2 kB    | 0.07 k allocs: 14.2 kB    | 1                          |
| AD gradients/Recurrence renewal/Mooncake forward                                     | 4.09 k allocs: 0.137 MB   | 4.09 k allocs: 0.137 MB   | 1                          |
| AD gradients/Recurrence renewal/Mooncake reverse                                     | 0.8 k allocs: 25.3 kB     | 0.8 k allocs: 25.3 kB     | 1                          |
| AD gradients/Recurrence renewal/ReverseDiff (compiled)                               | 2  allocs: 0.219 kB       | 2  allocs: 0.219 kB       | 1                          |
| AD gradients/Recurrence renewal/ReverseDiff (tape)                                   | 1.25 k allocs: 0.045 MB   | 1.25 k allocs: 0.045 MB   | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme forward          | 1.5 k allocs: 0.132 MB    | 1.5 k allocs: 0.132 MB    | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Enzyme reverse          | 0.198 k allocs: 15.6 kB   | 0.198 k allocs: 15.6 kB   | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ForwardDiff             | 0.174 k allocs: 0.0836 MB | 0.174 k allocs: 0.0836 MB | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake forward        | 5.38 k allocs: 0.321 MB   | 5.38 k allocs: 0.321 MB   | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/Mooncake reverse        | 0.381 k allocs: 16 kB     | 0.381 k allocs: 16 kB     | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (compiled)  | 2  allocs: 0.359 kB       | 2  allocs: 0.359 kB       | 1                          |
| AD gradients/Recurrence scalar modifier field, mixed eltypes/ReverseDiff (tape)      | 5.21 k allocs: 0.182 MB   | 5.21 k allocs: 0.182 MB   | 1                          |
| AD gradients/Recurrence sparse coupling/Enzyme forward                               | 2.74 k allocs: 0.209 MB   | 2.74 k allocs: 0.209 MB   | 1                          |
| AD gradients/Recurrence sparse coupling/ForwardDiff                                  | 0.237 k allocs: 0.105 MB  | 0.237 k allocs: 0.105 MB  | 1                          |
| AD gradients/Recurrence sparse coupling/Mooncake forward                             | 12.3 k allocs: 0.571 MB   | 12.3 k allocs: 0.571 MB   | 1                          |
| AD gradients/Recurrence sparse coupling/Mooncake reverse                             | 1.02 k allocs: 0.0351 MB  | 1.02 k allocs: 0.0351 MB  | 1                          |
| AD gradients/Recurrence sparse coupling/ReverseDiff (compiled)                       | 2  allocs: 0.516 kB       | 2  allocs: 0.516 kB       | 1                          |
| AD gradients/Recurrence sparse coupling/ReverseDiff (tape)                           | 4.27 k allocs: 0.15 MB    | 4.27 k allocs: 0.15 MB    | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Enzyme reverse                | 0.362 k allocs: 23.6 kB   | 0.362 k allocs: 23.6 kB   | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ForwardDiff                   | 0.338 k allocs: 0.149 MB  | 0.338 k allocs: 0.149 MB  | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake forward              | 16.1 k allocs: 0.752 MB   | 16.1 k allocs: 0.752 MB   | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/Mooncake reverse              | 1.17 k allocs: 0.0409 MB  | 1.17 k allocs: 0.0409 MB  | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (compiled)        | 2  allocs: 0.562 kB       | 2  allocs: 0.562 kB       | 1                          |
| AD gradients/Recurrence strata, coupling and depletion/ReverseDiff (tape)            | 5.52 k allocs: 0.199 MB   | 5.52 k allocs: 0.199 MB   | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme forward              | 10.7 k allocs: 0.917 MB   | 10.7 k allocs: 0.917 MB   | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Enzyme reverse              | 0.383 k allocs: 25 kB     | 0.383 k allocs: 25 kB     | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/ForwardDiff                 | 0.886 k allocs: 0.384 MB  | 0.886 k allocs: 0.384 MB  | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake forward            | 0.0515 M allocs: 2.58 MB  | 0.0515 M allocs: 2.58 MB  | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/Mooncake reverse            | 0.854 k allocs: 0.0328 MB | 0.854 k allocs: 0.0328 MB | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (compiled)      | 2  allocs: 1.8 kB         | 2  allocs: 1.8 kB         | 1                          |
| AD gradients/Recurrence time-varying kernel and coupling/ReverseDiff (tape)          | 3.87 k allocs: 0.146 MB   | 3.87 k allocs: 0.146 MB   | 1                          |
| Evaluation/Matrix bvd_patch T200_L20_S5                                              | 0.091 k allocs: 0.0452 MB | 0.091 k allocs: 0.0452 MB | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                            | 22  allocs: 7.33 kB       | 22  allocs: 7.33 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                               | 0.052 k allocs: 0.0399 MB | 0.052 k allocs: 0.0399 MB | 1                          |
| Evaluation/Matrix renewal T200_L20_S1                                                | 0.034 k allocs: 7.98 kB   | 0.034 k allocs: 7.98 kB   | 1                          |
| Evaluation/Matrix strata_mixing T200_L20_S5                                          | 0.072 k allocs: 0.0443 MB | 0.072 k allocs: 0.0443 MB | 1                          |
| time_to_load                                                                         | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

