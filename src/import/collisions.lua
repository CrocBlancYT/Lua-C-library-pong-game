local collisions = {}

local function dot_in_circle(pos_dot, pos_circle, radius)
    local magSqr = pos_dot:dot(pos_circle)
    local magSqr_max = radius^2
    return magSqr < magSqr_max
end

local function dot_in_rect(pos_dot, pos_rect, size_rect)
    local in_x = (pos_rect.x -size_rect.x < pos_dot.x < pos_rect.x + size_rect.x)
    local in_y = (pos_rect.y - size_rect.y < pos_dot.y < pos_rect.y + size_rect.y)
    return in_x and in_y
end

local function dot_in_line(pos_dot, pos_start, pos_end)
    local diff = pos_end:sub(pos_start)
    local k = pos_dot:sub(pos_start):div(diff)
    return k.x == k.y
end

local function get_normals(rect)
    local rotation = rect.rotation

    local up_vector
    local right_vector

    -- body
end

--[[
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
]]

return collisions
