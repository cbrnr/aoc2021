include("utils.jl")

cookie = ""
input = get_aoc_input(11, cookie)
data = permutedims(hcat(collect([parse.(Int, row) for row in collect.(split(strip(input)))])...))

function simulate_octos(energy, steps; mode="flashes")
    flashes = 0
    nrows, ncols = size(energy)
    energy = convert(Matrix{Float32}, energy)
    for _ in 1:steps
        energy .+= 1
        while any(energy .> 9)
            flash = findfirst(energy .> 9)
            flashes += 1
            energy[flash] = -Inf
            neighbors = [(i + flash[1], j + flash[2]) for i in -1:1, j in -1:1]
            neighbors = [(i, j) for (i, j) in neighbors if 0 < i ≤ nrows && 0 < j ≤ ncols]
            for neighbor in neighbors
                energy[neighbor...] += 1
            end
        end
        energy[energy .< 0] .= 0
    end
    mode == "flashes" && return flashes
    mode == "energy" && return convert(Matrix{Int}, energy)
end

println("Answer 1: ", simulate_octos(data, 100, mode="flashes"))

function find_synchronization(energy)
    step = 0
    while true
        tmp = simulate_octos(energy, step, mode="energy")
        all(first(tmp) .== tmp) && return step
        step += 1
    end
end

println("Answer 2: ", find_synchronization(data))
