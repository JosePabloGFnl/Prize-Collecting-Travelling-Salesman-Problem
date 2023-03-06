using DataFrames, DelimitedFiles

cities = 500000

df = DataFrame(city = 1:cities, 
               x_axis = rand(0:(cities*2),cities),
               y_axis = rand(0:(cities*2),cities),
               prize = rand(0:Int(round(cities/2)),cities)
               )

writedlm("cities.txt", Matrix(df))