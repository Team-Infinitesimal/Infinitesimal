function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
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
local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"

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

-- Thank you, Accelerator and DDR SN3 team!
-- These functions are a port of Delta NEX Rebirth and https://github.com/Inorizushi/DDR-X3/blob/master/Scripts/Starter.lua, please credit them if you want to put it in your theme

function GetOrCreateChild(tab, field, kind)
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

local outputPath = "/Themes/"..THEME:GetCurThemeName().."/Other/SongManager BasicMode.txt";
local isolatePattern = "/([^/]+)/?$" -- In English, "everything after the last forward slash unless there is a terminator"
local combineFormat = "%s/%s"

function AssembleBasicMode()
	if not (SONGMAN and GAMESTATE) then return end
	local set = {}

	-- Populate the groups
	for _, song in pairs(SONGMAN:GetAllSongs()) do
		local steps = song:GetStepsByStepsType('StepsType_Pump_Single');
		local doublesSteps = song:GetStepsByStepsType('StepsType_Pump_Double');
		if #steps >= 3 and #doublesSteps >= 1 then --Somehow doublesSteps can be non nil despite having no doubles steps.
			if steps[1]:GetMeter() < 9 and steps[2]:GetMeter() < 9 and steps[3]:GetMeter() < 9 and doublesSteps[1]:GetMeter() < 9 then
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

	-- Then, let's make a representation of our eventual file in memory.
	local outputLines = {}
	for _, groupName in ipairs(groupNames) do
		--table.insert(outputLines, "---"..groupName)
		for _, path in ipairs(set[groupName]) do
			table.insert(outputLines, 1, path)
		end
	end

	-- Now, slam it all out to disk.
	local fHandle = RageFileUtil.CreateRageFile()
	-- The mode is Write+FlushToDiskOnClose
	fHandle:Open(outputPath, 10)
	fHandle:Write(table.concat(outputLines,'\n'))
	fHandle:Close()
	fHandle:destroy()
end

-- And run!
AssembleBasicMode()
