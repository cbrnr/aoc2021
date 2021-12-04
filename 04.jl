include("utils.jl")

cookie = ""
input = get_aoc_input(4, cookie)

# part 1
data = split(strip(input), "\n\n")
numbers = parse.(Int, split(data[1], ","))

boards = Array{Int}(undef, 5, 5, length(data) - 1)
for (i, board) in enumerate(eachslice(boards, dims=3))
    board .= parse.(Int, hcat(split.(split(data[i + 1], "\n"))...))'
end

function is_bingo(mask)
    any(sum(mask, dims=1) .== 5) || any(sum(mask, dims=2) .== 5)
end

function play_bingo(boards, numbers; n=1)
    mask = zeros(Bool, size(boards))
    winners = []
    for number in numbers
        mask[boards .== number] .= 1
        for (i, m) in enumerate(eachslice(mask, dims=3))
            is_bingo(m) && !(i in winners) && push!(winners, i)
            if length(winners) == n
                return sum(boards[m .== 0, i]) * number
            end
        end
    end
end

score = play_bingo(boards, numbers)
println("Answer 1: ", score)

# part 2
score = play_bingo(boards, numbers, n=length(data) - 1)
println("Answer 2: ", score)
