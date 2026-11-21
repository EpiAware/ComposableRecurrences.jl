|                                                                                    | v0.1.0             | 97563ad83720d5...  | v0.1.0 / 97563ad83720d5... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0686 ± 0.0075 ms | 23.4 ± 5.8 μs      | 2.93 ± 0.8                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.34 ± 0.042 ms    | 0.646 ± 0.13 ms    | 3.62 ± 0.7                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0969 ± 0.012 ms  | 30.5 ± 7.3 μs      | 3.18 ± 0.85                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 15.9 ± 4.2 μs      | 4.6 ± 3.3 μs       | 3.45 ± 2.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.969 ± 0.11 ms    | 0.263 ± 0.056 ms   | 3.68 ± 0.89                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0475 ± 0.014 ms  | 11.4 ± 1.7 μs      | 4.16 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 13.3 ± 1.5 μs      | 3.91 ± 3.6 μs      | 3.41 ± 3.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.08 ± 0.086 ms    | 0.294 ± 0.048 ms   | 3.67 ± 0.66                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0353 ± 0.0013 ms | 11.4 ± 2.3 μs      | 3.1 ± 0.64                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.411 ± 0.039 ms   | 0.0478 ± 0.016 ms  | 8.59 ± 2.9                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14.9 ± 1.2 ms      | 2.51 ± 1.6 ms      | 5.94 ± 3.9                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.44 ± 0.034 ms    | 0.0642 ± 0.0024 ms | 6.85 ± 0.58                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.57 ± 0.47 μs     | 0.686 ± 0.25 μs    | 6.66 ± 2.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.1 ± 2.2 μs       | 3.5 ± 0.68 μs      | 2.31 ± 0.76                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.3 ± 1.1 μs      | 1.43 ± 0.23 μs     | 7.93 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0331 ± 0.0068 ms | 11.4 ± 4.9 μs      | 2.9 ± 1.4                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.79 ± 0.053 ms    | 0.33 ± 0.026 ms    | 5.42 ± 0.46                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0657 ± 0.0083 ms | 14.9 ± 4.8 μs      | 4.39 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.568 ± 0.028 ms   | 0.0675 ± 0.025 ms  | 8.42 ± 3.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0629 ± 0.0021 s  | 11.4 ± 0.13 ms     | 5.52 ± 0.19                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.551 ± 0.037 ms   | 0.0974 ± 0.0062 ms | 5.66 ± 0.53                |
| Convolution body/BLAS axpy per lag                                                 | 0.535 ± 0.015 μs   | 0.544 ± 0.017 μs   | 0.984 ± 0.041              |
| Convolution body/native axpy per lag                                               | 0.443 ± 0.004 μs   | 0.44 ± 0.0016 μs   | 1.01 ± 0.0097              |
| Convolution body/package                                                           | 0.536 ± 0.015 μs   | 0.315 ± 0.00067 μs | 1.7 ± 0.047                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 11.6 ± 2.1 μs      | 8.01 ± 0.29 μs     | 1.45 ± 0.26                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.25 ± 0.35 μs     | 1.88 ± 1.1 μs      | 1.73 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.16 ± 1.5 μs      | 2.98 ± 1.4 μs      | 0.725 ± 0.61               |
| Evaluation/Matrix overview T200_L20_S3                                             | 26.8 ± 1.1 μs      | 18.1 ± 1.3 μs      | 1.48 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.398 ± 0.23 μs    | 0.127 ± 0.0063 μs  | 3.13 ± 1.8                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.84 ± 1.9 μs      | 2.63 ± 0.24 μs     | 1.84 ± 0.76                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.037 ± 0.0021 ms  | 25.9 ± 4.2 μs      | 1.43 ± 0.25                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.22 ± 0.41 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.121 ± 0.0088 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 21.8 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0608 ± 0.0031 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.542 ± 0.2 ms     |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.31 ± 2.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.594 ± 0.19 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.44 ± 2.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0357 ± 0.0069 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 29.4 ± 6.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.041 ± 0.0026 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.9 ± 2.7 μs       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.41 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.164 ± 0.015 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 13.8 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 22.5 ± 2.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 18.6 ± 5.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.115 ± 0.017 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0477 ± 0.0034 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.517 ± 0.27 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0888 ± 0.0098 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.498 ± 0.25 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 12 ± 0.14 ms       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 14.7 ± 5.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 20.3 ± 5.6 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.8 ± 3.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0378 ± 0.002 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 27.4 ± 8.4 μs      |                            |
| time_to_load                                                                       | 0.211 ± 0.00055 s  | 0.27 ± 0.0013 s    | 0.781 ± 0.0042             |

|                                                                                    | v0.1.0                    | 97563ad83720d5...         | v0.1.0 / 97563ad83720d5... |
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

