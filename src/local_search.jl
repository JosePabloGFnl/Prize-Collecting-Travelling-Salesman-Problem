module local_search
include("minimum_profit.jl")
using DotEnv, .minimum_profit, DelimitedFiles, Statistics
DotEnv.load()
#Nearest Neighbor-type Heuristic

function calculate_radius(city_to_remove::Vector, dist_mat::Array)
    mean = Statistics.mean(dist_mat[city_to_remove[1]])
    return mean
end

function node_swap(cities_file::AbstractString, total_travel_cost::Float64, recollected_prize::Int, I::Array)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3)) 
    
    Improve = false
    new_travel_cost = 0

    able_to_replace = copy((I))

    while (Improve == false && !isempty(able_to_replace))
        city_to_remove = cities[rand(able_to_replace), :]

        radius = calculate_radius(city_to_remove, dist_mat)
        cities_within_radius = findall(dist_mat[city_to_remove[1], :] .<= radius)

        # Filter out cities that are already in the tour
        cities_to_add_candidates = setdiff(cities_within_radius, I)

        if isempty(cities_to_add_candidates)
            break  # stop the loop
        end

        city_to_add = cities[rand(cities_to_add_candidates), :]
        
        # Calculate the indices of the city to remove and add
        idx = findall(x -> x == city_to_remove[1], I)

        # Check if the city to remove is at the beginning or end of the tour
        if idx[1] == 1
            prev_city = I[end]
        else
            prev_city = I[idx[1] - 1]
        end

        if idx[end] == length(I)
            next_city = I[1]
        else
            next_city = I[idx[end] + 1]
        end

        # Update the tour_travel_cost variable
        new_travel_cost = total_travel_cost - (dist_mat[city_to_remove[1], prev_city] + dist_mat[city_to_remove[1], next_city])
        new_travel_cost = new_travel_cost + (dist_mat[city_to_add[1], prev_city] + dist_mat[city_to_add[1], next_city])

        new_prize = recollected_prize - city_to_remove[4] + city_to_add[4]

        # Adjust the new_travel_cost by the penalties of the cities removed and added
        new_travel_cost = new_travel_cost - city_to_add[5] + city_to_remove[5]

        new_prize = recollected_prize - city_to_remove[4] + city_to_add[4]

        if (total_travel_cost > new_travel_cost) && (new_prize >=minimum_profit)
            Improve = true
            total_travel_cost = new_travel_cost
            recollected_prize = new_prize
        else
            Improve = false
            able_to_replace = setdiff(able_to_replace, city_to_remove[1])
        end

    end

    return total_travel_cost

end

end