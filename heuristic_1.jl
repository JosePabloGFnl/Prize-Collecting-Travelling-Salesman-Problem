include("Utils.jl")
using CSV, DataFrames, DotEnv, .Utils
DotEnv.load()
#Neartest Neighbor-type Heuristic

function nearest_neighbor_heuristic(cities_file::AbstractString)
    # load cities data
    cities = DataFrame(CSV.File(cities_file))

    minimum_profit = calculate_minimum_profit(cities)

    # variable initialization
    I = [cities[1, :city]]
    able_to_visited = cities[.!(cities[:, :city] .∈ I), :city]
    recollected_prize = cities[1, :prize]
    total_travel_cost = 0

    # while loop that ends when all cities are visited or the total travel cost reaches its limit
    while (!isempty(able_to_visited)) && (recollected_prize < minimum_profit)
        # selects the current city to be the point of search based on the most recently inserted one in the tour
        current_city = cities[cities[!, :city] .== last(I), :]

        # checks the distances by coordinates between the selected city and the available
        cities[!,:distances] = sqrt.(((first(current_city[!,:x_axis],1)) .- cities[!,:x_axis]) .^ 2 + ((first(current_city[!,:y_axis],1)) .- cities[!,:y_axis]) .^ 2)
        cities[!,:prize_cost_ratio] = cities[!,:prize] ./ cities[!,:distances]

        # add the one with the biggest prize_cost_ratio
        added_city = cities[findall(in(able_to_visited), cities[!,:city]), :]
        added_city = added_city[sortperm(added_city[:, :prize_cost_ratio], rev=true), :]

        recollected_prize += added_city[1, :prize]
        total_travel_cost += added_city[1, :distances]

        push!(I, added_city[1, :city])
        able_to_visited = setdiff(able_to_visited, [added_city[1, :city]])
    end

    return recollected_prize, total_travel_cost
end

recollected_prize, total_travel_cost = nearest_neighbor_heuristic(ENV["GENERATED_FILE"])
println(recollected_prize)
println(total_travel_cost)