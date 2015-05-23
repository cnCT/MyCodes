package.path = package.path .. ";../?.lua;"
require "runable"
local eliminateFormatArray = require "NBEliminate"

-- dump(eliminateFormatArray,"eliminateFormatArray")

local Drop = {}
local xCount,yCount = 9,9

function Drop:ctor( ... )
	-- body

end

function Drop:init( ... )
	-- body
	self.ExitList = {}
	self.Map = {}
	self.PathMap = {}
end

function Drop:initExitList( ... )
	-- body
	self.ExitList = {p(1,1), p(1,2), p(1,3), p(1,4), p(1,5), p(1,6), p(1,7)}
end

function Drop:getUpValue( x,y )
    -- body
    if x>1 then
        local value = self.PathMap[x-1][y]
        if value and value~=-1 then
            return value+1
        end
    end
    return false
end

function Drop:getLeftValue( x,y )
    -- body
    if x>1 and y>1 then
        local value = self.PathMap[x-1][y-1]
        if value and value~=-1 then
            return value+3
        end
    end
    return false
end

function Drop:getRightValue( x,y )
    -- body
    if x>1 and y<yCount then
        local value = self.PathMap[x-1][y+1]
        if value and value~=-1 then
            return value+2
        end
    end
    return false
end
--出口 开始向下便利  向下+1 左+2 右+3 
function Drop:initPathValue( ... )
    -- body
    for _,point in ipairs(self.ExitList) do
        self.PathMap[point.x] = self.PathMap[point.x] or {}
        self.PathMap[point.x][point.y] = 1
    end
    for i=1,xCount do
        self.PathMap[i] = self.PathMap[i] or {}
        for j=1,yCount do
            if map[i][j]==0 then
                self.PathMap[i][j] = -1
            elseif self.PathMap[i][j]==nil then
                -- print(getUpValue(i,j), getRightValue(i,j), getLeftValue(i,j))
                local value = self:getUpValue(i,j) or self:getRightValue(i,j) or self:getLeftValue(i,j)
                if type(value) == "boolean" then
                    self.PathMap[i][j] = 1                                   
                else
                    self.PathMap[i][j] = value
                end
            end
        end
    end
end

function p( x,y )
    -- body
    return {x=x, y=y}
end

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
function Drop:find( x,y )
    -- body
    if x<1 or x>xCount or y<1 or y>yCount then return false end
    -- if isInEliminateMap(x,y) then
    --     return true
    -- end
    local value = self.PathMap[x][y]
    if value and value~=-1 then
        return value
    end
    return false
end

function Drop:findUp( x,y )
    -- body
    return self:find(x-1,y)
end

function Drop:findLeft( x,y )
    -- body
    return self:find(x-1,y-1)
end

function Drop:findRight( x,y )
    -- body
    return self:find(x-1,y+1)
end

function Drop:findOneWay( x,y )
    -- body
    local value = 0
    local xx,yy = x,y
    local tt
    local path = {}
    for i=1,2*xCount do
        local value = self:findUp(xx,yy)
        if value==false then
            local value = self:findLeft(xx,yy)
            if value== false then
                value = self:findRight(xx,yy)
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

function Drop:processDrop( ... )
	-- body
	self.EliminateList = {p(9,3),p(8,3),p(7,3),p(6,3)}
	self:init()
	self:initExitList()
	self:initPathValue()
	for _,point in ipairs(self.EliminateList) do
        dump(self:findOneWay(point.x, point.y))
    end
end

Drop:processDrop()