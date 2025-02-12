local collisions = {
    detect = {},
    react = {}
}

local vector2

local function raycast_in_square(size, angle)
    --can be optimized
    
    local rotation = math.rad(angle)
    
    local perimeter = size.x*2 + size.y*2 
        
    local wrapped_distance = (math.deg(rotation) / 360 * perimeter) % (perimeter/4)
        
    if wrapped_distance >= (perimeter/8) then --corner passed, derivative is inverted
        wrapped_distance = perimeter/4 - wrapped_distance
    end
        
    return math.sqrt(wrapped_distance^2 + (perimeter/8)^2)
end

function collisions.detect.squares_overlapping(square1, square2)
    local diff = square2.position:sub(square1.position)
    
    local distance = math.sqrt(diff.x^2 + diff.y^2)
        
    local angle = diff:theta()
    
    local distance1 = raycast_in_square(square1.size, square1.rotation + math.deg(angle))
    local distance2 = raycast_in_square(square2.size, -square2.rotation + math.deg(angle))

    local main_axis = 'x'
    if math.abs(diff.y) > math.abs(diff.x) then
        main_axis = 'y'
    end

    return distance < (distance1 + distance2), main_axis, distance1 + distance2
end

function collisions.detect.dot_in_circle(pos_dot, pos_circle, radius)
    local magSqr = pos_dot:dot(pos_circle)
    local magSqr_max = radius^2
    return magSqr < magSqr_max
end

function collisions.detect.dot_in_rect(pos_dot, pos_rect, size_rect)
    local in_x = (pos_rect.x -size_rect.x < pos_dot.x < pos_rect.x + size_rect.x)
    local in_y = (pos_rect.y - size_rect.y < pos_dot.y < pos_rect.y + size_rect.y)
    return in_x and in_y
end

function collisions.detect.dot_in_line(pos_dot, pos_start, pos_end)
    local diff = pos_end:sub(pos_start)
    local k = pos_dot:sub(pos_start):div(diff)
    return k.x == k.y
end

function collisions.rect_normals(rect)
    local rotation = rect.rotation

    local up_vector = vector2.new(0,1):rotate(rotation)
    local right_vector = vector2.new(1,0):rotate(rotation)

    return {
        up = up_vector,
        down = up_vector:mul(-1),
        right = right_vector,
        left = up_vector:mul(-1)
    }
end

local function setup(imports, game)
    vector2 = imports.vector2

    return collisions, {

    }
end

return setup