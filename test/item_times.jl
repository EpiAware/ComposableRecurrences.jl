# PACKAGE-OWNED: the recorded item times that `runtests.jl` balances its
# workers by, and the standards tests hold to the time budget.

const TIMES_FILE = joinpath(@__DIR__, "item_times.tsv")

# The suite's time budget: the recorded item times, split across `workers`
# processes the way `runtests.jl` splits them, finish within `minutes`.
const TEST_BUDGET = (; minutes = 15, workers = 4)

# Item names are unique across the suite, so a name keys the recorded times.
function read_times(path = TIMES_FILE)
    times = Dict{String, Float64}()
    isfile(path) || return times
    for line in eachline(path)
        (isempty(line) || startswith(line, '#')) && continue
        secs, name = split(line, '\t'; limit = 2)
        times[name] = parse(Float64, secs)
    end
    return times
end

# The names of the items the default run selects, read from the test files:
# every `@testitem` under `test/` but the AD and pending use-case ones.
function default_items(dir = @__DIR__)
    names = String[]
    for (root, _, files) in walkdir(dir), file in files
        endswith(file, ".jl") || continue
        for line in eachline(joinpath(root, file))
            m = match(r"^@testitem \"([^\"]+)\"(.*)$", line)
            m === nothing && continue
            occursin(r":(ad|usecase_pending)\b", m.captures[2]) && continue
            push!(names, m.captures[1])
        end
    end
    return names
end

# Longest recorded item first onto the least loaded worker. An item with no
# recorded time weighs as much as the median recorded item.
function assign(names, times, n)
    known = [times[k] for k in names if haskey(times, k)]
    fallback = isempty(known) ? 1.0 : sort(known)[cld(length(known), 2)]
    weight(k) = get(times, k, fallback)
    load = zeros(n)
    shard = Dict{String, Int}()
    for k in sort(names; by = k -> (-weight(k), k))
        i = argmin(load)
        shard[k] = i
        load[i] += weight(k)
    end
    return shard, load
end
