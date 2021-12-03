include("utils.jl")

cookie = ""
input = get_aoc_input(3, cookie)
data = parse.(Int16, split(strip(input)), base=2)

# part 1
report = permutedims(hcat(digits.(data, base=2, pad=ndigits(maximum(data), base=2))...))
gamma_bits = reverse(sum(report, dims=1) .> size(report, 1) / 2)
gamma = parse(Int, join(string.(gamma_bits, base=2)), base=2)
epsilon = parse(Int, join(string.(.!gamma_bits, base=2)), base=2)

println("Answer 1: ", gamma * epsilon)
