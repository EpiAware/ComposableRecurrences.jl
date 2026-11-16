|                                                                                    | v0.1.0              | e77f84e05f2c0b...  | v0.1.0 / e77f84e05f2c0b... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.119 ± 0.016 ms    | 30.4 ± 8.6 μs      | 3.92 ± 1.2                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.84 ± 0.041 ms     | 0.764 ± 0.022 ms   | 3.72 ± 0.12                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.182 ± 0.015 ms    | 0.0448 ± 0.011 ms  | 4.07 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.8 ± 5 μs         | 7.02 ± 5.2 μs      | 2.53 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.358 ± 0.024 ms    | 0.257 ± 0.019 ms   | 1.39 ± 0.14                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0599 ± 0.024 ms   | 14.5 ± 2.2 μs      | 4.14 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 16.3 ± 7 μs         | 7.36 ± 5.7 μs      | 2.21 ± 2                   |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.383 ± 0.021 ms    | 0.333 ± 0.014 ms   | 1.15 ± 0.08                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0663 ± 0.023 ms   | 14.1 ± 2.9 μs      | 4.71 ± 1.9                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.447 ± 0.064 ms    | 0.0588 ± 0.022 ms  | 7.6 ± 3.1                  |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.6 ± 1.1 ms       | 3.33 ± 0.65 ms     | 3.47 ± 0.76                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.594 ± 0.034 ms    | 0.0836 ± 0.0021 ms | 7.1 ± 0.45                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.85 ± 0.33 μs      | 0.471 ± 0.04 μs    | 10.3 ± 1.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 6.27 ± 7.3 μs       | 3.24 ± 0.44 μs     | 1.94 ± 2.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 16.9 ± 1.2 μs       | 1.51 ± 0.1 μs      | 11.2 ± 1.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0435 ± 0.011 ms   | 9.06 ± 0.71 μs     | 4.81 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.07 ± 0.035 ms     | 0.364 ± 0.039 ms   | 5.68 ± 0.62                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0912 ± 0.015 ms   | 18.4 ± 0.73 μs     | 4.96 ± 0.83                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.706 ± 0.075 ms    | 0.0797 ± 0.01 ms   | 8.85 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0563 ± 0.003 s    | 12.3 ± 0.081 ms    | 4.57 ± 0.25                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.77 ± 0.022 ms     | 0.146 ± 0.008 ms   | 5.26 ± 0.33                |
| Convolution body/BLAS axpy per lag                                                 | 0.783 ± 0.0035 μs   | 0.787 ± 0.0068 μs  | 0.994 ± 0.0097             |
| Convolution body/native axpy per lag                                               | 0.496 ± 0.0058 μs   | 0.503 ± 0.0063 μs  | 0.986 ± 0.017              |
| Convolution body/package                                                           | 0.783 ± 0.0034 μs   | 0.337 ± 0.0058 μs  | 2.32 ± 0.041               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.8 ± 0.37 μs      | 8.89 ± 0.35 μs     | 1.66 ± 0.078               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.37 ± 0.29 μs      | 2.28 ± 1.7 μs      | 1.91 ± 1.4                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.61 ± 1.3 μs       | 2.57 ± 2.7 μs      | 0.627 ± 0.83               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0399 ± 0.00074 ms | 19.3 ± 1 μs        | 2.07 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.531 ± 0.02 μs     | 0.18 ± 0.021 μs    | 2.95 ± 0.36                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 8.67 ± 1.7 μs       | 3.66 ± 0.19 μs     | 2.37 ± 0.47                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0475 ± 0.00088 ms | 30.9 ± 1.6 μs      | 1.54 ± 0.084               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.61 ± 0.11 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.181 ± 0.0093 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.8 ± 3.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0855 ± 0.0021 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.613 ± 0.025 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.72 ± 4.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.616 ± 0.028 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 5.23 ± 4 μs        |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.046 ± 0.0018 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.041 ± 0.013 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0471 ± 0.0011 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.74 ± 3.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.92 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.239 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 14.8 ± 8.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.7 ± 3.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 20.9 ± 9.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.15 ± 0.0099 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0585 ± 0.0015 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.542 ± 0.055 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.116 ± 0.0099 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.512 ± 0.049 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.1 ± 0.81 ms     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 15.7 ± 7.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 24.5 ± 7.5 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 21.7 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0486 ± 0.0011 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0381 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.238 ± 0.0019 s    | 0.255 ± 0.00069 s  | 0.932 ± 0.0079             |

|                                                                                    | v0.1.0                    | e77f84e05f2c0b...         | v0.1.0 / e77f84e05f2c0b... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 13.9 kB       | 1.85                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.036 k allocs: 18.4 kB   | 3.45                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.08 k allocs: 0.073 MB   | 3.22                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.08 k allocs: 0.0694 MB  | 5.08                       |
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
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 9  allocs: 5.14 kB        | 1.63                       |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 22  allocs: 20.1 kB       | 2.03                       |
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

