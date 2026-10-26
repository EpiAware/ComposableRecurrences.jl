# The docs pages' performance plot: one block of
# `benchmark/results/docs.csv`, the minimum time of each method on the
# forward run and each gradient backend. A page includes this file and
# calls `performance_plot(block)`, so the docs build times nothing itself.
module DocsPerformance

    using AlgebraOfGraphics, CairoMakie, DataFramesMeta
    using ComposableRecurrences: ComposableRecurrences
    using Markdown: Markdown

    export performance_plot

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
    # and the methods a backend could not differentiate.
    function caption(rows)
        revision = join(unique(rows.revision), ", ")
        reverse = ["Mooncake reverse", "Enzyme reverse"]
        rules = unique(@subset(rows, in.(:target, Ref(reverse))).rules)
        text = "Minimum times at revision $revision. " *
            "The Mooncake and Enzyme bars run " *
            (rules == ["true"] ? "with" : "without") * " the package's rules. " *
            "The forward run and ForwardDiff do not use them."
        failed = @subset(rows, :status .== "error")
        isempty(failed) && return text
        return text * "\nNo bar: " * join(unique(failed.target), ", ") *
            " could not differentiate " * join(unique(failed.method), " or ") * "."
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
        floor_us = 10.0^floor(log10(minimum(timed.min_us)))
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

end # module DocsPerformance

using .DocsPerformance: performance_plot
