module Utils

export calculate_minimum_profit

function calculate_minimum_profit(cities::Matrix)
    n = size(cities, 1)
    min_prize=parse(Int64, ENV["MIN_PRIZE"])
    max_prize=Int(round(n/2))
    return Int(round((n)*(min_prize+max_prize)/2))
end

end # module
