local PanelW = 330
local PanelH = 120

local StatsX = 55
local StatsXSpacing = 25
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
        ChangeStepsMessageCommand=function(self) self:playcommand("Refresh") end,
        SongChosenMessageCommand=function(self) self:playcommand("Refresh") end,

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

                local ChartInfoText = ChartTypeText .. " " .. THEME:GetString("ChartInfo", "By") .. " " .. ChartAuthorText
                if ChartDescriptionText ~= "" then
                    ChartInfoText = ChartInfoText .. "\n" .. ChartDescriptionText
                end
                ChartInfoText = string.upper(ChartInfoText)

                self:GetChild("ChartInfo"):settext(ChartInfoText)
                self:GetChild("Steps"):settext(THEME:GetString("PaneDisplay", "Steps") .. "\n" .. ChartRadar:GetValue('RadarCategory_TapsAndHolds'))
                self:GetChild("Jumps"):settext(THEME:GetString("PaneDisplay", "Jumps") .. "\n" .. ChartRadar:GetValue('RadarCategory_Jumps'))
                self:GetChild("Holds"):settext(THEME:GetString("PaneDisplay", "Holds") .. "\n" .. ChartRadar:GetValue('RadarCategory_Holds'))
                self:GetChild("Hands"):settext(THEME:GetString("PaneDisplay", "Hands") .. "\n" .. ChartRadar:GetValue('RadarCategory_Hands'))
                self:GetChild("Mines"):settext(THEME:GetString("PaneDisplay", "Mines") .. "\n" .. ChartRadar:GetValue('RadarCategory_Mines'))
                self:GetChild("Rolls"):settext(THEME:GetString("PaneDisplay", "Rolls") .. "\n" .. ChartRadar:GetValue('RadarCategory_Rolls'))
            else
                self:GetChild("ChartInfo"):settext("")
                self:GetChild("Steps"):settext("")
                self:GetChild("Jumps"):settext("")
                self:GetChild("Holds"):settext("")
                self:GetChild("Hands"):settext("")
                self:GetChild("Mines"):settext("")
                self:GetChild("Rolls"):settext("")
            end
        end,

        Def.BitmapText {
            Font="Montserrat extrabold 20px",
            Name="ChartInfo",
            InitCommand=function(self)
                self:maxwidth(PanelW / self:GetZoom())
                :vertspacing(-6)
                :skewx(-0.2)
                :x(-172 + (pn == PLAYER_2 and 345 or 0))
                :y(13)
            end
        },

        Def.BitmapText {
            Font="Montserrat normal 20px",
            Name="Steps",
            InitCommand=function(self)
                self:zoom(0.75)
                :maxwidth(96 / self:GetZoom())
                :valign(0):vertspacing(-4)
                :x(StatsXSpacing - StatsX * 6 + PlayerX)
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
                :x(StatsXSpacing - StatsX * 5 + PlayerX)
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
                :x(StatsXSpacing - StatsX * 4 + PlayerX)
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
                :x(StatsXSpacing - StatsX * 3 + PlayerX)
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
                :x(StatsXSpacing - StatsX * 2 + PlayerX)
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
                :x(StatsXSpacing - StatsX + PlayerX)
                :y(StatsY)
            end
        },

        Def.ActorFrame {
            InitCommand=function(self) self:diffusealpha(1):queuecommand("ShowAMV") end,
            SongChosenMessageCommand=function(self) self:stoptweening():diffusealpha(1):queuecommand("ShowAMV") end,

            ChangeStepsMessageCommand=function(self)
                self:stoptweening():diffusealpha(0)
                if GAMESTATE:GetCurrentSong() then
                    self:sleep(PreviewDelay):queuecommand("ShowAMV")
                end
            end,

            ShowAMVCommand=function(self) self:linear(PreviewDelay):diffusealpha(1) end,
            -- valign(1) doesn't work with ActorMultiVertex :(
            LoadActor("../NPSDiagram", (pn == PLAYER_2 and 128 or -128), 111, 250, 40, false, pn)
        }
    }
end

return t
