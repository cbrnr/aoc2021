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

"""Count unique elements in an array."""
function counter(array)
    d = Dict{Any, Int}()
    for x in array
        d[x] = get(d, x, 0) + 1
    end
    d
end

function find_paths(graph, current, path; visit="once")
    current == "end" && return [path]  # reached end node
    result = []  # new path
    for node in graph[current]
        condition = all(c -> isuppercase(c), node) || node ∉ path
        if visit == "twice"
            smalls = [s for s in path if all(islowercase.(collect(s)))]
            condition = condition || maximum(values(counter(smalls))) == 1
        end
        if condition
            result = vcat(result, find_paths(graph, node, vcat(path, node), visit=visit))
        end
    end
    result
end

graph = create_graph(data)
println("Answer 1: ", length(find_paths(graph, "start", Vector{String}())))
println("Answer 2: ", length(find_paths(graph, "start", Vector{String}(), visit="twice")))
