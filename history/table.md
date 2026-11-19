|                                                                                    | v0.1.0              | 5b39d6fda27b35...  | v0.1.0 / 5b39d6fda27b35... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0946 ± 0.016 ms   | 30.7 ± 9.3 μs      | 3.08 ± 1.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.64 ± 0.027 ms     | 0.84 ± 0.015 ms    | 3.15 ± 0.066               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.142 ± 0.016 ms    | 0.0429 ± 0.011 ms  | 3.3 ± 0.96                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.8 ± 4.6 μs       | 6.99 ± 5.5 μs      | 2.54 ± 2.1                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.387 ± 0.028 ms    | 0.27 ± 0.014 ms    | 1.43 ± 0.13                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0605 ± 0.022 ms   | 14.2 ± 2 μs        | 4.26 ± 1.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 15.3 ± 6.8 μs       | 7.37 ± 5.6 μs      | 2.08 ± 1.8                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.401 ± 0.024 ms    | 0.337 ± 0.01 ms    | 1.19 ± 0.08                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.06 ± 0.023 ms     | 14 ± 2.9 μs        | 4.28 ± 1.9                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.528 ± 0.069 ms    | 0.0586 ± 0.013 ms  | 9.01 ± 2.3                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.2 ± 1.5 ms       | 3.29 ± 0.25 ms     | 3.41 ± 0.51                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.563 ± 0.038 ms    | 0.083 ± 0.0021 ms  | 6.78 ± 0.49                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.39 ± 0.31 μs      | 0.411 ± 0.039 μs   | 13.1 ± 1.5                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.91 ± 0.68 μs      | 3.25 ± 0.61 μs     | 1.82 ± 0.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.4 ± 0.88 μs      | 1.46 ± 0.13 μs     | 9.18 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0408 ± 0.011 ms   | 14.3 ± 7 μs        | 2.86 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.02 ± 0.038 ms     | 0.365 ± 0.012 ms   | 5.52 ± 0.21                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0882 ± 0.016 ms   | 21.2 ± 7.1 μs      | 4.15 ± 1.6                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.664 ± 0.099 ms    | 0.0812 ± 0.042 ms  | 8.18 ± 4.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0554 ± 0.0038 s   | 12.2 ± 0.24 ms     | 4.53 ± 0.32                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.718 ± 0.023 ms    | 0.135 ± 0.0082 ms  | 5.33 ± 0.36                |
| Convolution body/BLAS axpy per lag                                                 | 0.776 ± 0.0033 μs   | 0.782 ± 0.0084 μs  | 0.992 ± 0.011              |
| Convolution body/native axpy per lag                                               | 0.491 ± 0.0054 μs   | 0.501 ± 0.0064 μs  | 0.98 ± 0.017               |
| Convolution body/package                                                           | 0.776 ± 0.0026 μs   | 0.343 ± 0.012 μs   | 2.26 ± 0.082               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14.1 ± 3.3 μs       | 9.15 ± 3.1 μs      | 1.54 ± 0.64                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.36 ± 3.1 μs       | 2.36 ± 0.48 μs     | 1.84 ± 1.3                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.29 ± 1.7 μs       | 2.79 ± 1.7 μs      | 1.53 ± 1.1                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0397 ± 0.00083 ms | 19.3 ± 1 μs        | 2.06 ± 0.12                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.541 ± 0.15 μs     | 0.18 ± 0.031 μs    | 3.01 ± 0.99                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.98 ± 2.2 μs       | 3.76 ± 0.44 μs     | 1.59 ± 0.61                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.047 ± 0.00082 ms  | 31.2 ± 1.3 μs      | 1.51 ± 0.067               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.67 ± 0.067 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.171 ± 0.0096 ms  |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.8 ± 3.7 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0853 ± 0.0022 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.621 ± 0.026 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.96 ± 4.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.622 ± 0.029 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 4.98 ± 4.1 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0458 ± 0.0025 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0391 ± 0.013 ms  |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.049 ± 0.0012 ms  |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.58 ± 4.1 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.9 ± 4.4 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.229 ± 0.013 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 15.6 ± 8.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.6 ± 3.8 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 22.6 ± 9.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.15 ± 0.01 ms     |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0598 ± 0.0017 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.539 ± 0.035 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.12 ± 0.0096 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.53 ± 0.04 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15.4 ± 1.5 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17.2 ± 7.5 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 26.5 ± 7.8 μs      |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.2 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0485 ± 0.0014 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0368 ± 0.014 ms  |                            |
| time_to_load                                                                       | 0.24 ± 0.0016 s     | 0.31 ± 0.0046 s    | 0.776 ± 0.013              |

|                                                                                    | v0.1.0                    | 5b39d6fda27b35...         | v0.1.0 / 5b39d6fda27b35... |
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

