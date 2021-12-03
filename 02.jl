include("utils.jl")

cookie = ""
input = get_aoc_input(2, cookie)
data = split(strip(input), "\n")

# part 1
let horizontal = 0, depth = 0
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
end

# part 2
let aim = 0, horizontal = 0, depth = 0
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
end
