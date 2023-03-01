include("Utils.jl")
using CSV, DataFrames, DotEnv, .Utils
DotEnv.load()
#Cheapest Insertion-type Heuristic

function cheapest_insertion_heuristic(cities_file::AbstractString)
    #variable initialization
    cities = DataFrame(CSV.File(cities_file))

    minimum_profit = calculate_minimum_profit(cities)

    #function for minimum distance
    min_from_1 = deepcopy(cities)
    min_from_1[!,:distances] = sqrt.(((first(min_from_1[1,:x_axis],1)) .- min_from_1[!,:x_axis]) .^ 2 + ((first(min_from_1[1,:y_axis],1)) .- min_from_1[!,:y_axis]) .^ 2)
    delete!(min_from_1, [1])
    min_city = findmin(min_from_1[!, :distances])[2]

    total_travel_cost = (min_from_1[min_city, :distances])*2

    I = [Int64(cities[1, :city])]

    push!(I, Int64(min_from_1[min_city, :city]), 1)

    able_to_visited = setdiff(cities[:, :city], I)

    recollected_prize = sum(cities.prize[cities.city .∈ Ref(I)])

    #while loop that ends when all cities are visited and the recollected prize in the tour is greater than the minimum profit

    while (length(able_to_visited) ≠ 0) && (recollected_prize < minimum_profit)

        #checks the distances by coordinates between the selected city and the available
        cities[!,:prize_cost_ratio] = cities[!,:prize] ./ total_travel_cost
        
        #Selection phase
        added_city = cities[findall(in(able_to_visited), cities[!,:city]), :]
        added_city = added_city[sortperm(added_city[:, :prize_cost_ratio], rev=true), :]

        recollected_prize += added_city[1, :prize]

        #Insertion phase
        distances = [sqrt((cities[added_city[1, :city], :x_axis] - cities[I[i], :x_axis])^2 + (cities[added_city[1, :city], :y_axis] - cities[I[i], :y_axis])^2) + 
                    sqrt((cities[added_city[1, :city], :x_axis] - cities[I[i+1], :x_axis])^2 + (cities[added_city[1, :city], :y_axis] - cities[I[i+1], :y_axis])^2) -
                    sqrt((cities[I[i+1], :x_axis] - cities[I[i], :x_axis])^2 + (cities[I[i+1], :y_axis] - cities[I[i], :y_axis])^2)
                    for i in 1:length(I)-1]

        total_travel_cost += minimum(distances)
        min_index = argmin(distances)
        insert!(I, min_index+1, Int64(added_city[1, :city]))


        able_to_visited = setdiff(cities[:, :city], I)

    end
    return recollected_prize, total_travel_cost
end

recollected_prize, total_travel_cost = cheapest_insertion_heuristic(ENV["GENERATED_FILE"])
println(recollected_prize)
println(total_travel_cost)