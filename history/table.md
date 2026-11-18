|                                                                                    | v0.1.0             | 554f1debb80104...  | v0.1.0 / 554f1debb80104... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0555 ± 0.0093 ms | 19.3 ± 5.6 μs      | 2.88 ± 0.97                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.49 ± 0.059 ms    | 0.626 ± 0.014 ms   | 2.38 ± 0.11                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0893 ± 0.017 ms  | 26.8 ± 7 μs        | 3.33 ± 1.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 13 ± 2.6 μs        | 4.04 ± 3.2 μs      | 3.22 ± 2.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.878 ± 0.033 ms   | 0.264 ± 0.014 ms   | 3.33 ± 0.21                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0375 ± 0.015 ms  | 9.93 ± 1.7 μs      | 3.78 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 10.5 ± 2.8 μs      | 4.94 ± 3.5 μs      | 2.12 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.995 ± 0.053 ms   | 0.301 ± 0.02 ms    | 3.3 ± 0.28                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 25.4 ± 1.4 μs      | 9.7 ± 2 μs         | 2.62 ± 0.55                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.274 ± 0.04 ms    | 0.0338 ± 0.018 ms  | 8.11 ± 4.6                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 16.1 ± 3.4 ms      | 2.05 ± 0.27 ms     | 7.86 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.326 ± 0.032 ms   | 0.0461 ± 0.0018 ms | 7.07 ± 0.74                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.13 ± 0.48 μs     | 0.261 ± 0.03 μs    | 12 ± 2.3                   |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 11.3 ± 2 μs        | 4.03 ± 1.4 μs      | 2.81 ± 1.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 8.38 ± 1.6 μs      | 0.921 ± 0.09 μs    | 9.1 ± 1.9                  |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 29.1 ± 6.9 μs      | 7.5 ± 4.5 μs       | 3.88 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.15 ± 0.042 ms    | 0.335 ± 0.0094 ms  | 3.44 ± 0.16                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0522 ± 0.015 ms  | 15.1 ± 4.7 μs      | 3.45 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.437 ± 0.086 ms   | 0.0497 ± 0.03 ms   | 8.79 ± 5.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0332 ± 0.0027 s  | 9.9 ± 0.85 ms      | 3.35 ± 0.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.434 ± 0.026 ms   | 0.0801 ± 0.005 ms  | 5.42 ± 0.46                |
| Convolution body/BLAS axpy per lag                                                 | 0.466 ± 0.012 μs   | 0.408 ± 0.0032 μs  | 1.14 ± 0.03                |
| Convolution body/native axpy per lag                                               | 0.379 ± 0.0082 μs  | 0.329 ± 0.0071 μs  | 1.15 ± 0.035               |
| Convolution body/package                                                           | 0.467 ± 0.016 μs   | 0.184 ± 0.001 μs   | 2.53 ± 0.088               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.85 ± 2.3 μs      | 6.22 ± 0.88 μs     | 1.58 ± 0.43                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.39 ± 1.9 μs      | 1.69 ± 1.1 μs      | 0.823 ± 1.3                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.79 ± 1.1 μs      | 2.82 ± 1.2 μs      | 0.99 ± 0.58                |
| Evaluation/Matrix overview T200_L20_S3                                             | 19.6 ± 0.72 μs     | 12.7 ± 0.54 μs     | 1.55 ± 0.087               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.291 ± 0.23 μs    | 0.11 ± 0.061 μs    | 2.65 ± 2.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.08 ± 0.95 μs     | 2.09 ± 0.24 μs     | 1.47 ± 0.49                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 25.4 ± 12 μs       | 18 ± 7.7 μs        | 1.41 ± 0.9                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.14 ± 0.094 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.102 ± 0.0053 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 18.6 ± 3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0499 ± 0.0018 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.522 ± 0.028 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.48 ± 1.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.599 ± 0.031 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.29 ± 2.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 27.1 ± 0.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 26.2 ± 6.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 31 ± 1.1 μs        |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.72 ± 2.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.16 ± 2.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.137 ± 0.0077 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 12.6 ± 5.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 19.7 ± 3 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 16.4 ± 6 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0887 ± 0.0067 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0343 ± 0.0011 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.515 ± 0.024 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.071 ± 0.0055 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.505 ± 0.02 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.7 ± 2.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 13.6 ± 5.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 19.1 ± 4.8 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14 ± 3.3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0361 ± 0.0044 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 24.9 ± 7.3 μs      |                            |
| time_to_load                                                                       | 0.152 ± 0.0096 s   | 0.165 ± 0.00076 s  | 0.92 ± 0.059               |

|                                                                                    | v0.1.0                    | 554f1debb80104...         | v0.1.0 / 554f1debb80104... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
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

