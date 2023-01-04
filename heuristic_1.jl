using CSV
using DataFrames

#variable initialization
cities = DataFrame(CSV.File("generated_cities.csv"))

restriction_cost = 450
I = [first(cities.city,1)]
visited = [first(cities.city,1)]
travel_cost = 0
recollected_prize = 0

#while loop that ends when all cities are visited or the total travel cost reaches its limit

while (cities.city ∉ visited) || (travel_cost < restriction_cost)
    current_city = cities[cities[!, :city] .== last(I), :]

    cities[!,:prize_cost_ratio] = ((first(current_city[!,:x_axis],1)) .- cities[!,:x_axis]) .^ 2 + ((first(current_city[!,:y_axis],1)) .- cities[!,:y_axis]) .^ 2
    select(cities, :prize_cost_ratio, :prize_cost_ratio => ByRow(sqrt))
    cities[!,:prize_cost_ratio] = cities[!,:prize] ./ cities[!,:prize_cost_ratio]
end