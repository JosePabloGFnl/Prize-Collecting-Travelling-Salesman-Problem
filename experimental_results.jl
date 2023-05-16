module experimental_results
using DotEnv, DataFrames
DotEnv.load()

export experiments_table

function experiments_table(total_travel_cost::Float64, recollected_prize::Int)
    results = DataFrame(
        "Total Travel Cost" => Float64[],
        "Recollected Prize" => Int[],
        "Prize/Cost Ratio" => Float64[]
    )
    push!(results, (total_travel_cost, recollected_prize, recollected_prize / total_travel_cost))
    return results
end

end # module