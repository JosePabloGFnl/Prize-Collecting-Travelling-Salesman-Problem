module heuristic_1
include("local_search.jl")
using DotEnv, DelimitedFiles, .local_search
DotEnv.load()
#Nearest Neighbor-type Heuristic

function nearest_neighbor_heuristic(cities::Matrix, distances::Array, minimum_profit::Int64, n::Int64, prizes::Vector{Int64}, penalties::Vector{Int64})

    # variable initialization
    I = [cities[1, 1]]
    recollected_prize = cities[1, 2]
    total_travel_cost = 0

    # Initialize able_to_visited with city IDs as keys and city data as values
    able_to_visited = Dict(cities[i, 1] => cities[i, :] for i in 2:size(cities, 1))

    # In your loop where you're building the tour
    while (!isempty(able_to_visited))

        # Calculate prize to cost ratios for each city in able_to_visited
        prize_cost_ratios = Dict(city_id => (distances[I[end], city_id]- able_to_visited[city_id][3]) for city_id in keys(able_to_visited))

        # Select the city with the minimum prize_cost_ratios
        added_city_id = argmin(prize_cost_ratios)[1]
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
    if isempty(able_to_visited)
        total_travel_cost = total_travel_cost
    else
        total_travel_cost += sum(city[3] for city in values(able_to_visited))
    end

    # Local Search improvement
    # Swap
    #swapped_tour, improved_travel_cost, h1_ls_time = local_search.node_swap(cities, total_travel_cost, recollected_prize, I, distances, minimum_profit, n)
    #println(swapped_tour, " H1 swapped cost ", improved_travel_cost)
    # 2-opt
    two_opt_solution, improved_opt_cost, h1_opt_time = local_search.two_opt_move(I, distances, prizes, penalties, minimum_profit)
    println(two_opt_solution, " H1 2-opt cost ", improved_opt_cost)

    return total_travel_cost, improved_opt_cost, h1_opt_time
end

end