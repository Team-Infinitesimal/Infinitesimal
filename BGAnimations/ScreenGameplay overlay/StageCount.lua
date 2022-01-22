return Def.ActorFrame {
	InitCommand=function(self)
		if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
			self:xy(GAMESTATE:IsPlayerEnabled(PLAYER_2) and 54 or SCREEN_RIGHT - 54, SCREEN_TOP+34)
		else
			self:xy(SCREEN_CENTER_X, SCREEN_TOP+34)
		end
	end,
	
	Def.Sprite {
		Texture=THEME:GetPathG("", "UI/StageCount"),
		InitCommand=function(self) self:zoom(0.4) end
	},

	Def.BitmapText {
		Font="Montserrat semibold 40px",
		Text=string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1),
		InitCommand=function(self)
			self:y(9):zoom(0.6):skewx(-0.1)
		end
	}
}