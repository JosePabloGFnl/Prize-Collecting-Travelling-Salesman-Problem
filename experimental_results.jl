module experimental_results
using DotEnv, DataFrames
DotEnv.load()

export experiments_table

results = DataFrame(
    "Iteration" => Int[],
    "H1 Total Travel Cost" => Float64[],
    "H1 Recollected Prize" => Int[],
    "H1 Prize/Cost Ratio" => Float64[],
    "H2 Total Travel Cost" => Float64[],
    "H2 Recollected Prize" => Int[],
    "H2 Prize/Cost Ratio" => Float64[]
)

function experiments_table(iteration, total_travel_cost_h1::Float64, recollected_prize_h1::Int, total_travel_cost_h2::Float64, recollected_prize_h2::Int)
    push!(results, (iteration, total_travel_cost_h1, recollected_prize_h1, recollected_prize_h1 / total_travel_cost_h1, total_travel_cost_h2, recollected_prize_h2, recollected_prize_h2 / total_travel_cost_h2))
    return results
end

end # module