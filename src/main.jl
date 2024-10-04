include("generator.jl")
include("heuristic_1.jl")
include("heuristic_2.jl")
include("experimental_results.jl")
using DotEnv, DelimitedFiles, DataFrames, CSV
import .generator, .heuristic_1, .heuristic_2, .experimental_results
DotEnv.load()

iterations = parse(Int64, ENV["ITERATIONS"])

for i in 1:iterations
    filename, distances = generator.instance_generator(i)
    total_travel_cost_h1, improved_travel_cost_h1, optimal_value, h1_ls_time, gurobi_time_h1 = heuristic_1.nearest_neighbor_heuristic(filename, distances)
    total_travel_cost_h2, improved_travel_cost_h2, h2_ls_time = heuristic_2.cheapest_insertion_heuristic(filename, distances)
    global(results) = experimental_results.experiments_table(i, total_travel_cost_h1, improved_travel_cost_h1, optimal_value, h1_ls_time, gurobi_time_h1, total_travel_cost_h2, improved_travel_cost_h2, h2_ls_time)
end

CSV.write(ENV["RESULTS"], results)