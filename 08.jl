include("utils.jl")

cookie = ""
input = get_aoc_input(8, cookie)

data = split.(split(strip(input), "\n"), " | ")
inputs = split.([s[1] for s in data])
outputs = split.([s[2] for s in data])

lens = [length.(output) for output in outputs]

println("Answer 1: ", sum(count.(i -> i in [2, 3, 4, 7], lens)))


sorted(s) = String(sort(collect(s)))


function infer_digits(pattern)
    pattern = sorted.(pattern)
    numbers = Dict{Int, AbstractString}()
    numbers[1] = pattern[length.(pattern) .== 2][1]  # 2 segments correspond to 1
    numbers[4] = pattern[length.(pattern) .== 4][1]  # 4 segments correspond to 4
    numbers[7] = pattern[length.(pattern) .== 3][1]  # 3 segments correspond to 7
    numbers[8] = pattern[length.(pattern) .== 7][1]  # 7 segments correspond to 8
    six = pattern[length.(pattern) .== 6]  # 6 segments can be 0, 6, or 9
    numbers[9] = six[length.(symdiff.(six, numbers[4])) .== 2][1]
    six = six[six .!= numbers[9]]
    numbers[0] = six[length.(symdiff.(six, numbers[1])) .== 4][1]
    numbers[6] = six[six .!= numbers[0]][1]
    five = pattern[length.(pattern) .== 5]  # 5 segments can be 2, 3, or 5
    numbers[5] = five[length.(symdiff.(five, numbers[6])) .== 1][1]
    five = five[five .!= numbers[5]]
    numbers[3] = five[length.(symdiff.(five, numbers[9])) .== 1][1]
    numbers[2] = five[five .!= numbers[3]][1]
    Dict(values(numbers) .=> keys(numbers))
end


function decode_output(pattern, mapping)
    parse(Int, join(getindex.((mapping,), sorted.(pattern))))
end


println("Answer 2: ", sum(decode_output.(outputs, infer_digits.(inputs))))
