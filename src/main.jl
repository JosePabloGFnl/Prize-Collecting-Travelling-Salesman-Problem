include("generator.jl")
include("heuristic_1.jl")
include("heuristic_2.jl")
include("experimental_results.jl")
using DotEnv, DelimitedFiles, DataFrames
import .generator, .heuristic_1, .heuristic_2, .experimental_results
DotEnv.load()

iterations = parse(Int64, ENV["ITERATIONS"])

for i in 1:iterations
    filename = generator.instance_generator(i)
    recollected_prize_h1, total_travel_cost_h1, improved_travel_cost_h1, optimal_value_h1, optimality_gap_h1 = heuristic_1.nearest_neighbor_heuristic(filename)
    recollected_prize_h2, total_travel_cost_h2, improved_travel_cost_h2, optimal_value_h2, optimality_gap_h2 = heuristic_2.cheapest_insertion_heuristic(filename)
    global(results) = experimental_results.experiments_table(i, total_travel_cost_h1, recollected_prize_h1, improved_travel_cost_h1, optimal_value_h1, optimality_gap_h1, total_travel_cost_h2, recollected_prize_h2, improved_travel_cost_h2, optimal_value_h2, optimality_gap_h2)
end

writedlm(ENV["RESULTS"], Matrix(results))