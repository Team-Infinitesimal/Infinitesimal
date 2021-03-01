local t = Def.ActorFrame {
	Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			:zoomx(255)
			:zoomy(SCREEN_HEIGHT)
            :diffuse(0,0,0,0.75)
        end
    },

    LoadActor(THEME:GetPathG("","ScreenHudFrame"))
}

--local column = GAMESTATE:GetCurrentStyle():GetColumnInfo( GAMESTATE:GetMasterPlayerNumber(), 2 )
for _,v in pairs(NOTESKIN:GetNoteSkinNames()) do
	-- GetCurrentStyle returns nil whenever the screen is first initialized. If you want support for
	-- other gamemodes than Pump with different arrows, uncomment the line above and replace "UpLeft" with column["Name"]
	t[#t+1] = NOTESKIN:LoadActorForNoteSkin( "UpLeft" , "Tap Note", v )..{
		Name="NS"..string.lower(v), InitCommand=function(s) s:visible(false) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1) end
	}
end

return t
