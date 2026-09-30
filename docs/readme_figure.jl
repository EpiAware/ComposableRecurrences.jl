# Renders docs/src/assets/readme-example.png from the README's Getting
# started example. Run with `task readme-figure`.
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

root = dirname(@__DIR__)
readme = read(joinpath(root, "README.md"), String)
example = only(match(r"```julia\n(.*?)```"s, readme).captures)
include_string(Main, example)

towns = ["A", "B", "C"]
T = size(R, 2)
long(x; kw...) = DataFrame(
    day = repeat(1:T; inner = 3), town = repeat(towns, T), value = vec(x); kw...
)
series = vcat(
    long(infections; series = "Infections"), long(reports; series = "Reports")
)

set_theme!(theme_light())
fig = Figure(size = (1000, 560))
grid = draw!(
    fig[1, 1],
    data(series) *
        mapping(:day, :value, color = :series => "", col = :town) *
        visual(Lines, linewidth = 2.5);
    axis = (xlabel = "Day", ylabel = "Count")
)
foreach(ae -> vlines!(ae.axis, [50]; color = :grey50, linestyle = :dash), grid)
legend!(fig[1, 2], grid)
ax = Axis(
    fig[2, 1]; xlabel = "Day", ylabel = "Town", yticks = (1:3, towns),
    title = "∂ total reports / ∂R"
)
hm = heatmap!(ax, 1:T, 1:3, permutedims(∂R); colormap = :viridis)
vlines!(ax, [50]; color = :white, linestyle = :dash)
Colorbar(fig[2, 2], hm)
rowsize!(fig.layout, 2, Relative(0.35))

save(joinpath(root, "docs", "src", "assets", "readme-example.png"), fig; px_per_unit = 2)
