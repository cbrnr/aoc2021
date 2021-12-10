include("utils.jl")

cookie = ""
input = get_aoc_input(9, cookie)
heightmap = permutedims(parse.(Int, hcat(collect.(split(strip(input)))...)))

function find_lowpoints(heightmap)
    lowpoints = []
    nrows, ncols = size(heightmap)
    for i in 1:nrows
        for j in 1:ncols
            neighbors = []
            i > 1 && push!(neighbors, heightmap[i - 1, j])
            i < nrows && push!(neighbors, heightmap[i + 1, j])
            j > 1 && push!(neighbors, heightmap[i, j - 1])
            j < ncols && push!(neighbors, heightmap[i, j + 1])
            all(heightmap[i, j] .< neighbors) && push!(lowpoints, (i, j))
        end
    end
    lowpoints
end

lowpoints = find_lowpoints(heightmap)
println("Answer 1: ", sum(1 + heightmap[i...] for i in lowpoints))

function basin_size(heightmap, lowpoint)
    heightmap = copy(heightmap)
    counter = 0
    queue = [lowpoint]
    nrows, ncols = size(heightmap)
    while !isempty(queue)
        i, j = popfirst!(queue)
        if heightmap[i, j] < 9
            heightmap[i, j] = 10
            counter += 1
            i > 1 && push!(queue, (i - 1, j))
            i < nrows && push!(queue, (i + 1, j))
            j > 1 && push!(queue, (i, j - 1))
            j < ncols && push!(queue, (i, j + 1))
        end
    end
    counter
end

println("Answer 2: ", prod(sort(basin_size.(Ref(heightmap), lowpoints), rev=true)[1:3]))
