include("Utils.jl")
using DotEnv, .Utils, DelimitedFiles
DotEnv.load()
#Nearest Neighbor-type Heuristic

function node_swap(cities_file::AbstractString)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)
    I = convert(Array, cities[1, :])
    cities = cities[setdiff(1:end, 1), :]
    minimum_profit = calculate_minimum_profit(cities)
    # calculate distances between all pairs of cities
    n = size(cities, 1)
    dist_mat = sqrt.(sum((reshape(cities[:, 2:3], 1, n, 2) .- reshape(cities[:, 2:3], n, 1, 2)).^2, dims=3))    
end

cities, I = node_swap(ENV["GENERATED_FILE"])
println(cities)
println(I)