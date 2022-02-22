function AutoVelocity()
	local t = {
		Name = "AutoVelocity",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		GoToFirstOnStart= false,
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = {OptionNameString('On'), "+100", "+10", "+1", "-1", "-10", "-100"},
		LoadSelections = function(self, list, pn)
			if LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") ~= false then
				list[1] = true
			end;
		end;
		SaveSelections = function(self, list, pn) end,
		NotifyOfSelection = function(self, pn, choice)
            local AV = LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
            
            if choice == 1 then
				if AV == false then 
                    AV = 300
                else
                    AV = false
                    GAMESTATE:ApplyGameCommand("mod,2x", pn)
                end
			elseif AV ~= false then
				if choice == 2 then
					AV = AV + 100
				elseif choice == 3 then
					AV = AV + 10
				elseif choice == 4 then
					AV = AV + 1
                elseif choice == 5 then
					AV = AV - 1
                elseif choice == 6 then
					AV = AV - 10
				elseif choice == 7 then
					AV = AV - 100
				end
                
                -- Clamp values
                if AV < 100 then AV = 100 end
                if AV > 999 then AV = 999 end
			end
            
            LoadModule("Config.Save.lua")("AutoVelocity", tostring(AV), CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
			return true
		end
	}
	setmetatable( t, t )
	return t
end