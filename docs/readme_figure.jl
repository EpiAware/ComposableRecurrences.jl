# Renders docs/src/assets/readme-example.png from the README's Getting
# started example. Run with `task -t docs/Taskfile.yml readme-figure`.
using CairoMakie, AlgebraOfGraphics, DataFramesMeta

root = dirname(@__DIR__)
readme = read(joinpath(root, "README.md"), String)
example = only(match(r"```julia\n(.*?)```"s, readme).captures)
include_string(Main, example)

towns = ["A", "B", "C"]
panels = ["Daily count", "Susceptible share"]
tidy(x, series, panel) = @chain DataFrame(permutedims(x), towns) begin
    @transform(:day = 1:size(x, 2), :series = series, :panel = panel)
    stack(towns; variable_name = :town, value_name = :value)
end
susceptible = 1 .- cumsum(infections; dims = 2) ./ pop

df = vcat(
    tidy(infections, "Infections", panels[1]),
    tidy(reports, "Reports", panels[1]),
    tidy(susceptible, "Susceptible", panels[2])
)
intervention = @chain crossjoin(DataFrame(town = towns), DataFrame(panel = panels)) begin
    @transform(:start = 50, :stop = 56)
end

plt = data(intervention) *
    mapping(:start, :stop, row = :panel, col = :town) *
    visual(VSpan, color = (:grey, 0.2)) +
    data(df) *
    mapping(:day => "Day", :value => "", color = :series => "", row = :panel, col = :town) *
    visual(Lines, linewidth = 2.5)

set_theme!(theme_light())
fig = draw(
    plt; figure = (; size = (1000, 520)), facet = (; linkyaxes = :rowwise),
    axis = (; xticks = 0:25:75)
)
save(joinpath(root, "docs", "src", "assets", "readme-example.png"), fig; px_per_unit = 2)
