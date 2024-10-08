module local_search
include("minimum_profit.jl")
using DotEnv, .minimum_profit, DelimitedFiles, Statistics
DotEnv.load()
#Nearest Neighbor-type Heuristic

function node_swap(cities_file::AbstractString, total_travel_cost::Int64, recollected_prize::Int, I::Array, distances::Array)
    # load cities data
    cities = readdlm(cities_file, '\t', Int64)

    minimum_profit = calculate_minimum_profit(cities)

    n = size(cities, 1)

    new_travel_cost = 0

    able_to_replace = copy((I))

    # Randomly select a city to remove from the tour
    city_to_remove = cities[rand(able_to_replace), :]

    # Filter out cities that are already in the tour
    cities_to_add_candidates = setdiff(cities[:, 1], I)

    # Time: Start
    heuristic_start_time = time()

    while (!isempty(able_to_replace))

        if !isempty(cities_to_add_candidates)
            city_to_add = cities[rand(cities_to_add_candidates), :]
        else
            able_to_replace = setdiff(able_to_replace, city_to_remove[1])
            if isempty(able_to_replace)
                break
            else
                city_to_remove = cities[rand(able_to_replace), :]

                cities_to_add_candidates = setdiff(cities[:, 1], I)
                city_to_add = cities[rand(cities_to_add_candidates), :]
            end
        end

        # Calculate the indices of the city to remove and add
        idx = findall(x -> x == city_to_remove[1], I)

        # Check if the city to remove is at the beginning or end of the tour
        if idx[1] == 1
            prev_city = I[end]
        else
            prev_city = I[idx[1]-1]
        end

        if idx[end] == length(I)
            next_city = I[1]
        else
            next_city = I[idx[end]+1]
        end

        # Update the tour_travel_cost variable
        new_travel_cost = total_travel_cost - (distances[city_to_remove[1], prev_city] + distances[city_to_remove[1], next_city])
        new_travel_cost = new_travel_cost + (distances[city_to_add[1], prev_city] + distances[city_to_add[1], next_city])

        new_prize = recollected_prize - city_to_remove[2] + city_to_add[2]

        # Adjust the new_travel_cost by the penalties of the cities removed and added
        new_travel_cost = new_travel_cost - city_to_add[3] + city_to_remove[3]

        if (total_travel_cost > new_travel_cost) && (new_prize >= minimum_profit)
            # Perform the swap in the tour I
            replace!(I, city_to_remove[1] => city_to_add[1])

            able_to_replace = setdiff(able_to_replace, city_to_remove[1])
            if isempty(able_to_replace)
                break
            else
                city_to_remove = cities[rand(able_to_replace), :]

                total_travel_cost = new_travel_cost
                recollected_prize = new_prize
            end
        else
            cities_to_add_candidates = setdiff(cities_to_add_candidates, city_to_add[1])
        end

    end


    # Time: End
    heuristic_end_time = time()
    heuristic_execution_time = heuristic_end_time - heuristic_start_time

    return I, total_travel_cost, heuristic_execution_time

end

function two_opt_move(tour::Vector{Int}, distances::Matrix{Int64}, prizes::Vector{Int64},
    penalties::Vector{Int64}, minimum_profit::Int64)
    n = length(tour)
    improved = true
    total_prize = sum(prizes[tour])
    total_cost = calculate_tour_cost(tour, distances, penalties)

    heuristic_start_time = time()
    while improved
        improved = false
        for i in 1:n-2
            for j in i+2:n-1  # Ensure we don't reverse the entire tour
                # Create new tour with reversed segment
                new_tour = copy(tour)
                reverse!(new_tour, i + 1, j)

                # Calculate new cost and prize
                new_cost = calculate_tour_cost(new_tour, distances, penalties)
                new_prize = sum(prizes[new_tour])

                # Check if the new tour is better and meets the minimum profit
                if new_cost < total_cost && new_prize >= minimum_profit
                    tour .= new_tour
                    total_cost = new_cost
                    total_prize = new_prize
                    improved = true
                    break
                end
            end
            if improved
                break
            end
        end
    end

    heuristic_end_time = time()
    heuristic_execution_time = heuristic_end_time - heuristic_start_time

    return tour, total_cost, heuristic_execution_time
end

function calculate_tour_cost(tour::Vector{Int}, distances::Matrix{Int64}, penalties::Vector{Int64})
    cost = sum(distances[tour[i], tour[i+1]] for i in 1:length(tour)-1)
    cost += distances[tour[end], tour[1]]  # Return to start
    cost += sum(penalties[setdiff(1:length(penalties), tour)])  # Add penalties for unvisited cities
    return cost
end

end