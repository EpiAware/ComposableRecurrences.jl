# PACKAGE-OWNED: text extraction for the documentation standards checks in
# `standards.jl`. Docstrings are read as authored (the string parts of each
# docstring, without the signature and field templates), src comments from
# the tokeniser, and prose from Markdown pages and Literate comment lines.

using EpiAwarePackageTools: BANNED_README_WORDS
include(joinpath(@__DIR__, "standards_config.jl"))

# The authored text of every docstring attached to `name` in `mod`.
function authored_docs(mod::Module, name::Symbol)
    binding = Base.Docs.Binding(mod, name)
    multidoc = get(Base.Docs.meta(mod), binding, nothing)
    multidoc === nothing && return String[]
    return [
        join(x for x in ds.text if x isa AbstractString)
            for ds in values(multidoc.docs)
    ]
end

# Every docstring in `mod` as `label => text`.
function all_authored_docs(mod::Module)
    out = Pair{String, String}[]
    for binding in keys(Base.Docs.meta(mod))
        for text in authored_docs(mod, binding.var)
            push!(out, "docstring $(binding.var)" => text)
        end
    end
    return out
end

# Exported and public names, the module itself included.
public_names(mod::Module) =
    sort!(filter(n -> Base.ispublic(mod, n), names(mod; all = true)))

has_maths(texts) = any(t -> occursin(r"^```math\s*$"m, t), texts)

# A runnable example: a doctest, an `@example` or `@repl` block, or a
# `julia` block with more than a single signature line.
function has_example(texts)
    for text in texts
        for m in eachmatch(r"^```([^\n]*)\n(.*?)^```"ms, text)
            lang = strip(m.captures[1])
            startswith(lang, "jldoctest") && return true
            startswith(lang, "@example") && return true
            startswith(lang, "@repl") && return true
            if lang == "julia"
                code = filter(!isempty, strip.(split(m.captures[2], '\n')))
                (length(code) > 1 || any(startswith("julia>"), code)) &&
                    return true
            end
        end
    end
    return false
end

# Prose lines of a Markdown text as `(line number, text)`, dropping fenced
# code, display maths, front matter, tables, HTML, admonition markers and
# the scaffold-managed README sections.
function markdown_prose(text::AbstractString)
    out = Tuple{Int, String}[]
    lines = split(text, '\n')
    fence = false
    dollars = false
    managed = false
    front = !isempty(lines) && strip(lines[1]) == "---"
    for (i, line) in enumerate(lines)
        s = strip(line)
        occursin("standard-sections:start", s) && (managed = true)
        occursin("standard-sections:end", s) && (managed = false)
        managed && continue
        if front
            i > 1 && s == "---" && (front = false)
            continue
        end
        if startswith(s, "```") || startswith(s, "~~~")
            fence = !fence
            continue
        end
        fence && continue
        if s == raw"$$"
            dollars = !dollars
            continue
        end
        dollars && continue
        (isempty(s) || startswith(s, "|") || startswith(s, "<")) && continue
        (startswith(s, ":::") || startswith(s, "!!!")) && continue
        startswith(line, "    ") && !startswith(s, "-") && continue
        push!(out, (i, String(line)))
    end
    return out
end

# Literate tutorial prose: the `# ` comment lines, as Markdown.
function literate_prose(text::AbstractString)
    lines = split(text, '\n')
    md = map(lines) do line
        m = match(r"^#(?: (.*))?$", line)
        m === nothing ? "" : something(m.captures[1], "")
    end
    return markdown_prose(join(md, '\n'))
end

prose_of(file) = endswith(file, ".jl") ?
    literate_prose(read(file, String)) : markdown_prose(read(file, String))

const JS = Base.JuliaSyntax

# Comments in a Julia source file as `(line number, text)`.
function source_comments(file)
    src = read(file, String)
    out = Tuple{Int, String}[]
    for tok in JS.tokenize(src)
        JS.kind(tok) == JS.K"Comment" || continue
        r = tok.range
        bytes = codeunits(src)
        line = count(==(UInt8('\n')), view(bytes, 1:(first(r) - 1))) + 1
        push!(out, (line, String(bytes[r])))
    end
    return out
end

src_files() = sort!(
    [
        joinpath(dir, f) for (dir, _, fs) in walkdir(joinpath(STANDARDS_ROOT, "src"))
            for f in fs if endswith(f, ".jl")
    ]
)

relpath_root(file) = relpath(file, STANDARDS_ROOT)

# A line with inline code, links and inline maths reduced to plain words.
function plain_words(line::AbstractString)
    s = replace(line, r"``[^`]*``" => " maths ")
    s = replace(s, r"`[^`]*`" => " Code ")
    s = replace(s, r"\$[^$]*\$" => " maths ")
    s = replace(s, r"!?\[([^\]]*)\]\([^)]*\)" => s"\1")
    s = replace(s, r"\]\([^)]*\)" => "]")
    return s
end

# A banned word as a regular expression. This mirrors the stem rule that
# EpiAwarePackageTools documents for `BANNED_README_WORDS`: case-insensitive,
# word-boundary anchored, any suffix allowed, with a trailing `e` trimmed so
# `leverage` also catches `leveraging`. The three entries the stem rule gets
# wrong carry their own pattern, as in the shared package.
const BANNED_WORD_PATTERNS = Dict(
    "novel" => "novel(?:s|ly|ty|ties)?",
    "synergy" => "synerg(?:y|ies|i[sz]e[sd]?|i[sz]ing|istic(?:ally)?)",
    "current approaches" => "current\\s+approach(?:es)?",
)

function banned_word_regex(word::AbstractString)
    key = String(strip(word))
    body = get(BANNED_WORD_PATTERNS, lowercase(key), nothing)
    if body === nothing
        # The entries are plain words, so need no regex escaping.
        stems = String.(split(key))
        stems[end] = replace(stems[end], r"e$" => "")
        body = join(stems, "\\s+") * "[a-z]*"
    end
    return Regex("\\b" * body * "\\b", "i")
end

const BANNED_PATTERNS = [
    banned_word_regex(w) for w in vcat(
            filter(!in(BANNED_SHARED_SKIP), BANNED_README_WORDS),
            collect(BANNED_EXTRA)
        )
]

function banned_hits(line)
    s = plain_words(line)
    hits = String[]
    for pattern in BANNED_PATTERNS
        m = match(pattern, s)
        m === nothing || push!(hits, m.match)
    end
    m = match(r"\bpieces?\b"i, s)
    m === nothing || push!(hits, m.match)
    return hits
end

function package_hits(line)
    s = plain_words(line)
    return [p for p in OTHER_PACKAGES if occursin(Regex("\\b$(p)\\b"), s)]
end

const ABBREVIATIONS = (
    "e.g.", "i.e.", "etc.", "vs.", "cf.", "et al.", "approx.", "resp.",
)

# True when a prose line holds more than one sentence. A question followed
# by its answer ("Want X? See Y.") counts as one.
function several_sentences(line)
    s = plain_words(line)
    s = replace(s, r"^\s*(?:[-*+]|\d+[.)])\s+" => "")
    for a in ABBREVIATIONS
        s = replace(s, a => "abbr")
    end
    return occursin(r"[a-z0-9)\]][.!][\"')\]*_]*\s+[A-Z]", s)
end

# Every `(label, line)` of prose, docstring and src comment text.
function prose_sources(mod::Module)
    out = Tuple{String, String}[]
    for file in standards_prose_files()
        for (i, line) in prose_of(file)
            push!(out, ("$(relpath_root(file)):$i", line))
        end
    end
    return out
end

function docstring_sources(mod::Module)
    out = Tuple{String, String}[]
    for (label, text) in all_authored_docs(mod)
        for (i, line) in markdown_prose(text)
            push!(out, ("$label, line $i", line))
        end
    end
    return out
end

function comment_sources()
    out = Tuple{String, String}[]
    for file in src_files()
        for (i, text) in source_comments(file)
            push!(out, ("$(relpath_root(file)):$i", text))
        end
    end
    return out
end

violations(f, sources) =
    [
    "$label: $(join(hits, ", "))" for (label, line) in sources
        for hits in (f(line),) if !isempty(hits)
]

# Headings of the sections of a Literate tutorial that introduce a model
# without maths first. A section starts at each `# ##` heading (level two or
# deeper) and runs to the next one. A section whose code uses one of `calls`
# introduces a model, and needs its own ```math block before that code.
# Headings are returned without any `[...](@id ...)`.
function sections_missing_maths(text::AbstractString, calls)
    flagged = String[]
    heading = "(before the first heading)"
    maths = false
    for line in split(text, '\n')
        m = match(r"^# #{2,} (.*)$", line)
        if m !== nothing
            title = strip(m.captures[1])
            link = match(r"^\[(.*)\]\(@id [^)]*\)$", title)
            heading = String(link === nothing ? title : link.captures[1])
            maths = false
        elseif startswith(line, "# ```math")
            maths = true
        elseif !startswith(line, "#")
            any(c -> occursin(call_regex(c), line), calls) || continue
            maths || heading in flagged || push!(flagged, heading)
        end
    end
    return flagged
end

# A Markdown page in the Literate form `sections_missing_maths` reads: the
# lines of its ```julia and ```@example blocks as code, every other line as
# a `# ` comment.
function markdown_as_literate(text::AbstractString)
    out = String[]
    code = false
    fence = false
    for line in split(text, '\n')
        s = strip(line)
        if !fence && (startswith(s, "```julia") || startswith(s, "```@example"))
            code = true
            fence = true
            push!(out, "# " * line)
        elseif fence && s == "```"
            code = false
            fence = false
            push!(out, "# " * line)
        elseif code
            push!(out, startswith(line, "#") ? "" : String(line))
        else
            startswith(s, "```") && (fence = !fence)
            push!(out, "# " * line)
        end
    end
    return join(out, '\n')
end

maths_first_text(file) = endswith(file, ".md") ?
    markdown_as_literate(read(file, String)) : read(file, String)

# Code lines of the ```julia blocks of a Markdown text.
julia_block_lines(text::AbstractString) = [
    String(l) for m in eachmatch(r"^```julia\n(.*?)^```"ms, text)
        for l in split(m.captures[1], '\n') if !isempty(strip(l))
]

# A call of `name`, bare or qualified by a module, but not a longer name
# that ends in it.
call_regex(name) = Regex("(?<![\\w.])(?:\\w+\\.)?" * name * "\\(")
