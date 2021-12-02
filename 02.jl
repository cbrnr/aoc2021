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
input = get_aoc_input(2, cookie)
data = split(strip(input), "\n")

# part 1
horizontal, depth = 0, 0
for command in data
    direction, units = split(command)
    units = parse(Int, units)
    if direction == "forward"
        horizontal += units
    elseif direction == "down"
        depth += units
    elseif direction == "up"
        depth -= units
    end
end

println("Answer 1: ", horizontal * depth)

# part 2
aim, horizontal, depth = 0, 0, 0
for command in data
    direction, units = split(command)
    units = parse(Int, units)
    if direction == "forward"
        horizontal += units
        depth += aim * units
    elseif direction == "down"
        aim += units
    elseif direction == "up"
        aim -= units
    end
end

println("Answer 2: ", horizontal * depth)
