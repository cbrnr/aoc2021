include("utils.jl")

cookie = ""
input = get_aoc_input(17, cookie)

target = parse.(Int, (m.match for m in eachmatch(r"-*\d+", input)))


function probe(velocity, target)
    pos = [0, 0]
    ymax = 0
    while true
        pos .+= velocity
        ymax = max(ymax, pos[2])
        (pos[1] > target[2] || pos[2] < target[3]) && return (false, 0)  # miss
        if (target[1] ≤ pos[1] ≤ target[2]) && (target[3] ≤ pos[2] ≤ target[4])
            return (true, ymax)  # hit
        end
        velocity[1] = velocity[1] ≠ 0 ? velocity[1] - sign(velocity[1]) : 0
        velocity[2] -= 1
    end
end

function find_ymax(target)
    ymax = 0
    for x = 0:1000
        for y = 0:1000
            ymax = max(probe([x, y], target)[2], ymax)
        end
    end
    ymax
end

function find_hits(target)
    hits = []
    for x = 0:1000
        for y = -1000:1000
            probe([x, y], target)[1] && push!(hits, [x, y])
        end
    end
    hits
end

println("Answer 1: ", find_ymax(target))
println("Answer 2: ", length(find_hits(target)))
