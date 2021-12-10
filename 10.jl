include("utils.jl")

cookie = ""
input = get_aoc_input(10, cookie)
data = split(strip(input))

function parse_line(s)
    parens = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
    points = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    queue = Char[]
    for c in s
        c in keys(parens) && push!(queue, c)  # open
        if c in values(parens)  # close
            if (expected = parens[pop!(queue)]) ≠ c
                println("Syntax error, expected $expected but got $c.")
                return points[c]
            end
        end
    end
    if !isempty(queue)
        println("Incomplete line.")
    else
        println("No syntax errors found.")
    end
    return 0
end

println("Answer 1: ", sum(parse_line.(data)))
