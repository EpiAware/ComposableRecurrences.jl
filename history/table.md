|                                                             | 577c3b9eecf6fe... |
|:------------------------------------------------------------|:-----------------:|
| AD gradients/placeholder sum_squares/Enzyme forward         | 0.111 ± 0.0067 μs |
| AD gradients/placeholder sum_squares/Enzyme reverse         | 19.1 ± 26 ns      |
| AD gradients/placeholder sum_squares/ForwardDiff            | 20.8 ± 16 ns      |
| AD gradients/placeholder sum_squares/Mooncake forward       | 0.24 ± 0.0082 μs  |
| AD gradients/placeholder sum_squares/Mooncake reverse       | 0.042 ± 0.027 μs  |
| AD gradients/placeholder sum_squares/ReverseDiff (compiled) | 0.109 ± 0.027 μs  |
| AD gradients/placeholder sum_squares/ReverseDiff (tape)     | 0.572 ± 0.015 μs  |
| time_to_load                                                | 26 ± 0.37 ms      |

|                                                             | 577c3b9eecf6fe...       |
|:------------------------------------------------------------|:-----------------------:|
| AD gradients/placeholder sum_squares/Enzyme forward         | 3  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/Enzyme reverse         | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ForwardDiff            | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/Mooncake forward       | 16  allocs: 0.469 kB    |
| AD gradients/placeholder sum_squares/Mooncake reverse       | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ReverseDiff (compiled) | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ReverseDiff (tape)     | 16  allocs: 0.578 kB    |
| time_to_load                                                | 0.196 k allocs: 11.6 kB |

