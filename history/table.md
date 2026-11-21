|                                                                                    | v0.1.0             | ad16b790f18479...  | v0.1.0 / ad16b790f18479... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0593 ± 0.0087 ms | 20.1 ± 5.5 μs      | 2.95 ± 0.92                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2 ± 0.088 ms       | 0.634 ± 0.051 ms   | 3.15 ± 0.29                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0906 ± 0.016 ms  | 27.6 ± 2.2 μs      | 3.29 ± 0.65                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 14.2 ± 5.3 μs      | 2.84 ± 3 μs        | 4.99 ± 5.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.744 ± 0.075 ms   | 0.25 ± 0.031 ms    | 2.98 ± 0.47                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.043 ± 0.0032 ms  | 10.2 ± 1.5 μs      | 4.23 ± 0.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 10.6 ± 3.8 μs      | 3.21 ± 3.5 μs      | 3.31 ± 3.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.821 ± 0.045 ms   | 0.272 ± 0.02 ms    | 3.02 ± 0.28                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 30.4 ± 2.2 μs      | 10.1 ± 1.7 μs      | 3.01 ± 0.56                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.404 ± 0.056 ms   | 0.0379 ± 0.015 ms  | 10.7 ± 4.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 12 ± 1.1 ms        | 2.74 ± 0.16 ms     | 4.39 ± 0.48                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.414 ± 0.038 ms   | 0.0536 ± 0.002 ms  | 7.71 ± 0.76                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.72 ± 0.28 μs     | 0.351 ± 0.053 μs   | 10.6 ± 1.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 10.3 ± 1.5 μs      | 2.41 ± 0.35 μs     | 4.27 ± 0.87                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 10.5 ± 1.5 μs      | 1.06 ± 0.089 μs    | 9.85 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.5 ± 6.5 μs      | 10.1 ± 4.6 μs      | 2.61 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.51 ± 0.079 ms    | 0.312 ± 0.023 ms   | 4.85 ± 0.44                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.059 ± 0.012 ms   | 14.8 ± 4.7 μs      | 4 ± 1.5                    |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.582 ± 0.093 ms   | 0.0589 ± 0.02 ms   | 9.88 ± 3.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0441 ± 0.0025 s  | 10.9 ± 0.94 ms     | 4.04 ± 0.42                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.509 ± 0.049 ms   | 0.086 ± 0.0089 ms  | 5.91 ± 0.84                |
| Convolution body/BLAS axpy per lag                                                 | 0.409 ± 0.012 μs   | 0.425 ± 0.015 μs   | 0.962 ± 0.044              |
| Convolution body/native axpy per lag                                               | 0.409 ± 0.011 μs   | 0.42 ± 0.011 μs    | 0.975 ± 0.037              |
| Convolution body/package                                                           | 0.407 ± 0.011 μs   | 0.327 ± 0.0098 μs  | 1.24 ± 0.051               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.7 ± 2.3 μs      | 7.12 ± 0.48 μs     | 1.5 ± 0.34                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 1.52 ± 1.5 μs      | 1.66 ± 0.93 μs     | 0.915 ± 1.1                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.68 ± 1.2 μs      | 2.62 ± 1.2 μs      | 1.02 ± 0.63                |
| Evaluation/Matrix overview T200_L20_S3                                             | 22.8 ± 0.72 μs     | 12.7 ± 0.44 μs     | 1.79 ± 0.084               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.357 ± 0.15 μs    | 0.122 ± 0.055 μs   | 2.93 ± 1.8                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.51 ± 0.97 μs     | 2.4 ± 0.23 μs      | 1.46 ± 0.43                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0333 ± 0.0096 ms | 20.2 ± 0.91 μs     | 1.65 ± 0.48                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.16 ± 0.13 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.106 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 19.8 ± 2.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0518 ± 0.002 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.536 ± 0.051 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.33 ± 0.91 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.532 ± 0.06 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.19 ± 2.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 27.3 ± 0.77 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 26.5 ± 3.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0349 ± 0.0016 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.33 ± 2.5 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.15 ± 2.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.143 ± 0.02 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 12.4 ± 5.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 20.3 ± 2.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 16.8 ± 5.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.104 ± 0.0077 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0385 ± 0.0015 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.495 ± 0.13 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0773 ± 0.0057 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.474 ± 0.12 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.9 ± 1.7 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 13.1 ± 5.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 19 ± 5.2 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 16.5 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0366 ± 0.00034 s |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 24.9 ± 3.1 μs      |                            |
| time_to_load                                                                       | 0.183 ± 0.00093 s  | 0.239 ± 0.00039 s  | 0.764 ± 0.0041             |

|                                                                                    | v0.1.0                    | ad16b790f18479...         | v0.1.0 / ad16b790f18479... |
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

