function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))

function ChartTypeToColor(Chart)
	local ChartMeter = Chart:GetMeter()
	local ChartDescription = Chart:GetDescription()
	local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
	
	if ChartType == "Single" then
		if string.find(ChartDescription, "SP") then
			return Color.HoloDarkPurple
		else
			return Color.HoloDarkOrange
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
			return Color.HoloDarkGreen
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