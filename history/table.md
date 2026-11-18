|                                                                                    | v0.1.0             | d3f2b9789b8878...  | v0.1.0 / d3f2b9789b8878... |
|:-----------------------------------------------------------------------------------|:------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.104 ± 0.015 ms   | 0.0359 ± 0.0084 ms | 2.89 ± 0.79                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.8 ± 0.066 ms     | 0.98 ± 0.053 ms    | 2.86 ± 0.17                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.164 ± 0.02 ms    | 0.0464 ± 0.0046 ms | 3.54 ± 0.56                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 23.9 ± 4.7 μs      | 7.67 ± 4.7 μs      | 3.12 ± 2                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.465 ± 0.077 ms   | 0.339 ± 0.036 ms   | 1.37 ± 0.27                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0696 ± 0.0074 ms | 16.8 ± 3.2 μs      | 4.14 ± 0.9                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 20.8 ± 5.1 μs      | 5.72 ± 5.4 μs      | 3.63 ± 3.6                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 1.26 ± 0.078 ms    | 0.384 ± 0.02 ms    | 3.27 ± 0.26                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0464 ± 0.021 ms  | 16.1 ± 3 μs        | 2.89 ± 1.4                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.584 ± 0.062 ms   | 0.0684 ± 0.025 ms  | 8.54 ± 3.2                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 14.4 ± 3.1 ms      | 4.19 ± 0.31 ms     | 3.44 ± 0.79                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.681 ± 0.073 ms   | 0.0921 ± 0.0061 ms | 7.4 ± 0.93                 |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 6.36 ± 0.78 μs     | 0.451 ± 0.13 μs    | 14.1 ± 4.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 9.02 ± 1.9 μs      | 6.27 ± 3.6 μs      | 1.44 ± 0.87                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 18.3 ± 4.5 μs      | 2.29 ± 0.85 μs     | 7.97 ± 3.6                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0428 ± 0.0072 ms | 14.8 ± 6.1 μs      | 2.89 ± 1.3                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.25 ± 0.054 ms    | 0.433 ± 0.038 ms   | 5.19 ± 0.48                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0953 ± 0.016 ms  | 21.7 ± 7.7 μs      | 4.39 ± 1.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.814 ± 0.059 ms   | 0.0959 ± 0.043 ms  | 8.49 ± 3.9                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0636 ± 0.0036 s  | 14.5 ± 0.86 ms     | 4.4 ± 0.36                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.789 ± 0.073 ms   | 0.148 ± 0.0093 ms  | 5.32 ± 0.59                |
| Convolution body/BLAS axpy per lag                                                 | 0.825 ± 0.025 μs   | 0.787 ± 0.021 μs   | 1.05 ± 0.042               |
| Convolution body/native axpy per lag                                               | 0.523 ± 0.01 μs    | 0.496 ± 0.01 μs    | 1.06 ± 0.03                |
| Convolution body/package                                                           | 0.827 ± 0.016 μs   | 0.362 ± 0.0074 μs  | 2.29 ± 0.065               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 17.7 ± 4 μs        | 10.2 ± 3.4 μs      | 1.73 ± 0.7                 |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 2.69 ± 3.3 μs      | 1.38 ± 1.8 μs      | 1.95 ± 3.5                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.86 ± 2.1 μs      | 1.97 ± 1.4 μs      | 2.46 ± 2.1                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0456 ± 0.0019 ms | 22.3 ± 2.1 μs      | 2.04 ± 0.21                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.701 ± 0.44 μs    | 0.24 ± 0.18 μs     | 2.92 ± 2.9                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 8.68 ± 3.4 μs      | 4.64 ± 0.8 μs      | 1.87 ± 0.8                 |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0535 ± 0.0027 ms | 0.0346 ± 0.0099 ms | 1.55 ± 0.45                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                    | 2 ± 0.17 ms        |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                    | 0.188 ± 0.016 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                    | 0.0333 ± 0.0056 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                    | 0.0994 ± 0.0071 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                    | 0.843 ± 0.067 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                    | 9.87 ± 5.3 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                    | 0.852 ± 0.096 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                    | 7.44 ± 3.2 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                    | 0.0506 ± 0.0073 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                    | 0.0464 ± 0.0073 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                    | 0.0596 ± 0.0058 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                    | 8.43 ± 2.4 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                    | 8.33 ± 4.9 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                    | 0.262 ± 0.015 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                    | 21.1 ± 7.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                    | 0.0347 ± 0.0055 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                    | 0.0319 ± 0.0097 ms |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                    | 0.177 ± 0.019 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                    | 0.0676 ± 0.0043 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                    | 0.795 ± 0.11 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                    | 0.135 ± 0.049 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                    | 0.819 ± 0.13 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                    | 15.9 ± 2.1 ms      |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                    | 22.2 ± 7.9 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                    | 0.0349 ± 0.0079 ms |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                    | 26.1 ± 3.2 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                    | 0.0668 ± 0.0086 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                    | 0.0438 ± 0.0075 ms |                            |
| time_to_load                                                                       | 0.264 ± 0.0032 s   | 0.344 ± 0.001 s    | 0.769 ± 0.0096             |

|                                                                                    | v0.1.0                    | d3f2b9789b8878...         | v0.1.0 / d3f2b9789b8878... |
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

