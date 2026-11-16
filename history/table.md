|                                                                                    | v0.1.0             | d28df7a4e6b345...  | v0.1.0 / d28df7a4e6b345... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0612 ± 0.0074 ms | 19.7 ± 2 μs        | 3.1 ± 0.49                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.01 ± 0.037 ms    | 0.623 ± 0.055 ms   | 3.24 ± 0.29                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0986 ± 0.018 ms  | 28.4 ± 6.5 μs      | 3.47 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 13.3 ± 5 μs        | 5.7 ± 4 μs         | 2.34 ± 1.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.792 ± 0.041 ms   | 0.224 ± 0.029 ms   | 3.54 ± 0.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0429 ± 0.012 ms  | 11.7 ± 1.9 μs      | 3.67 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 10.9 ± 4.7 μs      | 2.87 ± 3.4 μs      | 3.81 ± 4.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.23 ± 0.36 ms     | 0.256 ± 0.018 ms   | 4.81 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 30.5 ± 1.8 μs      | 9.99 ± 1.6 μs      | 3.06 ± 0.53                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.327 ± 0.045 ms   | 0.0414 ± 0.018 ms  | 7.89 ± 3.6                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 12.7 ± 1.5 ms      | 2.46 ± 1.5 ms      | 5.15 ± 3.2                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.435 ± 0.038 ms   | 0.0593 ± 0.0018 ms | 7.33 ± 0.68                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.64 ± 0.71 μs     | 0.335 ± 0.047 μs   | 10.9 ± 2.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 4.44 ± 0.96 μs     | 2.27 ± 0.42 μs     | 1.95 ± 0.56                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 10.1 ± 1.1 μs      | 1.04 ± 0.057 μs    | 9.71 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.9 ± 6.2 μs      | 9.94 ± 4.3 μs      | 2.71 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.55 ± 0.029 ms    | 0.281 ± 0.023 ms   | 5.52 ± 0.46                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0582 ± 0.0077 ms | 16.6 ± 4.2 μs      | 3.5 ± 1                    |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.49 ± 0.086 ms    | 0.0544 ± 0.026 ms  | 9.02 ± 4.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0446 ± 0.002 s   | 10.5 ± 0.21 ms     | 4.25 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.546 ± 0.043 ms   | 0.09 ± 0.0062 ms   | 6.07 ± 0.64                |
| Convolution body/BLAS axpy per lag                                                 | 0.417 ± 0.017 μs   | 0.417 ± 0.019 μs   | 1 ± 0.061                  |
| Convolution body/native axpy per lag                                               | 0.42 ± 0.0003 μs   | 0.42 ± 0.011 μs    | 1 ± 0.027                  |
| Convolution body/package                                                           | 0.417 ± 0.017 μs   | 0.33 ± 0.0087 μs   | 1.26 ± 0.062               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.5 ± 2.8 μs      | 6.86 ± 1.9 μs      | 1.53 ± 0.58                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.29 ± 1.7 μs      | 2.68 ± 0.23 μs     | 0.482 ± 0.65               |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.96 ± 1.3 μs      | 2.55 ± 1.1 μs      | 0.769 ± 0.6                |
| Evaluation/Matrix overview T200_L20_S3                                             | 22.9 ± 0.95 μs     | 16.7 ± 0.65 μs     | 1.37 ± 0.078               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.377 ± 0.16 μs    | 0.145 ± 0.022 μs   | 2.6 ± 1.2                  |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.23 ± 2 μs        | 2.39 ± 0.24 μs     | 1.77 ± 0.84                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0322 ± 0.0014 ms | 20.3 ± 7.9 μs      | 1.59 ± 0.62                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.07 ± 0.14 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.11 ± 0.014 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 19.3 ± 2.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0497 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.492 ± 0.061 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.8 ± 2.9 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.473 ± 0.054 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.08 ± 2.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 30.1 ± 8.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 27.2 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 31.3 ± 1.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.34 ± 2.5 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 4.72 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.148 ± 0.014 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.2 ± 5.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 19.8 ± 2.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.7 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0978 ± 0.0093 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.038 ± 0.0028 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.448 ± 0.11 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0756 ± 0.0063 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.437 ± 0.13 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.1 ± 1.1 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 11.6 ± 5 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 16.9 ± 5.6 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14.3 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0354 ± 0.0017 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 25.5 ± 7.8 μs      |                            |
| time_to_load                                                                       | 0.185 ± 0.00024 s  | 0.195 ± 0.00064 s  | 0.952 ± 0.0034             |

|                                                                                    | v0.1.0                    | d28df7a4e6b345...         | v0.1.0 / d28df7a4e6b345... |
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
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.204 k allocs: 11.9 kB   | 0.984                      |

