include("Utils.jl")
include("generator.jl")
include("heuristic_1.jl")
using DotEnv, DelimitedFiles, BenchmarkTools
import .generator, .heuristic_1
DotEnv.load()

iterations = parse(Int64, ENV["ITERATIONS"])

for i in 1:iterations
    filename = generator.instance_generator(i)
    recollected_prize, total_travel_cost = heuristic_1.nearest_neighbor_heuristic(filename)

end

