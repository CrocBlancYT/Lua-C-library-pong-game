local graphics = assert(require('graphics'))

local width, height = 1920/2, 1080/2
local window = graphics.setupWindow('Hello', width, height)


local pixels_wrt_cm = 37.795 --37 pixels = 1cm

local function onEvent(event, deltaTime)
    print(event.msgClass)
end

local function onFrame(deltaTime)
end

local function run()
    local deltaTime = graphics.wait(1/fps)

    while true do
        local event = graphics.runEventAsync()
        if not event then break end
        onEvent(event, deltaTime)
    end

    graphics.clear(window)
    onFrame(deltaTime)
end

