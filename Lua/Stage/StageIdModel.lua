-- Episode 01 (Level 001-010)：糖果小镇(Candy Town)
-- Episode 02 (Level 011-020)：糖果工厂 (Candy Factory)
-- Episode 03 (Level 021-035)：柠檬湖 (Lemonade Lake)
-- Episode 04 (Level 036-050)：巧克力山脉 (Chocolate Mountains)
-- Episode 05 (Level 051-065)：薄荷草原 (Minty Meadow)
-- Episode 06 (Level 066-080)：复活节兔子山丘 (Easter Bunny Hills)
-- Episode 07 (Level 081-095)：泡泡糖桥 (Bubblegum Bridge)
-- Episode 08 (Level 096-110)：盐味峡谷 (Salty Canyon)
-- Episode 09 (Level 111-125)：薄荷宫殿 (Peppermint Palace)
-- Episode 10 (Level 126-140)：威化饼码头 (Wafer Wharf)
-- Episode 11 (Level 141-155)：姜饼林地 (Gingerbread Glade)
-- Episode 12 (Level 156-170)：粉彩糖金字塔 (Pastille Pyramid)
-- Episode 13 (Level 171-185)：杯子蛋糕马戏团 (Cupcake Circus)
-- Episode 14 (Level 186-200)：焦糖湾 (Caramel Cove)
-- Episode 15 (Level 201-215)：香甜惊喜 (Sweet Surprise)
-- Episode 16 (Level 216-230)：脆饼城堡 (Crunchy Castle)
-- Episode 17 (Level 231-245)：巧克力谷仓 (Chocolate Barn)
-- Episode 18 (Level 246-260)：美味雪沙 (Delicious Drifts)
-- Episode 19 (Level 261-275)：渡假小屋 (Holiday Hut)
-- Episode 20 (Level 276-290)：糖果云 (Candy Clouds)
-- Episode 21 (Level 291-305)：果冻丛林 (Jelly Jungle)
-- Episode 22 (Level 306-320)：香薄荷海岸 (Savory Shores)
-- Episode 23 (Level 321-335)：酥饼巨石(Munchy Monolith)
-- Episode 24 (Level 336-350)：贝齿平原 (Pearly White Plains)
-- Episode 25 (Level 351-365)：乳脂软糖岛 (Fudge Islands)
-- Episode 26 (Level 366-380)：布丁宝塔 (Pudding Pagoda)
-- Episode 27 (Level 381-395)：甘草糖塔 (Licorice Tower)　　
-- Episode 28 (Level 396-410)：音乐狂欢节 (Polkapalooza)
-- Episode 29 (Level 411-425)：苏打沼泽 (Soda Swamp)
-- Episode 30 (Level 426-440)：彩虹跑道 (Rainbow Runway)
-- Episode 31 (Level 441-455)：奶油糖巨石 (Butterscotch Boulders)
-- Episode 32 (Level 456-470)：糖粉牧场 (Sugary Shire)
-- Episode 33 (Level 471-485)：樱桃庄园 (Cherry Chateau)
-- Episode 34 (Level 486-500)：蛋白糖霜荒野 (Meringue Moor)
-- Episode 35 (Level 501-515)：冰激凌洞穴 (Ice Cream Caves)
-- Episode 36 (Level 516-530)：酸味沙龙(Sour Salon)
-- Episode 37 (Level 531-545)：黏稠大草原(Sticky Savannah)
-- Episode 38 (Level 546-560)：果冻马车(Jelly Wagon)
-- Episode 39 (Level 561-575)：饼干洋房(Biscuit Bungalow)
-- Episode 40 (Level 576-590)：软糖花园(Gummy Gardens)
-- Episode 41 (Level 591-605)：威化饼风车(Wafer Windmill)
-- Episode 42 (Level 606-620)：麦片海 (Cereal Sea)
local StageIdInfo = {
	[00] = {0,0},
	[01] = {001,010},
	[02] = {011,020},
	[03] = {021,035},
	[04] = {036,050},
	[05] = {051,065},
	[06] = {066,080},
	[07] = {081,095},
	[08] = {096,110},
	[09] = {111,125},
	[10] = {126,140},
	[11] = {141,155},
	[12] = {156,170},
	[13] = {171,185},
	[14] = {186,200},
	[15] = {201,215},
	[16] = {216,230},
	[17] = {231,245},
	[18] = {246,260},
	[19] = {261,275},
	[20] = {276,290},
	[21] = {291,305},
	[22] = {306,320},
	[23] = {321,335},
	[24] = {336,350},
	[25] = {351,365},
	[26] = {366,380},
	[27] = {381,395},
	[28] = {396,410},
	[29] = {411,425},
	[30] = {426,440},
	[31] = {441,455},
	[32] = {456,470},
	[33] = {471,485},
	[34] = {486,500},
	[35] = {501,515},
	[36] = {516,530},
	[37] = {531,545},
	[38] = {546,560},
	[39] = {561,575},
	[40] = {576,590},
	[41] = {591,605},
	[42] = {606,620},
}

StageIdInfo.getEpisodeIdAndLvIdByStageId = function( stageId )
	-- body
	-- Assert(stageId,"stageId is nil!")
	for i,v in ipairs(StageIdInfo) do
		if stageId<=v[2] and stageId>=v[1] then
			return i,stageId-v[1]+1
		end
	end
	return 1,1
end

StageIdInfo.getStageIdByEpisodeIdAndLvId = function( episodeId,lvId )
	-- body
	-- Assert(stageId,"stageId is nil!")
	return StageIdInfo[episodeId-1][2]+lvId
end

StageIdInfo.getTotalStageNum = function( ... )
	-- body
	local stageNum = StageIdInfo[#StageIdInfo][2]
	return 300 or stageNum
end
print(StageIdInfo.getEpisodeIdAndLvIdByStageId(201))
print(StageIdInfo.getStageIdByEpisodeIdAndLvId(15,1))

print("ss")
return StageIdInfo