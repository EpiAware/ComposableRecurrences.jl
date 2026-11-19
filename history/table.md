|                                                                                    | v0.1.0              | 25774001ee9057...   | v0.1.0 / 25774001ee9057... |
|:-----------------------------------------------------------------------------------|:-------------------:|:-------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.0963 ± 0.016 ms   | 30.7 ± 8.9 μs       | 3.14 ± 1.1                 |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.57 ± 0.024 ms     | 0.831 ± 0.018 ms    | 3.1 ± 0.074                |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.142 ± 0.017 ms    | 0.0425 ± 0.011 ms   | 3.33 ± 0.97                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.5 ± 7.4 μs       | 5.5 ± 4.6 μs        | 3.18 ± 3                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.37 ± 0.022 ms     | 0.267 ± 0.018 ms    | 1.39 ± 0.13                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0601 ± 0.023 ms   | 14.3 ± 2.1 μs       | 4.2 ± 1.7                  |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 17.1 ± 6.8 μs       | 7.24 ± 5.7 μs       | 2.36 ± 2.1                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.391 ± 0.023 ms    | 0.33 ± 0.012 ms     | 1.19 ± 0.084               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0594 ± 0.023 ms   | 14.2 ± 2.9 μs       | 4.18 ± 1.8                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.533 ± 0.064 ms    | 0.0578 ± 0.011 ms   | 9.23 ± 2.1                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11.1 ± 1.3 ms       | 3.27 ± 0.27 ms      | 3.39 ± 0.48                |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.546 ± 0.037 ms    | 0.0832 ± 0.0019 ms  | 6.56 ± 0.47                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.37 ± 0.32 μs      | 0.431 ± 0.04 μs     | 12.5 ± 1.4                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.83 ± 0.77 μs      | 3.29 ± 0.8 μs       | 1.77 ± 0.49                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.7 ± 1.3 μs       | 1.55 ± 0.12 μs      | 8.83 ± 1.1                 |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0412 ± 0.011 ms   | 14.4 ± 6.8 μs       | 2.86 ± 1.6                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2.08 ± 0.036 ms     | 0.362 ± 0.011 ms    | 5.74 ± 0.2                 |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0845 ± 0.025 ms   | 22.1 ± 7.4 μs       | 3.82 ± 1.7                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.669 ± 0.093 ms    | 0.0803 ± 0.017 ms   | 8.33 ± 2.1                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.056 ± 0.0042 s    | 13.3 ± 2.7 ms       | 4.22 ± 0.91                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.721 ± 0.021 ms    | 0.135 ± 0.0069 ms   | 5.35 ± 0.32                |
| Convolution body/BLAS axpy per lag                                                 | 0.784 ± 0.0046 μs   | 0.796 ± 0.0087 μs   | 0.985 ± 0.012              |
| Convolution body/native axpy per lag                                               | 0.504 ± 0.0047 μs   | 0.505 ± 0.0062 μs   | 0.998 ± 0.015              |
| Convolution body/package                                                           | 0.785 ± 0.0061 μs   | 0.338 ± 0.006 μs    | 2.32 ± 0.045               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14 ± 0.36 μs        | 9.15 ± 3 μs         | 1.53 ± 0.51                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.38 ± 0.24 μs      | 0.882 ± 1.6 μs      | 4.96 ± 8.8                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.3 ± 1.6 μs        | 2.51 ± 2.8 μs       | 1.71 ± 2                   |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0393 ± 0.00079 ms | 19.5 ± 0.83 μs      | 2.02 ± 0.095               |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.561 ± 0.13 μs     | 0.18 ± 0.02 μs      | 3.12 ± 0.81                |
| Evaluation/Matrix renewal T200_L20_S1                                              | 5.97 ± 2.1 μs       | 3.67 ± 0.21 μs      | 1.63 ± 0.59                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.0469 ± 0.00085 ms | 31.3 ± 1.5 μs       | 1.5 ± 0.078                |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.67 ± 0.87 ms      |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.171 ± 0.0045 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.9 ± 3.5 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.0862 ± 0.0024 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.615 ± 0.022 ms    |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.59 ± 4.5 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.611 ± 0.023 ms    |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 5.86 ± 1.8 μs       |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0454 ± 0.0024 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.0391 ± 0.013 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0489 ± 0.00099 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 5.81 ± 3.7 μs       |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.78 ± 4.4 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.226 ± 0.012 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 15.2 ± 7.9 μs       |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.8 ± 3.6 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 23.2 ± 5.2 μs       |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.149 ± 0.009 ms    |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0596 ± 0.0014 ms  |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.527 ± 0.047 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.116 ± 0.0024 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.515 ± 0.045 ms    |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 26 ± 13 ms          |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 16.6 ± 7.7 μs       |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 26 ± 8.9 μs         |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.2 ± 5 μs         |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0473 ± 0.0015 s   |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0367 ± 0.014 ms   |                            |
| time_to_load                                                                       | 0.239 ± 0.002 s     | 0.305 ± 0.0017 s    | 0.784 ± 0.0079             |

|                                                                                    | v0.1.0                    | 25774001ee9057...         | v0.1.0 / 25774001ee9057... |
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

