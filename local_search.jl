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
end

cities, I = node_swap(ENV["GENERATED_FILE"])
println(cities)
println(I)