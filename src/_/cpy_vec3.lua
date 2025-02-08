local Enum = {
    NormalId = {
        ['Right'] = 0,
        ['Top'] = 1,
        ['Back'] = 2,
        ['Left'] = 3,
        ['Bottom'] = 4,
        ['Front'] = 5
    }
}

local Vector3 = {}

--core is not accessible from outside the lib
local core = {}
function core.vec_tostring(vec)
    return tostring(vec.X)..' '..tostring(vec.Y)..' '..tostring(vec.Z)
end
function core.Magnitude(vec1)
    local x,y,z = vec1.X, vec1.Y, vec1.Z
    return math.sqrt((x^2) + (y^2) + (z^2))
end
function core.Equals(vec1, vec2)
    for _, t in pairs({vec1, vec2}) do
        for _, k in pairs({'X','Y','Z'}) do
            if not t[k] then return false end
        end
    end
    return (vec1.X == vec2.X) and (vec1.Y == vec2.Y) and (vec1.Z == vec2.Z)
end
function core.Sub(vec1, vec2)
    local X = vec1.X - vec2.X
    local Y = vec1.Y - vec2.Y
    local Z = vec1.Z - vec2.Z
    return Vector3.New(X,Y,Z)
end
function core.Add(vec1, vec2)
    local X = vec1.X + vec2.X
    local Y = vec1.Y + vec2.Y
    local Z = vec1.Z + vec2.Z
    return Vector3.New(X,Y,Z)
end
function core.Multiply(vec1, vec2)
    local vec1, vec2 = vec1, vec2
    if type(vec1) == 'number' then
        vec1 = {X=vec1,Y=vec1,Z=vec1}
    end
    if type(vec2) == 'number' then
        vec2 = {X=vec2,Y=vec2,Z=vec2}
    end

    local X = vec1.X * vec2.X
    local Y = vec1.Y * vec2.Y
    local Z = vec1.Z * vec2.Z
    return Vector3.New(X,Y,Z)
end
function core.Divide(vec1, vec2)
    local vec1, vec2 = vec1, vec2
    if type(vec1) == 'number' then
        return core.Multiply(1/vec1, vec2)
    end
    if type(vec2) == 'number' then
        return core.Multiply(vec1, 1/vec2)
    end

    local X = vec1.X / vec2.X
    local Y = vec1.Y / vec2.Y
    local Z = vec1.Z / vec2.Z
    return Vector3.New(X,Y,Z)
end


--accessible methods
local methods = {}
function methods.Abs(vec1)
    if not vec1 then return end
    return Vector3.New(
        math.abs(vec1.X),
        math.abs(vec1.Y),
        math.abs(vec1.Z)
    )
end
function methods.Ceil(vec1)
    if not vec1 then return end
    return Vector3.New(
        math.ceil(vec1.X),
        math.ceil(vec1.Y),
        math.ceil(vec1.Z)
    )
end
function methods.Floor(vec1)
    if not vec1 then return end
    return Vector3.New(
        math.floor(vec1.X),
        math.floor(vec1.Y),
        math.floor(vec1.Z)
    )
end
function methods.Sign(vec1)
    if not vec1 then return end
    return Vector3.New(
        math.sign(vec1.X),
        math.sign(vec1.Y),
        math.sign(vec1.Z)
    )
end
function methods.ToAngles(vec1)
    if not vec1 then return end
    local unit, magnitude = vec1.Unit, vec1.Magnitude
    return Vector3.New(0, math.atan2(unit.Z, unit.X), math.asin(unit.Y)), magnitude
end
function methods.Cross(vec1, vec2)
    if not vec2 then return end
    local x1, y1, z1 = vec1.X, vec1.Y, vec1.Z
    local x2, y2, z2 = vec2.X, vec2.Y, vec2.Z

    local x3 = (y1 * z2) - (z1 * y2)
    local y3 = (z1 * x2) - (x1 * z2)
    local z3 = (x1 * y2) - (y1 * x2)

    return Vector3.New(x3, y3, z3)
end
function methods.Dot(vec1, vec2) --Scalar Product
    if not vec2 then return end
    return (vec1.X * vec2.X) + (vec1.Y * vec2.Y) + (vec1.Z * vec2.Z)
end
function methods.Angle(vec1, vec2)
    if not vec2 then return end
    local scalar = vec1:Dot(vec2)
    return math.deg(math.acos(scalar / vec1.Magnitude / vec2.Magnitude))
end
function methods.FuzzyEq(vec2, epsilon)
    return
end
function methods.Lerp(vec1, vec2, alpha) --linear interpolation
    if not alpha then return end
    local offset = vec2-vec1
    return vec1 + (offset*alpha)
end
function methods.Max(vec1, vec2)
    if not vec2 then return end
    return Vector3.New(
        math.max(vec1.X, vec2.X),
        math.max(vec1.Y, vec2.Y),
        math.max(vec1.Z, vec2.Z)
    )
end
function methods.Min(vec1, vec2)
    if not vec2 then return end
    return Vector3.New(
        math.min(vec1.X, vec2.X),
        math.min(vec1.Y, vec2.Y),
        math.min(vec1.Z, vec2.Z)
    )
end
function methods.RotateAround(vec1, axis, degrees) -- test to make sure it works
    if not degrees then return end
    local axisUnit = axis.Unit
    local theta = math.rad(degrees)
    
    local dotProduct = vec1:Dot(axisUnit)
    local crossProduct = vec1:Cross(axisUnit)

    -- Rodrigues' Rotation Formula
    local rotatedVec = 
        (vec1 * math.cos(theta)) +
        (crossProduct * math.sin(theta)) +
        (axisUnit * dotProduct * (1 - math.cos(theta)))
    
    return rotatedVec
end
function methods.ProjectOnto(vec1, vec2) --show the initial vector, "projected" (that fills) the 2nd vector
    if not vec2 then return end
    local dotProd = vec1:Dot(vec2)
    local mag2Squared = vec2:Dot(vec2)
    return vec2 * (dotProd / mag2Squared)
end
function methods.RejectFrom(vec1, vec2)  --opposite of projection
    if not vec2 then return end
    return vec1 - vec1:ProjectOnto(vec2)
end
function methods.Reflect(vec1, normal) --to describe!!
    if not normal then return end
    local dotProd = vec1:Dot(normal)
    return vec1 - normal * 2 * dotProd
end
function methods.ComponentAlong(vec1, axis) --arbitrary axis
    if not axis then return end
    --return axis * self:Dot(axis)
    return vec1:ProjectOnto(axis).Magnitude
end
function methods.Slerp(vec1, vec2, t) -- Spherical Linear Interpolation (makes an arc-like interpolation from the 2 vectors)
    if not t then return end
    local dotProd = vec1:Dot(vec2)
    local theta = math.acos(math.clamp(dotProd, -1, 1))
    local sinTheta = math.sin(theta)
    
    if sinTheta == 0 then
        return vec1  -- No need to interpolate if the vectors are the same
    end
    
    local scale1 = math.sin((1 - t) * theta) / sinTheta
    local scale2 = math.sin(t * theta) / sinTheta
    
    return vec1 * scale1 + vec2 * scale2
end

function Vector3.New(x_, y_, z_)
    local OuterVector = {}
    local InnerVector = {
        X=x_ or 0,
        Y=y_ or 0,
        Z=z_ or 0
    }

    InnerVector.Magnitude = core.Magnitude(InnerVector)
    
    local function getUnit()
        if InnerVector.Magnitude == 0 then return Vector3.New(0,0,0) end 
        return OuterVector/InnerVector.Magnitude 
    end
    

    setmetatable(
        OuterVector,{
        __tostring= core.vec_tostring,
        __concat= core.vec_tostring,

        __add= core.Add,
        __sub= core.Sub,
        __div= core.Divide,
        __mul= core.Multiply,
        __eq= core.Equals,
        
        __index = function (t, k)
            local index = k
            if type(index) == 'number' then local items = {'X','Y','Z','Magnitude'} index = items[index] end
            
            if not index then return end
            if index == 'Unit' then InnerVector[index]=getUnit() end

            return methods[index] or InnerVector[index]
        end,

        __newindex = function (t, k, v)
            if InnerVector[k] and type(InnerVector[k]) == type(v) then 
                InnerVector[k] = v 
                InnerVector.Magnitude = core.Magnitude(InnerVector)
            else 
                error("attempt do insert a new element in read-only", 2) 
            end
        end,

        __len = function () return 4 end
    })
  
    return OuterVector
end

function Vector3.FromNormalId(NormalId)
    local normals = {
        {0,0,1},
        {0,1,0},
        {-1,0,0},
        {0,0,-1},
        {0,-1,0},
        {1,0,0}
    }
    local xyz = normals[Enum.NormalId[NormalId]]
    return Vector3.New(table.unpack(xyz))
end

function Vector3.FromAngles(x, y, z, Magnitude) --rotation around each axis, in radians
    local yaw, pitch = y, z
    
    return Vector3.New(
        math.cos(pitch) * math.cos(yaw),
        math.sin(pitch),
        math.cos(pitch) * math.sin(yaw)
    ) * (Magnitude or 1)
end

return Vector3, Enum