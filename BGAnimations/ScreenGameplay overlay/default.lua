local t = Def.ActorFrame {
	OnCommand=function(self) self:playcommand("UpdateDiscordInfo") end,
	CurrentSongChangedMessageCommand=function(self) self:playcommand("UpdateDiscordInfo") end,
	UpdateDiscordInfoCommand=function(self)
		local pn = GAMESTATE:GetMasterPlayerNumber()
		if GAMESTATE:GetCurrentSong() then
			local title = PREFSMAN:GetPreference("ShowNativeLanguage") and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitFullTitle()
			local songname = title .. " - " .. GAMESTATE:GetCurrentSong():GetDisplayArtist()
			local state = GAMESTATE:IsDemonstration() and "Watching Song" or "Playing Song"
			GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(pn))
			local stats = STATSMAN:GetCurStageStats()
			if not stats then
				return
			end
			local courselength = function()
				if GAMESTATE:IsCourseMode() then
					if GAMESTATE:GetPlayMode() ~= "PlayMode_Endless" then
						return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() .. " (Song " .. stats:GetPlayerStageStats(pn):GetSongsPassed()+1 .. " of " .. GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() .. ")" or ""
					end
					return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() .. " (Song " .. stats:GetPlayerStageStats(pn):GetSongsPassed()+1 .. ")" or ""
				end
			end
			GAMESTATE:UpdateDiscordSongPlaying(GAMESTATE:IsCourseMode() and courselength() or state, songname, (GAMESTATE:GetCurrentSong():GetLastSecond() - GAMESTATE:GetCurMusicSeconds())/GAMESTATE:GetSongOptionsObject('ModsLevel_Song'):MusicRate())
		end
	end,
	
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
