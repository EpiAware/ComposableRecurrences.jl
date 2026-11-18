# PACKAGE-OWNED: the unit suite's time budget. The recorded item times,
# spread over the workers, fit within the budget in `test/item_times.jl`.

@testitem "Time budget: recorded item times fit the budget" tags = [:quality] begin
    include(joinpath(@__DIR__, "..", "item_times.jl"))
    times = read_times()
    names = default_items()
    @test !isempty(times)
    @test length(names) > 300
    # An item with no recorded time weighs as much as the median one.
    _, load = assign(names, times, TEST_BUDGET.workers)
    # Re-record with `julia --project=test test/runtests.jl record_times`.
    @test maximum(load) / 60 <= TEST_BUDGET.minutes
end
