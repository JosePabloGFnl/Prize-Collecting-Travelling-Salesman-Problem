module heuristic_1
include("minimum_profit.jl")
include("local_search.jl")
include("optimizer.jl")
using DotEnv, .minimum_profit, DelimitedFiles, .local_search, .optimizer
DotEnv.load()
#Nearest Neighbor-type Heuristic

function nearest_neighbor_heuristic(cities_file::AbstractString, distances::Array)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    n = size(cities, 1)

    # variable initialization
    I = [cities[1, 1]]
    recollected_prize = cities[1, 2]
    total_travel_cost = 0

    # Initialize able_to_visited with city IDs as keys and city data as values
    able_to_visited = Dict(cities[i, 1] => cities[i, :] for i in 2:size(cities, 1))

    # In your loop where you're building the tour
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)

        # Calculate prize to cost ratios for each city in able_to_visited
        prize_cost_ratios = Dict(city_id => able_to_visited[city_id][2] / (distances[I[end], city_id] - able_to_visited[city_id][3]) for city_id in keys(able_to_visited))

        # Select the city with the minimum prize_cost_ratios
        added_city_id = argmax(prize_cost_ratios)[1]
        added_city = able_to_visited[added_city_id]

        recollected_prize += added_city[2]
        total_travel_cost += distances[added_city_id]

        push!(I, added_city_id)
        delete!(able_to_visited, added_city_id)
    end

    #Connecting first and last city in the tour
    push!(I, I[1])
    total_travel_cost += distances[I[end-1], I[end]]

    # Sum of Penalties into the total travel cost
    total_travel_cost += sum(city[3] for city in values(able_to_visited))

    prizes = cities[:, 2]
    penalties = cities[:, 3]

    # Local Search improvement
    improved_travel_cost = local_search.node_swap(cities_file, total_travel_cost, recollected_prize, I, distances)

    # Call the gurobi_optimizer function
    optimal_value, optimality_gap = optimizer.gurobi_optimizer(distances, minimum_profit, prizes, penalties, improved_travel_cost)

    return recollected_prize, total_travel_cost, improved_travel_cost, optimal_value, optimality_gap
end

end