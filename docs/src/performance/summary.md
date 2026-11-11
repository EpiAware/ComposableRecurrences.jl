# [Performance summary](@id performance-summary)

This page shows, for each documented example, how the package's runtime compares with the alternatives.
Each example is timed against up to three alternatives:

- the package with its rules turned off by `NoAdjoint`, so the backend differentiates the forward loop;
- a hand-written loop of the same model, differentiated by the same backend;
- for the case study's kernels, that loop with hand-written Mooncake rules.

Each cell is the other method's minimum time over the package's, at the example's largest size.
Above 1 the package is faster; below 1 it is slower.
The rules are reverse-mode adjoints, which the forward run and ForwardDiff never call, so those columns have no time without the rules.
Plain Enzyme on the spatial model has no time either: `benchmark/matrix.jl` skips it because it gives a wrong gradient on a repeated sparse `mul!`.

## Overview

The geometric mean is taken over the examples, and the counts give how many are slower than each alternative.

```@example summary
using ComposableRecurrences # hide
include(joinpath(pkgdir(ComposableRecurrences), "docs", "performance.jl")) # hide
performance_overview() # hide
```

The rules gain most on the reverse backends.
The forward run and ForwardDiff are near the hand loop's speed and slower than it on several examples, and Enzyme is slower on a few, which [issue #417](https://github.com/EpiAware/ComposableRecurrences.jl/issues/417) tracks.
[Against hand-written code](@ref benchmarks-hand-written) lists every example in one table and names the slower cases.

## By example

### Getting started

The model of [Getting started](@ref getting-started).

```@example summary
performance_summary("naive vs package") # hide
```

### Case study: renewal kernel

The renewal kernel of [Case study: a backend model](@ref tutorial-backend-case-study).

```@example summary
performance_summary("backend renewal") # hide
```

### Case study: patch kernel

The patch kernel of [Case study: a backend model](@ref tutorial-backend-case-study).

```@example summary
performance_summary("backend patches") # hide
```

### Case study: delay kernel

The delay kernel of [Case study: a backend model](@ref tutorial-backend-case-study).

```@example summary
performance_summary("backend delay") # hide
```

### Renewal then delay

The model of [Renewal then delay](@ref tutorial-renewal-delay).

```@example summary
performance_summary("renewal") # hide
```

### Vaccination

The model of [Vaccination](@ref tutorial-vaccination).

```@example summary
performance_summary("vaccination") # hide
```

### Imported cases

The model of [Imported cases](@ref tutorial-imports).

```@example summary
performance_summary("imports") # hide
```

### Clinical outcomes

The model of [Clinical outcomes](@ref tutorial-clinical-outcomes).

```@example summary
performance_summary("clinical outcomes") # hide
```

### Forecasting

The model of [Forecasting](@ref tutorial-forecasting).

```@example summary
performance_summary("forecasting") # hide
```

### Reproduction number

The model of [Reproduction number](@ref tutorial-reproduction-number).

```@example summary
performance_summary("reproduction number") # hide
```

### Spatial models

The model of [Spatial models](@ref tutorial-spatial-strata).

```@example summary
performance_summary("spatial strata") # hide
```

### Occupancy and capacity

The model of [Occupancy and capacity](@ref tutorial-occupancy).

```@example summary
performance_summary("occupancy") # hide
```

### Latent processes

The model of [Latent processes](@ref tutorial-latent-rt).

```@example summary
performance_summary("latent processes") # hide
```

### Time-varying delays

The model of [Time-varying delays](@ref tutorial-time-varying-kernels).

```@example summary
performance_summary("time-varying delays") # hide
```

### Branching processes

The model of [Branching processes](@ref tutorial-branching).

```@example summary
performance_summary("transform") # hide
```

## The data

The tables read `benchmark/results/docs.csv`, so the docs build times nothing.
Each example is a case in `test/ADFixtures/src/matrix_cases.jl`, timed at the docs tier, and `task -t benchmark/Taskfile.yml matrix-docs` regenerates the file.
