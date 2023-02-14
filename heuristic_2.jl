using CSV
#Cheapest Insertion-type Heuristic
using DataFrames

#variable initialization
cities = DataFrame(CSV.File("generated_cities.csv"))

@time begin
minimum_profit = 450

#function for minimum distance
min_from_1 = copy(cities)
min_from_1[!,:distances] = ((first(min_from_1[1,:x_axis],1)) .- min_from_1[!,:x_axis]) .^ 2 + ((first(min_from_1[1,:y_axis],1)) .- min_from_1[!,:y_axis]) .^ 2
delete!(min_from_1, [1])
select(min_from_1, :distances, :distances => ByRow(sqrt))
min_city = findmin(min_from_1[!, :distances])[2]

I = [Int64(cities[1, :city])]

push!(I, Int64(min_from_1[min_city, :city]), 1)

able_to_visited = filter(row -> !(row[:city] in I), cities)

recollected_prize = sum(cities.prize[cities.city .∈ Ref(I)])
total_travel_cost = 0

#while loop that ends when all cities are visited or the total travel cost reaches its limit

while (length(able_to_visited) ≠ 0) && (recollected_prize < minimum_profit)

end

println(I)
println(recollected_prize)
println(total_travel_cost)
end