# The docs pages' performance plot: one block of
# `benchmark/results/docs.csv`, the minimum time of each method on the
# forward run and each gradient backend. A page includes this file and
# calls `performance_plot(block)`, so the docs build times nothing itself.
module DocsPerformance

    using AlgebraOfGraphics, CairoMakie, DataFramesMeta
    using ComposableRecurrences: ComposableRecurrences
    using Markdown: Markdown

    export performance_plot, performance_table, slower_cases

    const RESULTS = joinpath(
        pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv"
    )

    const TARGETS = [
        "primal" => "Forward run", "ForwardDiff" => "ForwardDiff",
        "Mooncake reverse" => "Mooncake", "Enzyme reverse" => "Enzyme",
    ]

    # The results as a table of strings, or `nothing` when the file is absent.
    function read_results(file)
        isfile(file) || return nothing
        lines = readlines(file)
        header = Symbol.(split(first(lines), ','))
        rows = split.(lines[2:end], ',')
        return DataFrame(
            [h => String.(getindex.(rows, i)) for (i, h) in enumerate(header)]
        )
    end

    # The revision, whether the reverse backends ran with the package's rules,
    # and the methods a backend could not differentiate, one sentence a line.
    function caption(rows)
        revision = join(unique(rows.revision), ", ")
        reverse = ["Mooncake reverse", "Enzyme reverse"]
        rules = unique(@subset(rows, in.(:target, Ref(reverse))).rules)
        lines = [
            "Minimum times at revision $revision.",
            "The Mooncake and Enzyme bars run " *
                (rules == ["true"] ? "with" : "without") * " the package's rules.",
            "The forward run and ForwardDiff do not use them.",
        ]
        failed = @subset(rows, :status .== "error")
        if !isempty(failed)
            names = Dict(TARGETS)
            push!(
                lines, "No bar: " * join(unique(getindex.(Ref(names), failed.target)), ", ") *
                    " could not differentiate " * join(unique(failed.method), " or ") * "."
            )
        end
        return join(lines, '\n')
    end

    """
        performance_plot(block; size = nothing, file = RESULTS)

    Bars of the minimum time of each method of `block` in `file`, on the
    forward run and each gradient backend, on a log scale.
    `size` picks one of the block's sizes, such as `"T200_L20_S3"`; the last
    one in the file by default.
    """
    function performance_plot(block; size = nothing, file = RESULTS)
        bench = read_results(file)
        bench === nothing && return Markdown.parse(
            "The benchmark results are not available in this build."
        )
        rows = @subset(bench, :block .== block)
        isempty(rows) && throw(ArgumentError("no block $(repr(block)) in $file"))
        rows = @subset(rows, :size .== something(size, last(rows.size)))
        methods = unique(rows.method)
        timed = @chain rows begin
            @subset(:status .== "ok", in.(:target, Ref(first.(TARGETS))))
            @transform(:min_us = parse.(Float64, :min_us))
        end
        # The decade at or below half the shortest bar, so every bar shows.
        floor_us = 10.0^floor(log10(minimum(timed.min_us) / 2))
        fg = @chain timed begin
            data(_) * mapping(
                :target => renamer(TARGETS...) => "",
                :min_us => "Minimum time (μs)",
                color = :method => sorter(methods...) => "",
                dodge = :method => sorter(methods...) => "",
            ) * visual(BarPlot, fillto = floor_us)
            draw(
                _; axis = (yscale = log10,), figure = (size = (800, 460),),
                legend = (position = :bottom,)
            )
        end
        Label(
            fg.figure[end + 1, :], caption(rows); tellwidth = false, fontsize = 12
        )
        return fg
    end

    # The method a block's package time is compared with: its hand loop, or
    # its first hand-loop variant, or `nothing` for a block without one.
    function reference_method(methods)
        "hand loop" in methods && return "hand loop"
        i = findfirst(m -> startswith(m, "hand loop"), methods)
        return i === nothing ? nothing : methods[i]
    end

    # The minimum time of `method` on `target` in `rows`, or `nothing`.
    function min_time(rows, method, target)
        hit = @subset(rows, :method .== method, :target .== target, :status .== "ok")
        return isempty(hit) ? nothing : parse(Float64, only(hit.min_us))
    end

    # `ref / pkg` as a speed-up, or a dash when either time is missing.
    function speedup(rows, ref, target)
        pkg = min_time(rows, "ComposableRecurrences", target)
        other = min_time(rows, ref, target)
        (pkg === nothing || other === nothing) && return "–"
        return string(round(other / pkg; digits = 1), "×")
    end

    """
        performance_table(; reference = :hand_loop, file = RESULTS)

    A table of how many times faster the package is than hand-written code,
    one row per block of `file` at its largest size, naming its matrix case,
    and one column per target:
    the reference method's minimum time over the package's.
    Above 1 the package is faster; below 1 it is slower.
    `reference = :hand_loop` compares with each block's hand loop,
    differentiated by the same backend; `reference = :hand_rules` compares
    with the hand loop given hand-written Mooncake rules, in the blocks that
    have them.
    """
    function performance_table(; reference = :hand_loop, file = RESULTS)
        bench = read_results(file)
        bench === nothing && return Markdown.parse(
            "The benchmark results are not available in this build."
        )
        targets = reference === :hand_rules ? TARGETS[3:3] : TARGETS
        cased = hasproperty(bench, :case)
        header = "| Block | " * (cased ? "Case | " : "") * "Size | " *
            join(last.(targets), " | ") * " |"
        lines = [
            header,
            "|:--|" * (cased ? ":--|" : "") * ":--|" * repeat("--:|", length(targets)),
        ]
        for block in unique(bench.block)
            rows = @subset(bench, :block .== block)
            rows = @subset(rows, :size .== last(rows.size))
            methods = unique(rows.method)
            ref = reference === :hand_rules ?
                ("hand rules" in methods ? "hand rules" : nothing) :
                reference_method(methods)
            (ref === nothing || !("ComposableRecurrences" in methods)) && continue
            cells = [speedup(rows, ref, first(t)) for t in targets]
            case = cased ?
                "`" * first(@subset(rows, :method .== "ComposableRecurrences").case) * "` | " : ""
            push!(
                lines, "| $block | $case`$(first(rows.size))` | " *
                    join(cells, " | ") * " |"
            )
        end
        push!(lines, "", "Minimum times at revision $(join(unique(bench.revision), ", ")).")
        return Markdown.parse(join(lines, '\n'))
    end

    # `x` to two decimal places, keeping a trailing zero.
    function two_places(x)
        s = string(round(x; digits = 2))
        return length(last(split(s, '.'))) == 1 ? s * "0" : s
    end

    """
        slower_cases(; file = RESULTS)

    One line per target listing the blocks where the package is slower than
    the block's hand loop, below 1 at two decimal places, with the speed-up
    as in `performance_table`, or saying there are none.
    """
    function slower_cases(; file = RESULTS)
        bench = read_results(file)
        bench === nothing && return Markdown.parse(
            "The benchmark results are not available in this build."
        )
        lines = String[]
        for (target, label) in TARGETS
            slow = String[]
            for block in unique(bench.block)
                rows = @subset(bench, :block .== block)
                rows = @subset(rows, :size .== last(rows.size))
                methods = unique(rows.method)
                ref = reference_method(methods)
                (ref === nothing || !("ComposableRecurrences" in methods)) && continue
                pkg = min_time(rows, "ComposableRecurrences", target)
                other = min_time(rows, ref, target)
                # Below 1 at two decimal places, as the table rounds.
                (pkg === nothing || other === nothing) && continue
                round(other / pkg; digits = 2) < 1 || continue
                push!(slow, "$block ($(two_places(other / pkg))×)")
            end
            push!(
                lines, "- **$label**: " *
                    (isempty(slow) ? "never slower." : join(slow, ", ") * ".")
            )
        end
        return Markdown.parse(join(lines, '\n'))
    end

end # module DocsPerformance

using .DocsPerformance: performance_plot, performance_table, slower_cases
