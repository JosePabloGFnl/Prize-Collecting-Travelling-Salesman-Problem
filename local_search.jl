include("Utils.jl")
using DotEnv, .Utils, DelimitedFiles
DotEnv.load()
#Nearest Neighbor-type Heuristic

function node_swap(cities_file::AbstractString)
    # load cities data
    cities = readdlm(cities_file, '\t', header=false)
    # Extract the header row as an array
    I = convert(Vector{Int64}, cities[1, :])

    # Extract the float value from the second row
    total_travel_cost = cities[2]
    recollected_prize = cities[3]

    # Create a DataFrame from the remaining rows
    cities = cities[setdiff(1:end, [1,2,3]), :]
    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3)) 
    
    Improve = true
    last_tour = []

    while (Improve == true)
        last_tour = copy(I)
        city_to_remove = cities[rand(I), :]
        city_to_add = cities[rand(setdiff(cities[:, 1], I)), :]
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

    return last_tour

end

last_tour = node_swap(ENV["GENERATED_FILE"])