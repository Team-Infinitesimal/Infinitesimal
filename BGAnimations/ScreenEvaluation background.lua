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
		end;
	end;
};

local song = GAMESTATE:GetCurrentSong();

t[#t+1] = Def.ActorFrame {
    LoadActor(THEME:GetPathG("","EvalElements/EvalBGGradient"))..{
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBackgroundPath()
        end;
    };

    Def.Sprite {
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBackgroundPath()
            self:Load(bg):scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
            self:diffusealpha(0.25);
        end
    };
};

return t;
