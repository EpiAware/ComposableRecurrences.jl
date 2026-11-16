|                                                                                    | v0.1.0             | e19854222900bf...  | v0.1.0 / e19854222900bf... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0605 ± 0.0083 ms | 19.8 ± 1.9 μs      | 3.06 ± 0.51                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 1.93 ± 0.097 ms    | 0.61 ± 0.057 ms    | 3.16 ± 0.34                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.0991 ± 0.017 ms  | 28.4 ± 2.1 μs      | 3.49 ± 0.64                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 12.8 ± 5.1 μs      | 5.63 ± 3.9 μs      | 2.27 ± 1.8                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.727 ± 0.03 ms    | 0.225 ± 0.033 ms   | 3.24 ± 0.49                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0421 ± 0.012 ms  | 11.9 ± 1.8 μs      | 3.55 ± 1.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 9.3 ± 1 μs         | 2.82 ± 3.4 μs      | 3.3 ± 4                    |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.861 ± 0.081 ms   | 0.278 ± 0.019 ms   | 3.1 ± 0.36                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 29.6 ± 1.1 μs      | 9.99 ± 1.8 μs      | 2.96 ± 0.53                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.318 ± 0.049 ms   | 0.0417 ± 0.012 ms  | 7.62 ± 2.5                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.7 ± 1.5 ms      | 2.45 ± 0.23 ms     | 4.79 ± 0.77                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.43 ± 0.037 ms    | 0.0589 ± 0.0018 ms | 7.3 ± 0.67                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 3.28 ± 0.42 μs     | 0.343 ± 0.076 μs   | 9.57 ± 2.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 4.44 ± 0.63 μs     | 2.35 ± 0.45 μs     | 1.89 ± 0.45                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 10 ± 1.1 μs        | 1.03 ± 0.068 μs    | 9.73 ± 1.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 27.4 ± 6.2 μs      | 9.79 ± 4.3 μs      | 2.8 ± 1.4                  |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.48 ± 0.036 ms    | 0.275 ± 0.02 ms    | 5.39 ± 0.41                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0597 ± 0.0089 ms | 16.5 ± 4.1 μs      | 3.61 ± 1                   |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.486 ± 0.096 ms   | 0.0543 ± 0.026 ms  | 8.95 ± 4.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0431 ± 0.0018 s  | 10.6 ± 1 ms        | 4.09 ± 0.43                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.541 ± 0.044 ms   | 0.0897 ± 0.0058 ms | 6.03 ± 0.63                |
| Convolution body/BLAS axpy per lag                                                 | 0.408 ± 0.0027 μs  | 0.549 ± 0.0033 μs  | 0.743 ± 0.0065             |
| Convolution body/native axpy per lag                                               | 0.409 ± 0.00016 μs | 0.409 ± 0.00025 μs | 1 ± 0.00073                |
| Convolution body/package                                                           | 0.407 ± 0.0051 μs  | 0.328 ± 0.0091 μs  | 1.24 ± 0.038               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 9.84 ± 0.26 μs     | 6.76 ± 1.8 μs      | 1.46 ± 0.39                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.84 ± 0.28 μs     | 1.21 ± 1.6 μs      | 2.35 ± 3.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.67 ± 1.1 μs      | 0.957 ± 0.74 μs    | 2.78 ± 2.5                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 22.7 ± 0.68 μs     | 16.5 ± 0.62 μs     | 1.37 ± 0.066               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.365 ± 0.14 μs    | 0.147 ± 0.039 μs   | 2.48 ± 1.2                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 3.46 ± 0.95 μs     | 2.37 ± 0.21 μs     | 1.46 ± 0.42                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0318 ± 0.0014 ms | 19.9 ± 0.88 μs     | 1.6 ± 0.098                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.05 ± 0.15 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.109 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 19.1 ± 2.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.049 ± 0.0016 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.48 ± 0.045 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 4.77 ± 2.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.47 ± 0.051 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.75 ± 1.1 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 28.9 ± 0.73 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 26.8 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 31.4 ± 1.4 μs      |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.18 ± 1.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 3.63 ± 2.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.147 ± 0.016 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 10.6 ± 4.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 19.7 ± 2.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 15.3 ± 5.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.0976 ± 0.01 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.038 ± 0.0016 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.452 ± 0.072 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.0748 ± 0.0069 ms |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.435 ± 0.13 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 11.2 ± 1.2 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 11.4 ± 5 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 17.4 ± 3.6 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 14.2 ± 3.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0357 ± 0.00039 s |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 25.7 ± 2.3 μs      |                            |
| time_to_load                                                                       | 0.178 ± 0.0011 s   | 0.193 ± 0.0015 s   | 0.923 ± 0.0092             |

|                                                                                    | v0.1.0                    | e19854222900bf...         | v0.1.0 / e19854222900bf... |
|:-----------------------------------------------------------------------------------|:-------------------------:|:-------------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.118 k allocs: 0.0363 MB | 0.05 k allocs: 26.3 kB    | 1.41                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 0.949 k allocs: 2.53 MB   | 0.465 k allocs: 2.03 MB   | 1.25                       |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 1.91 k allocs: 0.0821 MB  | 0.057 k allocs: 0.0325 MB | 2.53                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 0.046 k allocs: 25.8 kB   | 24  allocs: 18.5 kB       | 1.39                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.344 k allocs: 1.93 MB   | 0.23 k allocs: 1.18 MB    | 1.64                       |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.328 k allocs: 0.062 MB  | 0.034 k allocs: 24 kB     | 2.65                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 0.044 k allocs: 23.1 kB   | 22  allocs: 15.8 kB       | 1.46                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.302 k allocs: 1.68 MB   | 0.182 k allocs: 0.842 MB  | 1.99                       |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.328 k allocs: 0.0566 MB | 24  allocs: 15.9 kB       | 3.64                       |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 1.51 k allocs: 0.235 MB   | 0.084 k allocs: 0.0867 MB | 2.71                       |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 2.71 k allocs: 24.9 MB    | 1.05 k allocs: 9.33 MB    | 2.66                       |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 5.84 k allocs: 0.353 MB   | 0.081 k allocs: 0.0871 MB | 4.05                       |
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
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 12  allocs: 8.38 kB       | 12  allocs: 8.38 kB       | 1                          |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 10  allocs: 6.92 kB       | 10  allocs: 6.92 kB       | 1                          |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.052 k allocs: 0.0399 MB | 28  allocs: 29.7 kB       | 1.37                       |
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

