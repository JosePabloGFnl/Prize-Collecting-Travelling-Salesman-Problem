include("generator.jl")
include("heuristic_1.jl")
include("heuristic_2.jl")
include("experimental_results.jl")
include("minimum_profit_calc.jl")
include("optimizer.jl")
using DotEnv, DelimitedFiles, DataFrames, CSV
import .generator, .heuristic_1, .heuristic_2, .experimental_results, .minimum_profit_calc, .optimizer
DotEnv.load()

# Number of iterations
iterations = parse(Int64, ENV["ITERATIONS"])

# Generate 'cities' file and distance matrix
filename, distances = generator.instance_generator()

# Define variables to be used in the loop
cities = readdlm(filename, '\t', Int64)
n = size(cities, 1)
prizes = cities[:, 2]
penalties = cities[:, 3]
minimum_profit = minimum_profit_calc.calculate_minimum_profit(cities, n)

# Call the gurobi_optimizer function
optimal_value, gurobi_time = optimizer.gurobi_optimizer(distances, minimum_profit, prizes, penalties)

for i in 1:iterations
    total_travel_cost_h1, improved_travel_cost_h1, h1_ls_time = heuristic_1.nearest_neighbor_heuristic(cities, distances, minimum_profit, n, prizes, penalties)
    total_travel_cost_h2, improved_travel_cost_h2, h2_ls_time = heuristic_2.cheapest_insertion_heuristic(cities, distances, minimum_profit, n, prizes, penalties)
    global(results) = experimental_results.experiments_table(i, total_travel_cost_h1, improved_travel_cost_h1, optimal_value, h1_ls_time, gurobi_time, total_travel_cost_h2, improved_travel_cost_h2, h2_ls_time)
end

CSV.write(ENV["RESULTS"], results)