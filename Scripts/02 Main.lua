LastSongIndex = 0

function OptionNameString(str)
    return THEME:GetString('OptionNames',str)
end

-- Unfortunately, some settings persist with the machine profile even after a credit,
-- so we will reset all custom mods we have to avoid any weird situations
function ResetLuaMods(pn)
    LastSongIndex = 0
    local CarryJudgment = LoadModule("Config.Load.lua")("CarryJudgment", "Save/OutFoxPrefs.ini")
    local ProfileDir = "Save/MachineProfile/OutFoxPrefsForPlayerp" .. string.sub(pn,-1) .. "/OutFoxPrefs.ini"
    
    local settingsToReset = {
        {name = "AutoVelocity", value = 200},
        {name = "AutoVelocityType", value = false},
        {name = "ScreenFilter", value = 0},
        {name = "ScreenFilterColor", value = 2},
        {name = "ScreenFilterSize", value = "Full"},
        {name = "MeasureCounter", value = false},
        {name = "MeasureCounterDivisions", value = 12},
        {name = "JudgmentItems", value = false},
        {name = "ScoreDisplay", value = false},
        {name = "SongProgress", value = false},
        {name = "ProLifebar", value = false}
    }

    for i, setting in ipairs(settingsToReset) do
        LoadModule("Config.Save.lua")(setting.name, tostring(setting.value), ProfileDir)
    end

    if IsArcade() or (CarryJudgment == false) then
        LoadModule("Config.Save.lua")("SmartTimings",tostring("Pump Normal"),"Save/OutFoxPrefs.ini")
    end
end

-- Ensure that speed mods are accurate
function GameArrowSpacing()
    if IsGame("pump") or IsGame("piu") then
        return 60
    else
        -- Dunno what other modes might use but this is default
        return 64
    end
end

-- Lua Timing currently does not change these parameters, so the best we can do is
-- look at the current mode on boot up and change to the proper values
TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"

function ComboContinue()
    local Continue = {
        dance = GAMESTATE:GetPlayMode() == "PlayMode_Oni" and "TapNoteScore_W2" or "TapNoteScore_W3",
        pump = string.find(TimingMode, "Pump") and "TapNoteScore_W2" or "TapNoteScore_W3",
        ['be-mu'] = "TapNoteScore_W3",
        kb7 = "TapNoteScore_W3",
        para = "TapNoteScore_W4"
    }
  return Continue[GAMESTATE:GetCurrentGame():GetName()] or "TapNoteScore_W3"
end

function ComboMaintain()
    local Maintain = {
        dance = "TapNoteScore_W3",
        pump = string.find(TimingMode, "Pump") and "TapNoteScore_W3" or "TapNoteScore_W4",
        ['be-mu'] = "TapNoteScore_W3",
        kb7 = "TapNoteScore_W3",
        para = "TapNoteScore_W4"
    }
  return Maintain[GAMESTATE:GetCurrentGame():GetName()] or "TapNoteScore_W3"
end

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))

-- To avoid accessing the save file and introducing potential lag/stutter at every screen transition, save the setting as a global
IsVideoBackground = LoadModule("Config.Load.lua")("UseVideoBackground", "Save/OutFoxPrefs.ini")

function ChartTypeToColor(Chart)
    local ChartMeter = Chart:GetMeter()
    local ChartDescription = Chart:GetDescription()
    local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))

    local ChartColors = {
        Single = {
            SP = Color.HoloDarkPurple,
            default = color("#ff871f"),
        },
        Halfdouble = Color.HoloDarkRed,
        Double = {
            DP = Color.HoloDarkBlue,
            COOP = Color.HoloDarkBlue,
            default = color("#21db30"),
        },
        Couple = Color.HoloDarkBlue,
        Routine = Color.Yellow,
        default = color("#9199D4"),
    }

    if getenv("IsBasicMode") then
        if ChartType == "Double" then
            return color("#21db30")
        elseif ChartMeter <= 2 then
            return color("#209be3")
        elseif ChartMeter <= 4 then
            return color("#fff700")
        elseif ChartMeter <= 7 then
            return color("#ff3636")
        else
            return color("#d317e8")
        end
    else
        if ChartColors[ChartType] then
            -- Check if chart type has a nested table (for Single/Double charts)
            if type(ChartColors[ChartType]) == "table" then
                -- Check if chart description matches any key in the nested table
                for key, value in pairs(ChartColors[ChartType]) do
                    if key == "default" then
                        -- Use default color if no other match is found
                        return value
                    elseif string.find(string.upper(ChartDescription), key) then
                        return value
                    end
                end
            else
                return ChartColors[ChartType]
            end
        else
            return ChartColors.default
        end
    end
end

function BasicChartLabel(Chart)
    local ChartMeter = Chart:GetMeter()
    local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))

    if ChartType == "Double" then
        return THEME:GetString("BasicMode", "Double")
    elseif ChartMeter <= 2 then
        return THEME:GetString("BasicMode", "Easy")
    elseif ChartMeter <= 4 then
        return THEME:GetString("BasicMode", "Normal")
    elseif ChartMeter <= 7 then
        return THEME:GetString("BasicMode", "Hard")
    else
        return THEME:GetString("BasicMode", "Very Hard")
    end
end

function ChartStyleToIndex(Chart)
    local ChartMeter = Chart:GetMeter()
    local ChartDescription = Chart:GetDescription()
    local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))

    if ChartType == "Single" then
        return 0
    elseif ChartType == "Halfdouble" then
        return 1
    elseif ChartType == "Double" then
        ChartDescription:gsub("[%p%c%s]", "")
        if string.find(string.upper(ChartDescription), "DP") or
        string.find(string.upper(ChartDescription), "COOP") then
            if ChartMeter == 99 then
                return 3
            else
                return 2
            end
        else
            return 2
        end
    elseif ChartType == "Couple" then
        return 3
    elseif ChartType == "Routine" then
        return 2
    else
        return 0
    end
end

function IsAnniversary()
    return MonthOfYear() == 4 and DayOfMonth() == 19
end

-- Thank you, Accelerator and DDR SN3 team!
-- These functions are a port of Delta NEX Rebirth and https://github.com/Inorizushi/DDR-X3/blob/master/Scripts/Starter.lua, please credit them if you want to put it in your theme

local function GetOrCreateChild(tab, field, kind)
    kind = kind or 'table'
    local out = tab[field]
    if not out then
        out = ({
            table = {},
            number = 0,
            boolean = false,
            boolean_df = false,
            boolean_dt = true,
        })[kind]
        if not out then
            error("GetOrCreateChild: I don't know a default value for type " .. tostring(kind), 2)
        end
        tab[field] = out
    end
    return out
end

local function SortCharts(a, b)
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() - b:GetMeter() < 0 -- GetMeter() > b:GetMeter(), bitwise
    else
        return a:GetStepsType() > b:GetStepsType()
    end
end

local function ChartRange(chart, a, b)
    return chart:GetMeter() >= a and chart:GetMeter() <= b
end

local outputPath = THEME:GetCurrentThemeDirectory() .. "Other/SongManager PreferredSongs.txt"
local isolatePattern = "/([^/]+)/?$" -- In English, "everything after the last forward slash unless there is a terminator". Get's the last directory in a path.
local combineFormat = "%s/%s"

function AssembleBasicMode()
    if not (SONGMAN and GAMESTATE) then
        Warn("SONGMAN or GAMESTATE were not ready! Aborting!")
        return
    end
    local set = {}

    -- Populate the groups
    for i, song in pairs(SONGMAN:GetAllSongs()) do
        local steps = song:GetStepsByStepsType('StepsType_Pump_Single')
        table.sort(steps, SortCharts)
        local doublesSteps = song:GetStepsByStepsType('StepsType_Pump_Double')
        table.sort(doublesSteps, SortCharts)
        if #steps >= 3 and #doublesSteps >= 1 then --Somehow doublesSteps can be non nil despite having no doubles steps.
            if (ChartRange(steps[1], 1, 2) and ChartRange(steps[2], 3, 4) and ChartRange(steps[3], 5, 7) or
                (ChartRange(steps[1], 3, 4) and ChartRange(steps[2], 5, 7) and ChartRange(steps[3], 8, 9)))
                and ChartRange(doublesSteps[1], 1, 9) then
                local shortSongDir = string.match(song:GetSongDir(),isolatePattern)
                local groupName = song:GetGroupName()
                local groupTbl = GetOrCreateChild(set, groupName)
                table.insert(groupTbl,
                    string.format(combineFormat, groupName, shortSongDir))
            end
        end
    end

    -- Sort all the groups and collect their names, then sort that too
    local groupNames = {}
    for groupName, group in pairs(set) do
        if next(group) == nil then
            set[groupName] = nil
        else
            table.sort(group)
            table.insert(groupNames, groupName)
        end
    end
    table.sort(groupNames)
    Trace("Group names sorted")

    -- Then, let's make a representation of our eventual file in memory.
    local outputLines = {}
    for _, groupName in ipairs(groupNames) do
        --table.insert(outputLines, "---"..groupName)
        for _, path in ipairs(set[groupName]) do
            table.insert(outputLines, 1, path)
        end
    end
    Trace("Output lines populated")

    -- Now, slam it all out to disk.
    local fHandle = RageFileUtil.CreateRageFile()
    -- The mode is Write+FlushToDiskOnClose
    Trace("Opening list file at: " .. outputPath)
    fHandle:Open(outputPath, 10)
    Trace("Writing to file...")
    fHandle:Write(table.concat(outputLines,'\n'))
    Trace("Closing file...")
    fHandle:Close()
    fHandle:destroy()
    Trace("Done!")
end
