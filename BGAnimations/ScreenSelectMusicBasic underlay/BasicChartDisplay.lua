local ItemW = 56
local ItemH = 56
local ItemAmount = ...
local ItemTotalW = ItemW * ((ItemAmount - 1) / 2)

local FrameX = -ItemTotalW

local ChartIndex = { PlayerNumber_P1 = 1, PlayerNumber_P2 = 1 }
local PrevChartIndex = { PlayerNumber_P1 = 1, PlayerNumber_P2 = 1 }

local ChartArray = nil
local SongIsChosen = false
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")
local ConfirmStart = false

function SortCharts(a, b)
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return a:GetStepsType() > b:GetStepsType()
    end
end

local function InputHandler(event)
    local pn = event.PlayerNumber
    if not pn then return end
    
    -- To avoid control from a player that has not joined, filter the inputs out
    if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
    if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end
    
    if SongIsChosen then
        -- Filter out everything but button presses
        if event.type == "InputEventType_Repeat" or event.type == "InputEventType_Release" then return end
        
        local button = event.button
        if button == "Left" or button == "MenuLeft" or button == "DownLeft" then
            if ChartIndex[pn] == 1 then return else
            ChartIndex[pn] = ChartIndex[pn] - 1 end
            MESSAGEMAN:Broadcast("UpdateChartDisplay", { Player = pn })
            ConfirmStart = false
            
        elseif button == "Right" or button == "MenuRight" or button == "DownRight" then
            if ChartIndex[pn] == #ChartArray then return else
            ChartIndex[pn] = ChartIndex[pn] + 1 end
            MESSAGEMAN:Broadcast("UpdateChartDisplay", { Player = pn })
            ConfirmStart = false
            
        elseif button == "UpLeft" or button == "UpRight" or button == "Up" then
            MESSAGEMAN:Broadcast("StepsUnchosen", { Player = pn })
            MESSAGEMAN:Broadcast("SongUnchosen")
            ConfirmStart = false
            
        elseif button == "Start" or button == "MenuStart" or button == "Center" then
            if ConfirmStart then
                SongIsChosen = false
                
                -- Set these or else we crash.
                GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")
                GAMESTATE:SetCurrentStyle(GAMESTATE:GetNumSidesJoined() > 1 and "versus" or "single")
                SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
            else
                MESSAGEMAN:Broadcast("StepsChosen", { Player = pn })
                ConfirmStart = true
            end
        end
    end
    return
end

local t = Def.ActorFrame {
    OnCommand=function(self) 
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) 
        self:playcommand("Refresh")
    end,
    
    -- Prevent the chart list from moving when transitioning
    CodeCommand=function(self, params)
        if params.Name == "FullMode" then
            SongIsChosen = false
        end
    end,
    
    -- Update chart list
    UpdateChartDisplayMessageCommand=function(self) self:playcommand("Refresh") end,
    CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    
    -- These are to control the visibility of the chart highlight.
    SongChosenMessageCommand=function(self) SongIsChosen = true self:playcommand("Refresh") end,
    SongUnchosenMessageCommand=function(self) SongIsChosen = false self:playcommand("Refresh") end,

    RefreshCommand=function(self)
        self:finishtweening()
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
            if ChartIndex[PLAYER_1] < 1 then ChartIndex[PLAYER_1] = 1
            elseif ChartIndex[PLAYER_1] > #ChartArray then ChartIndex[PLAYER_1] = #ChartArray end
            
            if ChartIndex[PLAYER_2] < 1 then ChartIndex[PLAYER_2] = 1
            elseif ChartIndex[PLAYER_2] > #ChartArray then ChartIndex[PLAYER_2] = #ChartArray end
            
            -- Set the selected charts and broadcast a new message to avoid possible
            -- race conditions trying to obtain the currently selected chart.
            if GAMESTATE:IsPlayerEnabled(PLAYER_1) then 
                GAMESTATE:SetCurrentSteps(PLAYER_1, ChartArray[ChartIndex[PLAYER_1]])
                if ChartIndex[PLAYER_1] ~= PrevChartIndex[PLAYER_1] then
                MESSAGEMAN:Broadcast("CurrentChartChanged", { Player = PLAYER_1 }) end
            end
            if GAMESTATE:IsPlayerEnabled(PLAYER_2) then 
                GAMESTATE:SetCurrentSteps(PLAYER_2, ChartArray[ChartIndex[PLAYER_2]])
                if ChartIndex[PLAYER_2] ~= PrevChartIndex[PLAYER_2] then
                MESSAGEMAN:Broadcast("CurrentChartChanged", { Player = PLAYER_2 }) end
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

                    self:GetChild("")[i]:GetChild("Icon"):visible(true):diffuse(ChartTypeToColor(Chart))
                    self:GetChild("")[i]:GetChild("IconTrim"):visible(true)
                    self:GetChild("")[i]:GetChild("Level"):visible(true):settext(ChartMeter)
                    self:GetChild("")[i]:GetChild("Difficulty"):visible(true):settext(BasicChartLabel(Chart))
                    self:GetChild("")[i]:GetChild("HighlightP1"):visible(
                        (ChartIndex[PLAYER_1] == i) and SongIsChosen and GAMESTATE:IsHumanPlayer(PLAYER_1))
                    self:GetChild("")[i]:GetChild("HighlightP2"):visible(
                        (ChartIndex[PLAYER_2] == i) and SongIsChosen and GAMESTATE:IsHumanPlayer(PLAYER_2))
                else
                    self:GetChild("")[i]:GetChild("Icon"):visible(false)
                    self:GetChild("")[i]:GetChild("IconTrim"):visible(false)
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

t[#t+1] = Def.ActorFrame {
    Def.Sound {
        File=THEME:GetPathS("Common", "value"),
        IsAction=true,
        UpdateChartDisplayMessageCommand=function(self) self:play() end
    },

    Def.Sound {
        File=THEME:GetPathS("Common", "Start"),
        IsAction=true,
        StepsChosenMessageCommand=function(self) self:play() end
    }
}

return t
