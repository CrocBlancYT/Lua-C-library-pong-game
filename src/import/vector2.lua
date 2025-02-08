local vector2 = {}

local methods = {}

function methods.add(vec1, vec2)
    return vector2.new( vec1.x + vec2.x, vec1.y + vec2.y )
end
function methods.sub(vec1, vec2)
    return vector2.new( vec1.x - vec2.x, vec1.y - vec2.y )
end
function methods.mul(vec1, vec2)
    if type(vec2) == "number" then
        vec2 = {x=vec2, y=vec2}
    end

    return vector2.new( vec1.x * vec2.x, vec1.y * vec2.y )
end
function methods.div(vec1, vec2)
    if type(vec2) == "number" then
        vec2 = {x=vec2, y=vec2}
    end

    return vector2.new( vec1.x / vec2.x, vec1.y / vec2.y )
end

function methods.length(vec)
    return math.sqrt(vec:dot(vec))
end
function methods.unit(vec)
    local length = vec:length()

    if length == 0 then return vector2.new(0, 0) end

    return vector2.new(
        vec.x / length,
        vec.y / length
    )
end
function methods.dot(vec1, vec2)
    return vec1.x*vec2.x + vec1.y*vec2.y
end


function methods.angle(vec1, vec2) --verify
    return math.acos(vec1:dot(vec2) / math.sqrt( vec1:dot(vec1) + vec2:dot(vec2) ))
end
function methods.project(vec1, vec2)
    local dot_12 = vec1:dot(vec2)
    local dot_22 = vec2:dot(vec2)
    local scalar = dot_12 / dot_22
    return vector2.new(vec2.x * scalar, vec2.y * scalar), scalar
end
function methods.lerp(vec1, vec2, alpha)
    local x1, y1 = vec1.x, vec1.y
    local x2, y2 = vec2.x, vec2.y

    local dx, dy = x2-x1, y2-y1

    return vector2.new(x1+dx*alpha, y1+dy*alpha)
end
function methods.theta(vec)  --verify
    return math.atan2(vec.y, vec.x), vec:length()
end
function methods.rotate(vec, theta2)  --verify
    local theta1, length = vec:theta()
    return vector2.fromAngle(theta1+theta2, length)
end

function methods.tostring(vec)
    return 'x: ' .. tostring(vec.x) .. ' y: ' .. tostring(vec.y)
end

function vector2.new(x, y)
    if type(x) == "table" then
        y = x.y
        x = x.x
    end

    local vector = {x=x, y=y}

    for i, v in pairs(methods) do
        vector[i] = v
    end

    return vector
end

function vector2.fromAngle(theta, length)
    if not length then length = 1 end
    return vector2.new(
        math.cos(theta) * length,
        math.sin(theta) * length
    )
end

return vector2