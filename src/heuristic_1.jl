module heuristic_1
include("minimum_profit.jl")
include("local_search.jl")
include("optimizer.jl")
using DotEnv, .minimum_profit, DelimitedFiles, .local_search, .optimizer
DotEnv.load()
#Nearest Neighbor-type Heuristic

function nearest_neighbor_heuristic(cities_file::AbstractString)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3))    

    # variable initialization
    I = [cities[1, 1]]
    recollected_prize = cities[1, 4]
    total_travel_cost = 0.0

    # Initialize able_to_visited with city IDs as keys and city data as values
    able_to_visited = Dict(cities[i, 1] => cities[i, :] for i in 2:size(cities, 1))

    # In your loop where you're building the tour
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)
        # Create a distances array mapping city IDs to distances
        distances = Dict(city_id => dist_mat[I[end], city_id] for city_id in keys(able_to_visited))

        # Calculate prize to cost ratios for each city in able_to_visited
        prize_cost_ratios = Dict(city_id => able_to_visited[city_id][4] / (dist_mat[I[end], city_id] - able_to_visited[city_id][5]) for city_id in keys(able_to_visited))

        # Select the city with the minimum prize_cost_ratios
        added_city_id = argmax(prize_cost_ratios)[1]
        added_city = able_to_visited[added_city_id]

        recollected_prize += added_city[4]
        total_travel_cost += distances[added_city_id]

        push!(I, added_city_id)
        delete!(able_to_visited, added_city_id)
    end

    #Connecting first and last city in the tour
    push!(I, I[1])
    total_travel_cost += dist_mat[I[end-1], I[end]]

    prizes = cities[:, 4]
    penalties = cities[:, 5]

    # Call the gurobi_optimizer function
    optimal_value, optimality_gap = optimizer.gurobi_optimizer(dist_mat, minimum_profit, prizes, penalties, total_travel_cost)

    improved_travel_cost = local_search.node_swap( cities_file, total_travel_cost, recollected_prize, I)

    return recollected_prize, total_travel_cost, improved_travel_cost, optimal_value, optimality_gap
end

end