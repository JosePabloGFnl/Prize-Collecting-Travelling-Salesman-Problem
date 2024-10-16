module heuristic_2
include("local_search.jl")
using DotEnv, DelimitedFiles, .local_search
DotEnv.load()
# Cheapest Insertion-type Heuristic

function cheapest_insertion_heuristic(cities::Matrix, distances::Array, minimum_profit::Int64, n::Int64, prizes::Vector{Int64}, penalties::Vector{Int64})

    #function for minimum distance
    min_from_1 = cities[(argmin(distances[2:end, 1]) + 1), 1]

    # Calculate total_travel_cost as the round trip distance from city 1 to min_from_1
    total_travel_cost = distances[1, min_from_1]

    I = [1, min_from_1]

    # Initialize able_to_visited with city IDs as keys and city data as values
    able_to_visited = Dict(cities[i, 1] => cities[i, :] for i in 2:size(cities, 1) if cities[i, 1] != min_from_1)

    recollected_prize = sum(cities[in.(cities[:, 1], Ref(I)), 2])

    #while loop that ends when all cities are visited or the recollected prize in the tour is greater than the minimum profit
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)
        # Calculate prize to total travel cost ratios for each city in able_to_visited
        prize_cost_ratios = Dict(city_id => (distances[I[end], city_id]- able_to_visited[city_id][3]) for city_id in keys(able_to_visited))

        # Select the city with the maximum prize to total travel cost ratio
        added_city_id = argmin(prize_cost_ratios)[1]
        added_city = able_to_visited[added_city_id]

        recollected_prize += added_city[2]

        # Insertion phase
        distances_insertion = [distances[I[i], added_city[1]] + distances[added_city[1], I[i+1]] - distances[I[i], I[i+1]] for i in 1:length(I)-1]
        # Add the distance for inserting the city at the last position
        distances_insertion = vcat(distances_insertion, distances[I[end], added_city[1]] + distances[added_city[1], I[1]] - distances[I[end], I[1]])
        # Update tour
        insert!(I, argmin(distances_insertion) + 1, added_city[1])
        total_travel_cost += distances_insertion[argmin(distances_insertion)]
        # Remove city from able_to_visited set
        delete!(able_to_visited, added_city_id)
    end

    # Sum of Penalties into the total travel cost
    total_travel_cost += sum(city[3] for city in values(able_to_visited))

    # Local Search improvement
    # Swap
    swapped_tour, improved_travel_cost, h2_ls_time = local_search.node_swap(cities, total_travel_cost, recollected_prize, I, distances, minimum_profit, n)
    println(swapped_tour, " H2 swapped cost ", improved_travel_cost)
    # 2-opt
    two_opt_solution, improved_opt_cost, h2_opt_time = local_search.two_opt_move(swapped_tour, distances, prizes, penalties, minimum_profit)
    println(two_opt_solution, " H2 2-opt cost ", improved_opt_cost)
    # Call the gurobi_optimizer function
    #optimal_value, optimality_gap, gurobi_time = optimizer.gurobi_optimizer(distances, minimum_profit, prizes, penalties, total_travel_cost)

    return total_travel_cost, improved_opt_cost, (h2_ls_time + h2_opt_time)
end

end