#!/usr/bin/env julia
# Turn a `matrix.jl` result directory into a Markdown report: a target ×
# case table (median time, allocations, ratio to the fastest gradient), the
# rule gain of each backend (NoAdjoint / rule), the design bars, flagged
# opportunities and, given a previous run, its regressions.
#
#   julia benchmark/matrix_report.jl DIR [PREVIOUS_DIR] [--out=FILE]
#
# A change counts as a regression or an improvement only when the minimum
# and the median both move by at least `THRESHOLD`, so noise on a shared
# host that moves one of them is not reported.

using Printf: @sprintf

const THRESHOLD = 1.1
const RULE_BAR = 1.1
const GRADIENT_ORDER = [
    "ForwardDiff", "Mooncake reverse", "Mooncake forward", "Enzyme reverse",
    "Enzyme forward",
]

# Design bars on the Mooncake gradient at T = 200, L = 20 (µs).
const BARS = [
    ("renewal_depletion", "T200_L20_S1", "Mooncake reverse", 38 * 1.2),
    ("strata_mixing", "T200_L20_S5", "Mooncake reverse", 156 * 1.3),
    ("bvd_patch", "T200_L20_S5", "Mooncake reverse", 306 * 1.2),
]

struct Run
    meta::Dict{String, Dict{String, String}}  # target => metadata
    rows::Vector{Dict{String, String}}
end

function read_run(dir)
    meta = Dict{String, Dict{String, String}}()
    rows = Dict{String, String}[]
    for f in sort(readdir(dir; join = true))
        endswith(f, ".tsv") || continue
        m = Dict{String, String}()
        header = String[]
        for line in eachline(f)
            if startswith(line, "# ")
                k, v = split(line[3:end], '='; limit = 2)
                m[k] = v
            elseif isempty(header)
                header = split(line, '\t')
            else
                push!(rows, Dict(zip(header, split(line, '\t'))))
                rows[end]["tier"] = get(m, "tier", "")
            end
        end
        haskey(m, "target") && (meta[m["target"]] = m)
    end
    return Run(meta, rows)
end

_key(r) = (r["tier"], r["case"], r["size"], r["target"], r["arm"])
_num(r, k) = (v = get(r, k, ""); isempty(v) ? NaN : parse(Float64, v))
_ok(r) = get(r, "status", "") == "ok"

function fmt_time(ns)
    isnan(ns) && return "–"
    ns < 1.0e3 && return @sprintf("%.0f ns", ns)
    ns < 1.0e6 && return @sprintf("%.1f µs", ns / 1.0e3)
    ns < 1.0e9 && return @sprintf("%.2f ms", ns / 1.0e6)
    return @sprintf("%.2f s", ns / 1.0e9)
end

fmt_ratio(x) = isnan(x) ? "–" : @sprintf("%.2f×", x)

function _short(status)
    startswith(status, "skipped") && return "skip"
    startswith(status, "error") && return "error"
    startswith(status, "pending") && return "pending"
    return status
end

function index(run)
    return Dict(_key(r) => r for r in run.rows if !isempty(get(r, "case", "")))
end

function _targets(run)
    ts = unique(r["target"] for r in run.rows if haskey(run.meta, r["target"]))
    grads = [t for t in GRADIENT_ORDER if t in ts]
    return ("primal" in ts ? ["primal"] : String[]), grads
end

_rules(run, target) = get(get(run.meta, target, Dict()), "rules", "false") == "true"

function cases_in(run, tier)
    seen = Tuple{String, String, String}[]
    for r in run.rows
        r["tier"] == tier && !isempty(get(r, "case", "")) || continue
        startswith(get(r, "status", ""), "pending") && continue
        k = (r["case"], r["size"], get(r, "nparams", ""))
        k in seen || push!(seen, k)
    end
    return seen
end

function metadata_section(io, run)
    println(io, "## Runs\n")
    println(io, "| Target | Label | Revision | Julia | Threads | Rules | Load start → end | Versions |")
    println(io, "|:--|:--|:--|:--|--:|:--|:--|:--|")
    for (t, m) in sort(collect(run.meta); by = first)
        vs = join(
            [
                "$k $(m[k])" for k in (
                        "ComposableRecurrences", "Mooncake", "Enzyme", "ForwardDiff",
                    ) if haskey(m, k)
            ], ", "
        )
        println(
            io, "| ", t, " | ", get(m, "label", ""), " | `",
            first(get(m, "rev", ""), 8), "` | ", get(m, "julia", ""), " | ",
            get(m, "threads", ""), " | ", get(m, "rules", ""), " | ",
            get(m, "load_start", ""), " → ", get(m, "load_end", ""), " | ",
            vs, " |"
        )
    end
    return println(io)
end

function timings_section(io, run, tier)
    ix = index(run)
    primal, grads = _targets(run)
    cols = vcat(primal, grads)
    println(io, "## Timings, tier `", tier, "`\n")
    println(
        io, "Median time · allocations, rule arm (the operator as users call ",
        "it). Gradient cells also give the ratio to the fastest gradient in ",
        "the row.\n"
    )
    println(io, "| Case | Size | Params | ", join(cols, " | "), " |")
    println(io, "|:--|:--|--:|", repeat("--:|", length(cols)))
    for (c, sz, np) in cases_in(run, tier)
        rs = [get(ix, (tier, c, sz, t, "rule"), nothing) for t in cols]
        best = minimum(
            (
                _num(r, "median_ns") for (t, r) in zip(cols, rs)
                    if r !== nothing && t != "primal" && _ok(r)
            ); init = Inf
        )
        cells = map(zip(cols, rs)) do (t, r)
            r === nothing && return ""
            _ok(r) || return _short(r["status"])
            med = _num(r, "median_ns")
            s = fmt_time(med) * " · " * r["allocs"]
            t == "primal" && return s
            return s * " · " * fmt_ratio(med / best)
        end
        println(io, "| ", c, " | ", sz, " | ", np, " | ", join(cells, " | "), " |")
    end
    return println(io)
end

function gain_section(io, run, tier)
    ix = index(run)
    _, grads = _targets(run)
    grads = filter(t -> t != "ForwardDiff", grads)
    isempty(grads) && return
    println(io, "## Rule gain, tier `", tier, "`\n")
    norules = filter(t -> !_rules(run, t), grads)
    if !isempty(norules)
        println(
            io, "No rules on this revision for ", join(norules, ", "),
            ": both arms run plain AD, so their gain is noise around 1.\n"
        )
    end
    println(
        io, "NoAdjoint median / rule median. Below ", RULE_BAR,
        "× a rule is a deletion candidate (DESIGN item 35).\n"
    )
    println(io, "| Case | Size | ", join(grads, " | "), " |")
    println(io, "|:--|:--|", repeat("--:|", length(grads)))
    for (c, sz, _) in cases_in(run, tier)
        cells = map(grads) do t
            r = get(ix, (tier, c, sz, t, "rule"), nothing)
            n = get(ix, (tier, c, sz, t, "NoAdjoint"), nothing)
            (r === nothing || n === nothing) && return ""
            _ok(r) && _ok(n) || return _short(_ok(r) ? n["status"] : r["status"])
            g = _num(n, "median_ns") / _num(r, "median_ns")
            flag = _rules(run, t) && g < RULE_BAR ? " ⚠" : ""
            return fmt_ratio(g) * flag
        end
        println(io, "| ", c, " | ", sz, " | ", join(cells, " | "), " |")
    end
    return println(io)
end

function bars_section(io, run)
    ix = index(run)
    lines = String[]
    for (c, sz, t, bar) in BARS, tier in unique(r["tier"] for r in run.rows)
        r = get(ix, (tier, c, sz, t, "rule"), nothing)
        (r === nothing || !_ok(r)) && continue
        µs = _num(r, "median_ns") / 1.0e3
        push!(
            lines, @sprintf(
                "| %s | %s | %s | %.1f | %.1f | %s |", c, sz, t, µs, bar,
                µs <= bar ? "meets" : "misses"
            )
        )
    end
    isempty(lines) && return
    println(io, "## Design bars\n")
    println(io, "| Case | Size | Target | Median (µs) | Bar (µs) | |")
    println(io, "|:--|:--|:--|--:|--:|:--|")
    foreach(l -> println(io, l), unique(lines))
    return println(io)
end

function opportunities_section(io, run)
    ix = index(run)
    notes = String[]
    for r in run.rows
        _ok(r) || continue
        tier, c, sz, t, arm = _key(r)
        t == "primal" && continue
        p = get(ix, (tier, c, sz, "primal", "rule"), nothing)
        if p !== nothing && _ok(p) && arm == "rule"
            ratio = _num(r, "median_ns") / _num(p, "median_ns")
            ratio > 20 && t != "ForwardDiff" && push!(
                notes, @sprintf(
                    "%s %s %s: gradient is %.0f× the primal", c, sz, t, ratio
                )
            )
        end
        if arm == "rule" && _rules(run, t)
            n = get(ix, (tier, c, sz, t, "NoAdjoint"), nothing)
            if n !== nothing && _ok(n)
                g = _num(n, "median_ns") / _num(r, "median_ns")
                g < RULE_BAR && push!(
                    notes, @sprintf(
                        "%s %s %s: rule gain %.2f× is under %.1f×", c, sz,
                        t, g, RULE_BAR
                    )
                )
            end
        end
    end
    # Allocations growing with T mean a per-step allocation.
    for r in run.rows, s in run.rows
        (_ok(r) && _ok(s)) || continue
        same = all(r[k] == s[k] for k in ("tier", "case", "S", "target", "arm"))
        same && parse(Int, s["T"]) > parse(Int, r["T"]) && r["L"] == s["L"] ||
            continue
        a, b = parse(Int, r["allocs"]), parse(Int, s["allocs"])
        b > 1.5 * a && b - a > 10 && push!(
            notes, @sprintf(
                "%s S%s %s %s: allocations grow with T (%d at T%s, %d at T%s)",
                r["case"], r["S"], r["target"], r["arm"], a, r["T"], b, s["T"]
            )
        )
    end
    # Backends far apart on the same cell.
    for r in run.rows
        _ok(r) && r["target"] == "Mooncake reverse" || continue
        e = get(ix, (r["tier"], r["case"], r["size"], "Enzyme reverse", r["arm"]), nothing)
        (e === nothing || !_ok(e)) && continue
        x = _num(e, "median_ns") / _num(r, "median_ns")
        (x > 2 || x < 0.5) && push!(
            notes, @sprintf(
                "%s %s %s: Enzyme / Mooncake = %.2f×", r["case"], r["size"],
                r["arm"], x
            )
        )
    end
    println(io, "## Opportunities\n")
    isempty(notes) && println(io, "None flagged.")
    foreach(n -> println(io, "- ", n), unique(notes))
    return println(io)
end

function regressions_section(io, run, prev)
    println(io, "## Regressions\n")
    if prev === nothing
        println(io, "No previous run given.\n")
        return
    end
    for (t, m) in run.meta
        p = get(prev.meta, t, nothing)
        p === nothing && continue
        diffs = [
            "$k $(get(p, k, "–")) → $(get(m, k, "–"))" for k in (
                    "julia", "threads", "host", "rules", "Mooncake", "Enzyme",
                    "ForwardDiff",
                ) if get(p, k, "") != get(m, k, "")
        ]
        isempty(diffs) || println(
            io, "- ", t, " setup changed (compare with care): ",
            join(diffs, "; ")
        )
    end
    pix = index(prev)
    worse, better, status = String[], String[], String[]
    for r in run.rows
        isempty(get(r, "case", "")) && continue
        p = get(pix, _key(r), nothing)
        p === nothing && continue
        label = join(_key(r)[2:end], " ")
        if _ok(r) != _ok(p)
            push!(status, "| $label | $(_short(p["status"])) | $(_short(r["status"])) |")
            continue
        end
        _ok(r) || continue
        med = _num(r, "median_ns") / _num(p, "median_ns")
        mn = _num(r, "min_ns") / _num(p, "min_ns")
        line = "| $label | $(fmt_time(_num(p, "median_ns"))) | " *
            "$(fmt_time(_num(r, "median_ns"))) | $(fmt_ratio(med)) | " *
            "$(fmt_ratio(mn)) | $(p["allocs"]) → $(r["allocs"]) |"
        if med >= THRESHOLD && mn >= THRESHOLD
            push!(worse, line)
        elseif med <= 1 / THRESHOLD && mn <= 1 / THRESHOLD
            push!(better, line)
        end
    end
    println(io)
    head = "| Cell | Before | After | Median ratio | Min ratio | Allocations |\n" *
        "|:--|--:|--:|--:|--:|--:|"
    for (title, lines) in (("Slower", worse), ("Faster", better))
        println(
            io, "### ", title, " (min and median both ", THRESHOLD,
            "× or more ", lowercase(title), ")\n"
        )
        if isempty(lines)
            println(io, "None.\n")
        else
            println(io, head)
            foreach(l -> println(io, l), lines)
            println(io)
        end
    end
    if !isempty(status)
        println(io, "### Status changes\n")
        println(io, "| Cell | Before | After |\n|:--|:--|:--|")
        foreach(l -> println(io, l), status)
        println(io)
    end
    return nothing
end

function pending_section(io, run)
    ps = filter(r -> startswith(get(r, "status", ""), "pending"), run.rows)
    isempty(ps) && return
    println(io, "## Pending\n")
    for r in ps
        what = isempty(r["case"]) ? "target " * r["target"] : "case " * r["case"]
        println(io, "- ", what, ": waits on ", replace(r["status"], "pending: " => ""))
    end
    return println(io)
end

function details_section(io, run)
    println(io, "<details><summary>Every cell</summary>\n")
    println(io, "| Tier | Case | Size | Target | Arm | Status | Min | Median | Allocs | Memory | First call (s) | Rel. error | Checked against |")
    println(io, "|:--|:--|:--|:--|:--|:--|--:|--:|--:|--:|--:|--:|:--|")
    for r in run.rows
        isempty(get(r, "case", "")) && continue
        println(
            io, "| ", join(
                [
                    r["tier"], r["case"], r["size"], r["target"], r["arm"],
                    r["status"], fmt_time(_num(r, "min_ns")),
                    fmt_time(_num(r, "median_ns")), r["allocs"], r["memory"],
                    r["prep_s"], r["relerr"], r["check"],
                ], " | "
            ), " |"
        )
    end
    return println(io, "\n</details>")
end

function report(dir, prevdir = nothing)
    run = read_run(dir)
    prev = prevdir === nothing ? nothing : read_run(prevdir)
    io = IOBuffer()
    println(io, "# Benchmark matrix: ", basename(rstrip(dir, '/')), "\n")
    metadata_section(io, run)
    tiers = unique(
        r["tier"] for r in run.rows
            if !isempty(get(r, "case", "")) &&
            !startswith(get(r, "status", ""), "pending")
    )
    for tier in tiers
        timings_section(io, run, tier)
        gain_section(io, run, tier)
    end
    bars_section(io, run)
    opportunities_section(io, run)
    regressions_section(io, run, prev)
    pending_section(io, run)
    details_section(io, run)
    return String(take!(io))
end

if abspath(PROGRAM_FILE) == @__FILE__
    pos = filter(a -> !startswith(a, "--"), ARGS)
    i = findfirst(a -> startswith(a, "--out="), ARGS)
    out = i === nothing ? joinpath(first(pos), "REPORT.md") : ARGS[i][7:end]
    write(out, report(first(pos), get(pos, 2, nothing)))
    println("wrote ", out)
end
