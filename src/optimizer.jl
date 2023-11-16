using JuMP, Gurobi

# Define the number of nodes (n)
n = 5  # You can change this based on your problem

# Create a Gurobi model
model = Model(Gurobi.Optimizer)

# Decision variables
@variable(model, x[1:n, 1:n], Bin)  # Binary variables x[i, j]
@variable(model, y[1:n], Bin)        # Binary variables y[i]

# Objective function
# Assuming cost_matrix is a matrix of travel costs
@objective(model, Min, sum(cost_matrix[i, j] * x[i, j] for i in 1:n, j in 1:n))

# Constraints using array comprehensions
@constraint(model, [i in 1:n], sum(x[j, i] for j in setdiff(1:n, [i])) - y[i] == 0)
@constraint(model, [j in 1:n], sum(x[i, j] for i in setdiff(1:n, [j])) - y[j] == 0)

# Additional constraint
# Replace this with your actual constraint based on the third equation in your LaTeX model
# For example, if you want to ensure the total weight of selected nodes is greater than or equal to w0
@constraint(model, sum(w[i] * y[i] for i in 1:n) >= w0)

# Solve the model
optimize!(model)

# Print the solution
println("Objective value: ", objective_value(model))
println("Optimal x:")
println(value.(x))
println("Optimal y:")
println(value.(y))