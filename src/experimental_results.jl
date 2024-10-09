module experimental_results

using DataFrames

# Define the DataFrame with column names
results = DataFrame(
    "Iteration" => Int[],
    "H1 Total Travel Cost" => Float64[],
    "H1 Local Search Total Travel Cost" => Float64[],
    "Optimal Value" => Float64[],
    "Optimality Gap H1" => Float64[],
    "LS H1 Time" => Float64[],
    "Gurobi Time" => Float64[],
    "Improved? H1" => String[],
    "H2 Total Travel Cost" => Float64[],
    "H2 Local Search Total Travel Cost" => Float64[],
    "Optimality Gap H2" => Float64[],
    "LS H2 Time" => Float64[],
    "Improved? H2" => String[],
)

function experiments_table(iteration, total_travel_cost_h1::Int, improved_travel_cost_h1::Int, optimal_value::Float64, h1_ls_time, gurobi_time, total_travel_cost_h2::Int, improved_travel_cost_h2::Int, h2_ls_time)
    push!(results, (
        iteration,
        total_travel_cost_h1,
        improved_travel_cost_h1,
        optimal_value,
        ((abs(improved_travel_cost_h1 - optimal_value) / abs(improved_travel_cost_h1)) * 100),
        h1_ls_time,
        gurobi_time,
        total_travel_cost_h1 > improved_travel_cost_h1 ? "Yes" : "No",
        total_travel_cost_h2,
        improved_travel_cost_h2,
        ((abs(improved_travel_cost_h2 - optimal_value) / abs(improved_travel_cost_h2)) * 100),
        h2_ls_time,
        total_travel_cost_h2 > improved_travel_cost_h2 ? "Yes" : "No"
    ))
    return results
end

end # module