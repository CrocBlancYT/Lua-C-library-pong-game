local code_to_key = {}
local key_to_code = {}

--[[
local function isKey(name)
    return (string.sub(name, 1, 3) == 'Key') or (string.sub(name, 1, 7) == 'Sys_Key')
end

local function isMouse(name)
    return (string.sub(name, 1, 5) == 'Mouse')
end
]]

local function getState(name)
    local len = string.len(name)

    if (string.sub(name, len-1, len) == 'Up') then
        return 'Up'
    end
    
    local sub_4 = string.sub(name, len-3, len)

    if (sub_4 == 'Down') then
        return 'Down'
    elseif (sub_4 == 'Move') then
        return 'Move'
    end
    
    local sub_6 = string.sub(name, len-5, len)

    if sub_6 == 'Resize' then
        return 'Resize'
    elseif sub_6 == 'Scroll' then
        return 'Scroll'
    end
end

local function forward(signal, name, state, _info, deltaTime)
    --event output
    local input = {
        inputState = state,
        inputType = name,

        keycode = tostring(_info.keycode),
        mouseButton = _info.button,

        position = _info.pos,
        delta = _info.dlt
    }
    
    signal:Fire(input, deltaTime)
end

local function processEvent(signals, event, deltaTime)
    --event state
    local name = event.name

    local state = getState(name)

    local signal = signals.otherEvents

    --buttons & keys
    if state == 'Up' then
        signal = signals.inputEnded
        state = 'End'
    elseif state == 'Down' then
        if event.is_held then
            signal = signals.inputChanged --repetition
            state = 'Change'
        else
            signal = signals.inputBegan
            state = 'Began'
        end
    elseif (state == 'Scroll') or (state == 'Move')or (state == 'Resize') then
        signal = signals.inputChanged
        state = 'Change'
    end

    forward(signal, name, state, event, deltaTime)
end

local function setup(game)
    --imports
    local signals = dofile('./src/signals.lua')
    local vector2 = dofile('./src/vector2.lua')
    local keycodes = dofile('./src/keycodes.lua')

    --keycodes
    for code, key in pairs(keycodes) do
        code = tostring(tonumber(code))
        code_to_key[code] = key
        key_to_code[key] = code
    end

    --value holders
    local keys = {}
    local mouse = {
        x = 0,
        y = 0,

        Moved = signals.newEvent(),
        
        ButtonDown = signals.newEvent(),
        ButtonUp = signals.newEvent()
    }

    --public values
    local inputs
    inputs = {
        keys = keys,
        inputBegan = signals.newEvent(),
        inputChanged = signals.newEvent(),
        inputEnded = signals.newEvent(),

        otherEvents = signals.newEvent(),

        isKeycodeDown = function (keycode)
            return keys[tostring(keycode)] or false
        end,

        isKeyDown = function (key)
            return keys[key_to_code[key]] or false
        end,

        parseKeycode = function (keycode)
            if not keycode then return end
            return code_to_key[keycode]
        end,

        keycodes = key_to_code,

        mouse = mouse,

        __process = function (event, deltaTime)
            --vector process
            if event.x and event.y then
                event.pos = vector2.new(
                    event.x,
                    game.height-event.y
                )
            end

            if event.dx or event.dy then
                event.dlt = {
                    x = event.dx,
                    y = event.dy
                }
            end

            --event classification (type, state..)
            processEvent(inputs, event, deltaTime)
        end
    }

    --value holders
    local function state_changed(input)
        if input.position then --mouse input
            if input.inputState == 'Began' then
                mouse.ButtonDown:Fire(input)
            else
                mouse.ButtonUp:Fire(input)
            end
        elseif input.keycode then --keyboard input
            keys[input.keycode] = (input.inputState == 'Began')
        end
    end

    inputs.inputBegan:Connect(state_changed)
    inputs.inputEnded:Connect(state_changed)

    inputs.inputChanged:Connect(function(input)
        local pos = input.position
        if pos then
            local x, y = pos.x, pos.y
            mouse.x = x
            mouse.y = y

            mouse.Moved:Fire(x, y)
        end
    end)

    return inputs
end

return setup