include("utils.jl")

cookie = ""
input = get_aoc_input(14, cookie)

template, tmp = split(strip(input), "\n\n")
rules = Dict()
for line in eachline(IOBuffer(tmp))
    (a, b), c = split(line, " -> ")
    rules[(a, b)] = ((a, only(c)), (only(c), b))
end

function create_polymer(template, rules; steps=1)
    polymer = Dict()  # counts of each pair
    for pair in zip(template, template[2:end])
        polymer[pair] = get(polymer, pair, 0) + 1
    end
    for _ in 1:steps
        new = Dict()
        for pair in keys(polymer)
            if pair in keys(rules)
                pair1, pair2 = rules[pair]
                new[pair1] = get(new, pair1, 0) + polymer[pair]
                new[pair2] = get(new, pair2, 0) + polymer[pair]
            else
                new[pair] = polymer[pair]
            end
        end
        polymer = new
    end
    polymer
end

"""Count unique elements in a polymer."""
function counter(polymer, last)
    d = Dict{Any, Int}(last => 1)  # we need to count the last element separately
    for (pair, n) in polymer
        d[pair[1]] = get(d, pair[1], 0) + n  # count only first element of a pair
    end
    d
end

polymer = create_polymer(template, rules, steps=10)
counts = counter(polymer, template[end])
println("Answer 1: ", maximum(values(counts)) - minimum(values(counts)))

polymer = create_polymer(template, rules, steps=40)
counts = counter(polymer, template[end])
println("Answer 2: ", maximum(values(counts)) - minimum(values(counts)))
