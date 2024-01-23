module heuristic_2
include("minimum_profit.jl")
include("local_search.jl")
include("optimizer.jl")
using DotEnv, .minimum_profit, DelimitedFiles, .local_search, .optimizer
DotEnv.load()
#Cheapest Insertion-type Heuristic

function calculate_distances(cities, added_city, I)
    distances = [sqrt((added_city[2] - cities[I[i], 2])^2 + (added_city[3] - cities[I[i], 3])^2) +
                 sqrt((added_city[2] - cities[I[i+1], 2])^2 + (added_city[3] - cities[I[i+1], 3])^2) -
                 sqrt((cities[I[i+1], 2] - cities[I[i], 2])^2 + (cities[I[i+1], 3] - cities[I[i], 3])^2)
                 for i in 1:length(I)-1]
    return distances
end

function cheapest_insertion_heuristic(cities_file::AbstractString)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3))

    #function for minimum distance
    min_from_1 = cities[(argmin(dist_mat[2:end, 1]) + 1), 1]

    total_travel_cost = (dist_mat[1, argmin(dist_mat[2:end, 1])])*2

    I = [1, min_from_1, 1]

    able_to_visited = setdiff(cities[:, 1], I)

    recollected_prize = sum(cities[in.(cities[:, 1], Ref(I)), 4])

    #while loop that ends when all cities are visited or the recollected prize in the tour is greater than the minimum profit
    #for some reason, operands & and | work as opposites in Julia
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)

        #checks the distances by coordinates between the selected city and the available
        prize_cost_ratios = cities[able_to_visited, 4] ./ total_travel_cost

        added_city_idx = argmax(prize_cost_ratios)
        added_city = cities[able_to_visited[added_city_idx], :]

        recollected_prize += added_city[4]

        #Insertion phase
        distances = calculate_distances(cities, added_city, I)
    
        # Update tour
        insert!(I, argmin(distances) + 1, added_city[1])
        total_travel_cost += distances[argmin(distances)]
    
        # Remove city from able_to_visited set
        able_to_visited = setdiff(cities[:, 1], I)

    end
    # Assuming that the fourth column of the cities DataFrame contains the prizes
    prizes = cities[:, 4]

    # Call the gurobi_optimizer function
    optimal_value, optimality_gap = optimizer.gurobi_optimizer(dist_mat, minimum_profit, prizes, total_travel_cost)

    improved_travel_cost = local_search.node_swap(cities_file, total_travel_cost, recollected_prize, I)

    return recollected_prize, total_travel_cost, improved_travel_cost, optimal_value, optimality_gap
end

end