function eulerToQuaternion(x, y, z)
    local cr = math.cos(x / 2)
    local sr = math.sin(x / 2)
    
    local cy = math.cos(z / 2)
    local sy = math.sin(z / 2)
    
    local cp = math.cos(y / 2)
    local sp = math.sin(y / 2)

    local w = (cr * cp * cy) + (sr * sp * sy)
    local x = (sr * cp * cy) - (cr * sp * sy)
    local y = (cr * sp * cy) + (sr * cp * sy)
    local z = (cr * cp * sy) - (sr * sp * cy)

    return w, x, y, z
end

function multiplyQuaternions(w1, x1, y1, z1, w2, x2, y2, z2)
    local w3 = (w1 * w2 - x1 * x2) - (y1 * y2 - z1 * z2)
    local x3 = (w1 * x2 + x1 * w2) + (y1 * z2 - z1 * y2)
    local y3 = (w1 * y2 + y1 * w2) + (z1 * x2 - x1 * z2)
    local z3 = (w1 * z2 + z1 * w2) + (x1 * y2 - y1 * x2)
    
    --return w3, x3, y3, z3
    
    local a = {
      w = w1,
      x = x1,
      y = y1,
      z = z1
    }
    
    local b = {
      w = w2,
      x = x2,
      y = y2,
      z = z2
    }
    
    local w3 = w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2
    local x3 = w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2
    local y3 = w1 * y2 + y1 * w2 + z1 * x2 - x1 * z2
    local z3 = w1 * z2 + z1 * w2 + x1 * y2 - y1 * x2
    return w3, x3, y3, z3

    [[
    return 
      a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z,  -- 1
      a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y,  -- i
      a.w * b.y - a.x * b.z + a.y * b.w + a.z * b.x,  -- j
      a.w * b.z + a.x * b.y - a.y * b.x + a.z * b.w   -- k
      ]]
end

local x = math.rad(45)
local y = math.rad(45)
local z = math.rad(0)

local w1, x1, y1, z1 = eulerToQuaternion(x, y, z)
print("Quaternion:", x1, y1, z1, w1)

local x = math.rad(45)
local y = math.rad(0)
local z = math.rad(0)

local w2, x2, y2, z2 = eulerToQuaternion(x, y, z)
print("Quaternion:", x2, y2, z2, w2)

local w3, x3, y3, z3 = multiplyQuaternions(w1, x1, y1, z1, w2, x2, y2, z2)

print("Quaternion:", x3, y3, z3, w2)

function quaternionToEuler(w, z, x, y)
    -- Yaw (rotation around y-axis)
    local yaw = math.atan2(2 * (w * y + x * z), 1 - 2 * (x * x + y * y))

    -- Pitch (rotation around x-axis)
    local pitch = math.asin(2 * (w * x - y * z))

    -- Roll (rotation around z-axis)
    local roll = math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))

    -- Return the angles in radians
    return roll, pitch, yaw
end

local function round(num, precision)
  local div = 10^precision
  return math.floor(num*div +0.5)/div
end

local x, y, z = quaternionToEuler(w3, x3, y3, z3)
x = math.deg(round(x, 14))
y = math.deg(round(y, 14))
z = math.deg(round(z, 14))
print(x,y,z)
