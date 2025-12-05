--game
local width, height = 1920/2, 1080/2
local game = dofile('./src/core.lua')('Pong', width, height)

local json = dofile('json.lua')

--mouse
local mouse = inputs.mouse

local bluePadY = 0
local redPadY = 0

local blueOffset = {100, height // 2}
local redOffset = {width - 100, height // 2}

local floor = math.floor

local ball = {width//2, height//2}
local ball_velocity = {200, 200}

local function isInArea(x1,y1,x2,y2, x,y)
    return (x > x1 and x < x2) and (y > y1 and y < y2)
end

local function ball_collide()
    local next_pos = {ball[1]+ball_velocity[1] * 0.01, ball[2]+ball_velocity[2] * 0.01}
    
    if isInArea(blueOffset[1],blueOffset[2]+bluePadY,blueOffset[1]+10,blueOffset[2]+50+bluePadY, next_pos[1], next_pos[2]) then
        ball_velocity[1] = -ball_velocity[1]
    elseif isInArea(redOffset[1],redOffset[2]+redPadY,redOffset[1]+10,redOffset[2]+50+redPadY, next_pos[1], next_pos[2]) then
        ball_velocity[1] = -ball_velocity[1]
    elseif next_pos[1] < 0 then
        ball_velocity[1] = -ball_velocity[1]
        print('Red wins!')
        os.exit()
    elseif next_pos[1] > width then
        ball_velocity[1] = -ball_velocity[1]
        print('Blue wins!')
        os.exit()
    end
    
    if next_pos[2] < 0 then
        ball_velocity[2] = -ball_velocity[2]
    elseif next_pos[2] > height then
        ball_velocity[2] = -ball_velocity[2]
    end
end

--object behavior
game.onRender:Connect(function (deltaTime)
    local speed = 350*deltaTime
    
    if inputs.isKeyDown('Z') then bluePadY = bluePadY + speed end
    if inputs.isKeyDown('S') then bluePadY = bluePadY - speed end
    if inputs.isKeyDown('UP ARROW') then redPadY = redPadY + speed end
    if inputs.isKeyDown('DOWN ARROW') then redPadY = redPadY - speed end

    ball_collide()

    for x = 1, 10 do
        game.drawLine(
            blueOffset[1]+x, blueOffset[2]+floor(bluePadY),
            blueOffset[1]+x, blueOffset[2]+floor(bluePadY)+50,
            20,20,125
        )

        game.drawLine(
            redOffset[1]+x, redOffset[2]+floor(redPadY),
            redOffset[1]+x, redOffset[2]+floor(redPadY)+50,
            125,20,20
        )
    end

    ball[1] = ball[1] + ball_velocity[1] * deltaTime
    ball[2] = ball[2] + ball_velocity[2] * deltaTime
    
    for x = 1, 10 do
        for y = 1, 10 do
            game.setPixel(floor(ball[1] + x - 5), floor(ball[2] + y - 5), 125, 125, 125)
        end
    end    
end)

--game loop
game.setFps(60)
while true do game.run() end