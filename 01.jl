using HTTP

"""
    get_aoc_input(day, cookie)

Download Advent of Code 2021 input data for the given `day`.

A valid `cookie` must be provided, for example by logging into the
[Advent of Code website](https://adventofcode.com/2021) with a browser and copying the
session cookie (accessible in the browser preferences).
"""
function get_aoc_input(day::Integer, cookie::AbstractString)
    cookies = Dict("session"=>cookie)
    r = HTTP.get("https://adventofcode.com/2021/day/$day/input", cookies=cookies)
    String(r.body)
end

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
