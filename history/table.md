|                                                                                    | v0.1.0             | 91bfe377ef35de...  | v0.1.0 / 91bfe377ef35de... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0847 ± 0.015 ms  | 29.3 ± 8.7 μs      | 2.89 ± 0.99                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.16 ± 0.046 ms    | 0.954 ± 0.02 ms    | 2.26 ± 0.068               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.13 ± 0.014 ms    | 0.0421 ± 0.011 ms  | 3.09 ± 0.9                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.7 ± 7.8 μs      | 6.1 ± 4.8 μs       | 2.9 ± 2.6                  |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 1.51 ± 0.033 ms    | 0.384 ± 0.014 ms   | 3.93 ± 0.17                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.062 ± 0.026 ms   | 14.7 ± 2.4 μs      | 4.22 ± 1.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 12.3 ± 0.91 μs     | 7.47 ± 5.3 μs      | 1.65 ± 1.2                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.67 ± 0.039 ms    | 0.499 ± 0.015 ms   | 3.35 ± 0.13                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0403 ± 0.016 ms  | 14.3 ± 2.8 μs      | 2.81 ± 1.2                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.435 ± 0.067 ms   | 0.0556 ± 0.011 ms  | 7.82 ± 2                   |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 24.6 ± 2.6 ms      | 3.69 ± 0.14 ms     | 6.66 ± 0.74                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.501 ± 0.043 ms   | 0.0782 ± 0.0029 ms | 6.41 ± 0.6                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.02 ± 0.44 μs     | 0.431 ± 0.11 μs    | 11.6 ± 3.1                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 8.89 ± 7 μs        | 5.61 ± 0.99 μs     | 1.59 ± 1.3                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 12.5 ± 0.74 μs     | 1.46 ± 0.28 μs     | 8.56 ± 1.7                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 29.2 ± 9.6 μs      | 9.08 ± 6 μs        | 3.22 ± 2.4                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 1.64 ± 0.034 ms    | 0.635 ± 0.024 ms   | 2.59 ± 0.11                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0795 ± 0.01 ms   | 16.4 ± 6 μs        | 4.86 ± 1.9                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.599 ± 0.04 ms    | 0.0797 ± 0.0077 ms | 7.51 ± 0.88                |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0488 ± 0.0028 s  | 15.3 ± 0.53 ms     | 3.19 ± 0.21                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.628 ± 0.026 ms   | 0.128 ± 0.007 ms   | 4.92 ± 0.34                |
| Convolution body/BLAS axpy per lag                                                 | 0.82 ± 0.015 μs    | 0.826 ± 0.018 μs   | 0.993 ± 0.028              |
| Convolution body/native axpy per lag                                               | 0.48 ± 0.0089 μs   | 0.502 ± 0.017 μs   | 0.957 ± 0.036              |
| Convolution body/package                                                           | 0.803 ± 0.014 μs   | 0.378 ± 0.0085 μs  | 2.12 ± 0.06                |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.3 ± 3.4 μs      | 8.57 ± 0.26 μs     | 1.66 ± 0.4                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.8 ± 0.4 μs       | 2.69 ± 1.7 μs      | 1.78 ± 1.1                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 2.04 ± 1.7 μs      | 4.31 ± 1.9 μs      | 0.474 ± 0.44               |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0371 ± 0.0011 ms | 19.8 ± 1.2 μs      | 1.87 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.421 ± 0.05 μs    | 0.16 ± 0.05 μs     | 2.63 ± 0.88                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.64 ± 1.9 μs      | 3.19 ± 0.26 μs     | 2.4 ± 0.62                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0404 ± 0.0012 ms | 27.6 ± 2.4 μs      | 1.47 ± 0.13                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 1.83 ± 0.08 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.159 ± 0.01 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 28.8 ± 3.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0753 ± 0.0026 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.79 ± 0.039 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 6.1 ± 0.78 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 1.03 ± 0.03 ms     |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 4.97 ± 4.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0408 ± 0.0036 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0394 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0462 ± 0.0016 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 5.52 ± 4.3 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 8.69 ± 3 μs        |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.211 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 16.9 ± 7.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 29.7 ± 4.1 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 23.4 ± 9.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.141 ± 0.011 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0547 ± 0.0024 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.716 ± 0.037 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.112 ± 0.0094 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.733 ± 0.025 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 18.4 ± 2.3 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 17.9 ± 8.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 26 ± 9.5 μs        |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 22.7 ± 5.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0535 ± 0.0017 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.038 ± 0.014 ms   |                            |
| time_to_load                                                                       | 0.221 ± 0.0026 s   | 0.291 ± 0.0049 s   | 0.757 ± 0.016              |

|                                                                                    | v0.1.0                    | 91bfe377ef35de...         | v0.1.0 / 91bfe377ef35de... |
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

