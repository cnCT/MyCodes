local OneGrid = {}
OneGrid.State = {
	NORMAL = "NORMAL",				-- 正常格子
	NONE = "NONE",					-- 空格子
	FRUITNONE = "FRUITNONE", 		-- 暂时为空、消除状态
	NOMOVE = "NOMOVE",				-- 不可移动
}

function OneGrid:ctor( ... )
	-- body
	self._state = OneGrid.State.NORMAL
	self._pos = {x=1,y=1}
	self._managerObj = nil
	self._crateMachine = nil
end

function OneGrid:init( ... )
	-- body
	
end