local graphics = assert(require('graphics'))

local function default(_, _) end --_ to silence

local function init(name, width, height)
    local window = graphics.setupWindow(name, width, height)

    local onEvent = default
    local onFrame = default

    local core = {
        _HWND = window._HWND,
        _HDC = window._HDC,

        pixels_wrt_cm = 37.795, --37 pixels = 1cm

        runFrame = function (fps)
            local deltaTime = graphics.wait(1/fps)

            --clear screen to redraw
            graphics.clear(window)

            --process events
            while true do
                local event = graphics.runEventAsync()
                if not event then break end
                onEvent(event, deltaTime)
            end

            --redraw
            onFrame(deltaTime)
        end,
        
        connectEvent = function (new_onEvent)
            onEvent = new_onEvent
        end,
        connectFrame = function (new_onFrame)
            onFrame = new_onFrame
        end
    }

    for i, v in pairs(graphics) do
        core[i] = v
    end

    return core
end

return init