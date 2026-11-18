|                                                                                    | v0.1.0              | 22e3f2a1ea3675...  | v0.1.0 / 22e3f2a1ea3675... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.074 ± 0.012 ms    | 25.9 ± 2.9 μs      | 2.85 ± 0.57                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.89 ± 0.033 ms     | 0.816 ± 0.017 ms   | 2.31 ± 0.063               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.115 ± 0.029 ms    | 0.0366 ± 0.0099 ms | 3.15 ± 1.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.7 ± 6.7 μs       | 3.43 ± 4 μs        | 4.89 ± 6                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.3 ± 0.03 ms       | 0.337 ± 0.016 ms   | 3.86 ± 0.2                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.055 ± 0.022 ms    | 12.9 ± 2 μs        | 4.27 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.2 ± 1.2 μs       | 6.84 ± 4.9 μs      | 1.63 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.48 ± 0.49 ms      | 0.445 ± 0.011 ms   | 3.32 ± 1.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.035 ± 0.0009 ms   | 12.8 ± 2.6 μs      | 2.73 ± 0.56                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.373 ± 0.057 ms    | 0.0516 ± 0.024 ms  | 7.22 ± 3.6                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.8 ± 2.1 ms       | 3.07 ± 0.7 ms      | 7.08 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.446 ± 0.037 ms    | 0.0731 ± 0.0023 ms | 6.1 ± 0.54                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.05 ± 0.4 μs       | 0.35 ± 0.05 μs     | 11.6 ± 2                   |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.15 ± 6.5 μs       | 4.78 ± 0.64 μs     | 1.71 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.7 ± 1.4 μs       | 1.24 ± 0.18 μs     | 9.39 ± 1.8                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 25.6 ± 8.5 μs       | 8.21 ± 5.4 μs      | 3.12 ± 2.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.43 ± 0.038 ms     | 0.545 ± 0.013 ms   | 2.63 ± 0.095               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0678 ± 0.0082 ms  | 18.5 ± 6.7 μs      | 3.67 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.544 ± 0.051 ms    | 0.0686 ± 0.01 ms   | 7.93 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0426 ± 0.0018 s   | 14 ± 0.9 ms        | 3.04 ± 0.23                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.565 ± 0.025 ms    | 0.109 ± 0.0052 ms  | 5.19 ± 0.34                |
| Convolution body/BLAS axpy per lag                                                 | 0.707 ± 0.0059 μs   | 0.72 ± 0.0059 μs   | 0.982 ± 0.012              |
| Convolution body/native axpy per lag                                               | 0.424 ± 0.0063 μs   | 0.424 ± 0.0067 μs  | 1 ± 0.022                  |
| Convolution body/package                                                           | 0.707 ± 0.0065 μs   | 0.324 ± 0.0057 μs  | 2.18 ± 0.043               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.1 ± 0.38 μs      | 7.49 ± 0.27 μs     | 1.61 ± 0.077               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.2 ± 0.36 μs       | 2.34 ± 1.3 μs      | 1.79 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.61 ± 1.1 μs       | 3.76 ± 1.6 μs      | 0.429 ± 0.36               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0328 ± 0.00097 ms | 17.8 ± 1 μs        | 1.85 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.391 ± 0.21 μs     | 0.14 ± 0.02 μs     | 2.79 ± 1.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.78 ± 1.7 μs       | 2.72 ± 0.23 μs     | 2.49 ± 0.65                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0354 ± 0.00098 ms | 24.2 ± 2.3 μs      | 1.47 ± 0.15                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.56 ± 0.07 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.137 ± 0.009 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 24.8 ± 4 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0654 ± 0.0018 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.651 ± 0.028 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.31 ± 0.67 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.88 ± 0.033 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.24 ± 3.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0357 ± 0.0041 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0359 ± 0.012 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0413 ± 0.0012 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.73 ± 3.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.57 ± 1.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.183 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.3 ± 5.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 25.3 ± 3.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 20.6 ± 7.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.122 ± 0.0085 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0477 ± 0.0019 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.641 ± 0.059 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0966 ± 0.0076 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.633 ± 0.032 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 16.4 ± 1.4 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 16.4 ± 4.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 23.6 ± 7.9 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 20.1 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0455 ± 0.0014 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0323 ± 0.012 ms  |                            |
| time_to_load                                                                       | 0.192 ± 0.002 s     | 0.248 ± 0.00047 s  | 0.775 ± 0.0082             |

|                                                                                    | v0.1.0                    | 22e3f2a1ea3675...         | v0.1.0 / 22e3f2a1ea3675... |
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

