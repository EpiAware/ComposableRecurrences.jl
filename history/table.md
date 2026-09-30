|                                                             | fbbf250129d495... |
|:------------------------------------------------------------|:-----------------:|
| AD gradients/placeholder sum_squares/Enzyme forward         | 0.0947 ± 0.017 μs |
| AD gradients/placeholder sum_squares/Enzyme reverse         | 22.3 ± 18 ns      |
| AD gradients/placeholder sum_squares/ForwardDiff            | 0.0326 ± 0.016 μs |
| AD gradients/placeholder sum_squares/Mooncake forward       | 0.199 ± 0.018 μs  |
| AD gradients/placeholder sum_squares/Mooncake reverse       | 0.0469 ± 0.024 μs |
| AD gradients/placeholder sum_squares/ReverseDiff (compiled) | 0.0689 ± 0.022 μs |
| AD gradients/placeholder sum_squares/ReverseDiff (tape)     | 0.49 ± 0.042 μs   |
| time_to_load                                                | 23.3 ± 0.38 ms    |

|                                                             | fbbf250129d495...       |
|:------------------------------------------------------------|:-----------------------:|
| AD gradients/placeholder sum_squares/Enzyme forward         | 3  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/Enzyme reverse         | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ForwardDiff            | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/Mooncake forward       | 16  allocs: 0.469 kB    |
| AD gradients/placeholder sum_squares/Mooncake reverse       | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ReverseDiff (compiled) | 2  allocs: 0.0781 kB    |
| AD gradients/placeholder sum_squares/ReverseDiff (tape)     | 16  allocs: 0.578 kB    |
| time_to_load                                                | 0.196 k allocs: 11.6 kB |

