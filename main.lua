local init = dofile('./src/init.lua')
local width, height = 1920/2, 1080/2

local game = init('Pong', width, height)

local targetFps = 120
local actualFps = 120

local function square(pos, size, color)
    --top left
    local x1 = math.floor(pos.x - size.x/2)
    local y1 = math.floor(pos.y - size.y/2)

    --top right
    local x2 = math.floor(pos.x + size.x/2)
    local y2 = math.floor(pos.y - size.y/2)

    --bottom right
    local x3 = math.floor(pos.x + size.x/2)
    local y3 = math.floor(pos.y + size.y/2)

    --bottom left
    local x4 = math.floor(pos.x - size.x/2)
    local y4 = math.floor(pos.y + size.y/2)
    
    local r, g, b = color.r, color.b, color.b

    game.drawLine(x1,y1,  x2,y2,  r,g,b)
    game.drawLine(x2,y2,  x3,y3,  r,g,b)
    game.drawLine(x3,y3,  x4,y4,  r,g,b)
    game.drawLine(x4,y4,  x1,y1,  r,g,b)
end

local projectile = {
    position = {
        x = width / 2,
        y = height / 2
    },
    size = {
        x = 40,
        y = 40
    },
    velocity = {
        x = 550,
        y = 250
    },
    color = {
        r = 255,
        g = 255,
        b = 255
    }
}

local function react_collide(object, deltaTime, framesCalcOnVelChange)
    local pos, size, vel = object.position, object.size, object.velocity

    if pos.y+(size.y/2) > height then
        vel.y = -vel.y * 0.8
        pos.y = pos.y + vel.y*deltaTime*framesCalcOnVelChange
    end

    if pos.y-(size.y/2) < 0 then
        vel.y = -vel.y
        pos.y = pos.y + vel.y*deltaTime*framesCalcOnVelChange
    end

    if pos.x+(size.x/2) > width then
        vel.x = -vel.x
        pos.x = pos.x + vel.x*deltaTime*framesCalcOnVelChange
    end

    if pos.x-(size.x/2) < 0 then
        vel.x = -vel.x
        pos.x = pos.x + vel.x*deltaTime*framesCalcOnVelChange
    end
end

game.connectEvent(function ( event, deltaTime )
end)

game.connectFrame(function ( deltaTime )
    actualFps = 1/deltaTime

    local position, size, velocity, color = projectile.position, projectile.size, projectile.velocity, projectile.color

    local start_size = {x=size.x, y=size.y}
    square(position, size, color)
    for i = 1, 10 do
        square(position, size, color)
        size.x = size.x + 2
        size.y = size.y + 2
    end
    size.x = start_size.x
    size.y = start_size.y
    
    react_collide(projectile, deltaTime, 0.5)

    position.x = position.x + (velocity.x*deltaTime)
    position.y = position.y + (velocity.y*deltaTime)

    velocity.y = velocity.y + 9.81 * game.pixels_wrt_cm * deltaTime

    local air_res = {
        x = -0.2 * velocity.x,
        y = -0.2 * velocity.y
    }

    velocity.x = velocity.x + air_res.x*deltaTime
    velocity.y = velocity.y + air_res.y*deltaTime
end)

while true do
    game.runFrame(120)
    print(actualFps)
end