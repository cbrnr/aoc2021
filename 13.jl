include("utils.jl")

cookie = ""
input = get_aoc_input(13, cookie)

part1, part2 = split.(split(strip(input), "\n\n"), "\n")
dots = reverse(permutedims(hcat([parse.(Int, element) for element in split.(part1, ",")]...)), dims=2) .+ 1
instructions = replace.(part2, "fold along " => "")

function create_grid(dots)
    nrows, ncols = maximum(dots, dims=1)
    grid = zeros(Int, nrows, ncols)
    for dot in eachrow(dots)
        grid[dot...] = 1
    end
    grid
end

grid = create_grid(dots)

function fold_grid(grid, instructions)
    grid = copy(grid)
    for instruction in instructions
        axis, loc = split(instruction, "=")
        loc = parse(Int, loc) + 1
        if axis == "y"  # fold up
            folded = grid[1:loc - 1, :] .+ reverse(grid[loc + 1:end, :], dims=1)
        elseif axis == "x"  # fold left
            folded = grid[:, 1:loc - 1] .+ reverse(grid[:, loc + 1:end], dims=2)
        end
        folded[folded .> 1] .= 1
        grid = folded
    end
    grid
end

function print_grid(grid)
    s = ""
    for x in eachrow(code)
        for y in x
            if y == 0
                s *= " "
            else
                s *= "▮"
            end
        end
        s *= "\n"
    end
    println(s)
end

println("Answer 1: ", sum(fold_grid(grid, [instructions[1]])))
println("Answer 2:")
print_grid(fold_grid(grid, instructions))
