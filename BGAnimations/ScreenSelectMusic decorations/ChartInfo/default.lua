local baseZoom = 0.25
local spacing = 29;
local delay = 2

local baseX = SCREEN_CENTER_X - (spacing*5.5)
local baseY = SCREEN_CENTER_Y + 40;


local t = Def.ActorFrame {};


t[#t+1] = LoadActor(THEME:GetPathG("","GradientUI"))..{
	InitCommand=function(self)
		self:zoomx(baseZoom+0.5075)
		:zoomy(baseZoom)
		:x(baseX+spacing*5.5)
		:y(baseY-60)
		:visible(false);
	end;
	
	SongChosenMessageCommand=function(self)
		self:stoptweening()
		:visible(true)
		:decelerate(0.3)
		:y(baseY+80);
	end;
	
	SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
	PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;
	
	CloseCommand=function(self)
		self:stoptweening()
		:decelerate(0.3)
		:y(baseY-60)
		:visible(false);
	end;
};


for player in ivalues(PlayerNumber) do

    t[#t+1] = LoadActor("ChartInfo"..pname(player))..{

        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-85)
            :zoom(0.33)
			:visible(false)
        end;

        SongChosenMessageCommand=function(self)
            self:stoptweening()
            :visible(GAMESTATE:IsHumanPlayer(player));
            if player == PLAYER_1 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X-255);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X+255);
            end;
        end;
        
        SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

        CloseCommand=function(self)
            self:stoptweening()
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-241)
			else
				self:x(SCREEN_CENTER_X+242) --P2 isn't exactly mirrored from P1
			end;
			self:diffusealpha(1);
		end;
		
		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;
		
		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-241)
			else
				self:x(SCREEN_CENTER_X+241)
			end;
			self:diffusealpha(1);
		end;
		
		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
					self:settext(string.upper(chartDescription));
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-246)
			else
				self:x(SCREEN_CENTER_X+237)
			end;
			self:diffusealpha(1);
		end;
		
		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-198)
			else
				self:x(SCREEN_CENTER_X+285)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-246)
			else
				self:x(SCREEN_CENTER_X+237)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-198)
			else
				self:x(SCREEN_CENTER_X+285)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-246)
			else
				self:x(SCREEN_CENTER_X+237)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-198)
			else
				self:x(SCREEN_CENTER_X+285)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
			:visible(false)
		end;

		SongChosenMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
			:stoptweening():diffusealpha(0)
			:decelerate(0.25);
			if player == PLAYER_1 then
				self:x(SCREEN_CENTER_X-240)
			else
				self:x(SCREEN_CENTER_X+240)
			end;
			self:diffusealpha(1);
		end;

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:decelerate(0.25)
			:x(SCREEN_CENTER_X)
			:visible(false);
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
	
	--=============================================================================
	--		Large difficulty ball and text
	--=============================================================================
	
	t[#t+1] = LoadActor(THEME:GetPathG("","DifficultyDisplay/_icon"))..{
		InitCommand=function(self)
			self:zoom(baseZoom+0.25)
			:x(baseX+spacing*5.5)
			:y(baseY-60)
			:animate(false)
			
			if player == PLAYER_1 then
				self:addx(spacing*-5.5);
			else
				self:addx(spacing*5.5);
			end;
		end;
		
		PlayerJoinedMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
		end;
		
		CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
		CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
		
		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:visible(GAMESTATE:IsSideJoined(player))
			:decelerate(0.3)
			:y(baseY+80)
			:playcommand("Refresh");
		end;
		
		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:stoptweening()
			:decelerate(0.3)
			:y(baseY-60)
			:visible(false);
		end;
		
		RefreshCommand=function(self)
			if GAMESTATE:IsHumanPlayer(player) then 
				self:stoptweening()
				:diffusealpha(1);
				local steps = GAMESTATE:GetCurrentSteps(player);
				if steps then
					if steps:GetStepsType() == "StepsType_Pump_Single" then
						if (string.find(steps:GetDescription(), "SP")) then
							self:setstate(3);
						else
							self:setstate(2);
						end;
					elseif steps:GetStepsType() == "StepsType_Pump_Double" then
						if string.find(steps:GetDescription(), "DP") then
							if steps:GetMeter() == 99 then
								self:setstate(1);
							else
								self:setstate(0);
							end;
						else
							self:setstate(6);
						end;
					elseif steps:GetStepsType() == "StepsType_Pump_Halfdouble" then
						self:setstate(5);
					elseif steps:GetStepsType() == "StepsType_Pump_Routine" then
						self:setstate(4);
					else
						self:setstate(7);
					end;
				end;
			end;
		end
	};

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
		InitCommand=function(self)
			self:zoom(baseZoom+0.25)
			:shadowlength(0.8)
			:shadowcolor(color("0,0,0,1"))
			:x(baseX+spacing*5.5)
			:y(baseY-60)
			
			if player == PLAYER_1 then
				self:addx(-spacing*5.5);
			else
				self:addx(spacing*5.5);
			end;
		end;
		
		PlayerJoinedMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(player))
		end;
		
		CurrentStepsP1ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
		CurrentStepsP2ChangedMessageCommand=function(self)self:playcommand("Refresh")end;
		
		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:visible(GAMESTATE:IsSideJoined(player))
			:decelerate(0.3)
			:y(baseY+80)
			:playcommand("Refresh");
		end;
		
		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end;

		CloseCommand=function(self)
			self:stoptweening()
			:decelerate(0.3)
			:y(baseY-60)
			:visible(false);
		end;
			
		RefreshCommand=function(self)
			if GAMESTATE:IsHumanPlayer(player) then 
				self:stoptweening()
				:diffusealpha(1);
				local steps = GAMESTATE:GetCurrentSteps(player);
				if steps then
					if steps:GetMeter() >= 99 then
						self:settext("??");
					else
						self:settext(steps:GetMeter());
					end;
				end;
			end;
		end
	};
	
end;

return t;
