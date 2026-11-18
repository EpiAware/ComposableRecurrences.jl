|                                                                                    | v0.1.0              | 2476a5b073b169...  | v0.1.0 / 2476a5b073b169... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0745 ± 0.013 ms   | 25.7 ± 7.6 μs      | 2.9 ± 1                    |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.88 ± 0.027 ms     | 0.808 ± 0.022 ms   | 2.32 ± 0.071               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.116 ± 0.03 ms     | 0.0366 ± 0.01 ms   | 3.16 ± 1.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.5 ± 7.2 μs       | 3.29 ± 3.7 μs      | 5.01 ± 6.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.3 ± 0.022 ms      | 0.337 ± 0.012 ms   | 3.85 ± 0.15                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0533 ± 0.022 ms   | 13 ± 2.1 μs        | 4.09 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11 ± 1.3 μs         | 6.73 ± 5.2 μs      | 1.63 ± 1.3                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.47 ± 0.5 ms       | 0.436 ± 0.011 ms   | 3.37 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.034 ± 0.0008 ms   | 12.9 ± 2.6 μs      | 2.64 ± 0.54                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.365 ± 0.059 ms    | 0.0464 ± 0.024 ms  | 7.87 ± 4.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.2 ± 1.5 ms       | 3.03 ± 0.19 ms     | 6.98 ± 0.67                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.43 ± 0.039 ms     | 0.0665 ± 0.0026 ms | 6.46 ± 0.64                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.3 ± 0.41 μs       | 0.361 ± 0.041 μs   | 11.9 ± 1.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.18 ± 7.4 μs       | 4.62 ± 0.55 μs     | 1.77 ± 1.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.4 ± 1.1 μs       | 1.26 ± 0.18 μs     | 9.01 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 25.5 ± 8.3 μs       | 8.04 ± 4.1 μs      | 3.18 ± 1.9                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.41 ± 0.02 ms      | 0.537 ± 0.013 ms   | 2.63 ± 0.075               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0694 ± 0.0073 ms  | 14.2 ± 6.5 μs      | 4.87 ± 2.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.521 ± 0.031 ms    | 0.0679 ± 0.035 ms  | 7.68 ± 4                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0415 ± 0.0015 s   | 13 ± 0.15 ms       | 3.2 ± 0.12                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.557 ± 0.027 ms    | 0.109 ± 0.0059 ms  | 5.11 ± 0.37                |
| Convolution body/BLAS axpy per lag                                                 | 0.715 ± 0.0055 μs   | 0.714 ± 0.006 μs   | 1 ± 0.011                  |
| Convolution body/native axpy per lag                                               | 0.42 ± 0.0071 μs    | 0.424 ± 0.0065 μs  | 0.989 ± 0.023              |
| Convolution body/package                                                           | 0.714 ± 0.0065 μs   | 0.324 ± 0.0061 μs  | 2.2 ± 0.046                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.1 ± 0.61 μs      | 7.44 ± 0.24 μs     | 1.63 ± 0.098               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.25 ± 2.6 μs       | 2.3 ± 1.5 μs       | 1.84 ± 1.6                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.85 ± 1.7 μs       | 3.63 ± 1.6 μs      | 0.511 ± 0.52               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0326 ± 0.00081 ms | 15.2 ± 0.94 μs     | 2.15 ± 0.14                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.391 ± 0.18 μs     | 0.14 ± 0.03 μs     | 2.79 ± 1.4                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.36 ± 1.7 μs       | 2.71 ± 0.24 μs     | 2.34 ± 0.67                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0353 ± 0.00094 ms | 23.9 ± 2.7 μs      | 1.48 ± 0.17                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.54 ± 0.082 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.136 ± 0.009 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 24.7 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0662 ± 0.0016 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.647 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.44 ± 1.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.885 ± 0.034 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.21 ± 3.6 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0343 ± 0.0053 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.034 ± 0.012 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0409 ± 0.0011 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.6 ± 3.6 μs       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.56 ± 1.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.18 ± 0.0097 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 14.9 ± 6.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 25.5 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 21.4 ± 6.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.12 ± 0.0086 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0477 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.628 ± 0.04 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0962 ± 0.0081 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.615 ± 0.038 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.5 ± 1 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 15.6 ± 6.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 23.6 ± 7.7 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 19.9 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0438 ± 0.0013 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0319 ± 0.013 ms  |                            |
| time_to_load                                                                       | 0.189 ± 0.0017 s    | 0.243 ± 0.0023 s   | 0.778 ± 0.01               |

|                                                                                    | v0.1.0                    | 2476a5b073b169...         | v0.1.0 / 2476a5b073b169... |
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

