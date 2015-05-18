package.path = package.path .. ";../?.lua;"
require "runable"
local map = {
{0,0,5,5,5,5,5,0,0},
{4,0,5,5,6,5,6,0,3},
{3,2,5,5,5,5,5,2,1},
{3,2,4,5,4,5,1,2,2},
{2,3,4,5,3,4,1,4,5},
{3,6,4,1,4,5,6,3,6},
{6,6,3,5,3,4,1,6,3},
{6,0,3,2,1,6,4,0,6},
{0,0,2,6,4,4,5,0,0},}

local xCount,yCount = 9,9

--打印二维数组
function print2_DArray( array )
	-- body
	if not array then
		return
	end
	for _,v in ipairs(array) do
		local str = ""
		for _,vv in ipairs(v) do
			str = str..vv.."\t"
		end
		print(str)
	end
	print()
end

local mapArray = {}
local mapArrayT = {}
local eliminateArray = {eliminateX = {},eliminateY = {}}

function initTestMap( _mapArray,_mapArrayT )
	-- body
	for x,v in pairs(map) do
		for y,vv in pairs(v) do
			_mapArray[x] = _mapArray[x] or {}
			_mapArray[x][y] = vv
			_mapArrayT[y] = _mapArrayT[y] or {}
			_mapArrayT[y][x] = _mapArray[x][y]
		end
	end
end

function iterateMap( _mapArray,_isT )
 	-- body
 	local mapArray = _mapArray
 	local xCount = _isT and yCount or xCount --如果为转置 则互换x y值
 	local yCount = _isT and xCount or yCount
 	for i=1,xCount do
		local startPos = 1
		local tmpEliminate = {}	--存储临时可消除数据
		local len = 1 	--连续相同水果长度
		tmpEliminate[startPos] = {} 	--初始化第一个连续数组
		tmpEliminate[startPos][startPos] = startPos
		for j=2,yCount+1 do
			if mapArray[i][j] and mapArray[i][startPos] ~= 0 and mapArray[i][j] == mapArray[i][startPos] then
			   tmpEliminate[startPos][j] = j
			   len = len + 1
			else
			   if len>=3 then
		   		-- print("ssssX"..i)
			   		-- self:saveEliminateArray(tmpEliminate[startPos],i,len,_isT)
			   		local desArray = _isT and eliminateArray.eliminateY or eliminateArray.eliminateX
					desArray[i] = desArray[i] or {}
					-- dump(_tmpEliminate,"_tmpEliminate "..i)
					desArray[i][#desArray[i]+1]={array=tmpEliminate[startPos],len=len} --将满足条件的连续数组插入可消除数组中
			   end
			   tmpEliminate[startPos] = nil 	--将不符合条件的连续数组置空
			   len = 1
			   startPos = j
			   if startPos>=8 then break end
			   tmpEliminate[startPos] = {}
			   tmpEliminate[startPos][startPos] = startPos
			end
			
		    -- print("startPos"..startPos)
		end
		tmpEliminate = nil
	end
end

initTestMap(mapArray, mapArrayT)
iterateMap(mapArray,false)
iterateMap(mapArrayT,true)
dump(eliminateArray)