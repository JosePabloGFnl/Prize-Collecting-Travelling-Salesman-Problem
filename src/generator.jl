module generator
using DataFrames, DotEnv, DelimitedFiles, LinearAlgebra
DotEnv.load()

function instance_generator(iteration::Int)
    cities = parse(Int64, ENV["QUANTITY_CITIES"])
    min_distance = parse(Int64, ENV["MIN_DISTANCE"])
    max_distance = parse(Int64, ENV["MAX_DISTANCE"])
    min_prize = parse(Int64, ENV["MIN_PRIZE"])
    max_prize = parse(Int64, ENV["MAX_PRIZE"])

    # Create a DataFrame to store city prizes and penalties
    df = DataFrame(city = 1:cities, 
                prize = rand(min_prize:max_prize,cities),
                penalty = rand(min_prize:max_prize,cities)
                )

    # Create a distance matrix
    distances = tril(rand(min_distance:max_distance, cities, cities))
    distances = distances + distances' - diagm(diag(distances))  # Make the matrix symmetric
    distances[diagind(distances)] .= 0  # Set diagonal elements to 0

    filename = (ENV["GENERATED_FILE"] * string(iteration) * ".txt")
    writedlm(filename, Matrix(df))

    return filename, distances

end

end