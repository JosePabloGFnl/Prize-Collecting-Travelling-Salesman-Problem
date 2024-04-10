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
    "Optimalimal Value H1" => Float64[],
    "Optimality Gap H1" => Float64[],
    "LS H1 Time" => Float64[],
    "Gurobi H1 Time" => Float64[],
    "Improved? H1" => String[],
    "H2 Total Travel Cost" => Float64[],
    "H2 Recollected Prize" => Int[],
    "H2 Prize/Cost Ratio" => Float64[],
    "H2 Local Search Total Travel Cost" => Float64[],
    "Optimalimal Value H2" => Float64[],
    "Optimality Gap H2" => Float64[],
    "LS H2 Time" => Float64[],
    "Gurobi H2 Time" => Float64[],
    "Improved? H2" => String[],
)

function experiments_table(iteration, total_travel_cost_h1::Int, recollected_prize_h1::Int, improved_travel_cost_h1::Int, optimal_value_h1::Float64, optimality_gap_h1::Float64, h1_ls_time, gurobi_time_h1, total_travel_cost_h2::Int, recollected_prize_h2::Int, improved_travel_cost_h2::Int, optimal_value_h2::Float64, optimality_gap_h2::Float64, h2_ls_time, gurobi_time_h2)
    push!(results, (iteration, total_travel_cost_h1, recollected_prize_h1, recollected_prize_h1 / total_travel_cost_h1, improved_travel_cost_h1, optimal_value_h1, optimality_gap_h1, h1_ls_time, gurobi_time_h1, total_travel_cost_h1 > improved_travel_cost_h1 ? "Yes" : "No", total_travel_cost_h2, recollected_prize_h2, recollected_prize_h2 / total_travel_cost_h2, improved_travel_cost_h2, optimal_value_h2, optimality_gap_h2, h2_ls_time, gurobi_time_h2, total_travel_cost_h2 > improved_travel_cost_h2 ? "Yes" : "No"))
    return results
end

end # module