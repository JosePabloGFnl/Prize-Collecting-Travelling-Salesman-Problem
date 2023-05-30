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

    # Create a DataFrame from the remaining rows
    cities = cities[setdiff(1:end, [1,2]), :]
    minimum_profit = calculate_minimum_profit(cities)

    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3)) 
    
    Improve = true

    while (Improve = true)
        last = copy(I)
        city_to_remove = cities[rand(I), :]
        city_to_add = cities[rand(setdiff(cities[:, 1], I)), :]
        I = replace(last, city_to_remove[1] => city_to_add[1])

        
        # Calculate the indices of the city to remove and add
        idx = findall(x -> x == city_to_remove[1], last)

        # Check if the city to remove is at the beginning or end of the tour
        if idx[1] == 1
            prev_city = last[end]
        else
            prev_city = last[idx[1] - 1]
        end

        if idx[end] == length(last)
            next_city = last[1]
        else
            next_city = last[idx[end] + 1]
        end

        # Update the tour_travel_cost variable
        tour_travel_cost = total_travel_cost - (dist_mat[city_to_remove[1], prev_city] + dist_mat[city_to_remove[1], next_city])
        tour_travel_cost = tour_travel_cost + (dist_mat[city_to_add[1], prev_city] + dist_mat[city_to_add[1], next_city])

    end

end

cities, I = node_swap(ENV["GENERATED_FILE"])
println(cities)
println(I)