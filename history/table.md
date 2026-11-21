|                                                                                    | v0.1.0              | c7e6f0a3ff1f39...  | v0.1.0 / c7e6f0a3ff1f39... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0958 ± 0.017 ms   | 30.8 ± 9.1 μs      | 3.11 ± 1.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.59 ± 0.028 ms     | 0.84 ± 0.015 ms    | 3.09 ± 0.065               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.142 ± 0.016 ms    | 0.0427 ± 0.012 ms  | 3.33 ± 1                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.3 ± 8.4 μs       | 7.24 ± 5.6 μs      | 2.39 ± 2.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.369 ± 0.022 ms    | 0.273 ± 0.014 ms   | 1.35 ± 0.11                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0604 ± 0.021 ms   | 14.2 ± 2.1 μs      | 4.25 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 17.1 ± 5.3 μs       | 7.39 ± 5.7 μs      | 2.31 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.387 ± 0.02 ms     | 0.336 ± 0.011 ms   | 1.15 ± 0.071               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0597 ± 0.023 ms   | 14.4 ± 2.6 μs      | 4.15 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.523 ± 0.068 ms    | 0.0584 ± 0.0096 ms | 8.95 ± 1.9                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 10.8 ± 1.2 ms       | 3.3 ± 0.081 ms     | 3.28 ± 0.38                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.548 ± 0.036 ms    | 0.0828 ± 0.0019 ms | 6.62 ± 0.47                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.45 ± 0.35 μs      | 0.45 ± 0.04 μs     | 12.1 ± 1.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.95 ± 0.78 μs      | 3.14 ± 0.38 μs     | 1.9 ± 0.34                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.9 ± 0.89 μs      | 1.45 ± 0.071 μs    | 9.58 ± 0.77                |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0407 ± 0.011 ms   | 16.1 ± 8.3 μs      | 2.54 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.07 ± 0.028 ms     | 0.366 ± 0.013 ms   | 5.66 ± 0.21                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0864 ± 0.022 ms   | 21.2 ± 7.2 μs      | 4.09 ± 1.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.681 ± 0.096 ms    | 0.082 ± 0.012 ms   | 8.31 ± 1.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.055 ± 0.0018 s    | 12.3 ± 0.32 ms     | 4.48 ± 0.19                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.708 ± 0.026 ms    | 0.134 ± 0.009 ms   | 5.29 ± 0.41                |
| Convolution body/BLAS axpy per lag                                                 | 0.776 ± 0.0026 μs   | 0.781 ± 0.012 μs   | 0.995 ± 0.016              |
| Convolution body/native axpy per lag                                               | 0.495 ± 0.0062 μs   | 0.496 ± 0.0058 μs  | 0.998 ± 0.017              |
| Convolution body/package                                                           | 0.776 ± 0.003 μs    | 0.353 ± 0.0053 μs  | 2.2 ± 0.034                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14 ± 1.9 μs         | 9.05 ± 3.2 μs      | 1.55 ± 0.58                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.47 ± 3.1 μs       | 2.29 ± 1.6 μs      | 1.95 ± 1.9                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.39 ± 1.7 μs       | 2.65 ± 2.9 μs      | 1.66 ± 1.9                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0394 ± 0.00095 ms | 19.4 ± 0.77 μs     | 2.04 ± 0.095               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.551 ± 0.16 μs     | 0.161 ± 0.02 μs    | 3.42 ± 1.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.33 ± 3.1 μs       | 3.69 ± 0.2 μs      | 1.99 ± 0.85                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0473 ± 0.00094 ms | 31 ± 0.9 μs        | 1.53 ± 0.054               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.68 ± 0.077 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.168 ± 0.0094 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.7 ± 3.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0855 ± 0.002 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.615 ± 0.022 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.69 ± 4.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.62 ± 0.033 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 5.12 ± 3.9 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0461 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0389 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0502 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.83 ± 4.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.94 ± 4.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.226 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.4 ± 8 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.8 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 22.3 ± 9.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.153 ± 0.0096 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0596 ± 0.0014 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.542 ± 0.036 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.117 ± 0.0093 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.518 ± 0.035 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.8 ± 1.8 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.5 ± 7.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 25.9 ± 9.4 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.3 ± 5 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0492 ± 0.0019 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.036 ± 0.014 ms   |                            |
| time_to_load                                                                       | 0.241 ± 0.0017 s    | 0.312 ± 0.0019 s   | 0.774 ± 0.0072             |

|                                                                                    | v0.1.0                    | c7e6f0a3ff1f39...         | v0.1.0 / c7e6f0a3ff1f39... |
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

