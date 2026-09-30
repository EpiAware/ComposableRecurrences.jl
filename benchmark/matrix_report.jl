#!/usr/bin/env julia
# Turn a `matrix.jl` result directory into a Markdown report: a target ×
# case table (median time, allocations, ratio to the fastest gradient), the
# rule gain of each backend (NoAdjoint / rule), the design bars, flagged
# opportunities and, given a previous run, its regressions.
#
#   julia benchmark/matrix_report.jl DIR [PREVIOUS_DIR] [--out=FILE]
#       [--docs=benchmark/results/docs.csv]
#
# `--docs` also writes the docs table from the `docs` tier of DIR.
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
    meta::Dict{String, Dict{String, String}}  # "tier target" => metadata
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
        haskey(m, "target") && (meta[m["tier"] * " " * m["target"]] = m)
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
    ts = unique(
        r["target"] for r in run.rows
            if haskey(run.meta, r["tier"] * " " * r["target"])
    )
    # Targets beyond the serial CPU ones (a traced or threaded run, say) are
    # named "... primal" or "... gradient" and follow the built-in ones.
    grads = [t for t in GRADIENT_ORDER if t in ts]
    append!(grads, sort([t for t in ts if endswith(t, "gradient")]))
    primal = "primal" in ts ? ["primal"] : String[]
    append!(primal, sort([t for t in ts if t != "primal" && endswith(t, "primal")]))
    return primal, grads
end

_isprimal(t) = endswith(t, "primal")

# The row of a target as users call the operator: the `rule` arm, or
# `traced` for a target that compiles the call.
function _user_row(ix, tier, c, sz, t)
    r = get(ix, (tier, c, sz, t, "rule"), nothing)
    return r === nothing ? get(ix, (tier, c, sz, t, "traced"), nothing) : r
end

function _rules(run, target)
    return any(
        get(m, "target", "") == target && get(m, "rules", "") == "true"
            for m in values(run.meta)
    )
end

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
    println(io, "| Tier and target | Label | Revision | Julia | Threads | Rules | Load start → end | Versions |")
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
        rs = [_user_row(ix, tier, c, sz, t) for t in cols]
        best = minimum(
            (
                _num(r, "median_ns") for (t, r) in zip(cols, rs)
                    if r !== nothing && !_isprimal(t) && _ok(r)
            ); init = Inf
        )
        cells = map(zip(cols, rs)) do (t, r)
            r === nothing && return ""
            _ok(r) || return _short(r["status"])
            med = _num(r, "median_ns")
            s = fmt_time(med) * " · " * r["allocs"]
            _isprimal(t) && return s
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
        gains = Float64[]
        for r in run.rows
            r["tier"] == tier && r["arm"] == "rule" && _ok(r) &&
                r["target"] in norules || continue
            n = get(ix, (tier, r["case"], r["size"], r["target"], "NoAdjoint"), nothing)
            n !== nothing && _ok(n) &&
                push!(gains, _num(n, "median_ns") / _num(r, "median_ns"))
        end
        println(
            io, "No rules on this revision for ", join(norules, ", "),
            ": both arms run the same plain AD, so their ratio is the noise ",
            "floor of this run",
            isempty(gains) ? "" :
                @sprintf(" (%.2f× to %.2f×)", minimum(gains), maximum(gains)),
            ".\n"
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

# Cases with baseline arms: every arm per target, as median and ratio to
# the package as users call it.
function baselines_section(io, run, tier)
    ix = index(run)
    extra = unique(
        (r["case"], r["arm"]) for r in run.rows
            if r["tier"] == tier && !(get(r, "arm", "") in ("", "rule", "NoAdjoint"))
    )
    isempty(extra) && return
    println(io, "## Against code without the package, tier `", tier, "`\n")
    println(
        io, "Median time and ratio to the package's own call (`rule`). ",
        "Every arm computes the same loss.\n"
    )
    for c in unique(first.(extra))
        armnames = vcat(["rule", "NoAdjoint"], [a for (k, a) in extra if k == c])
        println(io, "| Case | Size | Target | ", join(armnames, " | "), " |")
        println(io, "|:--|:--|:--|", repeat("--:|", length(armnames)))
        for (cc, sz, _) in cases_in(run, tier)
            cc == c || continue
            for t in vcat(["primal"], GRADIENT_ORDER)
                ref = get(ix, (tier, c, sz, t, "rule"), nothing)
                (ref === nothing || !_ok(ref)) && continue
                cells = map(armnames) do a
                    r = get(ix, (tier, c, sz, t, a), nothing)
                    r === nothing && return ""
                    _ok(r) || return _short(r["status"])
                    med = _num(r, "median_ns")
                    return fmt_time(med) * " · " *
                        fmt_ratio(med / _num(ref, "median_ns"))
                end
                println(io, "| ", c, " | ", sz, " | ", t, " | ", join(cells, " | "), " |")
            end
        end
        println(io)
    end
    return nothing
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
                !_rules(run, t) ? "no rules" : µs <= bar ? "meets" : "misses"
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
        if p !== nothing && _ok(p) && arm == "rule" && _rules(run, t)
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
    # Allocations growing with T mean a per-step allocation. Plain AD
    # records a tape per step, so only the primal and rule paths are checked.
    for r in run.rows, s in run.rows
        (_ok(r) && _ok(s)) || continue
        r["target"] == "primal" ||
            (r["arm"] == "rule" && _rules(run, r["target"])) || continue
        same = all(r[k] == s[k] for k in ("tier", "case", "S", "target", "arm"))
        same && parse(Int, s["T"]) > parse(Int, r["T"]) || continue
        a, b = parse(Int, r["allocs"]), parse(Int, s["allocs"])
        b > 1.5 * a && b - a > 10 && push!(
            notes, @sprintf(
                "%s S%s %s %s: allocations grow with T (%d at T%s, %d at T%s)",
                r["case"], r["S"], r["target"], r["arm"], a, r["T"], b, s["T"]
            )
        )
    end
    # Backends far apart on the same cell, as users call the operator.
    for r in run.rows
        _ok(r) && r["target"] == "Mooncake reverse" && r["arm"] == "rule" ||
            continue
        e = get(ix, (r["tier"], r["case"], r["size"], "Enzyme reverse", r["arm"]), nothing)
        (e === nothing || !_ok(e)) && continue
        x = _num(e, "median_ns") / _num(r, "median_ns")
        (x > 2 || x < 0.5) && push!(
            notes, @sprintf(
                "%s %s: Enzyme / Mooncake = %.2f×", r["case"], r["size"], x
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
        baselines_section(io, run, tier)
    end
    bars_section(io, run)
    opportunities_section(io, run)
    regressions_section(io, run, prev)
    pending_section(io, run)
    details_section(io, run)
    return String(take!(io))
end

# The docs table: the getting-started model against code written without the
# package, and the user modifier with and without its `pullback!`. Each row
# is one method on one target; `ratio` is its median over the reference
# method's (the package, or the modifier with `forward` only).
const DOCS_BLOCKS = [
    (
        "naive vs package", "overview", "ComposableRecurrences",
        [
            ("overview", "rule") => "ComposableRecurrences",
            ("overview", "loop") => "hand loop",
            ("overview", "copy loop") => "hand loop (window copies)",
            ("overview", "accumulate") => "accumulate",
        ],
    ),
    (
        "custom modifier", "custom_modifier", "forward only",
        [
            ("custom_modifier", "rule") => "forward only",
            ("custom_modifier_pullback", "rule") => "with pullback!",
        ],
    ),
]
const DOCS_COLUMNS = [
    "block", "size", "method", "target", "status", "median_us", "min_us",
    "allocs",
    "ratio", "relerr", "check", "revision", "rules",
]

function docs_csv(run)
    io = IOBuffer()
    println(io, join(DOCS_COLUMNS, ','))
    ix = index(run)
    for (block, refcase, refname, methods) in DOCS_BLOCKS
        sizes = unique(
            r["size"] for r in run.rows if get(r, "case", "") == refcase &&
                _ok(r)
        )
        for sz in sizes, target in vcat(["primal"], GRADIENT_ORDER)
            ref = nothing
            for ((c, arm), name) in methods
                name == refname && (ref = get(ix, ("docs", c, sz, target, arm), nothing))
            end
            (ref === nothing || !_ok(ref)) && continue
            for ((c, arm), name) in methods
                r = get(ix, ("docs", c, sz, target, arm), nothing)
                r === nothing && continue
                startswith(r["status"], "skipped") && continue
                m = run.meta["docs " * target]
                ok = _ok(r)
                status = ok ? "ok" : first(split(r["status"], ':'))
                num(k) = ok ? @sprintf("%.2f", _num(r, k) / 1.0e3) : ""
                println(
                    io, join(
                        [
                            block, sz, name, target, status, num("median_ns"),
                            num("min_ns"), ok ? r["allocs"] : "",
                            ok ? @sprintf(
                                    "%.3f", _num(r, "median_ns") / _num(ref, "median_ns")
                                ) : "",
                            r["relerr"], r["check"], first(get(m, "rev", ""), 8),
                            get(m, "rules", ""),
                        ], ','
                    )
                )
            end
        end
    end
    return String(take!(io))
end

if abspath(PROGRAM_FILE) == @__FILE__
    pos = filter(a -> !startswith(a, "--"), ARGS)
    i = findfirst(a -> startswith(a, "--out="), ARGS)
    out = i === nothing ? joinpath(first(pos), "REPORT.md") : ARGS[i][7:end]
    write(out, report(first(pos), get(pos, 2, nothing)))
    println("wrote ", out)
    j = findfirst(a -> startswith(a, "--docs="), ARGS)
    if j !== nothing
        docs = ARGS[j][8:end]
        mkpath(dirname(docs))
        write(docs, docs_csv(read_run(first(pos))))
        println("wrote ", docs)
    end
end
