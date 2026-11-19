|                                                                                    | v0.1.0              | 70f6e66488740b...  | v0.1.0 / 70f6e66488740b... |
|:-----------------------------------------------------------------------------------|:-------------------:|:------------------:|:--------------------------:|
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Enzyme reverse                    | 0.093 ± 0.015 ms    | 30.3 ± 8.9 μs      | 3.07 ± 1                   |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/ForwardDiff                       | 2.63 ± 0.029 ms     | 0.837 ± 0.015 ms   | 3.14 ± 0.068               |
| AD gradients/Matrix bvd_renewal_call T200_L20_S1/Mooncake reverse                  | 0.142 ± 0.015 ms    | 0.0429 ± 0.011 ms  | 3.3 ± 0.92                 |
| AD gradients/Matrix conv_fixed T200_L20_S1/Enzyme reverse                          | 17.2 ± 7.8 μs       | 3.4 ± 4.4 μs       | 5.05 ± 7                   |
| AD gradients/Matrix conv_fixed T200_L20_S1/ForwardDiff                             | 0.358 ± 0.024 ms    | 0.273 ± 0.013 ms   | 1.31 ± 0.11                |
| AD gradients/Matrix conv_fixed T200_L20_S1/Mooncake reverse                        | 0.0597 ± 0.0061 ms  | 14.1 ± 2 μs        | 4.25 ± 0.75                |
| AD gradients/Matrix delay_fixed T200_L20_S1/Enzyme reverse                         | 16.4 ± 6.7 μs       | 3.74 ± 5.5 μs      | 4.39 ± 6.7                 |
| AD gradients/Matrix delay_fixed T200_L20_S1/ForwardDiff                            | 0.383 ± 0.02 ms     | 0.339 ± 0.011 ms   | 1.13 ± 0.068               |
| AD gradients/Matrix delay_fixed T200_L20_S1/Mooncake reverse                       | 0.0597 ± 0.022 ms   | 14.4 ± 2.8 μs      | 4.15 ± 1.7                 |
| AD gradients/Matrix overview T200_L20_S3/Enzyme reverse                            | 0.519 ± 0.064 ms    | 0.0579 ± 0.024 ms  | 8.96 ± 3.9                 |
| AD gradients/Matrix overview T200_L20_S3/ForwardDiff                               | 11 ± 1.3 ms         | 3.31 ± 0.082 ms    | 3.33 ± 0.4                 |
| AD gradients/Matrix overview T200_L20_S3/Mooncake reverse                          | 0.553 ± 0.039 ms    | 0.083 ± 0.0021 ms  | 6.67 ± 0.49                |
| AD gradients/Matrix random_walk T30_L1_S1/Enzyme reverse                           | 5.42 ± 0.33 μs      | 0.411 ± 0.05 μs    | 13.2 ± 1.8                 |
| AD gradients/Matrix random_walk T30_L1_S1/ForwardDiff                              | 5.92 ± 0.59 μs      | 3.31 ± 0.52 μs     | 1.79 ± 0.33                |
| AD gradients/Matrix random_walk T30_L1_S1/Mooncake reverse                         | 13.9 ± 1.1 μs       | 1.54 ± 0.12 μs     | 8.99 ± 1                   |
| AD gradients/Matrix renewal T200_L20_S1/Enzyme reverse                             | 0.0409 ± 0.011 ms   | 14.3 ± 6.5 μs      | 2.87 ± 1.5                 |
| AD gradients/Matrix renewal T200_L20_S1/ForwardDiff                                | 2 ± 0.031 ms        | 0.365 ± 0.011 ms   | 5.48 ± 0.18                |
| AD gradients/Matrix renewal T200_L20_S1/Mooncake reverse                           | 0.0869 ± 0.024 ms   | 18.3 ± 7 μs        | 4.75 ± 2.3                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/Enzyme reverse                       | 0.666 ± 0.1 ms      | 0.0801 ± 0.04 ms   | 8.31 ± 4.4                 |
| AD gradients/Matrix strata_mixing T200_L20_S5/ForwardDiff                          | 0.0549 ± 0.0028 s   | 12.1 ± 0.19 ms     | 4.53 ± 0.24                |
| AD gradients/Matrix strata_mixing T200_L20_S5/Mooncake reverse                     | 0.728 ± 0.036 ms    | 0.134 ± 0.0082 ms  | 5.42 ± 0.42                |
| Convolution body/BLAS axpy per lag                                                 | 0.806 ± 0.006 μs    | 0.777 ± 0.008 μs   | 1.04 ± 0.013               |
| Convolution body/native axpy per lag                                               | 0.53 ± 0.0058 μs    | 0.494 ± 0.005 μs   | 1.07 ± 0.016               |
| Convolution body/package                                                           | 0.806 ± 0.0066 μs   | 0.353 ± 0.0046 μs  | 2.29 ± 0.035               |
| Evaluation/Matrix bvd_renewal_call T200_L20_S1                                     | 14 ± 2.9 μs         | 9.01 ± 3.2 μs      | 1.56 ± 0.64                |
| Evaluation/Matrix conv_fixed T200_L20_S1                                           | 4.23 ± 2.8 μs       | 0.901 ± 0.34 μs    | 4.69 ± 3.6                 |
| Evaluation/Matrix delay_fixed T200_L20_S1                                          | 4.21 ± 1.6 μs       | 1.41 ± 2.7 μs      | 2.98 ± 5.8                 |
| Evaluation/Matrix overview T200_L20_S3                                             | 0.0395 ± 0.00076 ms | 19.5 ± 0.78 μs     | 2.03 ± 0.09                |
| Evaluation/Matrix random_walk T30_L1_S1                                            | 0.541 ± 0.13 μs     | 0.18 ± 0.05 μs     | 3.01 ± 1.1                 |
| Evaluation/Matrix renewal T200_L20_S1                                              | 7.48 ± 2.7 μs       | 3.69 ± 0.18 μs     | 2.03 ± 0.74                |
| Evaluation/Matrix strata_mixing T200_L20_S5                                        | 0.047 ± 0.00071 ms  | 31 ± 1 μs          | 1.51 ± 0.054               |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/ForwardDiff                       |                     | 1.68 ± 0.45 ms     |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Mooncake reverse                         |                     | 0.17 ± 0.01 ms     |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Mooncake reverse         |                     | 27.1 ± 3.5 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Mooncake reverse                  |                     | 0.086 ± 0.0022 ms  |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/ForwardDiff        |                     | 0.622 ± 0.025 ms   |                            |
| Evaluation/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1                      |                     | 7.64 ± 4.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/ForwardDiff      |                     | 0.631 ± 0.036 ms   |                            |
| Evaluation/Matrix tv_piecewise_secondary_k5 T200_L20_S1                            |                     | 6.11 ± 1.8 μs      |                            |
| Evaluation/Matrix bvd_patch T200_L20_S5                                            |                     | 0.0459 ± 0.0094 ms |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Mooncake reverse   |                     | 0.039 ± 0.013 ms   |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S1/Enzyme reverse                    |                     | 0.0497 ± 0.0011 ms |                            |
| Evaluation/Matrix tv_piecewise_primary_k5 T200_L20_S1                              |                     | 6.47 ± 1.8 μs      |                            |
| Evaluation/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1                    |                     | 5.87 ± 4.3 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Mooncake reverse                  |                     | 0.23 ± 0.016 ms    |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/Enzyme reverse           |                     | 16 ± 6.5 μs        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Mooncake reverse           |                     | 28.5 ± 3.4 μs      |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Enzyme reverse   |                     | 22.6 ± 8.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/Enzyme reverse                    |                     | 0.15 ± 0.0096 ms   |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S5                                     |                     | 0.0595 ± 0.0016 ms |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/ForwardDiff                |                     | 0.574 ± 0.024 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/Enzyme reverse                           |                     | 0.118 ± 0.011 ms   |                            |
| AD gradients/Matrix tv_piecewise_secondary_k5 T200_L20_S1/ForwardDiff              |                     | 0.527 ± 0.041 ms   |                            |
| AD gradients/Matrix bvd_patch T200_L20_S5/ForwardDiff                              |                     | 15 ± 1.2 ms        |                            |
| AD gradients/Matrix tv_piecewise_primary_k5 T200_L20_S1/Enzyme reverse             |                     | 17 ± 9.2 μs        |                            |
| AD gradients/Matrix tv_piecewise_renewal_primary_k5 T200_L20_S1/Enzyme reverse     |                     | 26 ± 9 μs          |                            |
| Evaluation/Matrix bvd_patches_call T200_L20_S1                                     |                     | 23.1 ± 4.8 μs      |                            |
| AD gradients/Matrix bvd_patches_call T200_L20_S5/ForwardDiff                       |                     | 0.0483 ± 0.0013 s  |                            |
| AD gradients/Matrix tv_piecewise_renewal_secondary_k5 T200_L20_S1/Mooncake reverse |                     | 0.0367 ± 0.013 ms  |                            |
| time_to_load                                                                       | 0.241 ± 0.0017 s    | 0.31 ± 0.0057 s    | 0.775 ± 0.015              |

|                                                                                    | v0.1.0                    | 70f6e66488740b...         | v0.1.0 / 70f6e66488740b... |
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

