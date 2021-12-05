include("utils.jl")

cookie = ""
input = get_aoc_input(5, cookie)
data = split(strip(input), "\n")

# part 1
lines = Matrix{Int}(undef, length(data), 4)
for (i, line) ∈ enumerate(data)
    fromto = join(split(line, " -> "), ",")
    lines[i, :] = parse.(Int, split(fromto, ","))
end
lines .+= 1  # 1-based indexing

diagram = zeros(Int, maximum(lines[:, [1, 3]]), maximum(lines[:, [2, 4]]))

function add_line(line, diagram; diagonal=false)
    if line[1] == line[3]  # vertical line
        from, to = line[2] < line[4] ? line[[2, 4]] : line[[4, 2]]
        diagram[from:to, line[1]] .+= 1
    elseif line[2] == line[4]  # horizontal line
        from, to = line[1] < line[3] ? line[[1, 3]] : line[[3, 1]]
        diagram[line[2], from:to] .+= 1
    elseif diagonal  # diagonal line
        x_step = line[1] < line[3] ? 1 : -1
        y_step = line[2] < line[4] ? 1 : -1
        index = CartesianIndex.(line[2]:y_step:line[4], line[1]:x_step:line[3])
        diagram[index] .+= 1
    end
end

for line in eachrow(lines)
    add_line(line, diagram)
end
println("Answer 1: ", sum(diagram .≥ 2))

# part 2
diagram = zeros(Int, maximum(lines[:, [1, 3]]), maximum(lines[:, [2, 4]]))
for line in eachrow(lines)
    add_line(line, diagram, diagonal=true)
end
println("Answer 2: ", sum(diagram .≥ 2))
