|                                                                                    | v0.1.0              | f51707ff10620a...  | v0.1.0 / f51707ff10620a... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0741 ± 0.012 ms   | 26.5 ± 7.9 μs      | 2.8 ± 0.96                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.89 ± 0.037 ms     | 0.825 ± 0.028 ms   | 2.29 ± 0.09                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.115 ± 0.013 ms    | 0.037 ± 0.011 ms   | 3.1 ± 0.96                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 16.8 ± 7.5 μs       | 3.57 ± 3.9 μs      | 4.72 ± 5.5                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.31 ± 0.027 ms     | 0.347 ± 0.015 ms   | 3.78 ± 0.18                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0538 ± 0.023 ms   | 13.4 ± 2.2 μs      | 4 ± 1.8                    |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 11 ± 0.77 μs        | 4.07 ± 4.8 μs      | 2.71 ± 3.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.45 ± 0.026 ms     | 0.45 ± 0.012 ms    | 3.23 ± 0.11                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0345 ± 0.0011 ms  | 13.1 ± 2.7 μs      | 2.64 ± 0.54                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.368 ± 0.066 ms    | 0.0477 ± 0.024 ms  | 7.71 ± 4.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 21.5 ± 2.6 ms       | 3.08 ± 0.1 ms      | 6.98 ± 0.87                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.435 ± 0.037 ms    | 0.0671 ± 0.0027 ms | 6.49 ± 0.61                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 4.07 ± 0.41 μs      | 0.381 ± 0.081 μs   | 10.7 ± 2.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.52 ± 7.5 μs       | 4.83 ± 0.65 μs     | 1.77 ± 1.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 11.3 ± 0.96 μs      | 1.34 ± 0.24 μs     | 8.4 ± 1.7                  |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26 ± 8.6 μs         | 8.11 ± 4.9 μs      | 3.21 ± 2.2                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.43 ± 0.027 ms     | 0.549 ± 0.015 ms   | 2.61 ± 0.086               |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0699 ± 0.01 ms    | 14.6 ± 6.7 μs      | 4.79 ± 2.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.524 ± 0.062 ms    | 0.0699 ± 0.0081 ms | 7.49 ± 1.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0423 ± 0.0022 s   | 13.3 ± 0.27 ms     | 3.17 ± 0.18                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.564 ± 0.019 ms    | 0.11 ± 0.0071 ms   | 5.11 ± 0.37                |
| Convolution body/BLAS axpy per lag                                                 | 0.788 ± 0.0068 μs   | 0.727 ± 0.009 μs   | 1.09 ± 0.016               |
| Convolution body/native axpy per lag                                               | 0.423 ± 0.0074 μs   | 0.428 ± 0.0066 μs  | 0.99 ± 0.023               |
| Convolution body/package                                                           | 0.739 ± 0.0058 μs   | 0.324 ± 0.0067 μs  | 2.28 ± 0.051               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 12.3 ± 0.55 μs      | 7.51 ± 0.52 μs     | 1.63 ± 0.14                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.36 ± 0.29 μs      | 2.35 ± 1.4 μs      | 1.85 ± 1.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 3.95 ± 1.6 μs       | 3.69 ± 1.7 μs      | 1.07 ± 0.67                |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0327 ± 0.00091 ms | 15.7 ± 1.3 μs      | 2.09 ± 0.18                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.391 ± 0.21 μs     | 0.13 ± 0.1 μs      | 3.01 ± 2.8                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 4.28 ± 1.5 μs       | 2.71 ± 0.26 μs     | 1.58 ± 0.57                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0354 ± 0.0013 ms  | 24.7 ± 11 μs       | 1.43 ± 0.65                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.54 ± 0.076 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.137 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 25.3 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.066 ± 0.0018 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.688 ± 0.045 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 6.32 ± 4.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.893 ± 0.035 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.39 ± 3.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0347 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0346 ± 0.0044 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.043 ± 0.0013 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 4.94 ± 3.7 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 6.67 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.182 ± 0.012 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 15.1 ± 7.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 26 ± 3.4 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 20.5 ± 9.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.124 ± 0.0085 ms  |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0483 ± 0.0035 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.68 ± 0.027 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.0967 ± 0.0079 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.644 ± 0.05 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.7 ± 1.7 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 16.5 ± 8.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 23 ± 8.9 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 20 ± 4.5 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0449 ± 0.00059 s |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 31.5 ± 12 μs       |                            |
| time_to_load                                                                       | 0.19 ± 0.00065 s    | 0.247 ± 0.0015 s   | 0.768 ± 0.0053             |

|                                                                                    | v0.1.0                    | f51707ff10620a...         | v0.1.0 / f51707ff10620a... |
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

