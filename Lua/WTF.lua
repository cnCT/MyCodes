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

local xCount,yCount = 9,9
local xx = {{},{}}
local clashs = {}
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
			local value1 = {map[i][startPos[1]],map[startPos[2]][i]}
			local value2 = {map[i][j],map[j][i]}
			cpv(map[i][j], map[i][startPos[1]], 1, j)
			cpv(map[j][i], map[startPos[2]][i], 2, j)
		end
	end
	print2_DArray(m_map)
	-- printClock()
	-- GF_dump(clashs)
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
	for i,point in ipairs(clashs) do
		local xArray = xx[1][point.x][find(xx[1][point.x],point.y)]
		local yArray = xx[2][point.y][find(xx[2][point.y],point.x)]
		-- GF_dump(point,"point")
		-- GF_dump(xArray)
		-- GF_dump(yArray)
		if xArray and yArray then
			
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
-- initTestMap()
helloT()
processClashs()
printClock()