include("utils.jl")

cookie = ""
input = get_aoc_input(14, cookie)

template, tmp = split(strip(input), "\n\n")
rules = Dict(Pair(rule...) for rule in [split(rule, " -> ") for rule in split(tmp, "\n")])

function create_polymer(template, rules; steps=1)
    polymer = ""
    for _ in 1:steps
        polymer = string(template[1])
        i = 1
        while i < length(template)
            pair = template[i:i + 1]
            insertion = get(rules, pair, "")
            polymer *= insertion * pair[2]
            i += 1
        end
        template = polymer
    end
    polymer
end

"""Count unique elements in an array."""
function counter(array)
    d = Dict{Any, Int}()
    for x in array
        d[x] = get(d, x, 0) + 1
    end
    d
end

polymer = create_polymer(template, rules, steps=10)
println("Answer 1: ", maximum(values(counter(polymer))) - minimum(values(counter(polymer))))
