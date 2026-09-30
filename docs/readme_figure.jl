# Renders docs/src/assets/readme-example.png from the README's Getting
# started example. Run with `task readme-figure`.
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

root = dirname(@__DIR__)
readme = read(joinpath(root, "README.md"), String)
example = only(match(r"```julia\n(.*?)```"s, readme).captures)
include_string(Main, example)

towns = ["A", "B", "C"]
tidy(x, name) = @chain DataFrame(permutedims(x), towns) begin
    @transform(:day = 1:size(x, 2))
    stack(towns; variable_name = :town, value_name = name)
end

counts = @chain vcat(
    @transform(tidy(infections, :count), :series = "Infections"),
    @transform(tidy(reports, :count), :series = "Reports")
) begin
    @rsubset(:day <= 80)
end
sensitivity = @rsubset(tidy(∂R, :gradient), :day <= 80)

set_theme!(theme_light())
fig = Figure(size = (1000, 560))
curves = draw!(
    fig[1, 1],
    data(counts) *
        mapping(:day => "Day", :count => "Count", color = :series => "", col = :town) *
        visual(Lines, linewidth = 2.5)
)
foreach(ae -> vlines!(ae.axis, 50; color = :grey50, linestyle = :dash), curves)
legend!(fig[1, 2], curves)
heat = draw!(
    fig[2, 1],
    data(sensitivity) *
        mapping(:day => "Day", :town => "Town", :gradient => "∂ total reports / ∂R") *
        visual(Heatmap, colormap = :viridis);
    axis = (xticks = 0:20:80,)
)
foreach(ae -> vlines!(ae.axis, 50; color = :white, linestyle = :dash), heat)
colorbar!(fig[2, 2], heat)
rowsize!(fig.layout, 2, Relative(0.35))

save(joinpath(root, "docs", "src", "assets", "readme-example.png"), fig; px_per_unit = 2)
