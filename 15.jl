include("utils.jl")

cookie = ""
input = get_aoc_input(15, cookie)
cost = permutedims(hcat([parse.(Int, x) for x in collect.(split(strip(input)))]...))

function min_path(path, unvisited)
    nrows, ncols = size(path)
    m = typemax(Int)
    row, col = 0, 0
    for i in 1:nrows
        for j in 1:ncols
            if unvisited[i, j] && path[i, j] < m
                m = path[i, j]
                row, col = i, j
            end
        end
    end
    m, [row, col]
end

"""Dijkstra's shortest path algorithm (from top left to bottom right)."""
function shortest_path(cost)
    nrows, ncols = size(cost)
    path = fill(typemax(Int), size(cost))  # fill with "integer infinity"
    path[1, 1] = 0  # source at top left
    unvisited = ones(Bool, size(path))

    while any(unvisited)
        v, loc = min_path(path, unvisited)
        unvisited[loc...] = 0
        neighbors = [loc - [1, 0], loc + [1, 0], loc - [0, 1], loc + [0, 1]]
        neighbors = [n for n in neighbors if 0 < n[1] ≤ nrows && 0 < n[2] ≤ ncols]
        for n in neighbors
            if (d = v + cost[n...]) < path[n...]
                path[n...] = d
            end
        end
    end

    path[end, end]  # destination at bottom right
end

println("Answer 1: ", shortest_path(cost))
