package.path = package.path .. ";../?.lua;"
require "runable"
--检测消除模块 只处理二维数组 初始化参数 EliminateModel得引用,行列值
local Eliminate2DArrayMoudle = Class("Eliminate2DArrayMoudle")

Eliminate2DArrayMoudle.MAP_IMMOVABLE = 0 		--不参与消除的格子

--构造函数
function Eliminate2DArrayMoudle:ctor(_xCount,_yCount,_eliminateModel)
	CCLOG(_xCount,_yCount)
	CCLOGF("_xCount,_yCount is %d ,%d",_xCount,_yCount)
	self.xCount,self.yCount = _xCount,_yCount
	self.eliminateModel = _eliminateModel

	self.mapArray = {}		--地图数组
	self.mapArrayT = {}		--转置地图数组
	self.eliminateArray = {eliminateX = {},eliminateY = {}} 		--X轴Y轴可消除的数组分别存贮

end

--初始化各种变量
function Eliminate2DArrayMoudle:init( ... )
	-- body
	self.mapArray = {}		--地图数组
	self.mapArrayT = {}		--转置地图数组
	self.eliminateArray = {eliminateX = {},eliminateY = {}} 		--X轴Y轴可消除的数组分别存贮
end

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

--初始化地图数组
function Eliminate2DArrayMoudle:initMap(  )
	-- body
	local xCount,yCount = self.xCount,self.yCount
	-- for i=1,xCount+1 do
	-- 	self.mapArray[i] = {}	--初始化地图二维数组
	-- 	self.mapArrayT[i] = {}  --转置矩阵
	-- 	self.mapArray[i][yCount+1] = 0
	-- 	self.mapArrayT[i][yCount+1] = 0
	-- end
	-- for i=1,yCount+1 do
	-- 	self.mapArray[yCount+1][i] = 0
	-- 	self.mapArrayT[yCount+1][i] = 0
	-- end

	-- self.eliminateModel:initMap(self.mapArray,self.mapArrayT)
	self.eliminateModel:initTestMap(self.mapArray,self.mapArrayT)

	print2_DArray(self.mapArray)
	print2_DArray(self.mapArrayT)
end

function Eliminate2DArrayMoudle:iterateMap( _mapArray,_isT )
 	-- body
 	local mapArray = _mapArray
 	local xCount = _isT and self.yCount or self.xCount --如果为转置 则互换x y值
 	local yCount = _isT and self.xCount or self.yCount
 	for i=1,xCount do
		local startPos = 1
		local tmpEliminate = {}	--存储临时可消除数据
		local len = 1 	--连续相同水果长度
		tmpEliminate[startPos] = {} 	--初始化第一个连续数组
		tmpEliminate[startPos][startPos] = startPos
		for j=2,yCount+1 do
			if mapArray[i][j] and mapArray[i][startPos] ~= self.MAP_IMMOVABLE and mapArray[i][j] == mapArray[i][startPos] then
			   tmpEliminate[startPos][j] = j
			   len = len + 1
			else
			   if len>=3 then
		   		-- print("ssssX"..i)
			   		-- self:saveEliminateArray(tmpEliminate[startPos],i,len,_isT)
			   		local desArray = _isT and self.eliminateArray.eliminateY or self.eliminateArray.eliminateX
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

function Eliminate2DArrayMoudle:saveEliminateArray( _tmpEliminate,_index,_len,_isT )
	-- body
	local desArray = _isT and self.eliminateArray.eliminateY or self.eliminateArray.eliminateX
	desArray[_index] = desArray[_index] or {}
	-- dump(_tmpEliminate,"_tmpEliminate ".._index)
	table.insert(desArray[_index],{array=_tmpEliminate,len=_len}) --将满足条件的连续数组插入可消除数组中
end

function Eliminate2DArrayMoudle:doEliminate( ... )
	-- body
	self:init()
	printClock("--- Eliminate2DArrayMoudle:doEliminate Start1~~~~~~")
	self:initMap()
	printClock("--- Eliminate2DArrayMoudle:doEliminate Start2~~~~~~")
	self:iterateMap(self.mapArray)
	printClock("--- Eliminate2DArrayMoudle:doEliminate Start3~~~~~~")
	self:iterateMap(self.mapArrayT,true)
	printClock("--- Eliminate2DArrayMoudle:doEliminate Start4~~~~~~")
	-- dump(self.eliminateArray,"self.eliminateArray")
	local flag = (next(self.eliminateArray.eliminateX) or next(self.eliminateArray.eliminateY))
	return flag,self.eliminateArray
end

local EliminateModel = Class("EliminateModel")

--构造函数
function EliminateModel:ctor(_xCount,_yCount,_mainControl)
	CCLOG("FK")
	self.xCount,self.yCount = _xCount,_yCount
	self.eliminate2DArrayMoudle = self.eliminate2DArrayMoudle or Eliminate2DArrayMoudle.new(9,9,self)
	self.mainControl = _mainControl
end

function EliminateModel:init( ... )
	-- body
	self.eliminateFormatArray = {}
	self.caArray = {}
end

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
function EliminateModel:initTestMap( _mapArray,_mapArrayT )
	-- body
	for x,v in pairs(map) do
		for y,vv in pairs(v) do
			_mapArray[x] = _mapArray[x] or {}
			_mapArray[x][y] = 1
			_mapArrayT[y] = _mapArrayT[y] or {}
			_mapArrayT[y][x] = _mapArray[x][y]
		end
	end
end
--出事话 地图函数
function EliminateModel:initMap( _mapArray,_mapArrayT ) --有待实现
	-- body
	for x,v in pairs(self.cb_cgArray) do
		for y,vv in pairs(v) do
			-- print(x,y)
			local value = vv:getCandyModelValue()
			-- -- value = value>6 and 0 or value
			if vv:isBlockLand(x,y) then
				value = 0
			end
			if vv:getIsRegistAroundEliminate() then
				self.caArray[#self.caArray+1] = {x=x,y=y}
			end
			_mapArray[x] = _mapArray[x] or {}
			_mapArray[x][y] = value
			_mapArrayT[y] = _mapArrayT[y] or {}
			_mapArrayT[y][x] = _mapArray[x][y]
		end
	end
end

function EliminateModel:getCandyAroundArray( ... )
	-- body
	return self.caArray
end

function EliminateModel:doEliminate( cb_cgArray )
	-- body
	-- self.cb_cgArray = self.mainControl.mapArray
	self:init()
	printClock("--- EliminateModel:doEliminate Start~~~~~~")
	local flag,eliminateArray = self.eliminate2DArrayMoudle:doEliminate()
	printClock("--- EliminateModel:doEliminate End~~~~~~")
	if flag then
		self.eliminateArray = eliminateArray
		printClock("--- EliminateModel:processEliminateArray Start~~~~~~")
		self:processEliminateArray(eliminateArray)
		printClock("--- EliminateModel:processEliminateArray Start~~~~~~")
		dump(self.eliminateFormatArray,"eliminateFormatArray")
	end
	printClock()
	return flag,self.eliminateFormatArray
end

function EliminateModel:processEliminateArray( _eliminateArray )
	-- body
	local eliminateArray = _eliminateArray
	for k,v in pairs(eliminateArray.eliminateX) do 		--处理X
		for kk,vv in pairs(v) do
			eliminateArray.eliminateX[k][kk] = self:proccessPriorityX(vv,k) and nil or eliminateArray.eliminateX[k][kk]
		end
	end
	for k,v in pairs(eliminateArray.eliminateY) do 		--处理Y
		for kk,vv in pairs(v) do
			eliminateArray.eliminateY[k][kk] = self:proccessPriorityX(vv,k,true) and nil or eliminateArray.eliminateY[k][kk]
		end
	end
end
--判断自身是否为有效消除数组
function EliminateModel:checkSelfIsTrible( k,eliminateFriute ) 			--不科学~
	-- body
	local count = 0
	local max = 0
	local min = 10
	for _,v in pairs(eliminateFriute) do
		count = count + 1
		if v > max then
			max = v
		end
		if v < min then
			min = v
		end
	end
	if count>=4 and (max-k>=3 or k-min>=3) then
		return true
	end
	return false
end

local function three(flag,arg1,arg2)
	-- arg1 = type(arg1) == "table" and arg1 or {arg1}
	-- arg2 = type(arg2) == "table" and arg2 or {arg2}
	-- print(unpack(flag and arg1 or arg2)) 
	return unpack(flag and arg1 or arg2)
end
--根据二位地图数组获取真正得一维索引
function EliminateModel:getRealIndex( x,y,_isT )
	-- body
	-- CCLOG(x.."x .. y"..y)p
	local x,y = three(not _isT,{x,y},{y,x})

	local xCount,yCount = self.xCount,self.yCount
	if x == xCount+1 or y == yCount+1 then
		return 0
	end
	-- x = xCount+1 - x   --行顺序倒置
	CCLOG("FK getRealIndex",x,y)
	return (x-1)*xCount + y
end

function EliminateModel:getXYbyIndex( index )
	-- body
	local xCount,yCount = self.xCount,self.yCount
	local line = math.floor(index%yCount)
	if line == 0 then
		line = yCount
	end
	-- line = 9 - line
	local column = math.ceil(index/xCount)
	-- column = xCount+1 - column --倒置
	return column,line
end

function EliminateModel:checkXinY( x,y,_eliminate )
	-- body
	CCLOG(x.." xy "..y)
	local eliminate = _eliminate or self.eliminateArray.eliminateY[y]
	-- dump(eliminate,"eliminate __")
	if not eliminate then return end
	for k,v in pairs(eliminate) do
		if v.array[x] ~= nil then
			return true,k
		end
	end
	return false
end

function EliminateModel:checkYinX( x,y,_eliminate )
	-- body
	CCLOG(x.." xy "..y)
	local eliminate = _eliminate or self.eliminateArray.eliminateX[x]
	-- dump(eliminate,"eliminate __")
	if not eliminate then return end
	for k,v in pairs(eliminate) do
		if v.array[y] ~= nil then
			return true,k
		end
	end
	return false
end

--如果转置 则同时处理 x与y轴
function EliminateModel:proccessPriorityX( _array,_row,_isT )
	-- body
	local array = _array
	local row = _row
	local ftype = 3
	local args = {array={}}
	local count = 0
	local eliminateX,eliminateY = self.eliminateArray.eliminateX,self.eliminateArray.eliminateY
	eliminateX,eliminateY = three(_isT,{eliminateY,eliminateX},{eliminateX,eliminateY})
	-- dump(eliminateX,"ass1")
	local fiveFlag,firstFlag = false,false
	for _,vv in pairs(array.array) do
		local index = self:getRealIndex(row,vv,_isT)--(row-1)*8 + vv
		fiveFlag = array.len>=5 or fiveFlag --五连判断
		if eliminateY[vv] ~= nil then	--判断十字
			CCLOG("VV is ",vv)
			dump(eliminateY[vv],"eliminateY ")
			local flag,mid_index = three(_isT,{self:checkYinX(vv,row)},{self:checkXinY(row,vv)}) --获取真实坐标
			if flag then
				CCLOG("ˆ_ˆ cross",mid_index)
				ftype = 10
				args.centre = args.centre or index
				firstFlag = firstFlag and firstFlag or true
				-- args.array.cross = {}--eliminateY[vv]
				for _,v in pairs(eliminateY[vv][mid_index].array) do
					fiveFlag = eliminateY[vv][mid_index].len>=5 or fiveFlag
					local cindex = self:getRealIndex(v,vv,_isT)--(vv-1)*8 + v
					-- if fiveFlag then
						args.cross = args.cross or {}
						args.cross[cindex] = cindex
					-- end
					-- CCLOG(v,row,"xx")
					if v ~= row and eliminateX[v] ~= nil then
						-- CCLOG(v,vv,"roe")
						-- dump(eliminateX)
						local flag,cross_index = three(_isT,{self:checkXinY(vv,v)},{self:checkYinX(v,vv)}) --获取真实坐标
						if flag then
							if firstFlag and eliminateX[v][cross_index].len >=5 and not fiveFlag then  --如果相交得第一根线是五连并且自身不是五连  则直接返回  等待五连得线处理~
								CCLOG("fk")
								return false
							end
							-- CCLOG("fiveFlag",fiveFlag)
							while eliminateX[v][cross_index].len<5 or fiveFlag do 						--如果不为五连 或者 自身为五连 继续剪枝~
								-- CCLOG("fk s")
								if self:checkSelfIsTrible(vv,eliminateX[v][cross_index].array) then 	--判断是否为有效数组
									eliminateX[v][cross_index] = nil
									CCLOG("checkSelfIsTrible is true")
								else
									eliminateX[v][cross_index].array[vv] = nil
									CCLOG("checkSelfIsTrible is false",v)
									dump(eliminateX[v][cross_index],v.."-"..cross_index)
								end 
								break
							end
						end
					end
				end
				eliminateY[vv][mid_index] = nil
				-- dump(args.cross,"Cross")
				-- dump(args.array,"Array")
				table.merge(args.array,args.cross or {})
			end
		else
			CCLOG("No cross")
		end
		args.array[index] = index
		args.cross = args.cross or {}
		args.cross = nil
		count = count + 1
	end
	ftype = (array.len >= 5 or fiveFlag) and 5 or ftype 		--五连
	ftype = (ftype == 3 and count > 3) and 4 or ftype 		--四连
	args.ftype = ftype
	-- dump(args,"args.array")
	self.eliminateFormatArray[#self.eliminateFormatArray+1]=self:getArrayByType(ftype,args)
	-- table.insert(self.eliminateFormatArray,self:getArrayByType(ftype,args))
	return true
end

function EliminateModel:check( cb_cgArray )
	-- body	
	self.cb_cgArray = cb_cgArray
end
--用于获取指定类型的数组
function EliminateModel:getArrayByType( _type,args )
	-- body
	return {ftype=_type,centre=args.centre,array=args.array}
end
-- print(string.upper("MAP_immovable"))

EliminateModel.new(9,9):doEliminate()
return EliminateModel