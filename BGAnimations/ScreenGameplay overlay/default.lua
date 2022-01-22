local t = Def.ActorFrame {
	LoadActor("StageCount")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local IsDouble = (GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides")
	local IsCenter = (IsDouble or Center1Player() or GAMESTATE:GetIsFieldCentered(pn))
    local PosX = IsCenter and SCREEN_CENTER_X or THEME:GetMetric(Var "LoadingScreen", "Player" .. ToEnumShortString(pn) .. "OnePlayerOneSideX")
    
    local IsReverse = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():Reverse() > 0
	local PosY = IsReverse and SCREEN_BOTTOM - 30 or 30
    
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			self:xy(PosX, PosY)
		end,
	
		LoadActor("LifeMeter", pn)
	}
end

return t
