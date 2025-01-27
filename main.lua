local init = dofile('./src/init.lua')
local width, height = 1920/2, 1080/2

local game = init('Pong', width, height)

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

    game:drawLine(x1,y1,  x2,y2,  r,g,b)
    game:drawLine(x2,y2,  x3,y3,  r,g,b)
    game:drawLine(x3,y3,  x4,y4,  r,g,b)
    game:drawLine(x4,y4,  x1,y1,  r,g,b)
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
        x = 200,
        y = 200
    },
    color = {
        r = 0,
        g = 0,
        b = 0
    }
}

local function react_collide(object)
    local pos, size, vel = object.position, object.size, object.velocity

    if pos.y+(size.y/2) > height then
        vel.y = -vel.y
    end

    if pos.y-(size.y/2) < 0 then
        vel.y = -vel.y
    end

    if pos.x+(size.x/2) > width then
        vel.x = -vel.x
    end

    if pos.x-(size.x/2) < 0 then
        vel.x = -vel.x
    end
end

game.connectEvent(function ( event, deltaTime )
end)

game.connectFrame(function ( deltaTime )
    local position, size, velocity, color = projectile.position, projectile.size, projectile.velocity, projectile.color

    square(position, size, color)
    react_collide(projectile)

    position.x = position.x + (velocity.x*deltaTime)
    position.y = position.y + (velocity.y*deltaTime)

end)

while true do
    game.runFrame(60)
end