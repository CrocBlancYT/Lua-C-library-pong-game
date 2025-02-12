local gui = {
    frames = {}
}

local default = {
    size = { x= 40, y=40 },
    position = { x= 0, y=0 },
    color = {r=255, g=255, b=255}
}

local signals
local vector2
local game

function gui.renderBox(box)
    local pos, size, rot, rgb = box.position, box.size, box.rotation, box.color

    size = size:div(2)

    local points = {
        pos:add(vector2.new(size.x, size.y):rotate(rot)),
        pos:add(vector2.new(size.x, -size.y):rotate(rot)),
        pos:add(vector2.new(-size.x, -size.y):rotate(rot)),
        pos:add(vector2.new(-size.x, size.y):rotate(rot)),
        pos:add(vector2.new(size.x, size.y):rotate(rot))
    }

    local r, g, b = rgb.r, rgb.g, rgb.b

    for i = 1, #points-1 do
        local point, next_point = points[i], points[i+1]
        game.drawLine(math.floor(point.x), math.floor(point.y), math.floor(next_point.x), math.floor(next_point.y), r, g, b)
    end

    return points
end

function gui.newBox(position, size, color, clickable)
    local frame = {
        position = position
            or vector2.new(default.position), --default

        size = size
            or vector2.new(default.size),  --default

        color = color
            or default.color,  --default

        rotation = 0,

        clickable = clickable,
        shape = 'box'
    }

    frame.onMouseButton = signals.newEvent()

    local index = #gui.frames
    table.insert(gui.frames, frame)

    return frame, index+1
end

local function fireClicks(input)
    local pos = input.position
    local x, y = pos.x, pos.y
    
    for _, frame in pairs(gui.frames) do
        local pos = frame.position
        local size = frame.size:div(2)

        if (frame.clickable) and (pos.x-size.x < x and x < pos.x+size.x) and (pos.y-size.y < y and y < pos.y+size.y) then
            frame.onMouseButton:Fire(input)
        end
    end
end

local function setup(imports, _game)
    signals = imports.signals
    vector2 = imports.vector2
    game = _game

    return gui, { fireClicks=fireClicks }
end

return setup