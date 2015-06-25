package.path = package.path .. ";../?.lua;"
require "runable"
require "NBEliminate"
map = {
{0,0,5,5,5,5,5,0,0},
{4,0,5,5,6,5,6,0,3},
{3,2,5,5,5,5,5,2,1},
{3,2,4,5,4,5,1,2,2},
{2,3,4,5,3,4,1,4,5},
{3,6,4,1,4,5,6,3,6},
{6,6,3,5,3,4,1,6,3},
{6,0,3,2,1,6,4,0,6},
{0,0,2,6,4,4,5,0,0},
{},}

local m_map = {
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
{0,0,0,0,0,0,0,0,0},
}

local Priority = {
	CROSS = 16,
	FIVE = 8,
	FOUR = 4,
	THREE = 3,
}

local xCount,yCount = 9,9
local xx = {{},{}}
local clashs = {}
local eliminateFormatArray = {}
function helloT( ... )
	-- body
	for i=1,xCount do
		local startPos = {1,1}
		local len = {1,1}
		local function cpv( value, startPosValue, index, j )
			-- body
			-- print("Value is ",value, startPosValue, index)
			-- GF_dump(len)
			if value and startPosValue~=0 and value==startPosValue then
				len[index] = len[index] + 1
			else
				if len[index]>=3 then
					xx[index][i] = xx[index][i] or {}
					xx[index][i][#xx[index][i]+1] = {startPos[index],j-1}
					for k=startPos[index],j-1 do
						if index == 1 then
							m_map[i][k] = m_map[i][k] + 1
							if m_map[i][k]>1 then
								clashs[#clashs+1] = {x=i,y=k}
							end
						else
							m_map[k][i] = m_map[k][i] + 1
							if m_map[k][i]>1 then
								clashs[#clashs+1] = {x=k,y=i}
							end
						end
					end
					print(i.."Thress!!"..index)
				end
				len[index] = 1
				startPos[index] = j
			end	
		end
		for j=2,yCount+1 do
			-- local value1 = {map[i][startPos[1]],map[startPos[2]][i]}
			-- local value2 = {map[i][j],map[j][i]}
			cpv(map[i][j], map[i][startPos[1]], 1, j)
			cpv(map[j][i], map[startPos[2]][i], 2, j)
		end
	end
	print2_DArray(m_map)
	-- printClock()
	-- GF_dump(clashs)
end

function getFormatArray( ... )
	-- body

end

-- ***@*** 七连中间未处理
function checkSelfIsTrible( i, array )
	-- body
	if i-array[1]>=3 then
		return true,array[1],i-1
	elseif array[2]-i>=3 then
		return true,i+1,array[2]
	end
	return false
end

function processClashs( ... )
	-- body
	local function find( array, value )
		-- body
		for i,v in ipairs(array) do
			if value>=v[1] and value<=v[2] then
				return i
			end
		end
		return 0
	end

	local function processClash( x, y )
		-- body
		-- print("P ",x,y)
		local xi, yi = find(xx[1][x],y), find(xx[2][y],x)
		if xi==0 and yi==0 then 
			return true
		end
		local xArray = xx[1][x][xi]
		local yArray = xx[2][y][yi]
		-- GF_dump(point,"point")
		-- GF_dump(xArray)
		-- GF_dump(yArray)
		if xArray and yArray then
			-- print("X Y TT",x,y)
			local priority = Priority.CROSS + math.max(Priority.FIVE,math.max(xArray[2]-xArray[1],yArray[2]-yArray[1]))
			eliminateFormatArray[#eliminateFormatArray+1] = {xArray = xArray, yArray = yArray, ftype=priority, center={x,y}}
			xx[1][x][xi] = nil
			xx[2][y][yi] = nil
			for i=xArray[1], xArray[2] do
				if m_map[x][i] > 1 then
					processClash(x,i)
				end
			end
			for i=yArray[1], yArray[2] do
				if m_map[i][y] > 1 then
					processClash(i,y)
				end
			end
		elseif xArray then
			local flag,r1,r2 = checkSelfIsTrible(y,xArray)
			-- print("X TT",flag,r1,r2)
			if flag then
				xArray[1] = r1
				xArray[2] = r2
			else
				xx[1][x][xi] = nil
			end
		elseif yArray then
			local flag,r1,r2 = checkSelfIsTrible(x,yArray)
			-- print("Y TT",flag,r1,r2)
			if flag then
				yArray[1] = r1
				yArray[2] = r2
			else
				xx[2][y][yi] = nil
			end
		end
		return false
	end
	for i,point in ipairs(clashs) do
		processClash(point.x, point.y)
	end
end

function processLast( ... )
	-- body
	for index,array in ipairs(xx) do
		for x,childArray in pairs(array) do
			for _,tt in pairs(childArray) do
				local value = tt[2]-tt[1]
				if value < 3 then goto fk end
				local priority = value>=5 and Priority.FIVE or value
				if index == 1 then
					eliminateFormatArray[#eliminateFormatArray+1] = {xArray = tt, ftype=priority, center={x,value/2}}
				elseif index == 2 then
					eliminateFormatArray[#eliminateFormatArray+1] = {yArray = tt, ftype=priority, center={value/2,x}}
				end
				::fk::
			end
		end
	end
end

function initTestMap( ... )
	-- body
	for i=1,xCount do
		for j=1, yCount do
			map[i][j] = 1
		end
	end
end
printClock()
-- initTestMap()
helloT()
-- GF_dump(xx)
processClashs()
processLast()
printClock()
-- GF_dump(xx)
-- GF_dump(eliminateFormatArray,"eliminateFormatArray")