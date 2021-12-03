include("utils.jl")

cookie = ""
input = get_aoc_input(1, cookie)
data = parse.(Int, split(strip(input)))

# part 1
println("Answer 1: ", sum(diff(data) .> 0))

# part 2
"""
    rolling_sum(x, n)

Compute the rolling sums of a sliding window containing `n` elements from `x`.
"""
function rolling_sum(x::Vector{<:Integer}, n::Integer)
    result = zeros(Int, length(x) - n + 1, n)
    for i in 1:length(x) - (n - 1)
        result[i, :] = x[i:i + n - 1]
    end
    dropdims(sum(result, dims=2), dims=2)
end

println("Answer 2: ", sum(diff(rolling_sum(data, 3)) .> 0))
