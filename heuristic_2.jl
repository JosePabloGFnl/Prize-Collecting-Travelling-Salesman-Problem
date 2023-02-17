using CSV, DataFrames
#Cheapest Insertion-type Heuristic

function cheapest_insertion_heuristic(cities_file::AbstractString, minimum_profit::Int64)
    #variable initialization
    cities = DataFrame(CSV.File(cities_file))

    #function for minimum distance
    min_from_1 = deepcopy(cities)
    min_from_1[!,:distances] = ((first(min_from_1[1,:x_axis],1)) .- min_from_1[!,:x_axis]) .^ 2 + ((first(min_from_1[1,:y_axis],1)) .- min_from_1[!,:y_axis]) .^ 2
    delete!(min_from_1, [1])
    select(min_from_1, :distances, :distances => ByRow(sqrt))
    min_city = findmin(min_from_1[!, :distances])[2]

    total_travel_cost = min_city

    I = [Int64(cities[1, :city])]

    push!(I, Int64(min_from_1[min_city, :city]), 1)

    able_to_visited = setdiff(cities[:, :city], I)

    recollected_prize = sum(cities.prize[cities.city .∈ Ref(I)])

    #while loop that ends when all cities are visited or the total travel cost reaches its limit

    while (length(able_to_visited) ≠ 0) && (recollected_prize < minimum_profit)

        #checks the distances by coordinates between the selected city and the available
        cities[!,:prize_cost_ratio] = cities[!,:prize] ./ total_travel_cost
        
        #add the one with the biggest prize_cost_ratio
        added_city = cities[findall(in(able_to_visited), cities[!,:city]), :]
        added_city = added_city[sortperm(added_city[:, :prize_cost_ratio], rev=true), :]

        recollected_prize += added_city[1, :prize]

    end
    return I, recollected_prize, total_travel_cost
end

I, recollected_prize, total_travel_cost = nearest_neighbor_heuristic("generated_cities.csv", 450)
println(I)
println(recollected_prize)
println(total_travel_cost)