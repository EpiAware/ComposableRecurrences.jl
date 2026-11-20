|                                                                                    | v0.1.0             | f010397d154a2f...  | v0.1.0 / f010397d154a2f... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0569 ± 0.0098 ms | 18 ± 5.1 μs        | 3.16 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.54 ± 0.036 ms    | 0.559 ± 0.017 ms   | 2.76 ± 0.11                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.082 ± 0.014 ms   | 24.1 ± 6.2 μs      | 3.4 ± 1.1                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 13.3 ± 4.1 μs      | 2.74 ± 2.3 μs      | 4.83 ± 4.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.912 ± 0.029 ms   | 0.252 ± 0.012 ms   | 3.62 ± 0.21                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0406 ± 0.016 ms  | 9.25 ± 1.5 μs      | 4.38 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.6 ± 2.8 μs      | 4.78 ± 3.2 μs      | 2.44 ± 1.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.42 ± 0.42 ms     | 0.269 ± 0.015 ms   | 5.27 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 25.5 ± 2.5 μs      | 8.84 ± 1.9 μs      | 2.88 ± 0.68                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.279 ± 0.011 ms   | 31.6 ± 1.3 μs      | 8.84 ± 0.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 16 ± 2.5 ms        | 1.96 ± 0.056 ms    | 8.15 ± 1.3                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.313 ± 0.031 ms   | 0.0426 ± 0.0011 ms | 7.35 ± 0.75                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.57 ± 0.51 μs     | 0.25 ± 0.021 μs    | 14.3 ± 2.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.63 ± 1.3 μs      | 3.88 ± 0.53 μs     | 1.71 ± 0.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.7 ± 1.1 μs       | 0.862 ± 0.04 μs    | 10.1 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 23.4 ± 6.7 μs      | 8.37 ± 4.3 μs      | 2.8 ± 1.7                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.18 ± 0.02 ms     | 0.374 ± 0.014 ms   | 3.15 ± 0.13                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0499 ± 0.0076 ms | 13.4 ± 4.6 μs      | 3.72 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.43 ± 0.034 ms    | 0.0476 ± 0.03 ms   | 9.03 ± 5.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0338 ± 0.0024 s  | 9.24 ± 0.37 ms     | 3.65 ± 0.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.397 ± 0.029 ms   | 0.0695 ± 0.0038 ms | 5.71 ± 0.52                |
| Convolution body/BLAS axpy per lag                                                 | 0.5 ± 0.0064 μs    | 0.465 ± 0.0021 μs  | 1.08 ± 0.015               |
| Convolution body/native axpy per lag                                               | 0.443 ± 0.0055 μs  | 0.378 ± 0.004 μs   | 1.17 ± 0.019               |
| Convolution body/package                                                           | 0.508 ± 0.0031 μs  | 0.192 ± 0.0007 μs  | 2.65 ± 0.019               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.3 ± 2.4 μs      | 5.69 ± 0.29 μs     | 1.81 ± 0.43                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.01 ± 1.7 μs      | 1.57 ± 1 μs        | 1.92 ± 1.7                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 3.06 ± 1.2 μs      | 2.6 ± 1.1 μs       | 1.18 ± 0.69                |
| Evaluation/Matrix overview T200_L20_S3                                             | 21.7 ± 0.93 μs     | 12.1 ± 0.55 μs     | 1.79 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.36 ± 0.28 μs     | 0.1 ± 0.061 μs     | 3.6 ± 3.6                  |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.25 ± 1.1 μs      | 1.93 ± 0.23 μs     | 1.68 ± 0.62                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 25.7 ± 1.3 μs      | 16.6 ± 0.58 μs     | 1.55 ± 0.097               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.03 ± 0.057 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.092 ± 0.0044 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 17.4 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0457 ± 0.0026 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.494 ± 0.028 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 3.88 ± 0.68 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.62 ± 0.031 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.21 ± 2.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 25.4 ± 0.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 24.2 ± 3.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 29.3 ± 1.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.42 ± 2.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.71 ± 1.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.121 ± 0.0051 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.4 ± 4.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 18.4 ± 2.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 16.1 ± 4.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.086 ± 0.057 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0321 ± 0.0012 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.474 ± 0.028 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0693 ± 0.0037 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.477 ± 0.028 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.8 ± 2.4 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 11.9 ± 4.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 17.6 ± 5.9 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14.2 ± 3.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0369 ± 0.0033 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 22.4 ± 7.9 μs      |                            |
| time_to_load                                                                       | 0.151 ± 0.0046 s   | 0.196 ± 0.0028 s   | 0.773 ± 0.026              |

|                                                                                    | v0.1.0                    | f010397d154a2f...         | v0.1.0 / f010397d154a2f... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.052 k allocs: 26.6 kB   | 1.4                        |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.059 k allocs: 0.0327 MB | 2.51                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 25  allocs: 14 kB         | 1.84                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 18.5 kB   | 3.43                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.081 k allocs: 0.0732 MB | 3.21                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.08 k allocs: 0.0695 MB  | 5.07                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 15  allocs: 1.91 kB       | 2.11                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 29  allocs: 18.3 kB       | 1.56                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 22  allocs: 2.39 kB       | 4.91                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 31  allocs: 18.3 kB       | 1.46                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.036 k allocs: 20.1 kB   | 3.41                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.077 k allocs: 0.116 MB  | 2.29                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.135 k allocs: 0.12 MB   | 2.91                       |
| Convolution body/BLAS axpy per lag                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                           | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 0.035 k allocs: 10.1 kB   | 15  allocs: 7.73 kB       | 1.31                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 7  allocs: 0.703 kB       | 1.69                       |
| Evaluation/Matrix renewal T200_L20_S1                                              | 19  allocs: 7.48 kB       | 11  allocs: 5.53 kB       | 1.35                       |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.044 k allocs: 0.0432 MB | 23  allocs: 0.0331 MB     | 1.3                        |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                           | 1.89 k allocs: 7.91 MB    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.16 k allocs: 0.13 MB    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.28 k allocs: 0.0632 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.126 k allocs: 0.0377 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.123 k allocs: 0.0522 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.303 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.113 k allocs: 30.2 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.143 k allocs: 0.234 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.112 k allocs: 0.125 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.113 k allocs: 29.1 kB   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.126 k allocs: 0.0394 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

