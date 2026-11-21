|                                                                                    | v0.1.0              | 3b41cb2a334b7d...  | v0.1.0 / 3b41cb2a334b7d... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0736 ± 0.012 ms   | 26.4 ± 7.9 μs      | 2.78 ± 0.96                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.87 ± 0.036 ms     | 0.808 ± 0.018 ms   | 2.31 ± 0.069               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.115 ± 0.013 ms    | 0.0365 ± 0.01 ms   | 3.14 ± 0.95                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.2 ± 7.1 μs       | 3.5 ± 4 μs         | 4.63 ± 5.7                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.29 ± 0.029 ms     | 0.335 ± 0.013 ms   | 3.86 ± 0.18                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0536 ± 0.022 ms   | 13 ± 2.2 μs        | 4.12 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 10.9 ± 0.82 μs      | 6.81 ± 5 μs        | 1.6 ± 1.2                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.45 ± 0.027 ms     | 0.443 ± 0.011 ms   | 3.26 ± 0.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.035 ± 0.001 ms    | 13 ± 2.5 μs        | 2.7 ± 0.54                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.375 ± 0.063 ms    | 0.0471 ± 0.025 ms  | 7.97 ± 4.4                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.4 ± 2.5 ms       | 3.05 ± 0.17 ms     | 6.99 ± 0.92                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.436 ± 0.037 ms    | 0.0665 ± 0.0023 ms | 6.55 ± 0.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.45 ± 0.4 μs       | 0.361 ± 0.08 μs    | 12.3 ± 2.9                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.77 ± 7.3 μs       | 4.56 ± 0.54 μs     | 1.71 ± 1.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.4 ± 0.83 μs      | 1.31 ± 0.17 μs     | 8.66 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.3 ± 8.9 μs       | 7.82 ± 0.52 μs     | 3.36 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.42 ± 0.025 ms     | 0.548 ± 0.082 ms   | 2.59 ± 0.39                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0677 ± 0.011 ms   | 13.5 ± 0.68 μs     | 5 ± 0.84                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.535 ± 0.075 ms    | 0.0684 ± 0.0045 ms | 7.82 ± 1.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0421 ± 0.0024 s   | 13.1 ± 0.18 ms     | 3.2 ± 0.19                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.551 ± 0.024 ms    | 0.109 ± 0.0042 ms  | 5.07 ± 0.3                 |
| Convolution body/BLAS axpy per lag                                                 | 0.733 ± 0.0059 μs   | 0.695 ± 0.0063 μs  | 1.05 ± 0.013               |
| Convolution body/native axpy per lag                                               | 0.423 ± 0.0059 μs   | 0.424 ± 0.0055 μs  | 0.999 ± 0.019              |
| Convolution body/package                                                           | 0.733 ± 0.0059 μs   | 0.322 ± 0.0073 μs  | 2.27 ± 0.055               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.2 ± 3 μs         | 7.47 ± 0.26 μs     | 1.63 ± 0.4                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.92 ± 2.7 μs       | 2.31 ± 1.4 μs      | 1.69 ± 1.6                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.65 ± 1.2 μs       | 3.7 ± 1.6 μs       | 0.447 ± 0.38               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0324 ± 0.00095 ms | 15.3 ± 0.98 μs     | 2.11 ± 0.15                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.391 ± 0.2 μs      | 0.13 ± 0.03 μs     | 3.01 ± 1.7                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.75 ± 1.7 μs       | 2.71 ± 0.23 μs     | 2.49 ± 0.65                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0351 ± 0.00091 ms | 24.4 ± 10 μs       | 1.44 ± 0.61                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.53 ± 0.074 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.136 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 25.1 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.066 ± 0.0019 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.656 ± 0.034 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.43 ± 1.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.886 ± 0.038 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.25 ± 3.7 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0353 ± 0.0052 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0338 ± 0.011 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0443 ± 0.0013 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.67 ± 3.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.5 ± 2 μs         |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.183 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 15 ± 7.8 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 25.6 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 21.2 ± 5 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.124 ± 0.0081 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0477 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.64 ± 0.03 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0948 ± 0.0092 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.637 ± 0.032 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.5 ± 1.4 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 16.4 ± 6.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 23.4 ± 7.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 20 ± 4.6 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0448 ± 0.00077 s |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 31.2 ± 11 μs       |                            |
| time_to_load                                                                       | 0.19 ± 0.00067 s    | 0.247 ± 0.00084 s  | 0.769 ± 0.0038             |

|                                                                                    | v0.1.0                    | 3b41cb2a334b7d...         | v0.1.0 / 3b41cb2a334b7d... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.053 k allocs: 28.5 kB   | 1.31                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 29  allocs: 14.4 kB       | 1.78                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 18.5 kB   | 3.43                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 24  allocs: 16 kB         | 1.44                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.091 k allocs: 0.074 MB  | 3.18                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.08 k allocs: 0.0695 MB  | 5.07                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 17  allocs: 1.97 kB       | 2.04                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 23  allocs: 18.1 kB       | 1.58                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 22  allocs: 2.39 kB       | 4.91                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 31  allocs: 20.1 kB       | 1.33                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.034 k allocs: 19.8 kB   | 3.45                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.083 k allocs: 0.134 MB  | 1.99                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.133 k allocs: 0.12 MB   | 2.92                       |
| Convolution body/BLAS axpy per lag                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                           | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 0.035 k allocs: 10.1 kB   | 15  allocs: 7.73 kB       | 1.31                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 5  allocs: 0.641 kB       | 1.85                       |
| Evaluation/Matrix renewal T200_L20_S1                                              | 19  allocs: 7.48 kB       | 11  allocs: 5.53 kB       | 1.35                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.044 k allocs: 0.0432 MB | 23  allocs: 0.0331 MB     | 1.3                        |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                           | 1.89 k allocs: 7.91 MB    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.158 k allocs: 0.129 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.278 k allocs: 0.063 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.116 k allocs: 0.0366 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.134 k allocs: 0.0635 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.301 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.105 k allocs: 29.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.154 k allocs: 0.288 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.119 k allocs: 0.135 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.105 k allocs: 28.9 kB   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.116 k allocs: 0.0383 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

