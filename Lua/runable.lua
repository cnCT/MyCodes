local srcDir = "/Lua"
local t = io.popen("pwd")
local pwd = t:read("*line")
print(pwd)
local _,endPos = string.find(pwd,srcDir)
pwd = string.sub(pwd,0,endPos)

package.path = pwd ..'/?.lua;'.. pwd ..'/luaFramework/?.lua;'.. pwd ..'/luaFramework/red/?.lua;'.. pwd ..'/luaFramework/cc/mvc/?.lua;'.. pwd ..'/luaFramework/cc/components/behavior/?.lua;'.. pwd ..'/luaFramework/cc/?.lua;'.. pwd ..'/CustomGoods/?.lua;'.. pwd ..'/Eliminate/?.lua;'.. pwd ..'/Stage/?.lua;'.. pwd ..'/Data/ScoreConfig/?.lua;'
package.path = package.path .. pwd .. "/Grid/?.lua;"

GV_MUSICE_EX = ".mp3"
require "functions"
require "init"

-- -- return
CCLOG = function(...)
	print(...)
end

CCLOGF = function(...)
	print(string.format(...))
end

Assert = function( ... )
    -- body     
    assert(...)
end
local baseClockTime = os.clock()
printClock = function( ... )
    -- body
    print(...)
    print(string.format("Clock is %.5f",os.clock()-baseClockTime))
    baseClockTime = os.clock()
end

--打印某对象的值
GF_dump = function(object, label, nesting, nest)
	if type(nesting) ~= "number" then nesting = 99 end
    local lookup_table = {}
    local function _dump(object, label, indent, nest)
        label = label or "<var>"
        if type(object) ~= "table" then
            print(string.format("%s%s = %s", indent, tostring(label), tostring(object)..""))
        elseif lookup_table[object] then
            print(string.format("%s%s = *REF*", indent, tostring(label)))
        else
            lookup_table[object] = true
            if nest > nesting then
                print(string.format("%s%s = *MAX NESTING*", indent, label))
            else
                print(string.format("%s%s = {", indent, tostring(label)))
                local indent2 = indent.."    "
                for k, v in pairs(object) do
                    _dump(v, k, indent2, nest + 1)
                end
                print(string.format("%s}", indent))
            end
        end
    end
    
    _dump(object, label, "- ", 1)
end
-- require "main"

function dump(object, label, isReturnContents, nesting)
    if type(nesting) ~= "number" then nesting = 99 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    CCLOG("dump from: " .. string.trim(traceback[3]))

    local function _dump(object, label, indent, nest, keylen)
        label = label or "<var>"
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(label)))
        end
        if type(object) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(label), spc, _v(object))
        elseif lookupTable[object] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, label, spc)
        else
            lookupTable[object] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, label)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(label))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(object) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(object, label, "- ", 1)

    if isReturnContents then
        return table.concat(result, "\n")
    end

    for i, line in ipairs(result) do
        CCLOG(line)
    end
end

function vardump(object, label)
    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local function _vardump(object, label, indent, nest)
        label = label or "<var>"
        local postfix = ""
        if nest > 1 then postfix = "," end
        if type(object) ~= "table" then
            if type(label) == "string" then
                result[#result +1] = string.format("%s%s = %s%s", indent, label, _v(object), postfix)
            else
                result[#result +1] = string.format("%s%s%s", indent, _v(object), postfix)
            end
        elseif not lookupTable[object] then
            lookupTable[object] = true

            if type(label) == "string" then
                result[#result +1 ] = string.format("%s%s = {", indent, label)
            else
                result[#result +1 ] = string.format("%s{", indent)
            end
            local indent2 = indent .. "    "
            local keys = {}
            local values = {}
            for k, v in pairs(object) do
                keys[#keys + 1] = k
                values[k] = v
            end
            table.sort(keys, function(a, b)
                if type(a) == "number" and type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b)
                end
            end)
            for i, k in ipairs(keys) do
                _vardump(values[k], k, indent2, nest + 1)
            end
            result[#result +1] = string.format("%s}%s", indent, postfix)
        end
    end
    _vardump(object, label, "", 1)

    return table.concat(result, "\n")
end