include("utils.jl")

using Statistics

cookie = ""
input = get_aoc_input(3, cookie)
data = parse.(Int16, split(strip(input)), base=2)  # input data as vector of integers
data = reverse(vcat(digits.(data, base=2, pad=ndigits(maximum(data), base=2))'...), dims=2)

# part 1
function bits_to_int(bits)
    parse(Int, join(string.(bits, base=2)), base=2)
end

gamma_bits = Bool.(round.(Int, mean(data, dims=1)))
gamma = bits_to_int(gamma_bits)
epsilon = bits_to_int(.!gamma_bits)

println("Answer 1: ", gamma * epsilon)

# part 2
function find_rating(bitmatrix, f)
    numbers = trues(size(bitmatrix, 1))
    for column in eachcol(bitmatrix)
        value = f(sum(column[numbers]), sum(numbers) / 2)
        numbers[column .!= value] .= 0
        sum(numbers) == 1 && return bits_to_int(bitmatrix[numbers, :])
    end
end

o2 = find_rating(data, >=)
co2 = find_rating(data, <)

println("Answer 2: ", o2 * co2)
