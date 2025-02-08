local Ray = {}
local Vector3 = require('Vector3')

local function RayBase(position)
    local ray = {}

    function ray.ClosestPoint(point)
        local origin = ray.Origin
        local ray_unit = ray.Direction.Unit

        local offseted_point = point - origin
        
        local point_distance = offseted_point.Magnitude
        local angle = ray_unit:Angle(offseted_point.Unit)
        if angle > 90 then angle = 180-angle ray_unit=ray_unit*-1 end
        
        local closest_point_distance = math.acos(math.rad(angle)) * point_distance
        return closest_point_distance * ray_unit
    end

    return ray
end

function Ray.New(origin, lookAt)
    local ray = RayBase(origin)

    ray.Origin = origin

    ray.Orientation = Vector3.New(0,0,0)
    ray.Direction = Vector3.New(1,0,0)
    
    local function ToDirection()
        local orientation = ray.Orientation
        local pitch = math.rad(orientation.Z)
        local yaw = math.rad(orientation.Y)
        return {
            X = math.cos(yaw)*math.cos(pitch),
            Y = math.sin(pitch),
            Z = math.sin(yaw)*math.cos(pitch)
          }
    end
    local function ToOrientation()
        local vector = ray.Direction
        return {
            X = 0,
            Y = math.deg(math.atan2(vector.Z, vector.X)),
            Z = math.deg(math.asin(vector.Y))
        }
    end

    if lookAt then
        local offset = lookAt - origin
        ray.Direction = offset / offset.Magnitude
        ray.Orientation = ToOrientation()
    end

    setmetatable(ray, {
        __newindex = function (t, k, v)
            if not table.find(ray, k) then return end
            ray[k] = v

            if (k == 'Orientation') then
                ray.Direction = ToDirection()
            elseif (k == 'Direction') then
                ray.Orientation = ToOrientation()
            end
        end
    })

    return ray
end

return Ray