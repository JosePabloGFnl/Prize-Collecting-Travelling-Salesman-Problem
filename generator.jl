using DataFrames, DotEnv, DelimitedFiles
DotEnv.load()

cities = parse(Int64, ENV["QUANTITY_CITIES"])

df = DataFrame(city = 1:cities, 
               x_axis = rand(parse(Int64, ENV["MIN_X_AXIS"]):(cities*2),cities),
               y_axis = rand(parse(Int64, ENV["MIN_Y_AXIS"]):(cities*2),cities),
               prize = rand(parse(Int64, ENV["MIN_PRIZE"]):Int(round(cities/2)),cities)
               )

writedlm("cities.txt", Matrix(df))