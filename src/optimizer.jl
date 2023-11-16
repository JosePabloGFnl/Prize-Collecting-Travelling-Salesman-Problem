using JuMP, Gurobi

#Create Gurobi model
model = Model(Gurobi.Optimizer)

#Define Decision Variables
@variable(model, x >= 0)
@variable(model, y >= 0)

#Set Objective Function
@objective(model, Max, 2x + 3y)

#Add Constraints
@constraint(model, x + y <= 10)
@constraint(model, 2x - y <= 5)

#Optimize the Model
optimize!(model)

#Retrieve and Print the Solution
println("Optimal x = ", value(x))
println("Optimal y = ", value(y))
println("Optimal objective value = ", objective_value(model))