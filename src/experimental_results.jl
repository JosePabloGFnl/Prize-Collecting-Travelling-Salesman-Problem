module experimental_results
using DotEnv, DataFrames
DotEnv.load()

export experiments_table

results = DataFrame(
    "Iteration" => Int[],
    "H1 Total Travel Cost" => Float64[],
    "H1 Recollected Prize" => Int[],
    "H1 Prize/Cost Ratio" => Float64[],
    "H1 Local Search Total Travel Cost" => Float64[],
    "Gurobi Results" => Float64[],
    "Improved? H1" => String[],
    "H2 Total Travel Cost" => Float64[],
    "H2 Recollected Prize" => Int[],
    "H2 Prize/Cost Ratio" => Float64[],
    "H2 Local Search Total Travel Cost" => Float64[],
    "Improved? H2" => String[],
)

function experiments_table(iteration, total_travel_cost_h1::Float64, recollected_prize_h1::Int, improved_travel_cost_h1::Float64, gurobi_result::Float64, total_travel_cost_h2::Float64, recollected_prize_h2::Int, improved_travel_cost_h2::Float64)
    push!(results, (iteration, total_travel_cost_h1, recollected_prize_h1, recollected_prize_h1 / total_travel_cost_h1, improved_travel_cost_h1, gurobi_result, total_travel_cost_h1 > improved_travel_cost_h1 ? "Yes" : "No", total_travel_cost_h2, recollected_prize_h2, recollected_prize_h2 / total_travel_cost_h2, improved_travel_cost_h2, total_travel_cost_h2 > improved_travel_cost_h2 ? "Yes" : "No"))
    return results
end

end # module