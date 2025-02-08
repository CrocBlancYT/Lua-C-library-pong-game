local init, imports = dofile('./src/init.lua')
local width, height = 1920/2, 1080/2
local game = init('Pong', width, height)

local gui = imports.user_interface
local vector2 = imports.vector2
local physics = imports.physics
local run_service = imports.run_service
local inputs = imports.user_inputs

local mouse = inputs.mouse

local object = gui.newBox(
    vector2.new{
        x = width/2,
        y = height/2
    },

    vector2.new{
        x = 40, y = 40
    },

    {
        r = 255,
        g = 255,
        b = 255
    },

    true
)

local dragging = nil

local function whenDragging(deltaTime)
    local last_pos = object.position
    local last_vel = object.velocity

    local new_pos = vector2.new(mouse.x, mouse.y)

    local deltaPos = new_pos:sub(last_pos)

    local new_vel = deltaPos:div(deltaTime)

    object.position = vector2.new(mouse.x, mouse.y)
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
        dragging = run_service.onHeartbeat:Connect(whenDragging)
    end
end)

object.velocity = vector2.new{
    x = 255,
    y = 255
}

local function react_collide(object, deltaTime)
    local pos, size, vel = object.position, object.size, object.velocity

    if pos.y+(size.y/2) > height then
        vel.y = -math.abs(vel.y) * 0.7
        pos.y = pos.y + vel.y*deltaTime

        vel.x = vel.x * 0.9
    end

    if pos.y-(size.y/2) < 0 then
        vel.y = math.abs(vel.y) * 0.7
        pos.y = pos.y + vel.y*deltaTime

        vel.x = vel.x * 0.9
    end

    if pos.x+(size.x/2) > width then
        vel.x = -math.abs(vel.x) * 0.7
        pos.x = pos.x + vel.x*deltaTime

        vel.x = vel.x * 0.9
    end

    if pos.x-(size.x/2) < 0 then
        vel.x = math.abs(vel.x) * 0.7

        pos.x = pos.x + vel.x*deltaTime

        vel.x = vel.x * 0.9
    end
end

local springs = {
    {
        last_force = 0,
        target_pos = vector2.new( game.width/6*2.5, game.height/2 ),
        target_distance = 120,
        spring_strength = 25,
        elasticity = 0.1
    },

    {
        last_force = 0,
        target_pos = vector2.new( game.width/6*3.5, game.height/2 ),
        target_distance = 120,
        spring_strength = 25,
        elasticity = 0.1
    }
}
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

local last_force = 0
run_service.onRender:Connect(function (deltaTime)
    local position, size, velocity, color = object.position, object.size, object.velocity, object.color

    gui.renderBox(object)
    
    react_collide(object, deltaTime)

    position.x = position.x + (velocity.x*deltaTime)
    position.y = position.y + (velocity.y*deltaTime)

    velocity.y = velocity.y - physics.g * game.pixels_wrt_cm * deltaTime

    local air_res = {
        x = -0.2 * velocity.x,
        y = -0.2 * velocity.y
    }

    velocity.x = velocity.x + air_res.x*deltaTime
    velocity.y = velocity.y + air_res.y*deltaTime

    for _, spring in pairs(springs) do
        simulate_spring(object, spring, deltaTime)
    end
end)


local function onInput(input)
    local key = imports.user_inputs.parseKeycode(input.keycode) or input.inputType

    local mouse = imports.user_inputs.mouse
    --[[
    print(mouse.x/width, mouse.y/height)
    print(input.inputType, input.inputState)

    print()
    ]]
end

inputs.inputBegan:Connect(onInput)
inputs.inputEnded:Connect(onInput)

while true do game.run(120) end