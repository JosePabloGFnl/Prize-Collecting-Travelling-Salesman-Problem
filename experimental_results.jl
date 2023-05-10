module experimental_results

using DotEnv, DelimitedFiles, BenchmarkTools, DataFrames
DotEnv.load()

export experiments_table

function experiments_table(total_travel_cost::Int, recollected_prize::Int)
    df = DataFrame([[],[],[]], ["Total Travel Cost", "Recollected Prize", "Prize/Cost Ratio"])
    return df
end

end # module
