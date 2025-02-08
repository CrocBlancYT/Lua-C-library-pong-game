local color3 = {}

local function lerp(color1, color2, alpha)
    local r1, g1, b1 = color1.r, color1.g, color1.b
    local r2, g2, b2 = color2.r, color2.g, color2.b

    local d_r, d_g, d_b = r2-r1, g2-g1, b2-b1

    return color3.new(
        r1 + d_r*alpha,
        g1 + d_g*alpha,
        b1 + d_b*alpha
    )
end

local function to_hex(color)
    local rgb = (color.r * 0x10000) + (color.g * 0x100) + color.b
    return string.format("%x", rgb)
end

function color3.new(r,g,b)
    return {
        r=r, g=g, b=b,
        lerp=lerp, hex=to_hex
    }
end

function color3.fromHex(hex)
    hex = hex:gsub("#","")
    local r,g,b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    return color3.new(r,g,b)
end

return color3