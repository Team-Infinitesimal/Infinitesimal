function AutoVelocity()
    local t = {
        Name = "AutoVelocity",
        LayoutType = "ShowAllInRow",
        SelectType = "SelectMultiple",
        GoToFirstOnStart = false,
        OneChoiceForAllPlayers = false,
        ExportOnChange = false,
        Choices = {"+100", "+10", "+1", "-1", "-10", "-100"},
        LoadSelections = function(self, list, pn) end,
        SaveSelections = function(self, list, pn) end,
        NotifyOfSelection = function(self, pn, choice)
            local profileIndex = tonumber(pn:sub(-1)) - 1
            local AV = LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(profileIndex).."/OutFoxPrefs.ini") or 200
            -- Sets AV to 200 if there's no AV set

            -- Modify AV based on choice
            AV = AV + ({[1]=100, [2]=10, [3]=1, [4]=-1, [5]=-10, [6]=-100})[choice]
            
            -- Clamp values
            AV = math.min(999, math.max(100, AV))

            LoadModule("Config.Save.lua")("AutoVelocity", tostring(AV), CheckIfUserOrMachineProfile(profileIndex).."/OutFoxPrefs.ini")
            return true
        end
    }
    setmetatable( t, t )
    return t
end
