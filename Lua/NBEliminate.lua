package.path = package.path .. ";../?.lua;"
require "runable"
local map = {
{0,0,5,5,5,5,5,0,0},
{4,0,5,5,6,2,6,0,3},
{3,2,5,5,5,5,5,2,1},
{3,2,4,5,4,5,1,2,2},
{2,3,4,5,3,4,1,4,5},
{3,6,4,1,4,5,6,3,6},
{6,6,3,5,3,4,1,6,3},
{6,0,3,2,1,6,4,0,6},
{0,0,2,6,4,4,5,0,0},}


local xCount,yCount = 9,9
local Priority = {
	CROSS = 16,
	FIVE = 8,
	FOUR = 4,
	THREE = 3,
}
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
local eliminateFormatArray = {}
local clashPoints = {}

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

function checkClashPoint( x,y )
	-- body
	print("x,y -- ",x,y)
	local eliminate = eliminateArray.eliminateX[y]
	if not eliminate then return end
	-- dump(eliminate,"eliminate")
	for k,v in pairs(eliminate) do
		if v.array[x] then
			return true,k
		end
	end
	return false
end

function copy( srcTable,destTable )
	-- body
	for i,v in ipairs(srcTable) do
		destTable[#destTable+1] = v
	end
	return destTable
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
   		local desArray = _isT and eliminateArray.eliminateY or eliminateArray.eliminateX
	 	local clashs = {}
		if _isT then
			local ff,index = checkClashPoint(i,startPos)
			if ff then
				local yi = desArray[i] and #desArray[i]+1 or 1
				clashs[#clashs+1] = {x=startPos,y=i,xi=index,yi=yi}
			end
		end
		for j=2,yCount+1 do
			if _isT then
				local ff,index = checkClashPoint(i,j)
				if ff then
					local yi = desArray[i] and #desArray[i]+1 or 1
					clashs[#clashs+1] = {x=j,y=i,xi=index,yi=yi}
				end
			end
			if mapArray[i][j] and mapArray[i][startPos] ~= 0 and mapArray[i][j] == mapArray[i][startPos] then
			   tmpEliminate[startPos][j] = j
			   len = len + 1
			else
			    if len>=3 then
		   		-- print("ssssX"..i)
			   		-- self:saveEliminateArray(tmpEliminate[startPos],i,len,_isT)
					desArray[i] = desArray[i] or {}
					-- dump(_tmpEliminate,"_tmpEliminate "..i)
					desArray[i][#desArray[i]+1]={array=tmpEliminate[startPos],len=len} --将满足条件的连续数组插入可消除数组中
					copy(clashs,clashPoints)
					dump(clashs,"Clashs")
			    end
			    tmpEliminate[startPos] = nil 	--将不符合条件的连续数组置空
			    len = 1
			    startPos = j
			    if startPos>=8 then break end
			    tmpEliminate[startPos] = {}
			    tmpEliminate[startPos][startPos] = startPos
				clashs = {}
			end
			
		    -- print("startPos"..startPos)
		end
		tmpEliminate = nil
	end
end

local function sortFunc( a,b )
	-- body
	local function getPri( v )
		-- body
		local x,y,xi,yi = v.x,v.y,v.xi,v.yi
		local xLen = eliminateArray.eliminateX[x][xi].len
		local yLen = eliminateArray.eliminateY[y][yi].len
		local len = 0
		if xLen>=5 then
			len = len + xCount
		end
		if yLen>=5 then
			len = len + yCount
		end
		len = len + xLen + yLen
		return len
	end
	return getPri(a)>getPri(b)
end

--判断自身是否为有效消除数组 返回被剔除的元素下标
function checkSelfIsTrible( k,eliminateFriute )
	-- body
	local count = 0
	local max = 0
	local min = 10
	dump(eliminateFriute,k)
	for _,v in pairs(eliminateFriute) do
		count = count + 1
		max = math.max(max,v)
		min = math.min(min,v)
	end
	if max-k>=3 then
		return true,k,min
	elseif k-min>=3 then
		return true,max,k
	end
	return false
end

--用于获取指定类型的数组 --TODO 改为存储Point
function getArrayByType( _type,centre,array )
	-- body
	print("WTF?/?")
	return {ftype=_type,centre=centre,array=array}
end

function copyTo( index,array,destArray,_isT )
	-- body
	for _,v in pairs(array) do
		destArray[#destArray+1] = _isT and {v,index} or {index,v}
	end
	return destArray
end

function processClashs( ... )
	-- body
	for i,v in ipairs(clashPoints) do
		local x,y,xi,yi = v.x,v.y,v.xi,v.yi
		local xArray = eliminateArray.eliminateX[x][xi]
		local yArray = eliminateArray.eliminateY[y][yi]
		print("x,y,xi,yi", x,y,xi,yi)
		dump(xArray,"xArray")
		dump(yArray,"yArray")
		if xArray and yArray then
			local priority = Priority.CROSS + math.max(Priority.FIVE,math.max(xArray.len,yArray.len))
			local array = {}
			copyTo(y,yArray.array,copyTo(x,xArray.array,array),true)
			eliminateFormatArray[#eliminateFormatArray+1] = getArrayByType(priority,{x,y},array)
			eliminateArray.eliminateX[x][xi] = nil
			eliminateArray.eliminateY[y][yi] = nil
		else
			if xArray then
				local flag,r1,r2 = checkSelfIsTrible(y,xArray.array)
				if flag then
					for i=r1,r2 do
						xArray.array[i] = nil
						xArray.len = xArray.len - 1
					end
				else
					eliminateArray.eliminateX[x][xi] = nil
				end
			end
			if yArray then
				local flag,r1,r2 = checkSelfIsTrible(x,yArray.array)
				if flag then
					for i=r1,r2 do
						yArray.array[i] = nil
						yArray.len = yArray.len - 1
					end
				else
					eliminateArray.eliminateY[y][yi] = nil
				end
			end
		end
	end
end

function processLast( ... )
	-- body
	for k,v in pairs(eliminateArray.eliminateX) do
		print("SSSSXXX")
		for kk,vv in pairs(v) do
			print("XX",k,vv.len)
			if vv.len>=3 then
				local priority = math.max(Priority.FIVE,vv.len)
				local array = {}
				copyTo(k,vv.array,array)
				eliminateFormatArray[#eliminateFormatArray+1] = getArrayByType(priority,array[1],array)
			end
		end
	end
	for k,v in pairs(eliminateArray.eliminateY) do
		print("SSSSYYY")
		for kk,vv in pairs(v) do
			print("YY",k,vv.len)
			if vv.len>=3 then
				local priority = math.max(Priority.FIVE,vv.len)
				local array = {}
				copyTo(k,vv.array,array,true)
				eliminateFormatArray[#eliminateFormatArray+1] = getArrayByType(priority,array[1],array)
			end
		end
	end
	printClock()
end

print2_DArray(map)
initTestMap(mapArray, mapArrayT)
iterateMap(mapArray,false)
iterateMap(mapArrayT,true)
dump(eliminateArray)
dump(clashPoints)
table.sort( clashPoints, sortFunc )
dump(clashPoints)
processClashs()
processLast()
dump(eliminateFormatArray,"eliminateFormatArray")
dump(eliminateArray)