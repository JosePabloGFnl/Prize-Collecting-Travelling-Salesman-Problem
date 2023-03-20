module Utils

export calculate_minimum_profit

function calculate_minimum_profit(cities::Matrix)
    n = size(cities, 1)
    min_prize = minimum(cities[:, 4])
    max_prize = maximum(cities[:, 4])
    return Int(round((n)*(min_prize+max_prize)/2))
end

end # module
