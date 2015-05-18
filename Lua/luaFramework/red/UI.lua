module("UI", package.seeall)
--从UI.plist中获取图片
function getUISprite(adaptedImgName)
	CCLOG("adaptedImgName -- "..adaptedImgName)
	--local spriteFrame = getUISpriteFrame(adaptedImgName)
	-- return CCSprite:createWithSpriteFrameName(adaptedImgName)
	return cc.Sprite:create(adaptedImgName)
end

--更换CCSprite的图片
function setSpriteWithFileFormPlist(sprite, adaptedImgName)
	-- CCLOG(adaptedImgName)
	-- GF_trace(string.format("UI.setSpriteWithFileFormPlist.%s", adaptedImgName))
	local frame = getUISpriteFrame(adaptedImgName)
	sprite:setSpriteFrame(frame)
end

--更换CCSprite的图片
function setSpriteWithFile(sprite, adaptedImgName)
	-- GF_trace(string.format("UI.setSpriteWithFile.%s", adaptedImgName))
	local newSprite = CCSprite:create(adaptedImgName)
	if sprite == nil or newSprite == nil then
		GF_trace(string.format("UI.setSpriteWithFile.%s", adaptedImgName))
	end
	local frame = CCSpriteFrame:createWithTexture(newSprite:getTexture(), newSprite:getTextureRect())
	sprite:setSpriteFrame(frame)

end

--获取一个CCSpriteFrame
function getUICCSpriteFrame(adaptedImgName)
	-- body
	local newSprite = cc.Sprite:create(adaptedImgName)
	local frame = cc.SpriteFrame:createWithTexture(newSprite:getTexture(), newSprite:getTextureRect())
	return frame
end

function getUISpriteFrame(adaptedImgName)
	CCLOG("要获取Plist中的图片 ：%s", adaptedImgName)
	local spriteFrame = CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(adaptedImgName)
	if spriteFrame == nil then
		CCLOG("要获取Plist中的图片 ：%s, 这个破图片没有找到", adaptedImgName)
	end
	return spriteFrame;
end

function getResFileName(value)
	-- body
	local fruitName = "fruit_type_"
	fruitName = fruitName..value..".png"
	
	return fruitName
end

function getUISpriteBatchNode(adaptedImgName)
	-- body
	local batchNode = CCSpriteBatchNode:create(adaptedImgName)
	return batchNode
end

function getStageIdIconNameByBId( bId )
	-- body
	return 
end