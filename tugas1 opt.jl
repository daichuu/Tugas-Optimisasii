using JuMP
import HiGHS

# Definisikan graf dengan matriks biaya
G = [
       0 1 4 0 0 0
       0 0 1 4 0 0
       0 0 0 0 3 0
       0 0 0 0 0 2
       0 2 0 3 0 2
       0 0 0 0 0 0
       ]
# Jumlah node
n = size(G, 1)

max_flow = Model(HiGHS.Optimizer)

@variable(max_flow, f[1:n, 1:n] >= 0)

@constraint(max_flow, [i = 1:n, j = 1:n], f[i, j] <= G[i, j])

@constraint(max_flow, [i = 1:n; i != 1 && i != 6], sum(f[i, :]) == sum(f[:, i]))

@objective(max_flow, Max, sum(f[1, :]))

optimize!(max_flow)

@assert is_solved_and_feasible(max_flow)

objective_value(max_flow)
