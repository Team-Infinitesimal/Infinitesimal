function AutoVelocity()
    local t = {
        Name = "AutoVelocity",
        LayoutType = "ShowAllInRow",
        SelectType = "SelectMultiple",
        GoToFirstOnStart = false,
        OneChoiceForAllPlayers = false,
        ExportOnChange = false,
        Choices = {"+100", "+10", "+1", "-1", "-10", "-100"},
        -- We'll do our own load/save functions below
        LoadSelections = function(self, list, pn) end,
        SaveSelections = function(self, list, pn) end,
        NotifyOfSelection = function(self, pn, choice)
            local AV = LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
            
            if not AV then
                AV = 200
            elseif choice == 1 then
                AV = AV + 100
            elseif choice == 2 then
                AV = AV + 10
            elseif choice == 3 then
                AV = AV + 1
            elseif choice == 4 then
                AV = AV - 1
            elseif choice == 5 then
                AV = AV - 10
            elseif choice == 6 then
                AV = AV - 100
            end
            
            -- Clamp values
            if AV < 100 then AV = 100 end
            if AV > 999 then AV = 999 end
            
            LoadModule("Config.Save.lua")("AutoVelocity", tostring(AV), CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
            return true
        end
    }
    setmetatable( t, t )
    return t
end