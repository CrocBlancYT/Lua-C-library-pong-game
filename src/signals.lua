local signals = {}

local async_events = {}

local function disconnect( signal )
    signal._parent[signal._name] = nil
end

local function connect( root, f )
    local _, _, addr = string.find(tostring(f), '^function: (.-)$')
    
    local signal = {
        _parent = root._signals,
        _name = addr,
        _f = f,

        Disconnect = disconnect
    }

    root._signals[addr] = signal

    return signal
end

local function connect_once( root, f )
    local signal = connect(root, f)
    signal._once = true
    return signal
end

local function fire( root, ... )
    for _, signal in pairs(root._signals) do
        signal._f(...)
        if signal._once then disconnect(signal) end
    end
end

function signals.newEvent(activateFunction)
    local root = { _signals = {} }

    if activateFunction then
        root._asyncFuncCheck = activateFunction
        table.insert(async_events, root)
    end

    root.Connect = connect
    root.ConnectOnce = connect_once
    root.Fire = fire
    
    return root
end

function signals.runAsyncEvents()
    local function try(event, activate, ...)
        if activate then
            event:Fire(...)
        end
    end

    for _, event in pairs(async_events) do
        try(event, event._asyncFuncCheck())
    end
end

return signals

--[[

{
.runAsyncEvents()
    
.newEvent()
    event
        :Connect()
            signal
                :Disconnect()
            
        :ConnectOnce()
            signal
                :Disconnect()

        :Fire()
}

]]