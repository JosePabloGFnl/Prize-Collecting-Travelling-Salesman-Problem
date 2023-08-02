# Prize-Collecting-Travelling-Salesman-Problem
 
This repo is focused on solving the prize collecting travelling salesman problem with two constructive heuristics.

## Procedure

For the inputs used in the heuristics, a file names genetaor.jl is executed with respective parameters to generate a set of cities.

The one shown in the heuristic_1.jl file is based on a Nearest Neighbor-type approach.

As for the one in the heuristic_2.jl file is based the Cheapest Insertion heuristic.

Both heuristics use Utils.jl to calculate the minimum profit to be used in the while loop.

A local search swap-move is executed in local_search.jl. This is applied to both heuristics to try to improve the given results.

Afterwards, experimental_results.jl is executed to store the results into a dataframe.

This is all executed n times for the given iterations.

### Environmental variables
``` textplain
GENERATED_FILE="cities"
MIN_AXIS=0
MIN_PRIZE=0
MAX_AXIS=1000
MAX_PRIZE=100
QUANTITY_CITIES=400
ALPHA=.6
GAMMA=11
ITERATIONS=20
```

## Alpha values

For each amount of cities used in the experiments, here are the values for Alpha in each respective instance specification.

| # of cities  | Alpha |
| ------------- | ------------- |
| 60  | .3  |
| 400  | .6  |
| 5000  | .9  |

## References

The parameters used for x and y axis positions as well as prizes were based on the following paper:

Dell’Amico, M., Maffioli, F. & Sciomachen, A. A Lagrangian heuristic for the
Prize Collecting Travelling Salesman Problem. Annals of Operations Research
81, 289–306 (1998). https://doi.org/10.1023/A:1018961208614
