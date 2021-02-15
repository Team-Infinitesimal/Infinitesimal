-- Originally from Soundwaves/OutFox

local t = Def.ActorFrame {
	OnCommand=function(self) 
		self:playcommand("UpdateDiscordInfo")
	end;
	
	UpdateDiscordInfoCommand=function(s)
		local player = GAMESTATE:GetMasterPlayerNumber()
		if GAMESTATE:GetCurrentSong() then
			local title = PREFSMAN:GetPreference("ShowNativeLanguage") and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitFullTitle()
			local songname = title .. " - " .. GAMESTATE:GetCurrentSong():GetDisplayArtist()
			local state = GAMESTATE:IsDemonstration() and "Watching Song" or "Playing Song"
			GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))
			
			local stats = STATSMAN:GetCurStageStats()
			if not stats then return end;
			local courselength = function()
				if GAMESTATE:IsCourseMode() then
					if GAMESTATE:GetPlayMode() ~= "PlayMode_Endless" then
						return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().. " (Song ".. stats:GetPlayerStageStats( player ):GetSongsPassed()+1 .. " of ".. GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() ..")" or ""
					end;
					
					return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle().. " (Song ".. stats:GetPlayerStageStats( player ):GetSongsPassed()+1 .. ")" or ""
				end
			end
			GAMESTATE:UpdateDiscordSongPlaying(GAMESTATE:IsCourseMode() and courselength() or state,songname,GAMESTATE:GetCurrentSong():GetLastSecond())
		end
	end;
	
	CurrentSongChangedMessageCommand=function(s) s:playcommand("UpdateDiscordInfo") end;
}

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
	local peak,npst,NMeasure,mcount = LoadModule("Chart.GetNPS.lua")( GAMESTATE:GetCurrentSteps(pn) )
	GAMESTATE:Env()["ChartData"..pn] = {peak,npst,NMeasure,mcount}

	if LoadModule("Config.Load.lua")("MeasureCounter",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") then
		t[#t+1] = LoadActor("MeasureCount", pn)
	end
end

return t;
