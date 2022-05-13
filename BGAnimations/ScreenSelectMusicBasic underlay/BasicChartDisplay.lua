local ItemW = 56
local ItemH = 56
local ItemAmount = ...
local ItemTotalW = ItemW * ((ItemAmount - 1) / 2)

local FrameX = -ItemTotalW

local SongIsChosen = false
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local CenterList = LoadModule("Config.Load.lua")("CenterChartList", "Save/OutFoxPrefs.ini")

local function GetCurrentChartIndex(pn, ChartArray)
	local PlayerSteps = GAMESTATE:GetCurrentSteps(pn)
	-- Not sure how the previous checks fails at times, so here it is once again
	if ChartArray then
		for i=1,#ChartArray do
			if PlayerSteps == ChartArray[i] then
				return i
			end
		end
	end
	-- If it reaches this point, the selected steps doesn't equal anything
	return -1
end

local function ColourSteps(meter, type)
    if type == "Double" then return {color("#21db30"), "DOUBLE"} end
    if meter <= 2 then return {color("#209be3"), "EASY"} end
    if meter <= 4 then return {color("#fff700"), "NORMAL"} end
    if meter <= 7 then return {color("#ff3636"), "HARD"} end
    if meter <= 12 then return {color("#d317e8"), "VERY HARD"} end
    return {Color.White, "idk lol"} -- failsafe to prevent errors, should never be displayed anyway
end

local t = Def.ActorFrame {
	InitCommand=function(self) self:playcommand("Refresh") end,
	CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
	CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,

	-- These are to control the visibility of the chart highlight.
	SongChosenMessageCommand=function(self) SongIsChosen = true self:playcommand("Refresh") end,
	SongUnchosenMessageCommand=function(self) SongIsChosen = false self:playcommand("Refresh") end,

	RefreshCommand=function(self)
		local ChartArray = nil
		local CurrentSong = GAMESTATE:GetCurrentSong()
		if CurrentSong then
            SingleCharts = CurrentSong:GetStepsByStepsType('StepsType_Pump_Single')
            DoubleCharts = CurrentSong:GetStepsByStepsType('StepsType_Pump_Double')
            ChartArray = { SingleCharts[1], SingleCharts[2], SingleCharts[3], DoubleCharts[1] }
        end

		if ChartArray then
        -- Generate the index of charts to choose from.
        local ChartIndexP1 = GetCurrentChartIndex(PLAYER_1, ChartArray)
        local ChartIndexP2 = GetCurrentChartIndex(PLAYER_2, ChartArray)
        local ChartIndex = ChartIndexP1 > ChartIndexP2 and ChartIndexP1 or ChartIndexP2

        local ListOffset = 0
        if ChartIndex + 1 > ItemAmount then
            ListOffset = ChartIndex - ItemAmount + (ChartIndex == #ChartArray and 0 or 1)
        end

	    if CenterList then
	        -- Shift the positioning of the charts if they don't take up all visible slots
	        local ChartArrayW = ItemW * ((#ChartArray < ItemAmount and #ChartArray or ItemAmount) - 1) / 2
	        self:x(ItemTotalW - ChartArrayW)
	    end

			for i=1,ItemAmount do
				local Chart = ChartArray[ i + ListOffset ]

				if Chart then
					local ChartMeter = Chart:GetMeter()
                    local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
					if ChartMeter == 99 then ChartMeter = "??" end
					local ChartDescription = Chart:GetDescription()
                    local StepData = ColourSteps(ChartMeter, ChartType)

					self:GetChild("")[i]:GetChild("Icon"):visible(true):diffuse(StepData[1])
                    self:GetChild("")[i]:GetChild("IconTrim"):visible(true)
					self:GetChild("")[i]:GetChild("Level"):visible(true):settext(ChartMeter)
                    self:GetChild("")[i]:GetChild("Difficulty"):visible(true):settext(StepData[2])
					self:GetChild("")[i]:GetChild("HighlightP1"):visible(
                        (ChartIndexP1 == i + ListOffset) and SongIsChosen and GAMESTATE:IsHumanPlayer(PLAYER_1))
                    self:GetChild("")[i]:GetChild("HighlightP2"):visible(
                        (ChartIndexP2 == i + ListOffset) and SongIsChosen and GAMESTATE:IsHumanPlayer(PLAYER_2))
				else
                    if not CenterList then
                        self:GetChild("")[i]:GetChild("Icon"):visible(true):diffuse(Color.White):diffusealpha(0.25)
                        self:GetChild("")[i]:GetChild("IconTrim"):visible(true)
                    else
                        self:GetChild("")[i]:GetChild("Icon"):visible(false)
                        self:GetChild("")[i]:GetChild("IconTrim"):visible(false)
                    end
					self:GetChild("")[i]:GetChild("Level"):visible(false)
					self:GetChild("")[i]:GetChild("HighlightP1"):visible(false)
                    self:GetChild("")[i]:GetChild("HighlightP2"):visible(false)
				end
			end
		else
			for i=1,ItemAmount do
				self:GetChild("")[i]:GetChild("Icon"):visible(false)
                self:GetChild("")[i]:GetChild("IconTrim"):visible(false)
				self:GetChild("")[i]:GetChild("Level"):visible(false)
				self:GetChild("")[i]:GetChild("HighlightP1"):visible(false)
                self:GetChild("")[i]:GetChild("HighlightP2"):visible(false)
			end
		end
	end,
}

for i=1,ItemAmount do
	t[#t+1] = Def.ActorFrame {
		Def.Sprite {
			Name="Icon",
			Texture=THEME:GetPathG("", "DifficultyDisplay/Ball"),
			InitCommand=function(self)
				self:xy(FrameX + ItemW * (i - 1), 0)
			end
		},

        Def.Sprite {
			Name="IconTrim",
			Texture=THEME:GetPathG("", "DifficultyDisplay/Trim"),
			InitCommand=function(self)
				self:xy(FrameX + ItemW * (i - 1), 0)
			end
		},

		Def.BitmapText {
			Font="Montserrat numbers 40px",
			Name="Level",
			InitCommand=function(self)
				self:xy(FrameX + ItemW * (i - 1), 0):zoom(0.6):maxwidth(75)
			end
		},

        Def.BitmapText {
			Font="Montserrat extrabold 20px",
			Name="Difficulty",
			InitCommand=function(self)
				self:xy(FrameX + ItemW * (i - 1), -15):zoom(0.5):maxwidth(85):shadowlength(2):skewx(-0.1)
			end
		},

        Def.Sprite {
			Name="HighlightP1",
			Texture=THEME:GetPathG("", "DifficultyDisplay/Cursor/P1"),
			InitCommand=function(self)
				self:xy(FrameX + ItemW * (i - 1), -22)
				:zoom(0.5)
				:bounce():effectmagnitude(0, -5, 0):effectclock("bgm")
				:visible(false)
			end
		},

        Def.Sprite {
			Name="HighlightP2",
			Texture=THEME:GetPathG("", "DifficultyDisplay/Cursor/P2"),
			InitCommand=function(self)
				self:xy(FrameX + ItemW * (i - 1), 22)
				:zoom(0.5)
				:bounce():effectmagnitude(0, 5, 0):effectclock("bgm")
				:visible(false)
			end
		},

		LoadActor(THEME:GetPathS("Common","value")) .. {}
	}
end

return t;
