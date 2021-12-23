include("utils.jl")

cookie = ""
input = strip(get_aoc_input(16, cookie))

"""Convert hexadecimal number to its binary representation."""
function hex_to_bin(hex::AbstractString)
    tokens = Dict(only(string(n, base=16)) => string(n, base=2, pad=4) for n = 0:15)
    join([tokens[lowercase(c)] for c in collect(hex)])
end

"""Packet with a pointer to the current position."""
mutable struct Packet
    str::AbstractString
    pos::Integer
end

"""Read from Packet and advance position by number of bits read."""
function _read(packet::Packet, len::Integer=1)
    v = packet.str[packet.pos : packet.pos + len - 1]
    packet.pos += len
    v
end

"""Parse Packet."""
function parse_packet(packet::Packet)
    start = packet.pos
    version = parse(Int, _read(packet, 3), base=2)
    type = parse(Int, _read(packet, 3), base=2)

    if type == 4  # literal value
        value = ""
        while true
            v = _read(packet, 5)
            value *= v[2:end]
            startswith(v, "0") && break  # the last group starts with "0"
        end
        return (version=version, value=parse(Int, value, base=2), nbits=packet.pos - start)
    end

    # operator
    op = Dict(0 => sum, 1 => prod, 2 => minimum, 3 => maximum, 5 => x -> Int(x[1] > x[2]),
              6 => x -> Int(x[1] < x[2]), 7 => x -> Int(x[1] == x[2]))
    length_type = _read(packet)
    versions = [version]
    values = []
    if length_type == "0"  # total length of sub-packets (next 15 bits)
        total_length = parse(Int, _read(packet, 15), base=2)
        nbits = 0
        while true
            v, value, n = parse_packet(packet)
            push!(versions, v)
            push!(values, value)
            nbits += n
            nbits ≥ total_length && break
        end
    elseif length_type == "1"  # number of sub-packets (next 11 bits)
        n_packets = parse(Int, _read(packet, 11), base=2)
        for _ in 1:n_packets
            v, value, _ = parse_packet(packet)
            push!(versions, v)
            push!(values, value)
        end
    end
    return (version=sum(versions), value=op[type](values), nbits=packet.pos - start)
end


p = parse_packet(Packet(hex_to_bin(input), 1))
println("Answer 1: ", p.version)
println("Answer 2: ", p.value)
