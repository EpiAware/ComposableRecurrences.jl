|                                                                                    | v0.1.0             | af02818442ffb6...  | v0.1.0 / af02818442ffb6... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0694 ± 0.0088 ms | 24 ± 3 μs          | 2.9 ± 0.52                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.36 ± 0.21 ms     | 0.659 ± 0.11 ms    | 3.58 ± 0.69                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0987 ± 0.019 ms  | 30.9 ± 7.4 μs      | 3.2 ± 0.98                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.2 ± 4.4 μs      | 3.77 ± 3.6 μs      | 4.3 ± 4.3                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.925 ± 0.13 ms    | 0.256 ± 0.034 ms   | 3.62 ± 0.7                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0488 ± 0.015 ms  | 11.3 ± 1.7 μs      | 4.31 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 13.9 ± 3.1 μs      | 4.15 ± 5 μs        | 3.36 ± 4.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.24 ± 0.39 ms     | 0.288 ± 0.048 ms   | 4.31 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0352 ± 0.0024 ms | 11.8 ± 2 μs        | 2.99 ± 0.54                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.413 ± 0.041 ms   | 0.0462 ± 0.017 ms  | 8.95 ± 3.4                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14.5 ± 1.7 ms      | 2.57 ± 0.51 ms     | 5.64 ± 1.3                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.446 ± 0.036 ms   | 0.0611 ± 0.0042 ms | 7.29 ± 0.78                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.84 ± 0.46 μs     | 0.54 ± 0.2 μs      | 8.96 ± 3.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.48 ± 3.6 μs      | 3.33 ± 1.3 μs      | 2.55 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.2 ± 1.2 μs      | 1.56 ± 0.24 μs     | 7.16 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 31.6 ± 5.8 μs      | 11 ± 5 μs          | 2.87 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.75 ± 0.059 ms    | 0.333 ± 0.034 ms   | 5.24 ± 0.57                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0661 ± 0.0082 ms | 16.1 ± 5.1 μs      | 4.1 ± 1.4                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.592 ± 0.028 ms   | 0.0679 ± 0.019 ms  | 8.72 ± 2.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0491 ± 0.0022 s  | 11.5 ± 0.39 ms     | 4.25 ± 0.24                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.561 ± 0.03 ms    | 0.0983 ± 0.0095 ms | 5.71 ± 0.63                |
| Convolution body/BLAS axpy per lag                                                 | 0.579 ± 0.012 μs   | 0.543 ± 0.032 μs   | 1.07 ± 0.066               |
| Convolution body/native axpy per lag                                               | 0.469 ± 0.0049 μs  | 0.441 ± 0.026 μs   | 1.06 ± 0.063               |
| Convolution body/package                                                           | 0.58 ± 0.012 μs    | 0.316 ± 0.018 μs   | 1.83 ± 0.11                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 11.9 ± 0.81 μs     | 8.21 ± 0.44 μs     | 1.45 ± 0.13                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.33 ± 1.9 μs      | 2.17 ± 1 μs        | 1.54 ± 1.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.04 ± 1.9 μs      | 3.11 ± 1.5 μs      | 0.656 ± 0.68               |
| Evaluation/Matrix overview T200_L20_S3                                             | 27.5 ± 0.99 μs     | 16.2 ± 1.2 μs      | 1.7 ± 0.14                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.418 ± 0.19 μs    | 0.133 ± 0.017 μs   | 3.14 ± 1.5                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.3 ± 1.9 μs       | 2.61 ± 0.14 μs     | 2.03 ± 0.74                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0388 ± 0.0018 ms | 26.6 ± 6.5 μs      | 1.46 ± 0.36                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.22 ± 0.34 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.118 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 22.2 ± 3.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0558 ± 0.003 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.557 ± 0.091 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.77 ± 3.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.581 ± 0.18 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.43 ± 2.9 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0345 ± 0.0063 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 29.4 ± 6.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0371 ± 0.0033 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.49 ± 3.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.48 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.163 ± 0.02 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 13.4 ± 4.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 22.5 ± 2.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 18.6 ± 5.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.115 ± 0.018 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0488 ± 0.0041 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.527 ± 0.18 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0863 ± 0.013 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.505 ± 0.17 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 12.1 ± 0.54 ms     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 14.7 ± 4.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 21 ± 5.4 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.9 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0387 ± 0.00073 s |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 27.7 ± 7.2 μs      |                            |
| time_to_load                                                                       | 0.212 ± 0.0019 s   | 0.27 ± 0.0036 s    | 0.786 ± 0.013              |

|                                                                                    | v0.1.0                    | af02818442ffb6...         | v0.1.0 / af02818442ffb6... |
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
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.204 k allocs: 11.9 kB   | 0.984                      |

