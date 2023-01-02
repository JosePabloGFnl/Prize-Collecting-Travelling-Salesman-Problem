using CSV
using DataFrames

cities = DataFrame(CSV.File("generated_cities.csv"))

restriction_cost = 450
I = [first(cities.city,1)]
visited = [first(cities.city,1)]
travel_cost = 0
recollected_prize = 0

while cities.city ∉ visited
    
end