|                                                                                    | v0.1.0             | bd441a8781e18d...  | v0.1.0 / bd441a8781e18d... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.071 ± 0.0089 ms  | 23.1 ± 5.7 μs      | 3.07 ± 0.85                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.31 ± 0.21 ms     | 0.644 ± 0.12 ms    | 3.58 ± 0.72                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0962 ± 0.019 ms  | 30.9 ± 6.4 μs      | 3.11 ± 0.9                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 15.8 ± 4.3 μs      | 3.4 ± 2.5 μs       | 4.64 ± 3.6                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.887 ± 0.097 ms   | 0.267 ± 0.042 ms   | 3.32 ± 0.63                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0476 ± 0.014 ms  | 11.3 ± 1.7 μs      | 4.2 ± 1.4                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 13.8 ± 1.6 μs      | 3.83 ± 3.6 μs      | 3.6 ± 3.4                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.18 ± 0.37 ms     | 0.297 ± 0.046 ms   | 3.97 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0342 ± 0.0023 ms | 11.4 ± 2.1 μs      | 2.99 ± 0.59                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.407 ± 0.042 ms   | 0.0452 ± 0.015 ms  | 8.99 ± 3.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14 ± 0.45 ms       | 2.53 ± 0.41 ms     | 5.53 ± 0.91                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.455 ± 0.039 ms   | 0.0622 ± 0.0024 ms | 7.32 ± 0.69                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.62 ± 0.51 μs     | 0.654 ± 0.19 μs    | 7.07 ± 2.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.44 ± 3.3 μs      | 3.59 ± 1.2 μs      | 2.35 ± 1.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.1 ± 1.4 μs      | 1.5 ± 0.29 μs      | 7.4 ± 1.7                  |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 30.3 ± 5.5 μs      | 11 ± 4.8 μs        | 2.76 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.71 ± 0.099 ms    | 0.326 ± 0.019 ms   | 5.26 ± 0.44                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0652 ± 0.009 ms  | 16.2 ± 4.9 μs      | 4.04 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.582 ± 0.034 ms   | 0.0668 ± 0.015 ms  | 8.72 ± 2.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0478 ± 0.0025 s  | 11.5 ± 0.89 ms     | 4.16 ± 0.39                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.558 ± 0.048 ms   | 0.0969 ± 0.0062 ms | 5.76 ± 0.62                |
| Convolution body/BLAS axpy per lag                                                 | 0.443 ± 0.0032 μs  | 0.44 ± 0.0036 μs   | 1.01 ± 0.011               |
| Convolution body/native axpy per lag                                               | 0.444 ± 0.0036 μs  | 0.441 ± 0.00036 μs | 1.01 ± 0.0081              |
| Convolution body/package                                                           | 0.442 ± 0.0033 μs  | 0.314 ± 0.00074 μs | 1.41 ± 0.011               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 11.6 ± 1.1 μs      | 7.99 ± 0.31 μs     | 1.46 ± 0.15                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.21 ± 1.8 μs      | 1.87 ± 1.1 μs      | 1.71 ± 1.4                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.61 ± 1 μs        | 2.99 ± 1.3 μs      | 0.537 ± 0.41               |
| Evaluation/Matrix overview T200_L20_S3                                             | 26.9 ± 1.1 μs      | 15.8 ± 1.1 μs      | 1.7 ± 0.14                 |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.387 ± 0.2 μs     | 0.128 ± 0.013 μs   | 3.02 ± 1.6                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 6.12 ± 1.5 μs      | 2.66 ± 0.25 μs     | 2.31 ± 0.62                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0378 ± 0.0018 ms | 26 ± 2.6 μs        | 1.46 ± 0.16                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.22 ± 0.4 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.119 ± 0.0078 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 21.9 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0587 ± 0.0037 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.54 ± 0.2 ms      |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.97 ± 0.86 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.568 ± 0.2 ms     |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.34 ± 2.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0332 ± 0.0014 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 29.7 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0378 ± 0.0028 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.81 ± 2.8 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.58 ± 2.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.164 ± 0.014 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 14.1 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 22.8 ± 2.7 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 18.2 ± 4.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.116 ± 0.019 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0479 ± 0.0026 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.513 ± 0.26 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0887 ± 0.0097 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.5 ± 0.25 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 12.2 ± 0.56 ms     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 14.3 ± 5.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 20.3 ± 5.9 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 18.7 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0387 ± 0.0012 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 27.7 ± 3.8 μs      |                            |
| time_to_load                                                                       | 0.207 ± 0.0013 s   | 0.27 ± 0.0016 s    | 0.766 ± 0.0067             |

|                                                                                    | v0.1.0                    | bd441a8781e18d...         | v0.1.0 / bd441a8781e18d... |
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

