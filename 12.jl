include("utils.jl")

cookie = ""
input = get_aoc_input(12, cookie)
data = split.(split(strip(input)), "-")

function create_graph(data)
    graph = Dict{String, Vector{String}}()
    for (l, r) in data
        if l ≠ "end" && r ≠ "start"  # do not include "end" as a node and "start" as a child
            graph[l] = push!(get(graph, l, []), r)
        end
        if r ≠ "end" && l ≠ "start"
            graph[r] = push!(get(graph, r, []), l)
        end
    end
    graph
end

function find_paths(graph, current, path)
    current == "end" && return [path]  # reached end node
    result = []  # new path
    for node in graph[current]
        if all(c -> isuppercase(c), node) || node ∉ path
            result = vcat(result, find_paths(graph, node, vcat(path, node)))
        end
    end
    result
end

graph = create_graph(data)
paths = find_paths(graph, "start", Vector{String}())
println("Answer 1: ", length(paths))
