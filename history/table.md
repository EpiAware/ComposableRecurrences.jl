|                                                                                    | v0.1.0             | 4afec4ac278698...  | v0.1.0 / 4afec4ac278698... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0944 ± 0.016 ms  | 30.8 ± 9 μs        | 3.06 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.57 ± 0.036 ms    | 0.853 ± 0.026 ms   | 3.02 ± 0.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.144 ± 0.021 ms   | 0.0428 ± 0.012 ms  | 3.37 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 18.2 ± 8.7 μs      | 3.37 ± 4.2 μs      | 5.41 ± 7.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.386 ± 0.021 ms   | 0.272 ± 0.019 ms   | 1.42 ± 0.12                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0606 ± 0.0055 ms | 14.2 ± 2.1 μs      | 4.27 ± 0.73                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 14.6 ± 6 μs        | 3.95 ± 5.7 μs      | 3.69 ± 5.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.403 ± 0.019 ms   | 0.336 ± 0.011 ms   | 1.2 ± 0.069                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0596 ± 0.023 ms  | 14.1 ± 2.8 μs      | 4.24 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.494 ± 0.07 ms    | 0.0595 ± 0.026 ms  | 8.29 ± 3.8                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.4 ± 2 ms        | 3.31 ± 0.083 ms    | 3.45 ± 0.62                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.562 ± 0.043 ms   | 0.0836 ± 0.0026 ms | 6.72 ± 0.55                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.39 ± 0.36 μs     | 0.461 ± 0.049 μs   | 11.7 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.94 ± 0.79 μs     | 3.14 ± 0.42 μs     | 1.89 ± 0.36                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.5 ± 0.87 μs     | 1.45 ± 0.13 μs     | 9.32 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0405 ± 0.011 ms  | 9.63 ± 7.1 μs      | 4.21 ± 3.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.08 ± 0.04 ms     | 0.367 ± 0.015 ms   | 5.67 ± 0.26                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0857 ± 0.021 ms  | 22.5 ± 7.7 μs      | 3.81 ± 1.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.672 ± 0.093 ms   | 0.0835 ± 0.014 ms  | 8.05 ± 1.8                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0562 ± 0.0028 s  | 12.5 ± 0.56 ms     | 4.5 ± 0.3                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.721 ± 0.033 ms   | 0.136 ± 0.0093 ms  | 5.31 ± 0.44                |
| Convolution body/BLAS axpy per lag                                                 | 0.784 ± 0.0027 μs  | 0.782 ± 0.0029 μs  | 1 ± 0.0051                 |
| Convolution body/native axpy per lag                                               | 0.494 ± 0.0076 μs  | 0.506 ± 0.0051 μs  | 0.976 ± 0.018              |
| Convolution body/package                                                           | 0.784 ± 0.002 μs   | 0.358 ± 0.0047 μs  | 2.19 ± 0.029               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.2 ± 3.2 μs      | 9.03 ± 3.1 μs      | 1.57 ± 0.64                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.34 ± 2.9 μs      | 0.962 ± 1.5 μs     | 2.43 ± 4.9                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.15 ± 1.6 μs      | 2.39 ± 2.8 μs      | 1.73 ± 2.1                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0396 ± 0.0011 ms | 19.3 ± 0.91 μs     | 2.06 ± 0.11                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.531 ± 0.14 μs    | 0.17 ± 0.05 μs     | 3.12 ± 1.2                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 8.18 ± 1.8 μs      | 3.67 ± 0.17 μs     | 2.23 ± 0.5                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.047 ± 0.0011 ms  | 31.2 ± 1.7 μs      | 1.51 ± 0.089               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.78 ± 0.1 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.171 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 27.3 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0859 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.634 ± 0.033 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 8.12 ± 4.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.635 ± 0.036 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 5.42 ± 1.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.045 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0395 ± 0.012 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0508 ± 0.0014 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 5.75 ± 1.9 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.93 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.228 ± 0.016 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 15.9 ± 8.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 27.9 ± 4 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 23.2 ± 9.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.157 ± 0.011 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0594 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.561 ± 0.034 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.117 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.552 ± 0.028 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15.9 ± 2.2 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.8 ± 8.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 26.5 ± 9.3 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 23.1 ± 4.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0515 ± 0.0028 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0362 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.24 ± 0.0012 s    | 0.309 ± 0.0011 s   | 0.776 ± 0.0048             |

|                                                                                    | v0.1.0                    | 4afec4ac278698...         | v0.1.0 / 4afec4ac278698... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.055 k allocs: 28.7 kB   | 1.3                        |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.059 k allocs: 0.0327 MB | 2.51                       |
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
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.043 k allocs: 26.8 kB   | 0.033 k allocs: 20.4 kB   | 1.31                       |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 0.522 k allocs: 1.77 MB   | 0.322 k allocs: 1.32 MB   | 1.34                       |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 1.7 k allocs: 0.0669 MB   | 0.036 k allocs: 20.1 kB   | 3.41                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 1.35 k allocs: 0.267 MB   | 0.085 k allocs: 0.134 MB  | 1.99                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 3.46 k allocs: 0.0507 GB  | 2.31 k allocs: 30.9 MB    | 1.68                       |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 8.37 k allocs: 0.35 MB    | 0.135 k allocs: 0.12 MB   | 2.91                       |
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
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                           | 0.16 k allocs: 0.13 MB    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                           | 0.28 k allocs: 0.0632 MB  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                           | 1.52 k allocs: 2.54 MB    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                           | 0.041 k allocs: 11.3 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                           | 1.52 k allocs: 2.65 MB    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                           | 0.033 k allocs: 0.0338 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                           | 0.126 k allocs: 0.0377 MB |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                           | 0.136 k allocs: 0.0637 MB |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                           | 28  allocs: 11.3 kB       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                           | 0.041 k allocs: 11.7 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                           | 0.303 k allocs: 0.265 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                           | 0.087 k allocs: 0.0346 MB |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                           | 0.115 k allocs: 31.1 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                           | 0.156 k allocs: 0.288 MB  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                           | 0.045 k allocs: 0.0821 MB |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                           | 0.121 k allocs: 0.135 MB  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                           | 1 k allocs: 3.26 MB       |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                           | 3.36 k allocs: 31.4 MB    |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                           | 0.077 k allocs: 26.8 kB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                           | 0.115 k allocs: 30 kB     |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                           | 0.038 k allocs: 17.9 kB   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                           | 9.02 k allocs: 0.182 GB   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                           | 0.126 k allocs: 0.0394 MB |                            |
| time_to_load                                                                       | 0.2 k allocs: 11.8 kB     | 0.2 k allocs: 11.8 kB     | 1                          |

