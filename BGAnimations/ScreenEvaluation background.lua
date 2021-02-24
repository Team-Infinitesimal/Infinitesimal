local t = Def.ActorFrame {

	InitCommand = function(self)
		local player = GAMESTATE:GetMasterPlayerNumber()
		local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
		local StepOrTrails = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)
		
		if GAMESTATE:GetCurrentSong() then
			local details = GAMESTATE:IsCourseMode() and SongOrCourse:GetTranslitFullTitle() or (PREFSMAN:GetPreference("ShowNativeLanguage") and SongOrCourse:GetDisplayMainTitle() or SongOrCourse:GetTranslitFullTitle()) .. " - " .. GAMESTATE:GetCurrentSong():GetDisplayArtist()
			details = string.len(details) < 128 and details or string.sub(details, 1, 124) .. "..."
			
			local Difficulty = GetChartType(player) .. " " .. StepOrTrails:GetMeter()
			local Percentage = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints()
			local states = Difficulty .. " (".. string.format( "%.2f%%", Percentage*100) .. ")"
			
			GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(player))
			GAMESTATE:UpdateDiscordScreenInfo(details,states,1)
		end
	end
}

local song = GAMESTATE:GetCurrentSong();

t[#t+1] = Def.ActorFrame {

    Def.Quad {
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffusetopedge(color("#2f2f2f")):diffusebottomedge(color("#161616"))
        end
    },

    Def.Sprite {
        InitCommand=function(self)
            self:Load(GAMESTATE:GetCurrentSong():GetBackgroundPath())
			:Center():scale_or_crop_background():diffusealpha(0.25)
        end
    }
}

return t
