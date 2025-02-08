local ray = {}

function ray.new(x,y, dx,dy)
    return {
        origin = {x=x, y=y},
        direction = {x=dx, y=dy}
    }
end

function ray.raycast(ray, dist)
end

local function Distance(x, y) return math.sqrt(x^2, y^2) end
local function Dot(x1,y1, x2,y2) return (x1 * x2) + (y1 * y2) end
local function Angle(x1, y1, x2, y2)
    local scalar = Dot(x1,y1, x2,y2)
    return math.deg(math.acos(scalar / Distance(x1,y1) / Distance(x2,y2)))
end

function ray.closestPoint(ray, x,y)
    local origin = ray.origin

    local ray_dir = ray.direction

    local dist = Distance(ray_dir.x, ray_dir.y)
    local ray_unit = {
        x = ray_dir.x / dist,
        y = ray_dir.y / dist
    }

    local offseted_point = {
        x = x-origin.x,
        y = y-origin.y
    }
        
    local point_distance = Distance(offseted_point.x, offseted_point.y)

    local offseted_point_unit = {
        x = offseted_point.x / point_distance,
        y = offseted_point.y / point_distance
    }

    local angle = Angle(ray_unit.x, ray_unit.y, offseted_point_unit.x, offseted_point_unit.y)

    if angle > 90 then
        angle = 180 - angle
        ray_unit = ray_unit * -1
    end
        
    local closest_point_distance = math.acos(math.rad(angle)) * point_distance

    return closest_point_distance * ray_unit
end

return ray