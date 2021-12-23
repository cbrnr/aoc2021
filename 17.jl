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
        (pos[1] > target[2] || pos[2] < target[3]) && return 0  # miss
        (target[1] ≤ pos[1] ≤ target[2]) && (target[3] ≤ pos[2] ≤ target[4]) && return ymax  # hit
        velocity[1] = velocity[1] ≠ 0 ? velocity[1] - sign(velocity[1]) : 0
        velocity[2] -= 1
    end
end

function find_ymax(target)
    ymax = 0
    for x = 0:1000
        for y = 0:1000
            ymax = max(probe([x, y], target), ymax)
        end
    end
    ymax
end

println("Answer 1: ", find_ymax(target))
