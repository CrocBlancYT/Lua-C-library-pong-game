

local function setup(imports, game)
    local signals = imports.signals

    return {
        onHeartbeat = signals.newEvent(),
        onRender = signals.newEvent()
    }, {
        defaultFps = 60
    }
end

return setup