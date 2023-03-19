using DataFrames,DotEnv, DelimitedFiles
DotEnv.load()

cities = parse(Int64, ENV["QUANTITY_CITIES"])
min_axis = parse(Int64, ENV["QUANTITY_CITIES"])
min_prize = parse(Int64, ENV["QUANTITY_CITIES"])
max_axis = parse(Int64, ENV["QUANTITY_CITIES"])
max_prize = parse(Int64, ENV["QUANTITY_CITIES"])

df = DataFrame(city = 1:cities, 
               x_axis = rand(min_axis:max_axis,cities),
               y_axis = rand(min_axis:max_axis,cities),
               prize = rand(min_prize:max_prize,cities)
               )

writedlm(ENV["GENERATED_FILE"], Matrix(df))