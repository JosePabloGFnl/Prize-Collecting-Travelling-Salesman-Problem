using CSV, DataFrames, DotEnv
DotEnv.load()

cities = parse(Int64, ENV["QUANTITY_CITIES"])

df = DataFrame(city = 1:cities, 
               x_axis = rand(parse(Int64, ENV["MIN_X_AXIS"]):parse(Int64, ENV["MAX_X_AXIS"]),cities),
               y_axis = rand(parse(Int64, ENV["MIN_Y_AXIS"]):parse(Int64, ENV["MAX_Y_AXIS"]),cities),
               prize = rand(parse(Int64, ENV["MIN_PRIZE"]):parse(Int64, ENV["MAX_PRIZE"]),cities)
               )

CSV.write(ENV["GENERATED_FILE"], df)