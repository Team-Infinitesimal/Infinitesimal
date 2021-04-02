local t = Def.ActorFrame {}

--[[ work on this later
t[#t+1] = LoadActor(THEME:GetPathG("","GradientUI"))..{
	InitCommand=function(self)
		self:zoomx(baseZoom+0.5075)
		:zoomy(baseZoom)
		:x(baseX+spacing*5.5)
		:y(baseY-60)
		:visible(false)
	end

	SongChosenMessageCommand=function(self)
		self:stoptweening()
		:visible(true)
		:decelerate(0.3)
		:y(baseY+80)
	end

	SongUnchosenMessageCommand=function(self)self:playcommand("Close")end
	PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

	CloseCommand=function(self)
		self:stoptweening()
		:decelerate(0.3)
		:y(baseY-60)
		:visible(false)
	end
}
]]--

local InfoXP1 = SCREEN_CENTER_X-235
local InfoXP2 = SCREEN_CENTER_X+235
local InfoY = SCREEN_CENTER_Y-70

for player in ivalues(PlayerNumber) do

    t[#t+1] = LoadActor("ChartInfo"..pname(player))..{

        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,InfoY)
            :zoom(0.33)
			:diffusealpha(0)
        end,

        SongChosenMessageCommand=function(self)
            self:stoptweening()
            :diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
            :decelerate(0.25)
            if player == PLAYER_1 then
                self:x(InfoXP1)
            elseif player == PLAYER_2 then
                self:x(InfoXP2)
            end
        end,

        SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

        CloseCommand=function(self)
            self:stoptweening()
			:decelerate(0.2)
			:diffusealpha(0)
            :x(SCREEN_CENTER_X)
        end
    }

	--=============================================================================
	--		Chart Type
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY-57.5)
			:horizalign(center)
			:zoom(0.5):maxwidth(175)
			:diffusecolor(255,255,255,0)
      :skewx(-0.25)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 14 or -13))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			local chartType = GetChartType(player)
			if chartType ~= nil then
				self:settext(chartType)
			else
				self:settext("Unknown")
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			local chartType = GetChartType(player)
			if chartType ~= nil then
				self:settext(chartType)
			else
				self:settext("Unknown")
			end
		end
	}

	--=============================================================================
	--		Chart Description
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY-39)
			:horizalign(center)
			:zoom(0.5):wrapwidthpixels(190):vertspacing(-8):maxheight(40)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 14 or -13))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local chartName = GAMESTATE:GetCurrentSteps(player):GetChartName()
				local chartDescription = GAMESTATE:GetCurrentSteps(player):GetDescription()
				if chartName ~= "" then
					self:settext(chartName)
				elseif chartDescription ~= nil then
					self:settext(string.upper(chartDescription)) --Because the last thing Pump stepcharts have is consistency
				else
					self:settext("")
				end
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local chartName = GAMESTATE:GetCurrentSteps(player):GetChartName()
				local chartDescription = GAMESTATE:GetCurrentSteps(player):GetDescription()
				if chartName ~= "" then
					self:settext(chartName)
				elseif chartDescription ~= nil then
					self:settext(string.upper(chartDescription)) --Because the last thing Pump stepcharts have is consistency
				else
					self:settext("")
				end
			end
		end
	}

	--=============================================================================
	--		Steps
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY-10)
			:horizalign(right)
			:zoom(0.6):maxwidth(50)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 10 or -17.5))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_TapsAndHolds'))
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_TapsAndHolds'))
			end
		end
	}

	--=============================================================================
	--		Jumps
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY-10)
			:horizalign(right)
			:zoom(0.6):maxwidth(50)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 57.5 or 30))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Jumps'))
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Jumps'))
			end
		end
	}

	--=============================================================================
	--		Holds
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY+15)
			:horizalign(right)
			:zoom(0.6):maxwidth(50)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 10 or -17.5))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Holds'))
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Holds'))
			end
		end
	}

	--=============================================================================
	--		Triple+
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY+15)
			:horizalign(right)
			:zoom(0.6):maxwidth(50)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 57.5 or 30))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.25)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Hands'))
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Hands'))
			end
		end
	}

	--=============================================================================
	--		Mines
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY+40)
			:horizalign(right)
			:zoom(0.6):maxwidth(50)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 10 or -17.5))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Mines'))
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Mines'))
			end
		end,
	}

	--=============================================================================
	--		Rolls
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY+40)
			:horizalign(right)
			:zoom(0.6):maxwidth(50)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 57.5 or 30))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Rolls'))
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local radar = GAMESTATE:GetCurrentSteps(player):GetRadarValues(player)
				self:settext(radar:GetValue('RadarCategory_Rolls'))
			end
		end
	}

	--=============================================================================
	--		Step Artist
	--=============================================================================

	t[#t+1] = LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,InfoY+69) --nice
			:horizalign(center)
			:zoom(0.6):wrapwidthpixels(146):vertspacing(-8):maxheight(34)
			:diffusealpha(0)
		end,

		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:diffusealpha(GAMESTATE:IsHumanPlayer(player) and 1 or 0)
			:decelerate(0.25)
			:x((player == PLAYER_1 and InfoXP1 or InfoXP2)+(player == PLAYER_1 and 14 or -13))
		end,

		SongUnchosenMessageCommand=function(self)self:playcommand("Close")end,
		--PlayerJoinedMessageCommand=function(self)self:playcommand("Close")end

		CloseCommand=function(self)
			self:decelerate(0.2)
			:diffusealpha(0)
			:x(SCREEN_CENTER_X)
		end,

		CurrentStepsP1ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local artist = GAMESTATE:GetCurrentSteps(player):GetAuthorCredit()
				if artist == "" or artist == nil then
					self:settext("Unknown")
				else
					self:settext(artist)
				end
			end
		end,

		CurrentStepsP2ChangedMessageCommand=function(self)
			if (GAMESTATE:GetCurrentSteps(player)) then
				local artist = GAMESTATE:GetCurrentSteps(player):GetAuthorCredit()
				if artist == "" or artist == nil then
					self:settext("Unknown")
				else
					self:settext(artist)
				end
			end
		end
	}
end

return t
