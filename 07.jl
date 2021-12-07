include("utils.jl")

cookie = ""
input = get_aoc_input(7, cookie)
data = parse.(Int, split(strip(input), ","))

function compute_fuel(data; part=1)
    fuel = Inf
    for position ∈ minimum(data):maximum(data)
        if part == 1
            cost = sum(abs.(position .- data))
        else
            cost = sum(sum.(range.(0, abs.(position .- data))))
        end
        fuel = cost < fuel ? cost : fuel
    end
    fuel
end

println("Answer 1: ", compute_fuel(data, part=1))
println("Answer 2: ", compute_fuel(data, part=2))
