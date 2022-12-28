using CSV
using DataFrames

cities = 10

df = DataFrame(city = 1:cities, 
               x_axis = rand(0:99,cities),
               y_axis = rand(0:99,cities),
               prize = rand(0:99,cities)
               )

CSV.write("generated_cities.csv", df)