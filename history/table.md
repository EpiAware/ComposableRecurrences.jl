|                                                                                    | v0.1.0            | 65e55f51844a06...  | v0.1.0 / 65e55f51844a06... |
|:-----------------------------------------------------------------------------------|:-----------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0623 ± 0.011 ms | 21.6 ± 6.7 μs      | 2.88 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.69 ± 0.051 ms   | 0.678 ± 0.022 ms   | 2.49 ± 0.11                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0934 ± 0.023 ms | 27.3 ± 7.4 μs      | 3.42 ± 1.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.6 ± 3.4 μs     | 3.24 ± 3.3 μs      | 5.12 ± 5.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.01 ± 0.072 ms   | 0.288 ± 0.012 ms   | 3.5 ± 0.29                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0435 ± 0.018 ms | 11 ± 2.3 μs        | 3.96 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 14.7 ± 2.3 μs     | 5.83 ± 3.8 μs      | 2.52 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.13 ± 0.042 ms   | 0.336 ± 0.019 ms   | 3.37 ± 0.23                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 29.3 ± 2.2 μs     | 10.3 ± 2.3 μs      | 2.84 ± 0.68                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.324 ± 0.049 ms  | 0.0371 ± 0.021 ms  | 8.72 ± 5.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 18.5 ± 3.4 ms     | 2.27 ± 1.5 ms      | 8.13 ± 5.6                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.354 ± 0.042 ms  | 0.05 ± 0.0023 ms   | 7.09 ± 0.91                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.73 ± 0.67 μs    | 0.301 ± 0.04 μs    | 12.4 ± 2.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 7.86 ± 5.6 μs     | 4.07 ± 0.9 μs      | 1.93 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 9.88 ± 1.5 μs     | 1.06 ± 0.13 μs     | 9.31 ± 1.8                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.8 ± 8.2 μs     | 7.92 ± 3.8 μs      | 3.39 ± 1.9                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.32 ± 0.1 ms     | 0.448 ± 0.02 ms    | 2.94 ± 0.27                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0576 ± 0.013 ms | 13 ± 5 μs          | 4.42 ± 1.9                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.542 ± 0.14 ms   | 0.0557 ± 0.034 ms  | 9.72 ± 6.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0403 ± 0.0035 s | 12.4 ± 0.38 ms     | 3.25 ± 0.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.44 ± 0.035 ms   | 0.0826 ± 0.012 ms  | 5.33 ± 0.86                |
| Convolution body/BLAS axpy per lag                                                 | 0.743 ± 0.013 μs  | 0.445 ± 0.0062 μs  | 1.67 ± 0.036               |
| Convolution body/native axpy per lag                                               | 0.584 ± 0.0082 μs | 0.313 ± 0.0048 μs  | 1.87 ± 0.039               |
| Convolution body/package                                                           | 0.74 ± 0.016 μs   | 0.199 ± 0.0026 μs  | 3.71 ± 0.093               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.9 ± 0.46 μs    | 6.75 ± 0.52 μs     | 1.61 ± 0.14                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.41 ± 0.34 μs    | 1.85 ± 1.2 μs      | 1.84 ± 1.2                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 3.38 ± 1.4 μs     | 3.08 ± 1.3 μs      | 1.09 ± 0.65                |
| Evaluation/Matrix overview T200_L20_S3                                             | 23.2 ± 1.3 μs     | 12.6 ± 0.6 μs      | 1.84 ± 0.14                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.351 ± 0.25 μs   | 0.111 ± 0.071 μs   | 3.16 ± 3                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.65 ± 1.2 μs     | 2.3 ± 0.25 μs      | 1.58 ± 0.55                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 28.1 ± 1.8 μs     | 19.7 ± 9.6 μs      | 1.43 ± 0.7                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                   | 1.24 ± 0.21 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                   | 0.101 ± 0.0062 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                   | 20.7 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                   | 0.0517 ± 0.0034 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                   | 0.56 ± 0.065 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                   | 4.6 ± 0.53 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                   | 0.765 ± 0.025 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                   | 3.77 ± 2.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                   | 28.1 ± 6.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                   | 28.4 ± 4 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                   | 0.0359 ± 0.0017 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                   | 4.08 ± 2.8 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                   | 6.61 ± 2.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                   | 0.147 ± 0.017 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                   | 14.8 ± 5.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                   | 21.6 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                   | 20 ± 6.1 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                   | 0.101 ± 0.011 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                   | 0.0379 ± 0.0016 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                   | 0.538 ± 0.043 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                   | 0.075 ± 0.0046 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                   | 0.554 ± 0.026 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                   | 12.9 ± 2.4 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                   | 14.9 ± 6.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                   | 21.9 ± 7.2 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                   | 16.4 ± 3.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                   | 0.0431 ± 0.0049 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                   | 25.8 ± 8.5 μs      |                            |
| time_to_load                                                                       | 0.184 ± 0.0046 s  | 0.245 ± 0.033 s    | 0.749 ± 0.1                |

|                                                                                    | v0.1.0                    | 65e55f51844a06...         | v0.1.0 / 65e55f51844a06... |
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

