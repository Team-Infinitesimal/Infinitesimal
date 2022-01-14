local pn = ...

local t = Def.ActorFrame {

	Def.Sprite {
		Texture="StageCount",
		OnCommand=function(self)
			self:zoom(0.4)
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
					local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)):GetX()
					self:xy(pn == PLAYER_1 and pos-286 or pos+286, SCREEN_TOP+34)
				end
			else
				self:xy(SCREEN_CENTER_X, SCREEN_TOP+34)
			end
		end
	},

	LoadFont("Montserrat semibold 40px")..{
		OnCommand=function(self)
			local CurStage = string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1)
			self:zoom(0.6):skewx(-0.1)
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
					local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)):GetX()
					self:xy(pn == PLAYER_1 and pos-286 or pos+286, SCREEN_TOP+43)
				end
			else
				self:xy(SCREEN_CENTER_X, SCREEN_TOP+43)
			end
			self:settext(CurStage)
		end
	}
}

return t
