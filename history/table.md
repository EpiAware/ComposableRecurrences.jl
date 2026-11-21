|                                                                                    | v0.1.0             | 6c77d3af68679b...  | v0.1.0 / 6c77d3af68679b... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.08 ± 0.011 ms    | 27.7 ± 2.6 μs      | 2.89 ± 0.47                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.75 ± 0.089 ms    | 0.872 ± 0.028 ms   | 3.15 ± 0.14                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.119 ± 0.017 ms   | 0.0359 ± 0.0086 ms | 3.33 ± 0.92                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 18.6 ± 5.4 μs      | 6.66 ± 4.3 μs      | 2.79 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.2 ± 0.049 ms     | 0.369 ± 0.021 ms   | 3.24 ± 0.22                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0554 ± 0.017 ms  | 13.5 ± 2 μs        | 4.12 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.8 ± 1.3 μs      | 4.48 ± 4.4 μs      | 3.52 ± 3.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.35 ± 0.05 ms     | 0.412 ± 0.026 ms   | 3.27 ± 0.24                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0415 ± 0.0018 ms | 13.6 ± 2.4 μs      | 3.06 ± 0.56                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.484 ± 0.048 ms   | 0.053 ± 0.017 ms   | 9.12 ± 3.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 20 ± 3.1 ms        | 3.48 ± 0.11 ms     | 5.74 ± 0.91                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.524 ± 0.04 ms    | 0.0739 ± 0.0038 ms | 7.09 ± 0.65                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.61 ± 0.49 μs     | 0.71 ± 0.25 μs     | 7.9 ± 2.9                  |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 9.76 ± 5 μs        | 4.09 ± 0.5 μs      | 2.39 ± 1.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13 ± 1.3 μs        | 1.57 ± 0.28 μs     | 8.28 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0366 ± 0.0073 ms | 9.78 ± 5.2 μs      | 3.74 ± 2.1                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.14 ± 0.058 ms    | 0.497 ± 0.025 ms   | 4.31 ± 0.25                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0785 ± 0.01 ms   | 18.2 ± 5.9 μs      | 4.32 ± 1.5                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.687 ± 0.071 ms   | 0.0814 ± 0.01 ms   | 8.44 ± 1.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0617 ± 0.0032 s  | 16.5 ± 0.37 ms     | 3.75 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.642 ± 0.037 ms   | 0.115 ± 0.0077 ms  | 5.58 ± 0.49                |
| Convolution body/BLAS axpy per lag                                                 | 0.689 ± 0.016 μs   | 0.564 ± 0.009 μs   | 1.22 ± 0.034               |
| Convolution body/native axpy per lag                                               | 0.566 ± 0.0008 μs  | 0.571 ± 0.0053 μs  | 0.991 ± 0.0092             |
| Convolution body/package                                                           | 0.692 ± 0.015 μs   | 0.406 ± 0.00098 μs | 1.7 ± 0.036                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.7 ± 0.75 μs     | 9.73 ± 2.4 μs      | 1.41 ± 0.35                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.93 ± 0.36 μs     | 2.17 ± 0.47 μs     | 1.81 ± 0.42                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.75 ± 1 μs        | 2.64 ± 1.5 μs      | 0.663 ± 0.55               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0321 ± 0.0014 ms | 20.8 ± 1.5 μs      | 1.54 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.449 ± 0.14 μs    | 0.154 ± 0.099 μs   | 2.92 ± 2.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.24 ± 1.6 μs      | 3.33 ± 0.29 μs     | 2.17 ± 0.53                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0443 ± 0.0018 ms | 28.7 ± 3 μs        | 1.54 ± 0.17                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.82 ± 0.14 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.148 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 25.6 ± 6.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0715 ± 0.0039 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.914 ± 0.062 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 6.67 ± 3.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.949 ± 0.061 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.13 ± 3.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.042 ± 0.0082 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0342 ± 0.0096 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0476 ± 0.0026 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.79 ± 3.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.17 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.195 ± 0.02 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 17.1 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 26.6 ± 3.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 22 ± 7.1 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.138 ± 0.014 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0551 ± 0.0046 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.9 ± 0.049 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.106 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.888 ± 0.047 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 17 ± 2.6 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 17.7 ± 5.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 24.9 ± 6.2 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 21.6 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0557 ± 0.0025 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0323 ± 0.01 ms   |                            |
| time_to_load                                                                       | 0.251 ± 0.00078 s  | 0.322 ± 0.0021 s   | 0.779 ± 0.0057             |

|                                                                                    | v0.1.0                    | 6c77d3af68679b...         | v0.1.0 / 6c77d3af68679b... |
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

