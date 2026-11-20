|                                                                                    | v0.1.0             | 459caade8cf8f4...  | v0.1.0 / 459caade8cf8f4... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0829 ± 0.01 ms   | 26.6 ± 6.8 μs      | 3.11 ± 0.89                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.73 ± 0.086 ms    | 0.854 ± 0.049 ms   | 3.2 ± 0.21                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.112 ± 0.017 ms   | 0.0356 ± 0.0087 ms | 3.15 ± 0.9                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.8 ± 5.4 μs      | 6.39 ± 4.2 μs      | 2.79 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.18 ± 0.055 ms    | 0.341 ± 0.029 ms   | 3.45 ± 0.33                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0542 ± 0.017 ms  | 13.3 ± 2.1 μs      | 4.09 ± 1.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.5 ± 2.7 μs      | 6.92 ± 4.7 μs      | 2.24 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.36 ± 0.42 ms     | 0.385 ± 0.027 ms   | 3.53 ± 1.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.041 ± 0.0024 ms  | 13 ± 2.2 μs        | 3.15 ± 0.57                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.466 ± 0.041 ms   | 0.0521 ± 0.017 ms  | 8.95 ± 3.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 18.7 ± 2.3 ms      | 3.26 ± 0.33 ms     | 5.73 ± 0.92                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.508 ± 0.033 ms   | 0.0726 ± 0.004 ms  | 7 ± 0.6                    |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.33 ± 0.49 μs     | 0.669 ± 0.29 μs    | 7.97 ± 3.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.44 ± 4.4 μs      | 3.92 ± 0.63 μs     | 2.15 ± 1.2                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13 ± 1.4 μs        | 1.57 ± 0.27 μs     | 8.23 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0358 ± 0.0028 ms | 9.65 ± 5.5 μs      | 3.71 ± 2.1                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.1 ± 0.06 ms      | 0.465 ± 0.037 ms   | 4.51 ± 0.38                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0753 ± 0.009 ms  | 19.2 ± 5.6 μs      | 3.92 ± 1.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.653 ± 0.032 ms   | 0.078 ± 0.0096 ms  | 8.37 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0607 ± 0.0025 s  | 15.2 ± 0.69 ms     | 3.99 ± 0.24                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.64 ± 0.039 ms    | 0.114 ± 0.0078 ms  | 5.6 ± 0.51                 |
| Convolution body/BLAS axpy per lag                                                 | 0.76 ± 0.029 μs    | 0.531 ± 0.019 μs   | 1.43 ± 0.075               |
| Convolution body/native axpy per lag                                               | 0.528 ± 0.019 μs   | 0.532 ± 0.016 μs   | 0.993 ± 0.046              |
| Convolution body/package                                                           | 0.757 ± 0.036 μs   | 0.377 ± 0.0014 μs  | 2.01 ± 0.096               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.7 ± 2.6 μs      | 9.51 ± 2.3 μs      | 1.44 ± 0.44                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.75 ± 0.51 μs     | 2.17 ± 1.3 μs      | 1.73 ± 1                   |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.61 ± 1 μs        | 3.4 ± 1.5 μs       | 0.472 ± 0.36               |
| Evaluation/Matrix overview T200_L20_S3                                             | 31.2 ± 1.6 μs      | 20 ± 1.4 μs        | 1.56 ± 0.13                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.438 ± 0.15 μs    | 0.147 ± 0.008 μs   | 2.98 ± 1                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.05 ± 1.7 μs      | 3.25 ± 0.34 μs     | 2.17 ± 0.57                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0428 ± 0.0022 ms | 28.6 ± 2.4 μs      | 1.5 ± 0.15                 |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.65 ± 0.25 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.143 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 25 ± 6 μs          |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0698 ± 0.0042 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.874 ± 0.081 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.85 ± 1.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.859 ± 0.075 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.88 ± 3.3 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0407 ± 0.0069 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0339 ± 0.0094 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0472 ± 0.0031 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.48 ± 3.2 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.32 ± 3.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.19 ± 0.019 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 16.6 ± 4.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 26.5 ± 3.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 21.6 ± 6.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.134 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0541 ± 0.0041 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.758 ± 0.16 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.104 ± 0.0097 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.783 ± 0.13 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 16 ± 2.1 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.5 ± 6.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 23.6 ± 6.1 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 20.9 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0517 ± 0.0033 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0323 ± 0.0099 ms |                            |
| time_to_load                                                                       | 0.245 ± 0.00097 s  | 0.314 ± 0.00021 s  | 0.779 ± 0.0031             |

|                                                                                    | v0.1.0                    | 459caade8cf8f4...         | v0.1.0 / 459caade8cf8f4... |
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
| time_to_load                                                                       | 0.204 k allocs: 11.9 kB   | 0.2 k allocs: 11.8 kB     | 1.02                       |

