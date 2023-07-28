module local_search
include("Utils.jl")
using DotEnv, .Utils, DelimitedFiles, Statistics
DotEnv.load()
#Nearest Neighbor-type Heuristic

function calculate_radius(city_to_remove::Vector, cities::Matrix, dist_mat::Array)
    n = size(cities, 1)
    alpha=parse(Float64, ENV["ALPHA"])
    mean = Statistics.mean(dist_mat[city_to_remove[1]])
    return Int(round((n*alpha)*(mean)))
end

function node_swap(cities_file::AbstractString, total_travel_cost::Float64, recollected_prize::Int, I::Array)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3)) 
    
    Improve = true
    new_travel_cost = 0

    while (Improve == true)
        last_tour = copy(I)
        city_to_remove = cities[rand(I[I .!= 1]), :]

        radius = calculate_radius(city_to_remove, cities, dist_mat)
        cities_within_radius = findall(dist_mat[city_to_remove[1], :] .<= radius)

        city_to_add = cities[rand(setdiff(cities_within_radius, I)), :]
     
        I = replace(last_tour, city_to_remove[1] => city_to_add[1])

        
        # Calculate the indices of the city to remove and add
        idx = findall(x -> x == city_to_remove[1], last_tour)

        # Check if the city to remove is at the beginning or end of the tour
        if idx[1] == 1
            prev_city = last_tour[end]
        else
            prev_city = last_tour[idx[1] - 1]
        end

        if idx[end] == length(last_tour)
            next_city = last_tour[1]
        else
            next_city = last_tour[idx[end] + 1]
        end

        # Update the tour_travel_cost variable
        new_travel_cost = total_travel_cost - (dist_mat[city_to_remove[1], prev_city] + dist_mat[city_to_remove[1], next_city])
        new_travel_cost = new_travel_cost + (dist_mat[city_to_add[1], prev_city] + dist_mat[city_to_add[1], next_city])

        new_prize = recollected_prize - city_to_remove[4] + city_to_add[4]

        if (total_travel_cost > new_travel_cost) && (new_prize >=minimum_profit)
            Improve = true
            total_travel_cost = new_travel_cost
            recollected_prize = new_prize
        else
            Improve = false
        end

    end

    return new_travel_cost

end

end