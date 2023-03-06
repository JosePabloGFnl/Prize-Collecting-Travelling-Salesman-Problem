include("Utils.jl")
using .Utils, DelimitedFiles

function nearest_neighbor_heuristic(cities_file::AbstractString)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], :, 1, 2) .- cities[:, 2:3]).^2, dims=3))

    # variable initialization
    I = [cities[1, 1]]
    able_to_visited = cities[2:end, 1]
    recollected_prize = cities[1, 2]
    total_travel_cost = 0.0

    # while loop that ends when all cities are visited or the total travel cost reaches its limit
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)
        # selects the current city to be the point of search based on the most recently inserted one in the tour
        current_city = cities[findlast(x -> x in I, cities[:, 1]), :]

        # get distances between the selected city and the available cities
        distances = dist_mat[current_city[1], findall(able_to_visited .== true), 1]
        prize_cost_ratios = cities[:, 4] ./ distances

        # add the one with the biggest prize_cost_ratio
        added_city_idx = argmax(cities[findall(in(able_to_visited), cities[:, 1]), 4] ./ distances)
        added_city = cities[findall(in(able_to_visited), cities[:, 1])[added_city_idx], :]

        recollected_prize += added_city[4]
        total_travel_cost += distances[added_city_idx]

        push!(I, added_city[1])
        able_to_visited = setdiff(able_to_visited, [added_city[1]])
    end

    return recollected_prize, total_travel_cost
end

recollected_prize, total_travel_cost = nearest_neighbor_heuristic("cities.txt")
println(recollected_prize)
println(total_travel_cost)