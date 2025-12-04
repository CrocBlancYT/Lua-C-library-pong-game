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
local ball_velocity = {100, 100}

--object behavior
game.onRender:Connect(function (deltaTime)
    local speed = 350*deltaTime
    
    if inputs.isKeyDown('Z') then bluePadY = bluePadY + speed end
    if inputs.isKeyDown('S') then bluePadY = bluePadY - speed end
    if inputs.isKeyDown('UP ARROW') then redPadY = redPadY + speed end
    if inputs.isKeyDown('DOWN ARROW') then redPadY = redPadY - speed end

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
    
    game.drawLine(
        floor(ball[1]), floor(ball[2]),
        floor(ball[1]-ball_velocity[1]//5), floor(ball[2]-ball_velocity[2]//5),
        125, 125, 125
    )
end)

--game loop
game.setFps(60)
while true do game.run() end