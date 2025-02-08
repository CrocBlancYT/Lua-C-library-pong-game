local data_store = {}

local function toboolean(e)
    if string.lower(e) == "true" then return true end
    if string.lower(e) == "false" then return false end
end

local function save(metadata, filename)
    local content = metadata.data

    local raw = ""
    for i, v in pairs(content) do
        local line = tostring(i) .. "=" .. (tonumber(v) or toboolean(v) or tostring(v))
        raw = raw .. line .. "\n"
    end

    local h = io.open(filename, "w+")
    if not h then return end
    h:write(raw)
    h:close()

    return true
end

local function load(metadata, filename)
    local h = io.open(filename, "r")
    if not h then return end
    local raw = h:read("*a")
    h:close()

    local content = {}

    for i, v in pairs(string.gmatch(raw, "^(.-)=(.*)$")) do
        content[i] = (tonumber(v) or toboolean(v) or tostring(v))
    end

    metadata.data = content
    
    return true
end

local function handle()
    local data = {}
    local metadata = {save=save, load=load, data=data}
    return data, metadata
end

local function setup()
    local public = {handle=handle}
    local private = {}

    return public, private
end

return setup