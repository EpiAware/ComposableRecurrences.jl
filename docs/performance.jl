# The docs pages' performance plot and tables, read from
# `benchmark/results/docs.csv`: the minimum time of each method on the
# forward run and each gradient backend. A page includes this file and
# calls `performance_plot(block)` or one of the tables, so the docs build
# times nothing itself.
module DocsPerformance

    using AlgebraOfGraphics, CairoMakie, DataFramesMeta
    using ComposableRecurrences: ComposableRecurrences
    using Markdown: Markdown

    export performance_plot, performance_table, slower_cases,
        performance_summary, performance_overview

    const RESULTS = joinpath(
        pkgdir(ComposableRecurrences), "benchmark", "results", "docs.csv"
    )

    const TARGETS = [
        "primal" => "Forward run", "ForwardDiff" => "ForwardDiff",
        "Mooncake reverse" => "Mooncake", "Enzyme reverse" => "Enzyme",
    ]

    # The method name of the package run with its rules turned off.
    const PLAIN_AD = "plain AD"

    # The targets that call the package's rules: a forward-mode `PLAIN_AD`
    # time would time the same code as the package's.
    const RULE_TARGETS = ["Mooncake reverse", "Enzyme reverse"]

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
        # Plain-AD rows are tabulated on the summary page, not drawn as bars.
        rows = @subset(rows, :method .!= PLAIN_AD)
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

    # The reference's minimum time over the package's on `target`, or
    # `nothing` when either time is missing.
    function ratio(rows, ref, target)
        pkg = min_time(rows, "ComposableRecurrences", target)
        other = min_time(rows, ref, target)
        return (pkg === nothing || other === nothing) ? nothing : other / pkg
    end

    # `x` as a speed-up to one decimal place, or a dash when missing.
    times(x) = x === nothing ? "–" : string(round(x; digits = 1), "×")

    # `ratio` as a speed-up to one decimal place, or a dash when missing.
    speedup(rows, ref, target) = times(ratio(rows, ref, target))

    # Whether the package is slower at `r`: below 1 at two decimal places,
    # one more than the tables show, so a case shown as 1.0× can count.
    is_slower(r) = round(r; digits = 2) < 1

    # `ratio`, or `nothing` for `PLAIN_AD` on a target that never calls the
    # rules.
    rule_ratio(rows, ref, target) =
        ref == PLAIN_AD && !(target in RULE_TARGETS) ? nothing :
        ratio(rows, ref, target)

    # A table's header and alignment lines: left-aligned `left` columns,
    # then right-aligned `right` columns.
    table_header(left, right) = [
        "| " * join(vcat(left, right), " | ") * " |",
        "|" * repeat(":--|", length(left)) * repeat("--:|", length(right)),
    ]

    # Each block of `bench` with a package row and a reference, as
    # `(block, rows, ref)`: its rows at its largest size, and its hand loop,
    # or its hand rules when `reference = :hand_rules`.
    function compared_blocks(bench, reference)
        blocks = Tuple{String, DataFrame, String}[]
        for block in unique(bench.block)
            rows = @subset(bench, :block .== block)
            rows = @subset(rows, :size .== last(rows.size))
            methods = unique(rows.method)
            ref = reference === :hand_rules ?
                ("hand rules" in methods ? "hand rules" : nothing) :
                reference_method(methods)
            (ref === nothing || !("ComposableRecurrences" in methods)) && continue
            push!(blocks, (block, rows, ref))
        end
        return blocks
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
        lines = table_header(
            cased ? ["Block", "Case", "Size"] : ["Block", "Size"], last.(targets)
        )
        for (block, rows, ref) in compared_blocks(bench, reference)
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
    the block's hand loop, below 1 at two decimal places (the table shows
    one), with the speed-up, or saying there are none.
    """
    function slower_cases(; file = RESULTS)
        bench = read_results(file)
        bench === nothing && return Markdown.parse(
            "The benchmark results are not available in this build."
        )
        lines = String[]
        for (target, label) in TARGETS
            slow = String[]
            for (block, rows, ref) in compared_blocks(bench, :hand_loop)
                r = ratio(rows, ref, target)
                (r === nothing || !is_slower(r)) && continue
                push!(slow, "$block ($(two_places(r))×)")
            end
            push!(
                lines, "- **$label**: " *
                    (isempty(slow) ? "never slower." : join(slow, ", ") * ".")
            )
        end
        return Markdown.parse(join(lines, '\n'))
    end

    # The rows of `block` in `file` at its largest size, as `(rows, ref)`
    # with `ref` its hand loop, or `nothing` when the file is absent.
    function block_rows(block, file)
        bench = read_results(file)
        bench === nothing && return nothing
        for (b, rows, ref) in compared_blocks(bench, :hand_loop)
            b == block && return (rows, ref)
        end
        throw(ArgumentError("no compared block $(repr(block)) in $file"))
    end

    # `t` microseconds to three significant figures.
    function microseconds(t)
        t === nothing && return "–"
        d = max(0, 2 - floor(Int, log10(t)))
        return string(d == 0 ? round(Int, t) : round(t; digits = d))
    end

    # A table row: its label, then one cell per target.
    table_row(label, cells) = "| $label | " * join(cells, " | ") * " |"

    """
        performance_summary(block; file = RESULTS)

    One example's runtime at its largest size in `file`: the package's
    minimum time on the forward run and each gradient backend, and how many
    times faster it is than the package with its rules turned off
    (`plain AD`, on the reverse backends, the only ones that call the rules),
    than the hand loop, and than the hand loop with hand-written Mooncake
    rules where the block has them.
    Above 1 the package is faster; below 1 it is slower.
    A row with no times is left out.
    """
    function performance_summary(block; file = RESULTS)
        found = block_rows(block, file)
        found === nothing && return Markdown.parse(
            "The benchmark results are not available in this build."
        )
        rows, ref = found
        targets = first.(TARGETS)
        methods = unique(rows.method)
        lines = [
            table_header([""], last.(TARGETS))...,
            table_row(
                "Package (μs)",
                [microseconds(min_time(rows, "ComposableRecurrences", t)) for t in targets]
            ),
        ]
        for (label, method) in (
                "Without its rules" => PLAIN_AD, "Hand loop" => ref,
                "Hand rules" => "hand rules",
            )
            method in methods || continue
            cells = [times(rule_ratio(rows, method, t)) for t in targets]
            all(==("–"), cells) && continue
            push!(lines, table_row(label, cells))
        end
        push!(
            lines, "",
            "Minimum times at `$(first(rows.size))`, revision $(first(rows.revision))."
        )
        return Markdown.parse(join(lines, '\n'))
    end

    # The geometric mean of `xs`, or `nothing` when there are none.
    geomean(xs) = isempty(xs) ? nothing : exp(sum(log, xs) / length(xs))

    """
        performance_overview(; file = RESULTS)

    Every example in `file` at a glance, per target: the geometric mean over
    the examples of how many times faster the package is than itself with
    its rules turned off, on the reverse backends, and than each example's
    hand loop, how many examples are slower than each, and the range against
    the hand loop.
    """
    function performance_overview(; file = RESULTS)
        bench = read_results(file)
        bench === nothing && return Markdown.parse(
            "The benchmark results are not available in this build."
        )
        blocks = compared_blocks(bench, :hand_loop)
        targets = first.(TARGETS)
        # Each block's ratio on `t` against `method`, or its hand loop
        # for `:ref`; `nothing` where a time is missing.
        against(method, t) = [
            rule_ratio(rows, method === :ref ? ref : method, t)
                for (_, rows, ref) in blocks
        ]
        ratios(method) = [filter(!isnothing, against(method, t)) for t in targets]
        rules, loop = ratios(PLAIN_AD), ratios(:ref)
        span(xs) = isempty(xs) ? "–" :
            string(two_places(minimum(xs)), "–", two_places(maximum(xs)), "×")
        slower(xs) = isempty(xs) ? "–" :
            "$(count(is_slower, xs)) of $(length(xs))"
        lines = [
            table_header([""], last.(TARGETS))...,
            table_row("Without its rules (geometric mean)", times.(geomean.(rules))),
            table_row("Slower than without its rules", slower.(rules)),
            table_row("Hand loop (geometric mean)", times.(geomean.(loop))),
            table_row("Hand loop (range)", span.(loop)),
            table_row("Slower than the hand loop", slower.(loop)),
            "",
            "Minimum times at each example's largest size, revision " *
                "$(join(unique(bench.revision), ", ")).",
        ]
        return Markdown.parse(join(lines, '\n'))
    end

end # module DocsPerformance

using .DocsPerformance: performance_plot, performance_table, slower_cases,
    performance_summary, performance_overview
