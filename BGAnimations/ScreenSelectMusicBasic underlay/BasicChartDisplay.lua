local ItemW = 56
local ItemH = 56
local ItemAmount = ...
local ItemTotalW = ItemW * ((ItemAmount - 1) / 2)

local FrameX = -ItemTotalW

local ChartIndexP1 = 1
local ChartIndexP2 = 1
local ChartArray = nil
local SongIsChosen = false
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local CenterList = LoadModule("Config.Load.lua")("CenterChartList", "Save/OutFoxPrefs.ini")

function SortCharts(a, b)
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return a:GetStepsType() > b:GetStepsType()
    end
end

local function ColourSteps(meter, type)
    if type == "Double" then return {color("#21db30"), "DOUBLE"} end
    if meter <= 2 then return {color("#209be3"), "EASY"} end
    if meter <= 4 then return {color("#fff700"), "NORMAL"} end
    if meter <= 7 then return {color("#ff3636"), "HARD"} end
    if meter <= 12 then return {color("#d317e8"), "VERY HARD"} end
    return {Color.White, "idk lol"} -- failsafe to prevent errors, should never be displayed anyway
end

local function InputHandler(event)
    if SongIsChosen then
        local pn = event.PlayerNumber
        if not pn then return end
        
        -- To avoid control from a player that has not joined, filter the inputs out
        if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
        if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end
        
        -- Filter out everything but button presses
        if event.type == "InputEventType_Repeat" or event.type == "InputEventType_Release" then return end
        
        local button = event.button
        if button == "MenuLeft" or button == "DownLeft" then
            if pn == PLAYER_1 then
                if ChartIndexP1 == 1 then return else
                ChartIndexP1 = ChartIndexP1 - 1 end
            else
                if ChartIndexP2 == 1 then return else
                ChartIndexP2 = ChartIndexP2 - 1 end
            end
            MESSAGEMAN:Broadcast("CurrentChartChanged")
        elseif button == "MenuRight" or button == "DownRight" then
            if pn == PLAYER_1 then
                if ChartIndexP1 == #ChartArray then return else
                ChartIndexP1 = ChartIndexP1 + 1 end
            else
                if ChartIndexP2 == #ChartArray then return else
                ChartIndexP2 = ChartIndexP2 + 1 end
            end
            MESSAGEMAN:Broadcast("CurrentChartChanged")
        end
    end
    return
end

local t = Def.ActorFrame {
    OnCommand=function(self) 
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) 
        self:playcommand("Refresh")
    end,
    
    -- Update chart list
    CurrentChartChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    
    -- These are to control the visibility of the chart highlight.
    SongChosenMessageCommand=function(self) SongIsChosen = true self:playcommand("Refresh") end,
    SongUnchosenMessageCommand=function(self) SongIsChosen = false self:playcommand("Refresh") end,

    RefreshCommand=function(self)
        ChartArray = nil
        local CurrentSong = GAMESTATE:GetCurrentSong()
        if CurrentSong then
            SingleCharts = CurrentSong:GetStepsByStepsType('StepsType_Pump_Single')
            table.sort(SingleCharts, SortCharts)
            DoubleCharts = CurrentSong:GetStepsByStepsType('StepsType_Pump_Double')
            table.sort(DoubleCharts, SortCharts)
            
            -- Exclude double from two players
            if GAMESTATE:GetNumSidesJoined() > 1 then
                ChartArray = { SingleCharts[1], SingleCharts[2], SingleCharts[3] }
            else
                ChartArray = { SingleCharts[1], SingleCharts[2], SingleCharts[3], DoubleCharts[1] }
            end
        end

        if ChartArray then
            -- Correct player chart indexes to ensure they're not off limits
            if ChartIndexP1 < 1 then ChartIndexP1 = 1 elseif ChartIndexP1 > #ChartArray then ChartIndexP1 = #ChartArray end
            if ChartIndexP2 < 1 then ChartIndexP2 = 1 elseif ChartIndexP2 > #ChartArray then ChartIndexP2 = #ChartArray end
            
            -- Set the selected charts and broadcast a new message to avoid possible
            -- race conditions trying to obtain the currently selected chart.
            if GAMESTATE:IsPlayerEnabled(PLAYER_1) then 
                GAMESTATE:SetCurrentSteps(PLAYER_1, ChartArray[ChartIndexP1]) 
                MESSAGEMAN:Broadcast("ChangeChart")
            end
            if GAMESTATE:IsPlayerEnabled(PLAYER_2) then 
                GAMESTATE:SetCurrentSteps(PLAYER_2, ChartArray[ChartIndexP2])
                MESSAGEMAN:Broadcast("ChangeChart")				
            end
            
            -- Shift the positioning of the charts if they don't take up all visible slots
            local ChartArrayW = ItemW * ((#ChartArray < ItemAmount and #ChartArray or ItemAmount) - 1) / 2
            self:x(ItemTotalW - ChartArrayW)

            -- Draw the chart list
            for i=1,ItemAmount do
                local Chart = ChartArray[i]

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
                        (ChartIndexP1 == i) and SongIsChosen and GAMESTATE:IsHumanPlayer(PLAYER_1))
                    self:GetChild("")[i]:GetChild("HighlightP2"):visible(
                        (ChartIndexP2 == i) and SongIsChosen and GAMESTATE:IsHumanPlayer(PLAYER_2))
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

t[#t+1] = Def.Sound {
    File=THEME:GetPathS("Common", "value"),
    IsAction=true,
    CurrentChartChangedMessageCommand=function(self) self:play() end
}

return t
