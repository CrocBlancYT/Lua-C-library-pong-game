

local function setup(imports, game)
    local signals = imports.signals

    return {
        onHeartbeat = signals.newEvent(),
        onRender = signals.newEvent()
    }
end

return setup