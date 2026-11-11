|                                                                                    | v0.1.0            | 226f85a24839a5...  | v0.1.0 / 226f85a24839a5... |
|:-----------------------------------------------------------------------------------|:-----------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0565 ± 0.011 ms | 18.9 ± 2.6 μs      | 2.99 ± 0.72                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.46 ± 0.023 ms   | 0.612 ± 0.02 ms    | 2.39 ± 0.086               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0896 ± 0.018 ms | 25.7 ± 6.4 μs      | 3.49 ± 1.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 12.5 ± 5.4 μs     | 6.52 ± 4.1 μs      | 1.92 ± 1.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.849 ± 0.019 ms  | 0.271 ± 0.013 ms   | 3.14 ± 0.17                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0388 ± 0.016 ms | 11.9 ± 2.6 μs      | 3.25 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 9.04 ± 1.4 μs     | 5.4 ± 3.4 μs       | 1.68 ± 1.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.983 ± 0.014 ms  | 0.303 ± 0.012 ms   | 3.24 ± 0.13                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 25.8 ± 1.2 μs     | 9.52 ± 2.1 μs      | 2.71 ± 0.6                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.255 ± 0.018 ms  | 0.0348 ± 0.0021 ms | 7.32 ± 0.68                |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 19.8 ± 6.8 ms     | 2.05 ± 0.065 ms    | 9.68 ± 3.3                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.345 ± 0.039 ms  | 0.0492 ± 0.0014 ms | 7 ± 0.82                   |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 2.98 ± 0.41 μs    | 0.271 ± 0.039 μs   | 11 ± 2.2                   |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.41 ± 0.96 μs    | 4 ± 0.54 μs        | 1.6 ± 0.32                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.58 ± 0.98 μs    | 0.951 ± 0.1 μs     | 9.03 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 30.2 ± 7.1 μs     | 8.31 ± 4.2 μs      | 3.64 ± 2                   |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.14 ± 0.021 ms   | 0.331 ± 0.015 ms   | 3.43 ± 0.17                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0536 ± 0.012 ms | 12.8 ± 4.6 μs      | 4.17 ± 1.8                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.385 ± 0.057 ms  | 0.0492 ± 0.03 ms   | 7.82 ± 4.8                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0337 ± 0.0026 s | 10.2 ± 0.98 ms     | 3.29 ± 0.41                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.423 ± 0.033 ms  | 0.0795 ± 0.0041 ms | 5.32 ± 0.5                 |
| Convolution body/BLAS axpy per lag                                                 | 0.415 ± 0.0032 μs | 0.49 ± 0.0055 μs   | 0.848 ± 0.012              |
| Convolution body/native axpy per lag                                               | 0.303 ± 0.0044 μs | 0.388 ± 0.0095 μs  | 0.783 ± 0.022              |
| Convolution body/package                                                           | 0.419 ± 0.0041 μs | 0.213 ± 0.0019 μs  | 1.97 ± 0.026               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.8 ± 2.5 μs     | 6.48 ± 1 μs        | 1.66 ± 0.46                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.44 ± 1.9 μs     | 1.39 ± 2 μs        | 1.04 ± 2                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.91 ± 1.2 μs     | 1.19 ± 0.84 μs     | 2.44 ± 2                   |
| Evaluation/Matrix overview T200_L20_S3                                             | 21 ± 0.74 μs      | 14.7 ± 0.76 μs     | 1.43 ± 0.09                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.311 ± 0.23 μs   | 0.13 ± 0.1 μs      | 2.39 ± 2.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.19 ± 1.3 μs     | 2.3 ± 0.29 μs      | 1.38 ± 0.58                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 24.9 ± 0.66 μs    | 17.8 ± 0.69 μs     | 1.4 ± 0.066                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                   | 1.14 ± 0.065 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                   | 0.103 ± 0.0039 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                   | 18.9 ± 3.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                   | 0.0504 ± 0.002 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                   | 0.549 ± 0.022 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                   | 5.34 ± 3.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                   | 0.621 ± 0.04 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                   | 4.65 ± 1.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                   | 27.4 ± 0.85 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                   | 26.3 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                   | 0.0318 ± 0.0013 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                   | 5.06 ± 1.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                   | 4.15 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                   | 0.138 ± 0.006 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                   | 12.3 ± 4.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                   | 20.5 ± 3.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                   | 16.1 ± 6.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                   | 0.0916 ± 0.0092 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                   | 0.0353 ± 0.0011 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                   | 0.526 ± 0.029 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                   | 0.0712 ± 0.0031 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                   | 0.519 ± 0.025 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                   | 12.6 ± 2.9 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                   | 13.4 ± 5.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                   | 17.4 ± 6.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                   | 14.7 ± 3.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                   | 0.0619 ± 0.039 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                   | 24.5 ± 7 μs        |                            |
| time_to_load                                                                       | 0.15 ± 0.0048 s   | 0.172 ± 0.0015 s   | 0.876 ± 0.029              |

|                                                                                    | v0.1.0                    | 226f85a24839a5...         | v0.1.0 / 226f85a24839a5... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 18.5 kB       | 1.39                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.034 k allocs: 24 kB     | 2.65                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.084 k allocs: 0.0867 MB | 2.71                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.081 k allocs: 0.0871 MB | 4.05                       |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 0.033 k allocs: 4.02 kB   | 15  allocs: 1.91 kB       | 2.11                       |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 0.056 k allocs: 28.6 kB   | 29  allocs: 18.3 kB       | 1.56                       |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.327 k allocs: 11.7 kB   | 22  allocs: 2.39 kB       | 4.91                       |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 29  allocs: 18.1 kB       | 1.48                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.034 k allocs: 19.8 kB   | 3.45                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.075 k allocs: 0.116 MB  | 2.3                        |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.133 k allocs: 0.12 MB   | 2.92                       |
| Convolution body/BLAS axpy per lag                                                 | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/native axpy per lag                                               | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Convolution body/package                                                           | 0  allocs: 0 B            | 0  allocs: 0 B            |                            |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 0.035 k allocs: 10.1 kB   | 15  allocs: 7.73 kB       | 1.31                       |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 28  allocs: 29.7 kB       | 1.37                       |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 15  allocs: 1.19 kB       | 7  allocs: 0.703 kB       | 1.69                       |
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
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.121 k allocs: 0.052 MB  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.301 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.103 k allocs: 29 kB     |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.141 k allocs: 0.234 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.11 k allocs: 0.125 MB   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.075 k allocs: 25.9 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.103 k allocs: 27.9 kB   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.116 k allocs: 0.0383 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

