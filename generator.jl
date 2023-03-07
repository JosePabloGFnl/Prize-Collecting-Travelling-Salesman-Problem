using DataFrames,DotEnv, DelimitedFiles
DotEnv.load()

cities = parse(Int64, ENV["QUANTITY_CITIES"])

df = DataFrame(city = 1:cities, 
               x_axis = rand(0:(cities*2),cities),
               y_axis = rand(0:(cities*2),cities),
               prize = rand(0:Int(round(cities/2)),cities)
               )

writedlm(ENV["GENERATED_FILE"], Matrix(df))