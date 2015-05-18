print "Hello World~~"

math.randomseed(os.time())
math.random()
math.random()

local point = {x,y}

function p( x,y )
    -- body
    return {x=x, y=y}
end

local map = {
    {8,8,8,8,8,8,8},
    {},
    {},
    {},
    {},
    {},
    {},
}

local pathMap = {
    {},
    {},
    {},
    {},
    {},
    {},
    {},
}

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

    -- local traceback = string.split(debug.traceback("", 2), "\n")
    -- CCLOG("dump from: " .. string.trim(traceback[3]))

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
        print(line)
    end
end

--打印二维数组
function print2_DArray( array )
    -- body
    -- if not OPEN_CCLOG then return end
    if not array then
        return
    end
    -- local traceback = string.split(debug.traceback("", 2), "\n")
    -- CCLOG("print2_DArray from: " .. string.trim(traceback[3]))
    for _,v in ipairs(array) do
        local str = ""
        for _,vv in ipairs(v) do
            -- str = str..vv.."\t"
            str = string.format("%s%s\t",str,vv)
        end
        print(str)
    end
    print()
end
local xCount,yCount = 7,7
function initRandomMap( ... )
    -- body
    local xx = {1, 1, 0}
    for i=1,xCount do
        for j=1,yCount do
            map[i][j] = xx[math.random(1,3)]
        end
    end
end

local ExitList = {p(1,1), p(1,2), p(1,3), p(1,4), p(1,5), p(1,6), p(1,7)}

-- initRandomMap()
map = { 
        {0,0,0,1,1,0,0,},
        {1,1,0,1,1,1,1,},
        {1,1,0,1,1,1,1,},
        {1,1,0,1,1,1,1,},
        {0,1,1,1,1,1,1,},
        {1,1,1,1,0,0,1,},
        {0,1,1,0,1,1,1,},
    }
print2_DArray(map)

function getUpValue( x,y )
    -- body
    if x>1 then
        local value = pathMap[x-1][y]
        if value and value~=-1 then
            return value+1
        end
    end
    return false
end

function getLeftValue( x,y )
    -- body
    if x>1 and y>1 then
        local value = pathMap[x-1][y-1]
        if value and value~=-1 then
            return value+3
        end
    end
    return false
end

function getRightValue( x,y )
    -- body
    if x>1 and y<yCount then
        local value = pathMap[x-1][y+1]
        if value and value~=-1 then
            return value+2
        end
    end
    return false
end

--出口 开始向下便利  向下+1 左+2 右+3 
function initPathValue( ... )
    -- body
    for _,point in ipairs(ExitList) do
        pathMap[point.x] = pathMap[point.x] or {}
        pathMap[point.x][point.y] = 1
    end
    for i=1,xCount do
        pathMap[i] = pathMap[i] or {}
        for j=1,yCount do
            if map[i][j]==0 then
                pathMap[i][j] = -1
            elseif pathMap[i][j]==nil then
                -- print(getUpValue(i,j), getRightValue(i,j), getLeftValue(i,j))
                local value = getUpValue(i,j) or getRightValue(i,j) or getLeftValue(i,j)
                if type(value) == "boolean" then
                    pathMap[i][j] = 1                                   
                else
                    pathMap[i][j] = value
                end
            end
        end
    end
end

local EliminateList = {p(5,2)}--,p(6,3),p(5,3)}
initPathValue()
print2_DArray(pathMap)
local EliminateMap = {[5]={[3]=3},[6]={[3]=3},[7]={[3]=3},}
function isInEliminateMap( x,y )
    -- body
    if EliminateMap[x] and EliminateMap[x][y] then
        return true
    end
    return false
end
--寻找时先向上查找直到 X或者出口 
--如果 找到的是X 则 按照路径的 数值大小进行比较
local function find( x,y )
    -- body
    if x<1 or x>xCount or y<1 or y>yCount then return false end
    if isInEliminateMap(x,y) then
        return true
    end
    local value = pathMap[x][y]
    if value and value~=-1 then
        return value
    end
    return false
end

function findUp( x,y )
    -- body
    return find(x-1,y)
end

function findLeft( x,y )
    -- body
    return find(x-1,y-1)
end

function findRight( x,y )
    -- body
    return find(x-1,y+1)
end

function findOneWay( x,y )
    -- body
    local value = 0
    local xx,yy = x,y
    local tt
    local path = {}
    for i=1,2*xCount do
        local value = findUp(xx,yy)
        if value==false then
            local value = findLeft(xx,yy)
            if value== false then
                value = findRight(xx,yy)
                tt = {p(xx-1,yy+1),p(xx,yy)}
                xx,yy = xx-1,yy+1
                goto fk
            else
                tt = {p(xx-1,yy-1),p(xx,yy)}
                xx,yy = xx-1,yy-1
                goto fk
            end
        else
            tt = {p(xx-1,yy),p(xx,yy)}
            xx,yy = xx-1,yy
            goto fk
        end
        ::fk::
        -- print(tt[1], tt[2], value, xx, yy)
        -- dump(tt[1])
        -- dump(tt[2])
        path[#path+1] = tt              
        if value == 1 then
            break
        end
    end
    return path
end

function processDrop( ... )
    -- body
    for _,point in ipairs(EliminateList) do
        dump(findOneWay(point.x, point.y))
    end
end

processDrop()