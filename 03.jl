include("utils.jl")

cookie = ""
input = get_aoc_input(3, cookie)
data = parse.(Int16, split(strip(input)), base=2)

# part 1
function bits_to_int(bits)
    parse(Int, join(string.(bits, base=2)), base=2)
end

pad = ndigits(maximum(data), base=2)
report = reverse(permutedims(hcat(digits.(data, base=2, pad=pad)...)), dims=2)
gamma_bits = sum(report, dims=1) .> size(report, 1) / 2
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

o2 = find_rating(report, >=)
co2 = find_rating(report, <)

println("Answer 2: ", o2 * co2)
