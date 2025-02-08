local hex_keycodes = {
    ['0x08'] = 'BACKSPACE',
    ['0x09'] = 'TAB',
    ['0x0C'] = 'CLEAR',
    ['0x0D'] = 'ENTER',
    ['0x10'] = 'SHIFT',
    ['0x11'] = 'CTRL',
    ['0x12'] = 'ALT',
    ['0x13'] = 'PAUSE',
    ['0x1B'] = 'ESCAPE',

    ['0x20'] = 'SPACEBAR',

    ['0x25'] = 'LEFT ARROW',
    ['0x26'] = 'UP ARROW',
    ['0x27'] = 'RIGHT ARROW',
    ['0x28'] = 'DOWN ARROW',

    ['0x29'] = 'SELECT',

    ['0x2D'] = 'INSERT',
    ['0x2E'] = 'DELETE',

    ['0x30'] = 'zero',
    ['0x31'] = 'one',
    ['0x32'] = 'two',
    ['0x33'] = 'three',
    ['0x34'] = 'four',
    ['0x35'] = 'five',
    ['0x36'] = 'six',
    ['0x37'] = 'seven', 
    ['0x38'] = 'eight',
    ['0x39'] = 'nine',

    ['0x41'] = 'A',
    ['0x42'] = 'B',
    ['0x43'] = 'C',
    ['0x44'] = 'D',
    ['0x45'] = 'E',
    ['0x46'] = 'F',
    ['0x47'] = 'G',
    ['0x48'] = 'H',
    ['0x49'] = 'I',
    ['0x4A'] = 'J',
    ['0x4B'] = 'K',
    ['0x4C'] = 'L',
    ['0x4D'] = 'M',
    ['0x4E'] = 'N',
    ['0x4F'] = 'O',
    ['0x50'] = 'P',
    ['0x51'] = 'Q',
    ['0x52'] = 'R',
    ['0x53'] = 'S',
    ['0x54'] = 'T',
    ['0x55'] = 'U',
    ['0x56'] = 'V',
    ['0x57'] = 'W',
    ['0x58'] = 'X',
    ['0x59'] = 'Y',
    ['0x5A'] = 'Z',

    ['0x6A'] = 'multiply',
    ['0x6B'] = 'add',
    ['0x6C'] = 'seperator',
    ['0x6D'] = 'substract',
    ['0x6E'] = 'decimal',
    ['0x6F'] = 'divide',

    ['0x70'] = 'F1',
    ['0x71'] = 'F2',
    ['0x72'] = 'F3',
    ['0x73'] = 'F4',
    ['0x74'] = 'F5',
    ['0x75'] = 'F6',
    ['0x76'] = 'F7',
    ['0x77'] = 'F8',
    ['0x78'] = 'F9',
    ['0x79'] = 'F10',
    ['0x7A'] = 'F11',
    ['0x7B'] = 'F12',
    ['0x7C'] = 'F13',
    ['0x7D'] = 'F14',
    ['0x7E'] = 'F15',
    ['0x7F'] = 'F16',
    ['0x80'] = 'F17',
    ['0x81'] = 'F18',
    ['0x82'] = 'F19',
    ['0x83'] = 'F20',
    ['0x84'] = 'F21',
    ['0x85'] = 'F22',
    ['0x86'] = 'F23',
    ['0x87'] = 'F24',

    ['0xA2'] = 'Left Control',
    ['0xA3'] = 'Right Control',

    ['0xA4'] = 'Left Alt',
    ['0xA5'] = 'Right Alt'
}

local code_to_key = {}
local key_to_code = {}

for hex, key in pairs(hex_keycodes) do
    local code = tostring(tonumber(hex))
    code_to_key[code] = key
    key_to_code[key] = code
end

local function setup()
    return {
        code_to_key = code_to_key,
        key_to_code = key_to_code
    }
end

return setup