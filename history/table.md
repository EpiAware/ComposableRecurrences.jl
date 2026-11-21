|                                                                                    | v0.1.0             | a8a620490b5f10...  | v0.1.0 / a8a620490b5f10... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0787 ± 0.011 ms  | 26.7 ± 2.5 μs      | 2.95 ± 0.49                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 3.31 ± 0.065 ms    | 0.832 ± 0.069 ms   | 3.98 ± 0.34                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.112 ± 0.014 ms   | 0.0354 ± 0.0085 ms | 3.17 ± 0.86                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.6 ± 5.2 μs      | 6.16 ± 4.1 μs      | 2.85 ± 2.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.15 ± 0.045 ms    | 0.332 ± 0.03 ms    | 3.47 ± 0.34                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0536 ± 0.017 ms  | 12.8 ± 1.9 μs      | 4.19 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.1 ± 1.3 μs      | 4.42 ± 4.2 μs      | 3.41 ± 3.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.28 ± 0.048 ms    | 0.374 ± 0.023 ms   | 3.43 ± 0.25                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0403 ± 0.0017 ms | 12.9 ± 2.3 μs      | 3.13 ± 0.57                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.468 ± 0.045 ms   | 0.0515 ± 0.018 ms  | 9.09 ± 3.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 17.1 ± 2.8 ms      | 3.07 ± 0.39 ms     | 5.56 ± 1.1                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.509 ± 0.037 ms   | 0.071 ± 0.003 ms   | 7.17 ± 0.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.22 ± 0.52 μs     | 0.676 ± 0.29 μs    | 7.73 ± 3.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.81 ± 4.5 μs      | 4.04 ± 0.52 μs     | 2.18 ± 1.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 12.8 ± 1.4 μs      | 1.73 ± 0.27 μs     | 7.41 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0355 ± 0.0072 ms | 8.93 ± 5.4 μs      | 3.98 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.07 ± 0.047 ms    | 0.413 ± 0.04 ms    | 5.01 ± 0.49                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0752 ± 0.0098 ms | 18.9 ± 5.7 μs      | 3.98 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.644 ± 0.054 ms   | 0.0776 ± 0.018 ms  | 8.3 ± 2                    |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0605 ± 0.0027 s  | 14.2 ± 0.47 ms     | 4.26 ± 0.24                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.63 ± 0.036 ms    | 0.112 ± 0.0069 ms  | 5.6 ± 0.47                 |
| Convolution body/BLAS axpy per lag                                                 | 0.622 ± 0.014 μs   | 0.668 ± 0.0034 μs  | 0.931 ± 0.021              |
| Convolution body/native axpy per lag                                               | 0.511 ± 0.00057 μs | 0.511 ± 0.00063 μs | 1 ± 0.0017                 |
| Convolution body/package                                                           | 0.624 ± 0.013 μs   | 0.367 ± 0.0021 μs  | 1.7 ± 0.037                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.3 ± 1 μs        | 9.29 ± 0.84 μs     | 1.43 ± 0.17                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.55 ± 2.1 μs      | 2.1 ± 1.3 μs       | 1.69 ± 1.4                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.39 ± 2 μs        | 3.4 ± 1.5 μs       | 0.704 ± 0.66               |
| Evaluation/Matrix overview T200_L20_S3                                             | 30.5 ± 1.1 μs      | 19.8 ± 1.1 μs      | 1.54 ± 0.1                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.455 ± 0.2 μs     | 0.148 ± 0.007 μs   | 3.07 ± 1.3                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.75 ± 2.3 μs      | 3.05 ± 0.27 μs     | 1.88 ± 0.78                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0425 ± 0.0018 ms | 28.1 ± 2.5 μs      | 1.51 ± 0.15                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.57 ± 0.31 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.139 ± 0.014 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 24.6 ± 4.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0704 ± 0.0029 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.858 ± 0.091 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.76 ± 0.99 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.861 ± 0.083 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.87 ± 3.4 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0405 ± 0.0076 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0335 ± 0.0091 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0467 ± 0.0022 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.47 ± 3.4 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.49 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.188 ± 0.017 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 16.5 ± 3.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 26.1 ± 3 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 21.2 ± 6.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.132 ± 0.014 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0539 ± 0.0044 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.796 ± 0.15 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.102 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.752 ± 0.17 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 14.7 ± 1.6 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.5 ± 6.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 24.4 ± 4.1 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 20.8 ± 3.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0477 ± 0.0053 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 31.1 ± 9.3 μs      |                            |
| time_to_load                                                                       | 0.244 ± 0.0018 s   | 0.311 ± 0.00067 s  | 0.784 ± 0.006              |

|                                                                                    | v0.1.0                    | a8a620490b5f10...         | v0.1.0 / a8a620490b5f10... |
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

