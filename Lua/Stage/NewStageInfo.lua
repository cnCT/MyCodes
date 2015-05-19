-- 0															  0
-- 1															  1
-- 2															 10
-- 4															100
-- 16						    							  10000
-- 32 														 100000
-- 64						                                1000000
-- 128						                               10000000
-- 256						                              100000000
-- 512						                             1000000000
-- 1024													10000000000
-- 2048					                           	   100000000000
-- 4096					                          	  1000000000000
-- 65536					                      10000000000000000
-- 131072					                     100000000000000000
-- 262144					                    1000000000000000000
-- 524288					                   10000000000000000000
-- 1048576					                  100000000000000000000
-- 2097152					                 1000000000000000000000
-- 4194304					                10000000000000000000000
-- 8388608					               100000000000000000000000
-- 16777216				       		  	  1000000000000000000000000
-- 33554432				       		 	 10000000000000000000000000
-- 67108864				       			100000000000000000000000000
-- 134217728				       	   1000000000000000000000000000
-- 268435456				       	  10000000000000000000000000000
-- 536870912				         100000000000000000000000000000
-- 1073741824				        1000000000000000000000000000000
-- 2147483648					   10000000000000000000000000000000
-- 4294967296				      100000000000000000000000000000000
-- 8589934592				     1000000000000000000000000000000000
-- 17179869184				    10000000000000000000000000000000000
-- 34359738368				   100000000000000000000000000000000000
-- 274877906944				100000000000000000000000000000000000000

local StageInfo = {
{
	--格子不可用
	value = 0,
	stype = "Map_None",
},
{ 	
	--空格子,暂时为空
	value = 1,
	stype = "Map_Goods",
},
{
	--糖果
	value = 2,
	stype = "Map_Goods",
},
{
	--果冻
	value = 4,
	stype = "Map_Goods",
},
{
	--入口
	value = 16,
	stype = "Map_LandType",
},
{
	--(岩石,巧克力) 周围消除可以使其同时消除
	value = 32,    --???
	stype = "Map_Goods",
},
{
	--岩石	
	value = 64,
	stype = "Map_Goods",
},
{
	--铁丝
	value = 128,
	stype = "Map_Goods",
},
{
	--巧克力
	value = 256,
	stype = "Map_Goods",
},
{
	--出口
	value = 512,
	stype = "Map_LandType",
},
{
	--(可通过？？)
	value = 1024,  --???
	stype = "Map_LandType",
},
{
	--下空可通过
	value = 2048,
	stype = "Map_LandType",
},
{
	--上空可通过
	value = 4096,
	stype = "Map_LandType",
},
{
	--蚊香
	value = 65536,
	stype = "Map_Goods",
},
{
	--炸弹
	value = 131072,
	stype = "Map_Goods",
},
{
	--1层高能墙
	value = 262144,
	stype = "Map_Goods",
},
{
	--2层高能墙
	value = 524288,
	stype = "Map_Goods",
},
{
	--3层高能墙
	value = 1048576,
	stype = "Map_Goods",
},
{
	--4层高能墙
	value = 2097152,
	stype = "Map_Goods",
},
{
	--5层高能墙
	value = 4194304,
	stype = "Map_Goods",
},
{
	--巧克力风扇
	value = 8388608,
	stype = "Map_LandType",
},
{
	--七彩糖果特殊C
	value = 16777216,
	stype = "Map_Goods",
},
{
	--条纹糖果特殊A横向
	value = 33554432,
	stype = "Map_Goods",
},
{
	--条纹糖果特殊A竖向
	value = 67108864,
	stype = "Map_Goods",
},
{
	--包装糖特殊B
	value = 134217728,
	stype = "Map_Goods",
},
{
	--椰子轮
	value = 268435456,
	stype = "Map_Goods",
},
{
	--随机颜色鱼
	value = 536870912,
	stype = "Map_Goods",
},
{
	--普+5
	value = 1073741824,
	stype = "Map_Goods",
},
{
	--颜色果冻😓
	value = 2147483648,
	stype = "Map_Goods",
},
{
	--特殊出口
	value = 4294967296,
	stype = "Map_LandType",
},
{
	--特殊扇
	value = 8589934592,
	stype = "Map_LandType",
},
{
	--蚊香扇
	value = 17179869184,
	stype = "Map_LandType",
},
{
	--炸弹扇
	value = 34359738368,
	stype = "Map_LandType",
},
{
	--随机糖
	value = 274877906944,
	stype = "Map_Goods",
},
}

StageInfo.getValue = function( i )
	-- body
	return StageInfo[i].value
end

StageInfo.getType = function( i )
	-- body
	return StageInfo[i].stype
end

return StageInfo