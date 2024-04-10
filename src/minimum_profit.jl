module minimum_profit
using DotEnv, Statistics
DotEnv.load()

export calculate_minimum_profit

function calculate_minimum_profit(cities::Matrix)
    n = size(cities, 1)
    alpha=parse(Float64, ENV["ALPHA"])
    mean = Statistics.mean(cities[:, 2])
    return Int(round((n*alpha)*(mean)))
end

end
