using CSV
#Nearest Neighbor-type Heuristic
using DataFrames

#variable initialization
cities = DataFrame(CSV.File("generated_cities.csv"))

@time begin
minimum_profit = 450
I = [Int64(cities[1, :city])]
able_to_visited = cities[.!(cities[:, :city] .∈ I), :city]
recollected_prize = Int64(cities[1, :prize])
total_travel_cost = 0

#while loop that ends when all cities are visited or the total travel cost reaches its limit

while (length(able_to_visited) ≠ 0) && (recollected_prize < minimum_profit)
    #selects the current city to be the point of search based on the most recently inserted one in the tour
    current_city = cities[cities[!, :city] .== last(I), :]

    #checks the distances by coordinates between the selected city and the available
    cities[!,:distances] = ((first(current_city[!,:x_axis],1)) .- cities[!,:x_axis]) .^ 2 + ((first(current_city[!,:y_axis],1)) .- cities[!,:y_axis]) .^ 2
    select(cities, :distances, :distances => ByRow(sqrt))
    cities[!,:prize_cost_ratio] = cities[!,:prize] ./ cities[!,:distances]
    
    #add the one with the biggest prize_cost_ratio
    added_city = cities[findall(in(able_to_visited), cities[!,:city]), :]
    added_city = added_city[sortperm(added_city[:, :prize_cost_ratio], rev=true), :]

    global recollected_prize += added_city[!,:prize][1]
    global total_travel_cost += added_city[!,:distances][1]
    
    append!( I, added_city[1, :city] )
    deleteat!( able_to_visited, findfirst(able_to_visited .== added_city[1, :city]) )

end

println(I)
println(recollected_prize)
println(total_travel_cost)
end