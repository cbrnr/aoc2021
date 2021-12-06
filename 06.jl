include("utils.jl")

cookie = ""
input = get_aoc_input(6, cookie)
data = parse.(Int, split(strip(input), ","))

counter = zeros(Int, 9)
for fish in data
    counter[fish + 1] += 1
end

function spawn(counter, n)
    next = copy(counter)
    for _ in 1:n
        for (i, c) in enumerate(counter)
            if c > 0
                next[i] -= c
                if i == 1
                    next[7] += c
                    next[9] += c
                else
                    next[i - 1] += c
                end
            end
        end
        counter = copy(next)
    end
    counter
end

println("Answer 1: ", sum(spawn(counter, 80)))
println("Answer 2: ", sum(spawn(counter, 256)))
