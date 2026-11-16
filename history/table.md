|                                                                                    | v0.1.0             | 1f2360c0cea0d3...  | v0.1.0 / 1f2360c0cea0d3... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0692 ± 0.0087 ms | 19.7 ± 2.1 μs      | 3.51 ± 0.58                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.6 ± 0.082 ms     | 0.614 ± 0.048 ms   | 4.24 ± 0.35                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.148 ± 0.019 ms   | 28.2 ± 6.7 μs      | 5.26 ± 1.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 13.6 ± 5.2 μs      | 2.45 ± 2.7 μs      | 5.53 ± 6.4                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.74 ± 0.049 ms    | 0.22 ± 0.03 ms     | 3.36 ± 0.51                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0484 ± 0.014 ms  | 10.8 ± 1.5 μs      | 4.48 ± 1.5                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 9.71 ± 0.8 μs      | 3.8 ± 3.5 μs       | 2.55 ± 2.4                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.867 ± 0.076 ms   | 0.257 ± 0.022 ms   | 3.38 ± 0.41                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.073 ± 0.0022 ms  | 9.93 ± 1.7 μs      | 7.35 ± 1.3                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.333 ± 0.045 ms   | 0.0382 ± 0.016 ms  | 8.72 ± 3.8                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 12.8 ± 1 ms        | 2.45 ± 1.5 ms      | 5.22 ± 3.3                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.49 ± 0.042 ms    | 0.0552 ± 0.0018 ms | 8.86 ± 0.81                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 8.88 ± 0.59 μs     | 0.34 ± 0.079 μs    | 26.1 ± 6.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 4.71 ± 5.3 μs      | 2.34 ± 0.92 μs     | 2.02 ± 2.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 0.0353 ± 0.0021 ms | 1.04 ± 0.11 μs     | 34 ± 4.2                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 26.9 ± 5.9 μs      | 9.79 ± 4.3 μs      | 2.75 ± 1.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.51 ± 0.033 ms    | 0.273 ± 0.025 ms   | 5.53 ± 0.53                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0648 ± 0.011 ms  | 16.6 ± 4 μs        | 3.91 ± 1.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.502 ± 0.071 ms   | 0.0539 ± 0.026 ms  | 9.31 ± 4.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0437 ± 0.002 s   | 10.5 ± 0.14 ms     | 4.17 ± 0.2                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.634 ± 0.038 ms   | 0.09 ± 0.0064 ms   | 7.04 ± 0.65                |
| Convolution body/BLAS axpy per lag                                                 | 0.503 ± 0.012 μs   | 0.406 ± 0.0053 μs  | 1.24 ± 0.034               |
| Convolution body/native axpy per lag                                               | 0.409 ± 0.0003 μs  | 0.409 ± 0.00027 μs | 1 ± 0.00099                |
| Convolution body/package                                                           | 0.503 ± 0.012 μs   | 0.327 ± 0.01 μs    | 1.54 ± 0.06                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 10.5 ± 0.4 μs      | 6.65 ± 0.16 μs     | 1.59 ± 0.071               |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.81 ± 0.35 μs     | 1.6 ± 0.34 μs      | 1.76 ± 0.44                |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.27 ± 0.92 μs     | 2.47 ± 1.2 μs      | 0.514 ± 0.44               |
| Evaluation/Matrix overview T200_L20_S3                                             | 23 ± 0.72 μs       | 14.7 ± 0.36 μs     | 1.56 ± 0.062               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.374 ± 0.15 μs    | 0.129 ± 0.013 μs   | 2.9 ± 1.2                  |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.22 ± 1.2 μs      | 2.41 ± 0.28 μs     | 2.17 ± 0.58                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0319 ± 0.0011 ms | 20 ± 1.2 μs        | 1.59 ± 0.11                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.07 ± 0.14 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.109 ± 0.015 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 19.4 ± 2.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0487 ± 0.0016 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.48 ± 0.049 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.19 ± 0.34 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.475 ± 0.046 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.16 ± 2.5 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 29.1 ± 1.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 27.2 ± 2.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 31.4 ± 1.5 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 3.43 ± 2.6 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 5.19 ± 2.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.145 ± 0.02 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 11.5 ± 3.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 20 ± 2.3 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.7 ± 5.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0959 ± 0.01 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.038 ± 0.0013 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.454 ± 0.12 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0745 ± 0.0058 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.439 ± 0.12 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.2 ± 0.18 ms     |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 11.9 ± 5 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 17.2 ± 6 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14.1 ± 3.4 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0363 ± 0.0015 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 25.4 ± 7.1 μs      |                            |
| time_to_load                                                                       | 0.18 ± 0.0012 s    | 0.192 ± 0.0011 s   | 0.938 ± 0.0084             |

|                                                                                    | v0.1.0                    | 1f2360c0cea0d3...         | v0.1.0 / 1f2360c0cea0d3... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 13.9 kB       | 1.85                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.039 k allocs: 18.6 kB   | 3.42                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.08 k allocs: 0.073 MB   | 3.22                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.083 k allocs: 0.0696 MB | 5.07                       |
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

