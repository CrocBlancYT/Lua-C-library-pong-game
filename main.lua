--game
local init, imports = dofile('./src/init.lua')
local width, height = 1920/2, 1080/2
local game = init('Pong', width, height)
game.nextFrame = game.run

--imports
local gui = imports.user_interface
local vector2 = imports.vector2
local physics = imports.physics
local run_service = imports.run_service
local inputs = imports.user_inputs
local data_store = imports.data_store

local collisions = imports.collisions

--mouse
local mouse = inputs.mouse

--scene
local objects = {}

local function new_object()
    local object = gui.newBox(nil, nil, nil, true)
    object.position = vector2.new{ x = width/2, y = height/2}
    object.velocity = vector2.new{ x = math.random()*1000, y = math.random()*1000 }
    table.insert(objects, object)
end

local object_count = 5

for i = 1, object_count do
    new_object()
end

--objects[1].rotation = 32
--objects[2].rotation = 125

local springs = {
    {
        last_force = 0,
        target_pos = vector2.new( game.width/12*5, game.height/2 ),
        target_distance = 120,
        spring_strength = 25,
        elasticity = 0.1
    },

    {
        last_force = 0,
        target_pos = vector2.new( game.width/12*7, game.height/2 ),
        target_distance = 120,
        spring_strength = 25,
        elasticity = 0.1
    }
}

--initializes dragging for each object
for _, object in pairs(objects) do
    --object dragging + velocity inheritance
    local dragging = nil
    local offset = nil

    local function whenDragging(deltaTime)
        local last_pos = object.position
        local last_vel = object.velocity

        local new_pos = vector2.new(mouse.x, mouse.y):add(offset)

        local deltaPos = new_pos:sub(last_pos)

        local new_vel = deltaPos:div(deltaTime)

        object.position = new_pos
        object.velocity = last_vel:lerp(new_vel, deltaTime*10)
    end

    mouse.ButtonUp:Connect(function (input)
        if (input.inputType == 'Mouse_1_Up') and dragging then
            dragging:Disconnect()
            dragging = nil
        end
    end)

    object.onMouseButton:Connect(function ( input )
        if (input.inputType == 'Mouse_1_Down') and not dragging then
            local mouse_pos = vector2.new(mouse.x, mouse.y)
            offset = object.position:sub(mouse_pos)
            dragging = run_service.onHeartbeat:Connect(whenDragging)
        end
    end)
end

function math.clamp(min, num, max)
    if num < min then return min end
    if num > max then return max end
    return num
end

-- container collisions
local function react_collide(object, deltaTime)
    local pos, size, vel = object.position, object.size, object.velocity

    local collision_detected = false

    if pos.y+(size.y/2) > height then
        vel.y = -math.abs(vel.y) * 0.7
        pos.y = pos.y + vel.y*deltaTime

        vel.x = vel.x * 0.9

        collision_detected = true
    end

    if pos.y-(size.y/2) < 0 then
        vel.y = math.abs(vel.y) * 0.7
        pos.y = pos.y + vel.y*deltaTime

        vel.x = vel.x * 0.9

        collision_detected = true
    end

    if pos.x+(size.x/2) > width then
        vel.x = -math.abs(vel.x) * 0.7
        pos.x = pos.x + vel.x*deltaTime

        vel.x = vel.x * 0.9

        collision_detected = true
    end

    if pos.x-(size.x/2) < 0 then
        vel.x = math.abs(vel.x) * 0.7

        pos.x = pos.x + vel.x*deltaTime

        vel.x = vel.x * 0.9

        collision_detected = true
    end

    if collision_detected then
        local size_x, size_y = size.x/2, size.y/2
        pos.x = math.clamp(size_x, pos.x, width-size_x)
        pos.y = math.clamp(size_y, pos.y, height-size_y)
    end
end


--spring simulation
local function simulate_spring(object, spring, deltaTime)
    local position = object.position
    local target_pos, target_distance, spring_strength = spring.target_pos, spring.target_distance, spring.spring_strength

    local diff = position:sub(target_pos)
    local distance = diff:length()

    local current_force = physics.spring_force(target_distance, distance) * spring_strength

    local delta_force = current_force - spring.last_force
    local forceVector = diff:mul(current_force + delta_force/spring.elasticity)
    spring.last_force = current_force

    object.velocity = object.velocity:add(forceVector:mul(deltaTime))
    
    game.setPixel(target_pos.x, target_pos.y, 255, 255, 255)
    game.drawLine(math.floor(position.x), math.floor(position.y), target_pos.x, target_pos.y, 255, 255, 255)
end

local function collide(object1, object2)
    local collided, axis, min_distance = collisions.detect.squares_overlapping(object1, object2)
    if not collided then return end
        
    local vel1, vel2 = object1.velocity, object2.velocity
    if axis == 'x' then
        local x1, x2 = vel1.x, vel2.x
        vel1.x = x2
        vel2.x = x1
    else
        local y1, y2 = vel1.y, vel2.y
        vel1.y = y2
        vel2.y = y1
    end

    local pos_diff_unit = object2.position:sub(object1.position)
    local distance = pos_diff_unit:length()
    pos_diff_unit = pos_diff_unit:div(distance)

    local target_distance = min_distance - distance

    object1.position = object1.position:sub(pos_diff_unit:mul(target_distance))
    object2.position = object2.position:add(pos_diff_unit:mul(target_distance))
end

--object behavior
run_service.onRender:Connect(function (deltaTime)
    for _, object in pairs(objects) do
        local position, size, velocity, color = object.position, object.size, object.velocity, object.color

        --inertia
        position.x = position.x + (velocity.x*deltaTime)
        position.y = position.y + (velocity.y*deltaTime)

        --forces
        velocity = physics.gravity(velocity, game.pixels_wrt_cm, deltaTime)
        velocity = physics.air_resistance(velocity, deltaTime)
        object.velocity = velocity
        
        --world-map container collisions
        react_collide(object, deltaTime) -- (ADD ACTIVE COLLISION FOR MAP (is only passive right now))

        --active and passive object-object collisions
        local object1 = object
        for _, object2 in pairs(objects) do
            if not (object1 == object2) then
                collide(object1, object2)
            end
        end

        --gfx
        gui.renderBox(object)

    end

    for _, spring in pairs(springs) do
        simulate_spring(objects[1], spring, deltaTime*5)
    end    
end)

--game loop
run_service.setFps(240)
while true do game.nextFrame() end