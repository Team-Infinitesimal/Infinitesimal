local pn = ...

local t = Def.ActorFrame {
	OnCommand=function(self)
		if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
			local stepsType = GAMESTATE:GetCurrentStyle():GetStepsType()
			local pos = ((stepsType == "StepsType_Pump_Double" or stepsType == "StepsType_Pump_Halfdouble") and SCREEN_CENTER_X
									or THEME:GetMetric(Var "LoadingScreen","Player".. ToEnumShortString(pn) .."OnePlayerOneSideX"))
			self:xy(pos, SCREEN_BOTTOM - 20)
			self:GetChild("Username"):settext( PROFILEMAN:GetProfile(pn):GetDisplayName() )
		end
	end,

	Def.Sprite { 
        Texture=THEME:GetPathG("", "UI/NameBadge"), 
        OnCommand=function(self)
            self:visible(PROFILEMAN:IsPersistentProfile(pn)):zoom(0.45) 
        end
    },

	Def.BitmapText {
		Font="Montserrat semibold 20px",
		Name="Username",
		OnCommand=function(self) 
            self:visible(PROFILEMAN:IsPersistentProfile(pn)):shadowlength(1):zoom(0.75)
        end
	}
}

return t
