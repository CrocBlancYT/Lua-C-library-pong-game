function table.find(t,k)
    for i, v in pairs(t) do
        if k == v then return i end
    end
end

function math.sign(n)
    if n == 0 then return 0 end
    if n > 0 then return 1 end
    return -1
end

function string.split(str, sep)
    local slices = {}

    for new_slice in string.gmatch(str, "([^"..sep.."]+)") do
        table.insert(slices, new_slice)
    end
    
    return slices
end

local function point_in_circle(x1,y1, x2,y2, dist)
    local dx = x2-x1
    local dy = y2-y1

    return math.sqrt(dx^2 + dy^2) < dist
end

local function point_in_rectangle(x1,y1, x2,y2, x_size,y_size)
    local dx = math.abs(x2-x1)
    local dy = math.abs(y2-y1)

    return (dx < x_size/2) and (dy < y_size/2)
end

local function spring_force(init, n)
    return (init-n) / init
end
