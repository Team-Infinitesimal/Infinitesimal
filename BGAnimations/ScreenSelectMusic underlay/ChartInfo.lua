local PanelW = 328
local PanelH = 120

local StatsX = 57
local StatsY = 46

local SongIsChosen = false
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")

-- Breakdown from Soundwaves (JoseVarelaP, Jousway, Lirodon)
local GetStreamBreakdown = function(Player)
    if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(Player) then
        local streams = LoadModule("Chart.GetStreamMeasure.lua")(NMeasure, 2, mcount)
        if not streams then return "" end
        
        local streamLengths = {}
        
        for i, stream in ipairs(streams) do
            local streamCount = tostring(stream.streamEnd - stream.streamStart)
            if not stream.isBreak then
                streamLengths[#streamLengths + 1] = streamCount
            end
        end
        
        return table.concat(streamLengths, "/")
    end
    return ""
end

local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    -- This will help us position each element to each player's side
    local PlayerX = pn == PLAYER_2 and 339 or 0
    
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self) self:queuecommand("Refresh") end,
        ["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(self) self:playcommand("Refresh") end,
        
        RefreshCommand=function(self)
            if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
                local Song = GAMESTATE:GetCurrentSong()
                local Chart = GAMESTATE:GetCurrentSteps(pn)
                local ChartRadar = Chart:GetRadarValues(pn)
                
                local ChartAuthorText = Chart:GetAuthorCredit()
                if ChartAuthorText == "" then ChartAuthorText = "Unknown" end
                
                local ChartTypeText = ToEnumShortString(ToEnumShortString(Chart:GetStepsType())) .. " " .. Chart:GetMeter()
                
                local ChartDescriptionText = Chart:GetChartName()
                -- if ChartDescriptionText == "" then ChartDescriptionText = ToUpper(Chart:GetDescription()) end
                
                local ChartInfoText = ChartTypeText .. " by " .. ChartAuthorText
                if ChartDescriptionText ~= "" then 
                    ChartInfoText = ChartInfoText .. "\n" .. ChartDescriptionText
                end
                
                self:GetChild("ChartInfo"):settext(ChartInfoText)
                self:GetChild("Steps"):settext(ChartRadar:GetValue('RadarCategory_TapsAndHolds') .. "\n" .. THEME:GetString("ChartStats","Steps"))
                self:GetChild("Jumps"):settext(ChartRadar:GetValue('RadarCategory_Jumps') .. "\n" .. THEME:GetString("ChartStats","Jumps"))
                self:GetChild("Holds"):settext(ChartRadar:GetValue('RadarCategory_Holds') .. "\n" .. THEME:GetString("ChartStats","Holds"))
                self:GetChild("Hands"):settext(ChartRadar:GetValue('RadarCategory_Hands') .. "\n" .. THEME:GetString("ChartStats","Hands"))
                self:GetChild("Mines"):settext(ChartRadar:GetValue('RadarCategory_Mines') .. "\n" .. THEME:GetString("ChartStats","Mines"))
                self:GetChild("Rolls"):settext(ChartRadar:GetValue('RadarCategory_Rolls') .. "\n" .. THEME:GetString("ChartStats","Rolls"))
            else
                self:GetChild("ChartType"):settext("")
                self:GetChild("Steps"):settext("")
                self:GetChild("Jumps"):settext("")
                self:GetChild("Holds"):settext("")
                self:GetChild("Hands"):settext("")
                self:GetChild("Mines"):settext("")
                self:GetChild("Rolls"):settext("")
            end
        end,
        
        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="ChartInfo",
            InitCommand=function(self)
                self:maxwidth(PanelW / self:GetZoom())
                :vertspacing(-3)
                :x(-170 + (pn == PLAYER_2 and 340 or 0))
                :y(12)
            end
        },
        
        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="Steps",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(30 - StatsX * 6 + PlayerX)
                :y(StatsY)
            end
        },
        
        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="Jumps",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(30 - StatsX * 5 + PlayerX)
                :y(StatsY)
            end
        },
        
        Def.BitmapText{
            Font="Montserrat normal 20px",
            Name="Holds",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(30 - StatsX * 4 + PlayerX)
                :y(StatsY)
            end
        },
        
        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="Hands",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(30 - StatsX * 3 + PlayerX)
                :y(StatsY)
            end
        },
        
        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="Mines",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(30 - StatsX * 2 + PlayerX)
                :y(StatsY)
            end
        },
        
        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="Rolls",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(30 - StatsX + PlayerX)
                :y(StatsY)
            end
        },
        
        Def.ActorFrame {
            InitCommand=function(self) self:diffusealpha(1):queuecommand("ShowAMV") end,
            SongChosenMessageCommand=function(self) self:stoptweening():diffusealpha(1):queuecommand("ShowAMV") end,
            
            ["CurrentSteps".. ToEnumShortString(pn) .."ChangedMessageCommand"]=function(self)
                self:stoptweening():diffusealpha(0)
                if GAMESTATE:GetCurrentSong() then
                    self:decelerate(PreviewDelay):queuecommand("ShowAMV")
                end
            end,
            
            ShowAMVCommand=function(self) self:linear(PreviewDelay):diffusealpha(1) end,
            -- Stop being an idiot, add valign(1) and fix height limits later
            LoadActor("../NPSDiagram", -122 + (pn == PLAYER_2 and 244 or 0), 136, 240, 84, false, pn)
        }
    }
end

return t
