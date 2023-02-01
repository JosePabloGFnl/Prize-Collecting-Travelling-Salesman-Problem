using CSV
#Nearest Neighbor-type Heuristic
using DataFrames

#variable initialization
cities = DataFrame(CSV.File("generated_cities.csv"))

restriction_cost = 450
I = [first(cities.city,1)]
able_to_visited = cities[.!(cities[:, :city] .∈ I), :city]
travel_cost = 0
recollected_prize = 0

#while loop that ends when all cities are visited or the total travel cost reaches its limit

while (cities.city ∉ I) || (travel_cost < restriction_cost)
    #selects the current city to be the point of search based on the most recently inserted one in the tour
    current_city = cities[cities[!, :city] .== last(I), :]

    #checks the distances by coordinates between the selected city and the available
    cities[!,:prize_cost_ratio] = ((first(current_city[!,:x_axis],1)) .- cities[!,:x_axis]) .^ 2 + ((first(current_city[!,:y_axis],1)) .- cities[!,:y_axis]) .^ 2
    select(cities, :prize_cost_ratio, :prize_cost_ratio => ByRow(sqrt))
    cities[!,:prize_cost_ratio] = cities[!,:prize] ./ cities[!,:prize_cost_ratio]
    
    #add the one with the biggest prize_cost_ratio
    added_city = cities[cities[!, :city] .∉ (I), :]
    added_city = added_city[sortperm(max.(added_city.prize_cost_ratio); rev=true),:]
    
    push!( I, first(added_city.city,1) )

end