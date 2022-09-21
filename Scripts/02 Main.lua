LastSongIndex = 0

function OptionNameString(str)
    return THEME:GetString('OptionNames',str)
end

-- Unfortunately, some settings persist with the machine profile even after a credit,
-- so we will reset all custom mods we have to avoid any weird situations
function ResetLuaMods(pn)
    LastSongIndex = 0
    local ProfileDir = "Save/MachineProfile/OutFoxPrefsForPlayerp" .. string.sub(pn,-1) .. "/OutFoxPrefs.ini"
    LoadModule("Config.Save.lua")("AutoVelocity", tostring(200), ProfileDir)
    LoadModule("Config.Save.lua")("AutoVelocityType", tostring(false), ProfileDir)
    LoadModule("Config.Save.lua")("ScreenFilter", 0, ProfileDir)
    LoadModule("Config.Save.lua")("ScreenFilterColor", 2, ProfileDir)
    LoadModule("Config.Save.lua")("ScreenFilterSize", "Full", ProfileDir)
    LoadModule("Config.Save.lua")("MeasureCounter", tostring(false), ProfileDir)
    LoadModule("Config.Save.lua")("MeasureCounterDivisions", 12, ProfileDir)
    LoadModule("Config.Save.lua")("JudgmentItems", tostring(false), ProfileDir)
    LoadModule("Config.Save.lua")("ScoreDisplay", tostring(false), ProfileDir)
    LoadModule("Config.Save.lua")("SongProgress", tostring(false), ProfileDir)
    if IsArcade() then
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
        if ChartType == "Single" then
            if string.find(ChartDescription, "SP") then
                return Color.HoloDarkPurple
            else
                return color("#ff871f")
            end
        elseif ChartType == "Halfdouble" then
            return Color.HoloDarkRed
        elseif ChartType == "Double" then
            ChartDescription:gsub("[%p%c%s]", "")
            if string.find(string.upper(ChartDescription), "DP") or
            string.find(string.upper(ChartDescription), "COOP") then
                if ChartMeter == 99 then
                    return Color.Yellow
                else
                    return Color.HoloDarkBlue
                end
            else
                return color("#21db30")
            end
        elseif ChartType == "Couple" then
            return Color.HoloDarkBlue
        elseif ChartType == "Routine" then
            return Color.Yellow
        else
            return color("#9199D4")
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
    if MonthOfYear() == 4 and DayOfMonth() == 19 then return true end
    return false
end

-- Thank you, Accelerator and DDR SN3 team!
-- These functions are a port of Delta NEX Rebirth and https://github.com/Inorizushi/DDR-X3/blob/master/Scripts/Starter.lua, please credit them if you want to put it in your theme

local function GetOrCreateChild(tab, field, kind)
    kind = kind or 'table'
    local out
    if not tab[field] then
        if kind == 'table' then
            out = {}
        elseif kind == 'number' then
            out = 0
        elseif kind == 'boolean_df' or kind == 'boolean' then
            out = false
        elseif kind == 'boolean_dt' then
            out = true
        else
            error("GetOrCreateChild: I don't know a default value for type "..kind)
        end
        tab[field] = out
    else out = tab[field] end
    return out
end

local function SortCharts(a, b)
    if a:GetStepsType() == b:GetStepsType() then
        return a:GetMeter() < b:GetMeter()
    else
        return a:GetStepsType() > b:GetStepsType()
    end
end

local function ChartRange(chart, a, b)
    if chart:GetMeter() >= a and chart:GetMeter() <= b then
        return true
    end
    return false
end

local outputPath = THEME:GetCurrentThemeDirectory() .. "Other/SongManager PreferredSongs.txt"
local isolatePattern = "/([^/]+)/?$" -- In English, "everything after the last forward slash unless there is a terminator"
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
