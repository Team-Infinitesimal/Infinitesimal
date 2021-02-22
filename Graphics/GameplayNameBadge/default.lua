local pn = ...

local t = Def.ActorFrame {
	OnCommand=function(self)
		if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
			local pos = THEME:GetMetric(Var "LoadingScreen","Player".. ToEnumShortString( pn ) .."OnePlayerOneSideX")
			self:xy(pos, SCREEN_BOTTOM - 20)
			self:GetChild("Username"):settext( PROFILEMAN:GetProfile(pn):GetDisplayName() )
		end
	end,

	Def.Sprite{ Texture="badge", OnCommand=function(self) self:zoom(0.45) end },

	Def.BitmapText{
		Font="Montserrat semibold 20px",
		Name="Username",
		OnCommand=function(self) self:shadowlength(1):zoom(0.75) end
	}
}

return t
