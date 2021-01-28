function OptionRowModeSelect()
    local t = {
        Name = "ModeSelCustom";
        LayoutType = "ShowAllInRow";
        SelectType = "SelectOne";
        OneChoiceForAllPlayers = true;
        Choices = {"Arcade", "Pro", "Stamina"};
        LoadSelections = function(self, list, pn)
            local mode = PREFSMAN:GetPreference("AllowW1")
            if mode == "AllowW1_Everywhere" then -- Pro Mode
                list[2] = true;
            else -- Arcade Mode
                list[1] = true;
            end;
        end;
        SaveSelections = function(self, list, pn)
            if list[3] or list[2] then
                PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
            elseif list[1] then
                PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
            end;
        end;
    };
    setmetatable(t, t)
	return t
end;

--Requires string:split from Utils
function OptionRowAvailableNoteskins()
  	local ns = NOTESKIN:GetNoteSkinNames();
  	local disallowedNS = THEME:GetMetric("Common","NoteSkinsToHide"):split(",");
  	for i = 1, #disallowedNS do
		for k,v in pairs(ns) do
			if v == disallowedNS[i] then
					table.remove(ns, k)
			end
		end;
  	end;

  	local t = {
		Name="NoteskinsCustom",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		Choices = ns,
		NumNoteskins = #ns,
		LoadSelections = function(self, list, pn)
			--This returns an instance of playerOptions, you need to set it back to the original
			local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local curNS = playerOptions:NoteSkin();
			local found = false;
			for i=1,#list do
				if ns[i] == curNS then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				assert(found,"There was no noteskin selected, but the player's noteskin should be "..curNS);
				list[1] = true;
			end;
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			--list[1] = true;
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(ns[i]);
						found = true
						--SCREENMAN:SystemMessage("NS set to "..ns[i]);
					end
				end
			end
      	end,
  	};
  	setmetatable(t, t)
  	return t
end
