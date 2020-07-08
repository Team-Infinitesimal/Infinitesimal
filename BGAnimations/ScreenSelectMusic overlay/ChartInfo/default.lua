local t = Def.ActorFrame {};

for player in ivalues(PlayerNumber) do

    t[#t+1] = LoadActor("ChartInfo"..pname(player))..{

        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-85)
            :zoom(0.10)
        end;

        SongChosenMessageCommand=function(self)
            self:stoptweening();
            self:visible(GAMESTATE:IsHumanPlayer(player));
            if player == PLAYER_1 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X-255);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X+255);
            end;
        end;

        SongUnchosenMessageCommand=function(self)
            self:stoptweening();
            if player == PLAYER_1 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X);
            end;
        end;
    };
	
	--=============================================================================
	--		Chart Type
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-143)
			:horizalign(center)
			:zoom(0.25,0.25)
			:maxwidth(350)
			:diffusecolor(0,0,0,1)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-241)
			else
				self:x(SCREEN_CENTER_X+242) --P2 isn't exactly mirrored from P1
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			local chartType = GetChartType(player);
			if chartType ~= nil then
				self:settext(chartType);
			else
				self:settext("Unknown");
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			local chartType = GetChartType(player);
			if chartType ~= nil then
				self:settext(chartType);
			else
				self:settext("Unknown");
			end;
		end;
	};
	
	--=============================================================================
	--		Chart Description
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-124)
			:horizalign(center)
			:zoom(0.25,0.25)
			:maxwidth(350)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-241)
			else
				self:x(SCREEN_CENTER_X+241)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local chartDescription = GAMESTATE:GetCurrentSteps(player):GetDescription();
				if chartDescription ~= nil then
					self:settext(string.upper(chartDescription)); --Because the last thing Pump stepcharts have is consistency
				else
					self:settext("");
				end;
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local chartDescription = GAMESTATE:GetCurrentSteps(player):GetDescription();
				if chartDescription ~= nil then
					self:settext(string.upper(chartDescription)); --Because the last thing Pump stepcharts have is consistency
				else
					self:settext("");
				end;
			end;
		end;
	};

	--=============================================================================
	--		Steps
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-95)
			:horizalign(right)
			:zoom(0.3,0.3)
			:maxwidth(100)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-246)
			else
				self:x(SCREEN_CENTER_X+237)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_TapsAndHolds'));
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_TapsAndHolds'));
			end;
		end;
	};

	--=============================================================================
	--		Jumps
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-95)
			:horizalign(right)
			:zoom(0.3,0.3)
			:maxwidth(100)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-198)
			else
				self:x(SCREEN_CENTER_X+285)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Jumps'));
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Jumps'));
			end;
		end;
	};

	--=============================================================================
	--		Holds
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-70)
			:horizalign(right)
			:zoom(0.3,0.3)
			:maxwidth(100)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-246)
			else
				self:x(SCREEN_CENTER_X+237)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Holds'));
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Holds'));
			end;
		end;
	};

	--=============================================================================
	--		Triple+
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-70)
			:horizalign(right)
			:zoom(0.3,0.3)
			:maxwidth(100)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-198)
			else
				self:x(SCREEN_CENTER_X+285)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Hands'));
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Hands'));
			end;
		end;
	};

	--=============================================================================
	--		Mines
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-45)
			:horizalign(right)
			:zoom(0.3,0.3)
			:maxwidth(100)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-246)
			else
				self:x(SCREEN_CENTER_X+237)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Mines'));
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Mines'));
			end;
		end;
	};

	--=============================================================================
	--		Rolls
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-45)
			:horizalign(right)
			:zoom(0.3,0.3)
			:maxwidth(100)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-198)
			else
				self:x(SCREEN_CENTER_X+285)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Rolls'));
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player);
				self:settext(radar:GetValue('RadarCategory_Rolls'));
			end;
		end;
	};

	--=============================================================================
	--		Step Artist
	--=============================================================================

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y-16)
			:horizalign(center)
			:zoom(0.3,0.3)
			:maxwidth(260)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player));
			self:stoptweening():diffusealpha(0);
			self:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-240)
			else
				self:x(SCREEN_CENTER_X+240)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)
			self:decelerate(0.25);
			self:x(SCREEN_CENTER_X);
		end;

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local artist = GAMESTATE:GetCurrentSteps(player):GetAuthorCredit();
				if artist == "" or artist == nil then
					self:settext("Unknown");
				else
					self:settext(artist);
				end;
			end;
		end;

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local artist = GAMESTATE:GetCurrentSteps(player):GetAuthorCredit();
				if artist == "" or artist == nil then
					self:settext("Unknown");
				else
					self:settext(artist);
				end;
			end;
		end;
	};
end;

return t;
