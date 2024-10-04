module optimizer
using JuMP, Gurobi

function gurobi_optimizer(c::Matrix{Int64}, w0::Int64, prizes::Vector{Int64}, penalties::Vector{Int64})
    # Calculate the total number of cities
    n = length(prizes)

    #println(n)
    
    # Create a model
    model = Model(Gurobi.Optimizer)
    set_silent(model)

    # Time: Start
    start_time = time()

    # Variables
    @variable(model, y[1:n], Bin)
    @variable(model, x[1:n, 1:n], Bin)
    @variable(model, u[1:n] >= 0)  # New variables for MTZ formulation



    # Objective
    @objective(model, Min, sum(c[i, j] * x[i, j] for i in 1:n for j in setdiff(1:n, [i])) + sum(penalties[i] * (1 - y[i]) for i in 1:n))

    # Constraints
    @constraint(model, [i in 1:n], sum(x[i, j] for j in setdiff(1:n, [i])) - y[i] == 0)
    @constraint(model, [j in 1:n], sum(x[i, j] for i in setdiff(1:n, [j])) - y[j] == 0)
    @constraint(model, sum(prizes[i] * y[i] for i in 1:n) >= w0)

    # MTZ constraints
    for i in 2:n
        for j in 2:n
            if i != j
                @constraint(model, u[i] - u[j] + n*x[i,j] <= n - 1)
            end
        end
    end

    # Ensure u[1] = 0 for the starting city
    @constraint(model, u[1] == 0)

    # Solve the model
    optimize!(model)

    # Check the optimization status
    if termination_status(model) == MOI.INFEASIBLE
        println("The model is infeasible.")
        return NaN  # or another appropriate value to indicate infeasibility
    end

    # Get the best bound value
    optimal_value = dual_objective_value(model)

    # Calculate the optimality gap
    #optimality_gap = (abs(total_travel_cost - optimal_value) / abs(total_travel_cost)) * 100

    # Time: End
    end_time = time()
    execution_time = end_time - start_time
    x = value.(model[:x])
    x = round.(Int, x)
    y = value.(model[:y])
    y = round.(Int, y)

    #println(x)
    #println(y)
    gurobi_sol = interpret_gurobi_pctsp_solution(x, y)
    @show gurobi_sol

    return optimal_value, execution_time
end

function interpret_gurobi_pctsp_solution(x::Matrix{Int64}, y::Vector{Int64}, threshold::Float64=0.5)
    n = length(y)
    visited_cities = findall(y .>= threshold)
    
    tour = Int[]
    unvisited = Set(visited_cities)
    
    while !isempty(unvisited)
        if isempty(tour)
            start = first(unvisited)
            push!(tour, start)
            delete!(unvisited, start)
        else
            current = tour[end]
            next = findfirst(j -> j in unvisited && x[current, j] >= threshold, 1:n)
            
            if next === nothing
                # If no next city found, this might be the end of a subtour
                if x[current, tour[1]] >= threshold
                    push!(tour, tour[1])  # Complete the subtour
                end
                break
            else
                push!(tour, next)
                delete!(unvisited, next)
            end
        end
    end
    
    # Check for disconnected subtours
    subtours = [tour]
    while !isempty(unvisited)
        subtour = Int[]
        start = first(unvisited)
        push!(subtour, start)
        delete!(unvisited, start)
        
        while true
            current = subtour[end]
            next = findfirst(j -> j in unvisited && x[current, j] >= threshold, 1:n)
            
            if next === nothing
                if x[current, subtour[1]] >= threshold
                    push!(subtour, subtour[1])  # Complete the subtour
                end
                break
            else
                push!(subtour, next)
                delete!(unvisited, next)
            end
        end
        
        push!(subtours, subtour)
    end
    
    return subtours
end

end