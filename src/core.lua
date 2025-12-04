local graphics = assert(require('graphics'))

local function init(name, width, height)
    --window init
    local x_offset = 1
    local y_offset = 1

    local width_offset = 15 + x_offset + 1
    local height_offset = 40 + y_offset + 2

    graphics.initScreen( name, width+width_offset, height+height_offset )


    --game imports
    local game = { pixels_wrt_cm = 37.795, height=height, width=width }
    _G.game = game -- game is game..
    
    _G.signals = dofile('./src/signals.lua')
    _G.vector2 = dofile('./src/vector2.lua')
    
    -- utils / events processing
    _G.inputs = dofile('./src/inputs.lua')(game)
    
    game.onRender = _G.signals.newEvent()
    
    --[[
    imports.user_inputs.inputChanged:Connect(function ( event )
        if not (event.inputType == 'Screen_Resize' or event.inputType == 'Screen_Move') then return end

        print(event)
        for i, v in pairs(event) do
            print(i, v)
        end
    end)
    ]]
    
    local fps = 60
    function game.setFps(new_fps)
        fps = new_fps
    end
    
    --game methods
    function game.run()
        local deltaTime = graphics.wait(1/fps)

        graphics.clearScreen() --clear screen to redraw

        while true do --process events
            local event = graphics.getEventAsync()
            if not event then break end
            inputs.__process(event, deltaTime)
        end
        
        game.onRender:Fire(deltaTime) --redraw

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

return init