local LuaLayer = Class("LuaLayer")

function LuaLayer:ctor( ... )
	-- body
	
end

-- create one ccb layer
function LuaLayer:createLayer()
	self.scheduleIdList = {}
	self:preloadResources()
	self:initBeforeCreateLayer()
	self.layer = CCBReaderLoad(self.ccbiName,cc.CCBProxy:create(),self)
	self:initUI()
    self:initAfterCreateLayer()
	-- regist layer onEnter and onExit
	local function sceneEventHandler( eventType )
		-- print(eventType,"eventType")
		if eventType == "enter" then
            self:onPreEnter()
        else
            self:onPreExit()
        end
	end
	self.layer:registerScriptHandler(sceneEventHandler)
	return self.layer
end

-- 将自己移除
function LuaLayer:removeSelf(  )
	-- 移除自己所有的定时任务
	for _, handle in pairs(self.scheduleIdList) do
		scheduler.unschedule(handle)
	end
	self.layer:removeFromParent()
end

-- 注册touch事件
function LuaLayer:registTouch( priority )
	priority = priority or 0
 	local touchLayer = self.layer--cc.Layer:create()
	-- touchLayer:setContentSize(self.layer:getContentSize())
	-- self.layer:addChild(touchLayer)
	self.touchLayer = self.layer

    -- local function onTouch(eventType, x, y)
		-- local touchPointOnNode = GV_Instance.mainScene.vars.layer_main:convertToNodeSpace(ccp(x, y))
		-- x = touchPointOnNode.x
		-- y = touchPointOnNode.y
 --        if eventType == "began" then
 --        	if type(self.onTouchBegan) == "function" then
	--             return self:onTouchBegan(x, y)
	--         else
	--         	-- 吞掉事件
	--         	return true
	--         end
 --        elseif eventType == "moved" then
 --        	if type(self.onTouchMoved) == "function" then
	--             return self:onTouchMoved(x, y)
	--         end
 --        else
	-- 		if type(self.onTouchEnded) == "function" then
	--             return self:onTouchEnded(x, y)
	--         end
 --        end
 --    end
	-- touchLayer:registerScriptTouchHandler(onTouch, false, priority, true)
	-- touchLayer:setTouchEnabled(true)

	local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(function(...)
    	if type(self.onTouchBegan) == "function" then
	            return self:onTouchBegan(...)
	        else
	        	-- 吞掉事件
	        	CCLOG("FK NO OUT!!")
	        	return true
	        end
    end,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(function(...)
    	if type(self.onTouchMoved) == "function" then
	            return self:onTouchMoved(...)
	        end
    end,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(function(...)
    	if type(self.onTouchMoved) == "function" then
	            return self:onTouchEnded(...)
	        end
    end,cc.Handler.EVENT_TOUCH_ENDED )
    local eventDispatcher = touchLayer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, touchLayer)
end

-- check touch is on node or not
function LuaLayer:isTouchingInNode( node, x, y )
	-- GF_trace("ˆ_ˆnimei")
	local touchPointOnNode = node:convertToNodeSpace(cc.p(x, y))
	local nodeContentSize = node:getContentSize()
	-- print("nodeContentSize.width"..nodeContentSize.width,"==nodeContentSize.height"..nodeContentSize.height)
	local nodeRect = CCRectMake(0,0,nodeContentSize.width,nodeContentSize.height)
	if nodeRect:containsPoint(touchPointOnNode) then
		return true
	else
		return false
	end
end

-- scheduler
function LuaLayer:schedule( listener, interval, isPaused )
	local scheduler = CCDirector:getInstance():getScheduler()
	local handle = scheduler:scheduleScriptFunc(listener, interval, isPaused or false)
	table.insert(self.scheduleIdList, handle)
	return handle
end

-- unscheduler
function LuaLayer:unschedule( handle )
	scheduler.unschedule(handle)
end

-- delay schduler
function LuaLayer:performWithDelay(args)
	local time = args.time
	local cbd = args.cbd
	local cbs = args.cbs
	local funcArgs = args.args

	-- zhuge，手动延时所用的延时调用1/30秒
    time = time + (1 / 30)
	local scheduler = CCDirector:getInstance():getScheduler()
    local handle
    handle = scheduler:scheduleScriptFunc(function()
        scheduler:unscheduleScriptEntry(handle)
        if cbs then
            if cbd == nil then
                cbs(funcArgs)
            else
                cbs(cbd, funcArgs)
            end
        end
    end, time, false)
    table.insert(self.scheduleIdList, handle)
    return handle
end

-- preload resources
function LuaLayer:preloadResources(  )
	
end

-- delete resources
function LuaLayer:deleteResources(  )
	
end

-- proxy of onEnter
function LuaLayer:onPreEnter(  )
	-- CCLOG("onPreEnter")
	self:onEnter()
end

-- proxy of onExit
function LuaLayer:onPreExit(  )
	-- CCLOG("onPreExit")
	self:deleteResources()
	self:onExit()
end

-- onEnter
function LuaLayer:onEnter(  )
	-- every subclass inherite
end

-- onExit
function LuaLayer:onExit(  )
	-- every subclass inherite
end

-- init ui
function LuaLayer:initUI(  ) 
	-- every subclass inherite
end

-- bind vars for ccb
function LuaLayer:initVars(  )
	-- every subclass inherite
end

-- init, like add sprite frame cache
function LuaLayer:initBeforeCreateLayer(  )
	-- every subclass implements
end

function LuaLayer:initAfterCreateLayer(  )
	-- every subclass implements
end

function LuaLayer:setInitalData( initalData )
	-- body
	self.initalData = initalData
end

function LuaLayer:playerTimeLineByName( aniName )
	-- body
	if self.mAnimationManager and aniName then
		self.mAnimationManager:runAnimationsForSequenceNamed(aniName)
	else
		CCLOG("aniName or mAnimationManager is nil ~~~")
	end
end

return LuaLayer