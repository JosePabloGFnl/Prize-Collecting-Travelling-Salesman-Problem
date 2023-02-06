using CSV
#Nearest Neighbor-type Heuristic
using DataFrames

#variable initialization
cities = DataFrame(CSV.File("generated_cities.csv"))

minimum_profit = 450
I = [Int64(cities[1, :city])]
able_to_visited = cities[.!(cities[:, :city] .∈ I), :city]
travel_cost = 0
recollected_prize = 0

#while loop that ends when all cities are visited or the total travel cost reaches its limit

while (length(able_to_visited) ≠ 0) || (recollected_prize < minimum_profit)
    #selects the current city to be the point of search based on the most recently inserted one in the tour
    current_city = cities[cities[!, :city] .== last(I), :]

    #checks the distances by coordinates between the selected city and the available
    cities[!,:prize_cost_ratio] = ((first(current_city[!,:x_axis],1)) .- cities[!,:x_axis]) .^ 2 + ((first(current_city[!,:y_axis],1)) .- cities[!,:y_axis]) .^ 2
    select(cities, :prize_cost_ratio, :prize_cost_ratio => ByRow(sqrt))
    cities[!,:prize_cost_ratio] = cities[!,:prize] ./ cities[!,:prize_cost_ratio]
    
    #add the one with the biggest prize_cost_ratio
    added_city = cities[findall(in(able_to_visited), cities[!,:city]), :]
    added_city = added_city[sortperm(added_city[:, :prize_cost_ratio], rev=true), :]
    
    append!( I, added_city[1, :city] )
    deleteat!( able_to_visited, findfirst(able_to_visited .== added_city[1, :city]) )

end