include("utils.jl")

cookie = ""
input = get_aoc_input(10, cookie)
data = split(strip(input))

function parse_line(s; mode="error", verbose=false)
    parens = Dict('(' => ')', '[' => ']', '{' => '}', '<' => '>')
    points_error = Dict(')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
    points_incomplete = Dict(')' => 1, ']' => 2, '}' => 3, '>' => 4)
    queue = Char[]
    for c in s
        c in keys(parens) && push!(queue, c)  # open
        if c in values(parens)  # close
            if (expected = parens[pop!(queue)]) ≠ c
                verbose && println("Syntax error, expected $expected but got $c.")
                if mode == "error"
                    return points_error[c]
                else
                    return 0
                end
            end
        end
    end
    if !isempty(queue)
        completion = reverse([parens[q] for q in queue])
        verbose && println("Incomplete line, missing closing parens: ", join(completion))
        if mode == "incomplete"
            score = 0
            for c in completion
                score = score * 5 + points_incomplete[c]
            end
            return score
        end
    else
        verbose && println("No syntax errors found.")
    end
    return 0
end

println("Answer 1: ", sum(parse_line.(data, mode="error")))

points = parse_line.(data, mode="incomplete")
points = sort(points[points .> 0])
println("Answer 2: ", points[(length(points) ÷ 2) + 1])
