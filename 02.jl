include("utils.jl")

cookie = ""
input = get_aoc_input(2, cookie)
data = split(strip(input), "\n")

# part 1
function part1()
    horizontal = depth = 0
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
    horizontal * depth
end

println("Answer 1: ", part1())

# part 2
function part2()
    aim = horizontal = depth = 0
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
    horizontal * depth
end

println("Answer 2: ", part2())
