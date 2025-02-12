local data_store = {}

local json
local defaultPath = './data/'

local function save(metadata, filename)
    --table data get
    local content = metadata.data

    --json encoded (table -> string)
    local raw = json.encode(content)

    --io set operation
    local h = io.open(defaultPath .. filename, "w+")
    if not h then return end
    h:write(raw)
    h:close()

    return true
end

local function load(metadata, filename)
    --io get operation
    local h = io.open(defaultPath .. filename, "r")
    if not h then return end
    local raw = h:read("*a")
    h:close()

    --json decoded(string -> table)
    local new_data = json.decode(raw)

    --table data set (clear + replace)
    local old_data = metadata.data
    for i, _ in pairs(old_data) do old_data[i] = nil end
    for i, v in pairs(new_data) do old_data[i] = v end
    
    return true
end

local function handle()
    local data = {}
    local metadata = {save=save, load=load, data=data}
    return data, metadata
end

local function setup(imports)
    json = imports.json

    local public = {handle=handle}
    local private = {}

    return public, private
end

return setup