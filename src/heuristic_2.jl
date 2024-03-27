module heuristic_2
include("minimum_profit.jl")
include("local_search.jl")
include("optimizer.jl")
using DotEnv, .minimum_profit, DelimitedFiles, .local_search, .optimizer
DotEnv.load()
# Cheapest Insertion-type Heuristic

# Function to calculate cheapest insertion of selected city into the tour
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

    # Calculate total_travel_cost as the round trip distance from city 1 to min_from_1
    total_travel_cost = dist_mat[1, min_from_1] + dist_mat[min_from_1, 1]

    I = [1, min_from_1, 1]

    # Initialize able_to_visited with city IDs as keys and city data as values
    able_to_visited = Dict(cities[i, 1] => cities[i, :] for i in 2:size(cities, 1) if cities[i, 1] != min_from_1)

    recollected_prize = sum(cities[in.(cities[:, 1], Ref(I)), 4])

    #while loop that ends when all cities are visited or the recollected prize in the tour is greater than the minimum profit
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)
        # Calculate prize to total travel cost ratios for each city in able_to_visited
        prize_cost_ratios = Dict(city_id => able_to_visited[city_id][4] / (total_travel_cost - able_to_visited[city_id][5]) for city_id in keys(able_to_visited))

        # Select the city with the maximum prize to total travel cost ratio
        added_city_id = argmax(prize_cost_ratios)[1]
        added_city = able_to_visited[added_city_id]

        recollected_prize += added_city[4]

        # Insertion phase
        distances = calculate_distances(cities, added_city, I)
        # Update tour
        insert!(I, argmin(distances) + 1, added_city[1])
        total_travel_cost += distances[argmin(distances)]
        # Remove city from able_to_visited set
        delete!(able_to_visited, added_city_id)
    end

    # Sum of Penalties into the total travel cost
    total_travel_cost += sum(city[5] for city in values(able_to_visited))

    prizes = cities[:, 4]
    penalties = cities[:, 5]

    # Call the gurobi_optimizer function
    optimal_value, optimality_gap = optimizer.gurobi_optimizer(dist_mat, minimum_profit, prizes, penalties, total_travel_cost)

    improved_travel_cost = local_search.node_swap(cities_file, total_travel_cost, recollected_prize, I)

    return recollected_prize, total_travel_cost, improved_travel_cost, optimal_value, optimality_gap
end

end