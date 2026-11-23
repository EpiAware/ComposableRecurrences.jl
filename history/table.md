|                                                                                    | v0.1.0              | f4d0e1671cd5a4...  | v0.1.0 / f4d0e1671cd5a4... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0752 ± 0.013 ms   | 26.7 ± 3.2 μs      | 2.82 ± 0.58                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.91 ± 0.045 ms     | 0.85 ± 0.019 ms    | 2.24 ± 0.072               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.114 ± 0.029 ms    | 0.038 ± 0.01 ms    | 3 ± 1.1                    |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.5 ± 6.8 μs       | 3.9 ± 4.1 μs       | 4.23 ± 4.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.32 ± 0.029 ms     | 0.356 ± 0.014 ms   | 3.72 ± 0.17                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0554 ± 0.023 ms   | 13.6 ± 2.3 μs      | 4.08 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11.2 ± 1.4 μs       | 5 ± 4.7 μs         | 2.25 ± 2.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.47 ± 0.034 ms     | 0.503 ± 0.012 ms   | 2.92 ± 0.096               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0355 ± 0.00098 ms | 13.1 ± 2.7 μs      | 2.7 ± 0.56                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.378 ± 0.064 ms    | 0.0505 ± 0.024 ms  | 7.48 ± 3.7                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.4 ± 2.5 ms       | 3.17 ± 0.19 ms     | 6.74 ± 0.89                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.454 ± 0.04 ms     | 0.0694 ± 0.0028 ms | 6.55 ± 0.63                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.24 ± 0.44 μs      | 0.37 ± 0.1 μs      | 11.4 ± 3.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.74 ± 7.2 μs       | 5.32 ± 1.3 μs      | 1.64 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.6 ± 1.3 μs       | 1.27 ± 0.23 μs     | 9.13 ± 1.9                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 27.5 ± 8.9 μs       | 8.59 ± 6.2 μs      | 3.2 ± 2.5                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.44 ± 0.026 ms     | 0.572 ± 0.019 ms   | 2.52 ± 0.094               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0682 ± 0.011 ms   | 14.4 ± 2.1 μs      | 4.74 ± 1                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.577 ± 0.086 ms    | 0.0713 ± 0.0085 ms | 8.1 ± 1.5                  |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0428 ± 0.0023 s   | 14.6 ± 0.74 ms     | 2.92 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.573 ± 0.027 ms    | 0.115 ± 0.0076 ms  | 4.99 ± 0.4                 |
| Convolution body/BLAS axpy per lag                                                 | 0.716 ± 0.0057 μs   | 0.784 ± 0.011 μs   | 0.914 ± 0.015              |
| Convolution body/native axpy per lag                                               | 0.425 ± 0.0062 μs   | 0.418 ± 0.0078 μs  | 1.02 ± 0.024               |
| Convolution body/package                                                           | 0.715 ± 0.0054 μs   | 0.322 ± 0.0082 μs  | 2.22 ± 0.059               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.6 ± 3.3 μs       | 7.5 ± 0.55 μs      | 1.68 ± 0.46                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.2 ± 0.38 μs       | 2.34 ± 1.4 μs      | 1.79 ± 1.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.04 ± 1.7 μs       | 3.86 ± 1.7 μs      | 1.05 ± 0.64                |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.033 ± 0.0011 ms   | 18 ± 1.1 μs        | 1.84 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.38 ± 0.04 μs      | 0.13 ± 0.03 μs     | 2.92 ± 0.74                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.3 ± 1.5 μs        | 2.75 ± 0.29 μs     | 1.56 ± 0.56                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0357 ± 0.0014 ms  | 24.7 ± 11 μs       | 1.45 ± 0.66                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.6 ± 0.085 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.139 ± 0.0098 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 25.5 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.067 ± 0.0021 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.727 ± 0.042 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 5.9 ± 3.1 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.95 ± 0.053 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.37 ± 3.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.036 ± 0.0025 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0343 ± 0.0059 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0446 ± 0.0015 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.83 ± 3.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 7.02 ± 3.1 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.19 ± 0.016 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16.7 ± 6.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 26.1 ± 3.6 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 21.4 ± 8.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.127 ± 0.013 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0483 ± 0.0023 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.702 ± 0.037 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0987 ± 0.0093 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.697 ± 0.039 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 17.3 ± 3.1 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.8 ± 6.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 24.5 ± 9.1 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 20.1 ± 4.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0523 ± 0.0049 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0319 ± 0.011 ms  |                            |
| time_to_load                                                                       | 0.193 ± 0.00016 s   | 0.258 ± 0.0013 s   | 0.746 ± 0.0039             |

|                                                                                    | v0.1.0                    | f4d0e1671cd5a4...         | v0.1.0 / f4d0e1671cd5a4... |
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

