|                                                                                    | v0.1.0             | 59bde73334d1e1...  | v0.1.0 / 59bde73334d1e1... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0783 ± 0.011 ms  | 26.7 ± 5.8 μs      | 2.94 ± 0.75                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.71 ± 0.12 ms     | 0.844 ± 0.02 ms    | 3.22 ± 0.16                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.11 ± 0.016 ms    | 0.0349 ± 0.008 ms  | 3.14 ± 0.85                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 18.1 ± 4.7 μs      | 6.2 ± 4.1 μs       | 2.92 ± 2.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.2 ± 0.044 ms     | 0.338 ± 0.016 ms   | 3.53 ± 0.22                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0532 ± 0.016 ms  | 13 ± 2 μs          | 4.1 ± 1.4                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 16.2 ± 1.8 μs      | 5.15 ± 4.2 μs      | 3.14 ± 2.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.32 ± 0.046 ms    | 0.371 ± 0.022 ms   | 3.55 ± 0.24                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0403 ± 0.0015 ms | 13.2 ± 2.2 μs      | 3.04 ± 0.52                |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.467 ± 0.047 ms   | 0.0527 ± 0.0091 ms | 8.85 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 19.2 ± 3.2 ms      | 3.17 ± 0.13 ms     | 6.06 ± 1                   |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.513 ± 0.036 ms   | 0.0711 ± 0.0028 ms | 7.22 ± 0.58                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.37 ± 0.48 μs     | 0.676 ± 0.32 μs    | 7.95 ± 3.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 9.46 ± 3.9 μs      | 3.82 ± 0.42 μs     | 2.48 ± 1.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 12.6 ± 1.4 μs      | 1.52 ± 0.29 μs     | 8.32 ± 1.8                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0374 ± 0.0074 ms | 9.03 ± 5.2 μs      | 4.14 ± 2.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.11 ± 0.081 ms    | 0.418 ± 0.033 ms   | 5.05 ± 0.44                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0743 ± 0.0095 ms | 18.4 ± 5.5 μs      | 4.05 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.671 ± 0.03 ms    | 0.0767 ± 0.011 ms  | 8.75 ± 1.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.059 ± 0.0029 s   | 14.6 ± 0.34 ms     | 4.03 ± 0.22                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.654 ± 0.053 ms   | 0.111 ± 0.0067 ms  | 5.87 ± 0.59                |
| Convolution body/BLAS axpy per lag                                                 | 0.622 ± 0.011 μs   | 0.628 ± 0.011 μs   | 0.991 ± 0.025              |
| Convolution body/native axpy per lag                                               | 0.512 ± 0.001 μs   | 0.516 ± 0.0033 μs  | 0.992 ± 0.0067             |
| Convolution body/package                                                           | 0.623 ± 0.011 μs   | 0.367 ± 0.039 μs   | 1.7 ± 0.18                 |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 13.4 ± 2.5 μs      | 9.58 ± 2.3 μs      | 1.4 ± 0.42                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 3.51 ± 1.7 μs      | 2.08 ± 1.2 μs      | 1.68 ± 1.3                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 1.63 ± 0.77 μs     | 3.33 ± 1.5 μs      | 0.489 ± 0.32               |
| Evaluation/Matrix overview T200_L20_S3                                             | 30.6 ± 1.4 μs      | 19.5 ± 1.2 μs      | 1.57 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.432 ± 0.15 μs    | 0.152 ± 0.007 μs   | 2.84 ± 1                   |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.03 ± 1.7 μs      | 3.14 ± 0.32 μs     | 2.24 ± 0.58                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0432 ± 0.0019 ms | 28 ± 1.5 μs        | 1.54 ± 0.11                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.71 ± 0.15 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.139 ± 0.0086 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 24.9 ± 3.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0725 ± 0.0039 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.873 ± 0.057 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 5.66 ± 0.75 μs     |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.899 ± 0.071 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 3.83 ± 3.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0399 ± 0.0024 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0332 ± 0.0091 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.047 ± 0.0045 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 4.35 ± 3.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 6.92 ± 2.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.188 ± 0.018 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 16 ± 4.7 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 25.8 ± 3 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 21.2 ± 5.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.133 ± 0.012 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0532 ± 0.0033 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.802 ± 0.1 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.102 ± 0.0085 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.821 ± 0.052 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15.6 ± 2.2 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 16.4 ± 6.2 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 23.8 ± 5.8 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 20.4 ± 3.6 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0502 ± 0.0023 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 30.8 ± 9.4 μs      |                            |
| time_to_load                                                                       | 0.244 ± 0.0011 s   | 0.315 ± 0.0015 s   | 0.775 ± 0.0052             |

|                                                                                    | v0.1.0                    | 59bde73334d1e1...         | v0.1.0 / 59bde73334d1e1... |
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

