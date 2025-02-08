local function read_only(table)
    setmetatable(table, {
        __index = function (t, k)
            error('table is read-only')
        end,
        __newindex = function (t, k)
            error('table is read-only')
        end
    })
    return table
end

local function table_find(table, val)
    for i, v in pairs(table) do
        if v == val then
            return i
        end
    end
end

local tags = {
    tagged = {},
    tags = {}
}

function tags.startTag(tagName) --creates a new tag
    if tags.tagged[tagName] then print('tag already present') return end

    table.insert(tags.tags, tagName)
    local tag = {}
    tags.tagged[tagName] = tag

    return tag
end

function tags.endTag(tagName) --completly deletes a tag
    local tag_index = table_find(tags.tags, tagName)
    if not tag_index then error('no tag found') end

    tags.tagged[tagName] = nil
    table.remove(tags.tags, tag_index)
end

function tags.tag(table, tagName) --adds a tag to a table
    local tag = tags.tagged[tagName]
    if not tag then error('no tag found') end

    table.insert(tag, table)
end

function tags.untag(table, tagName) --remove a tag from a table
    local tag = tags.tagged[tagName]
    if not tag then error('no tag found') end

    local table_index = table_find(tag, table)
    if not table_index then error('table not tagged') end

    table.remove(tag, table_index)
end

function tags.all_tags() return tags.tags end --returns all tagNames

function tags.all_tables(tagName) --returns all tables from a tag
    local tag = tags.tagged[tagName]
    if not tag then error('no tag found') end

    return tag[tagName]
end

return tags