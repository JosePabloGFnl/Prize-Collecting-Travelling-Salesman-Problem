module generator
include("graph_results.jl")
using DataFrames, DotEnv, DelimitedFiles, .graph_results
DotEnv.load()

function instance_generator(iteration::Int)
    cities = parse(Int64, ENV["QUANTITY_CITIES"])
    min_axis = parse(Int64, ENV["MIN_AXIS"])
    min_prize = parse(Int64, ENV["MIN_PRIZE"])
    max_axis = parse(Int64, ENV["MAX_AXIS"])
    max_prize = parse(Int64, ENV["MAX_PRIZE"])

    df = DataFrame(city = 1:cities, 
                x_axis = rand(min_axis:max_axis,cities),
                y_axis = rand(min_axis:max_axis,cities),
                prize = rand(min_prize:max_prize,cities)
                )

    filename = (ENV["GENERATED_FILE"] * string(iteration) * ".txt")
    writedlm(filename, Matrix(df))

    graph_results.graph_cities(df)

    return filename

end

end