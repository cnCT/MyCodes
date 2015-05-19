package.path = package.path .. ";../?.lua;?.lua"
require "runable"

local StageModel = {}--Class("StageModel")

function StageModel:binarySearch(a, v) --二分查找
    low = 1
    high = #a
    local t
    times = 0
    while(low <= high) do
        times = times + 1
        mid = math.floor((low + high) / 2)
        t = a.getValue(mid) or a[mid]
        CCLOG("FK t,v",t,v)
        if t < v  then
            low = mid + 1
        elseif t > v then
            high = mid - 1
        else
            return mid,times
        end
    end

    mid = v > t and mid or mid-1
    CCLOGF("Find %d, MID IS %d,T IS %d",v,mid,a.getValue(mid))
    return mid,times
end

function StageModel:ctor( ... )
    -- body
    -- self:loadUserStageDatas()
    self.stageCache = import("StageLevelsInfo")--{}
    -- for i=1,self:getTotalStageNum() do
    --     self:processStageInfoByBId(i)
    -- end
    -- GF_saveTableToFileForString(self.stageCache,"XX.lua")

end

function StageModel:getCurentStageId( ... )
    -- body
    return 300
    -- return self.stageInfo.currentStageId
end

function StageModel:setCurentStageId( stageId )
    -- body
    if self:getCurentStageId() == self:getCurBId() then
        CCLOG("StageDataPlayer setCurentStageId =====",stageId)
        self.stageInfo.currentStageId = self.stageInfo.currentStageId + 1
        self:dispatchEvent("BUTTON_CURSTAGEID_CHANGE",{stageId=self.stageInfo.currentStageId})
        self:saveStageInfo()
    end
end

function StageModel:getTotalStageNum( ... )
    -- body
    return import("StageIdModel").getTotalStageNum()
end

function StageModel:processStageInfoByBId( bId )
    -- body
    local stageIdModel = import("StageIdModel")
    local id1,id2 = stageIdModel.getEpisodeIdAndLvIdByStageId(bId)
    self:processStageInfoBy(id1,id2,bId)

end

function StageModel:processStageInfoBy( _episode,_level,bId )
    -- body
    CCLOG("_episode,_level,bId",_episode,_level,bId)
    local result = self.stageCache[bId]
    if not result then
        local fileName = string.format("episode%dlevel%d.txt",_episode,_level)
        --local path = "/Users/mac/Desktop/SVNS/CandyFactory/frameworks/runtime-src/Classes/Lua/Stage/levels/"--cc.FileUtils:getInstance():fullPathForFilename(fileName)
        local path = cc.FileUtils:getInstance():fullPathForFilename(fileName)
        --path = path..fileName
        local json2str = io.readfile(path)
        Assert(json2str,"File not found")
        local json = require("json") 
        result = json.decode(json2str)
        self.stageCache[bId] = result
    end

    -- local stageWeight = require("StageDropWeightInfo").getStageWeight(_episode, _level)
    -- dump(stageWeight, "stageWeight")

    -- dump(result,"Result ==")
    -- self.stageInfo = result

    -- self:processTileMap(result.tileMap)
    -- self:processPortals(result.portals)
    -- self:processIngredients(result)
end

function StageModel:setCurBId( bId )
    -- body
    self.curBId = bId
end

function StageModel:getCurBId( ... )
    -- body
    return self.curBId
end

function StageModel:getNextBId( ... )
    -- body
    local nextBid = self.curBId+1
    local totalNum = self:getTotalStageNum()
    nextBid = nextBid>totalNum and totalNum or nextBid
    return nextBid
end

function StageModel:processPortals( _portals )
    -- body
    dump(portals, "穿越洞哦u ma......")
    local portals = _portals
    local bottomCrossForTop = {}
    local topCrossForBottom = {}
    local FromCrossTo = {}

    for k, v in pairs(portals) do
        --if v[1][3] ~= 0 then
            local topColumn = v[1][1] + 1
            local topRow = v[1][2] + 1
            local topIndex = CommonUtils.getRealIndex(topRow, topColumn)

            local bottomColumn = v[2][1] + 1
            local bottomRow = v[2][2] + 1
            local bottomIndex = CommonUtils.getRealIndex(bottomRow, bottomColumn)

            bottomCrossForTop[topIndex] = bottomIndex
            topCrossForBottom[bottomIndex] = topIndex
            FromCrossTo[topIndex] = bottomIndex
        --end
    end

    dump(self.FromCrossTo, "FromCrossTo")
    --dump(self.bottomCrossForTop, "bottomCrossForTop")
    --dump(self.topCrossForBottom, "topCrossForBottom")
    return FromCrossTo
end

function StageModel:processIngredients( _stageInfo )
    -- body
    local stageInfo = _stageInfo
    if stageInfo.ingredients and not stageInfo.ingredients[2] then
        stageInfo.ingredients[2] = 0
    end 
    local ingredientsInfo = {ingredients=stageInfo.ingredients,numIngredientsOnScreen=stageInfo.numIngredientsOnScreen,ingredientSpawnDensity=stageInfo.ingredientSpawnDensity}
    -- self.ingredientsInfo = ingredientsInfo
    return ingredientsInfo
end

function StageModel:processTileMap( _tileMap )
    -- body
    local tileMap = _tileMap
    dump(tileMap,"FKFK")
    local searchMap = require("NewStageInfo")
    local landTypeArray = {}
    local goodArray = {}
    for k,v in pairs(tileMap) do  --读取二维地图配置数组
        CCLOG("NS ",k,v)
        for kk,vv in pairs(v) do  --读取二维地图配置数组
            -- local index = self:binarySearch(searchMap,vv)
            vv = vv==512 and 513 or vv  --出口上面认为有糖果
            local x = tonumber(vv)
            local t = {}
            -- CCLOG("VV is",k,kk,vv)
            -- dump(v)
            for i=1,100 do
                if x == 0 then break end
                local index = self:binarySearch(searchMap,x)
                local value = searchMap.getValue(index)
                -- CCLOG("x is",x)
                local count = math.floor(x/value)
                x = x%value                             --不断取余数求值
                local stype = searchMap.getType(index)
                t[stype] = t[stype] or {}               --读取字段 Map_LandType和Map_Goods 两种类型~
                -- CCLOG("Index is",index,value,(count))
                for i=1,count do
                    table.insert(t[stype],value)        --有可能存在多个值
                end
            end
            -- dump(t)
            -- CCLOG("RealIndex is",CommonUtils.getRealIndex(k,kk),vv)
            landTypeArray[k] = landTypeArray[k] or {}
            landTypeArray[k][kk] = tonumber(vv)==0 and {0} or t["Map_LandType"] --Map_None 为空地形直接赋值0
            goodArray[k] = goodArray[k] or {}
            goodArray[k][kk] = tonumber(vv)==0 and {0} or t["Map_Goods"] --Map_None 为空地形直接赋值0
            goodArray[k][kk] = goodArray[k][kk] or {0}      --暂时木有糖果 但是应该存在~
        end
    end
    GF_dump(goodArray,"goodArray")
    -- self.landTypeArray = landTypeArray
    -- self.goodArray = goodArray
    return landTypeArray,goodArray
end

function StageModel:getIngredientsInfo( bId )
    -- body
    return self:processIngredients(self.stageCache[bId or self.curBId])
end

function StageModel:getMoveLimit( bId )
    -- body
    return self.stageCache[bId or self.curBId].moveLimit
end

function StageModel:getRandomSeed( bId )
    -- body
   return self.stageCache[bId or self.curBId].randomSeed 
end
--分数数组
function StageModel:getScoreTargets( bId )
    -- body
   return self.stageCache[bId or self.curBId].scoreTargets 
end

function StageModel:getLicoriceMax( bId )
    -- body
    return self.stageCache[bId or self.curBId].licoriceMax or 0
end

function StageModel:getLicoriceSpawn( bId )
    -- body
    return self.stageCache[bId or self.curBId].licoriceSpawn or 0
end

function StageModel:getPepperCandySpawn( bId )
    -- body
    return self.stageCache[bId or self.curBId].pepperCandySpawn or 0
end

function StageModel:getPepperCandyMax( bId )
    -- body
    return self.stageCache[bId or self.curBId].pepperCandyMax or 0
end

function StageModel:getNumOfColours( bId )
    -- body
   return self.stageCache[bId or self.curBId].numberOfColours
end

function StageModel:getTimeLimit( bId )
    -- body
    return self.stageCache[bId or self.curBId].timeLimit
end

function StageModel:getItemsToOrder( bId )
    -- body
    local itemsToOrder = self.stageCache[bId or self.curBId]._itemsToOrder or {}
    dump(itemsToOrder,"itemsToOrder")
    return clone(TranKVTable(itemsToOrder,"item"))
end

function StageModel:getPortals( bId )
    -- body
    return self:processPortals(self.stageCache[bId or self.curBId].portals)
end

function StageModel:boomStep( ... )
    -- body
    return self.stageCache[bId or self.curBId].pepperCandyExplosionTurns
end

function StageModel:getLandTypeArrayAndGoodArray( bId )
    -- body
    return self:processTileMap(self.stageCache[bId or self.curBId].tileMap)
end

function StageModel:getGameMode( bId )
    -- body
    return self.stageCache[bId or self.curBId].gameModeName
end
-- local iconName = {
--     [Constants.GAME_MODE_ORDER]="biao_cheng.png",
--     [Constants.GAME_MODE_LIGHTUP]="biao_lan.png",
--     [Constants.GAME_MODE_DROPDOWN]="biao_lv.png",
--     [Constants.GAME_MODE_CLASSIC]="biao_zi.png",
--     [Constants.GAME_MODE_CLASSICMOVES]="biao_fen.png",
-- }
function StageModel:getIconNameByBid( bId )
    -- body
    return iconName[self:getGameMode(bId)]
end
-- function StageModel:getGoodArrayByBId( bId )
--     -- body
--     return self.goodArray
-- end
-- StageModel:processStageInfoBy(3,14)
function StageModel:registObserver( _obname,_observer,_func )
    -- body
    Assert(_obname,"_obname is nil")
    Assert(_observer,"_observer is nil")
    self.observerArray = self.observerArray or {}
    self.observerArray[string.upper(_obname)] = {obj=_observer,func=_func}
end

function StageModel:unRegistObserver( _obname )
    -- body
    self.observerArray[string.upper(_obname)] = nil
end

function StageModel:dispatchEvent( _obname,args )
    -- body
    local observer = self.observerArray[string.upper(_obname)]
    if observer then
        observer.func(observer.obj,args)
    end
end

StageModel:ctor()
return StageModel