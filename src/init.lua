local graphics = assert(require('graphics'))
local json = assert(dofile('json.lua'))

local imports = { json=json }
local game

local function import(name)
    local setup, _private= dofile('./src/import/'..name..'.lua')

    if type(setup) == "table" then
        imports[name] = setup
        return _private
    end

    local public, private = setup(imports, game)
    imports[name] = public
    return private
end

local function init(name, width, height)
    --window init
    local x_offset = 1
    local y_offset = 1

    local width_offset = 15 + x_offset + 1
    local height_offset = 40 + y_offset + 2

    graphics.initScreen( name, width+width_offset, height+height_offset )


    --game imports
    game = { pixels_wrt_cm = 37.795, height=height, width=width }

    --data
    import('keycodes')

    --core objects
    import('signals')
    import('vector2')
    import('tags')
    import('color3')

    -- utils / events processing
    local inputs = import('user_inputs')
    local run_settings = import('run_service')
    import('data_store')
    import('pid')
    import('rays')

    --objects interactions
    import('collisions')
    import('physics')

    local interface = import('user_interface')

    local onHeartbeat = imports.run_service.onHeartbeat
    local onRender = imports.run_service.onRender

    local onScreenEvent = imports.signals.newEvent()
    onScreenEvent:Connect(inputs.processEvent)

    imports.user_inputs.mouse.ButtonDown:Connect(interface.fireClicks)

    --[[
    imports.user_inputs.inputChanged:Connect(function ( event )
        if not (event.inputType == 'Screen_Resize' or event.inputType == 'Screen_Move') then return end

        print(event)
        for i, v in pairs(event) do
            print(i, v)
        end
    end)
    ]]

    local fps = run_settings.defaultFps
    function imports.run_service.setFps(newFps)
        fps = newFps
    end

    --game methods
    function game.run()
        local deltaTime = graphics.wait(1/fps)

        graphics.clearScreen() --clear screen to redraw

        while true do --process events
            local event = graphics.getEventAsync()
            if not event then break end
            onScreenEvent:Fire(event, deltaTime)
        end

        onHeartbeat:Fire(deltaTime)
        onRender:Fire(deltaTime) --redraw

        graphics.refreshScreen()
    end

    function game.setPixel(x,y, r,g,b)
        graphics.setPixel(x+x_offset, height-y+y_offset, r,g,b)
    end

    function game.getPixel(x,y)
        return graphics.getPixel(x+x_offset,height-y+y_offset)
    end

    function game.drawLine(x1,y1, x2,y2, r,g,b)
        graphics.drawLine(
            x1+x_offset, height-y1+y_offset,
            x2+x_offset, height-y2+y_offset,
            r,g,b)
    end

    --game ready
    return game
end

return init, imports