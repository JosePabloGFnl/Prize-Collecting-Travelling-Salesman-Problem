include("Utils.jl")
include("generator.jl")
include("heuristic_1.jl")
include("heuristic_2.jl")
using DotEnv, DelimitedFiles, BenchmarkTools
import .generator, .heuristic_1, .heuristic_2
DotEnv.load()

iterations = parse(Int64, ENV["ITERATIONS"])

for i in 1:iterations
    filename = generator.instance_generator(i)
    recollected_prize_h1, total_travel_cost_h1 = heuristic_1.nearest_neighbor_heuristic(filename)
    recollected_prize_h2, total_travel_cost_h2 = heuristic_2.cheapest_insertion_heuristic(filename)

end

