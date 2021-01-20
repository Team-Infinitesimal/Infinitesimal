function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--This defines the custom player options.
PlayerDefaults = {
  	DetailedPrecision = false,
  	JudgmentType = "Normal",
  	ScreenFilter = 0,
}

--Set tables so you can do ActiveModifiers["P1"] to get the table of custom player modifiers, ex ActiveModifiers["P1"]["JudgmentType"]
--No metatable because it was too hard to implement
--[[ActiveModifiers = {
	P1 = table.shallowcopy(PlayerDefaults),
	P2 = table.shallowcopy(PlayerDefaults),
	MACHINE = table.shallowcopy(PlayerDefaults),
}]]

--Test
--[[local AM = { P1 = setmetatable({}, {JT = "Normal"})}
local AM = {{"Test"}, {"Test2"}}
local AM = { P1 = {JT = "Normal"}}
ActiveModifiers = {
	P1 = setmetatable({}, PlayerDefaults),
	P2 = setmetatable({}, PlayerDefaults),
	MACHINE = setmetatable({}, PlayerDefaults)
}
]]

function OptionRowJudgement()
    local t = {
        Name = "JudgementCustom";
        LayoutType = "ShowAllInRow";
        SelectType = "SelectOne";
        OneChoiceForAllPlayers = true;
        Choices = {"Normal", "Hard", "Very Hard", "Infinity", "Groove", "Hero"};
        LoadSelections = function(self, list, pn)
			-- Thank you StepMania for not cutting off your extra decimals
            local window = tonumber(string.format("%.6f", PREFSMAN:GetPreference("TimingWindowSecondsW5")));
            --SCREENMAN:SystemMessage(window);
            if window == 0.187500 then -- NJ
                list[1] = true;
            elseif window == 0.170833 then -- HJ
                list[2] = true;
            elseif window == 0.129166 then -- VJ
                list[3] = true;
            elseif window == 0.200000 then -- INFINITY
                list[4] = true;
            elseif window == 0.180000 then -- ITG
                list[5] = true;
            elseif window == 0.062500 then -- GH
                list[6] = true;
            else
				list[1] = true; -- Fallback to NJ and set it
				PREFSMAN:SetPreference("TimingWindowSecondsMine",0.130000);
				PREFSMAN:SetPreference("TimingWindowSecondsRoll",0.450000);
				PREFSMAN:SetPreference("TimingWindowSecondsHold",0.062500);
				PREFSMAN:SetPreference("TimingWindowSecondsW1",0.031250);
				PREFSMAN:SetPreference("TimingWindowSecondsW2",0.062500);
				PREFSMAN:SetPreference("TimingWindowSecondsW3",0.104166);
				PREFSMAN:SetPreference("TimingWindowSecondsW4",0.145833);
				PREFSMAN:SetPreference("TimingWindowSecondsW5",0.187500);
            end;
        end;
        SaveSelections = function(self, list, pn)
            PREFSMAN:SetPreference("TimingWindowSecondsMine",0.130000);
            PREFSMAN:SetPreference("TimingWindowSecondsRoll",0.450000);
            if list[1] == true then                                         -- NJ
                PREFSMAN:SetPreference("TimingWindowSecondsHold",0.062500);
                PREFSMAN:SetPreference("TimingWindowSecondsW1",0.031250);
                PREFSMAN:SetPreference("TimingWindowSecondsW2",0.062500);
                PREFSMAN:SetPreference("TimingWindowSecondsW3",0.104166);
                PREFSMAN:SetPreference("TimingWindowSecondsW4",0.145833);
                PREFSMAN:SetPreference("TimingWindowSecondsW5",0.187500);
            elseif list[2] == true then                                     -- HJ
                PREFSMAN:SetPreference("TimingWindowSecondsHold",0.062500); -- HJ still has the same hold tolerance as NJ
                PREFSMAN:SetPreference("TimingWindowSecondsW1",0.022916);
                PREFSMAN:SetPreference("TimingWindowSecondsW2",0.045833);
                PREFSMAN:SetPreference("TimingWindowSecondsW3",0.087500);
                PREFSMAN:SetPreference("TimingWindowSecondsW4",0.129166);
                PREFSMAN:SetPreference("TimingWindowSecondsW5",0.170833);
            elseif list[3] == true then                                     -- VJ
                PREFSMAN:SetPreference("TimingWindowSecondsHold",0.029166);
                PREFSMAN:SetPreference("TimingWindowSecondsW1",0.014583);
                PREFSMAN:SetPreference("TimingWindowSecondsW2",0.029166);
                PREFSMAN:SetPreference("TimingWindowSecondsW3",0.062500);
                PREFSMAN:SetPreference("TimingWindowSecondsW4",0.095833);
                PREFSMAN:SetPreference("TimingWindowSecondsW5",0.129166);
            elseif list[4] == true then                                     -- INFINITY
                PREFSMAN:SetPreference("TimingWindowSecondsHold",0.05800);  -- Original was unmodified from ITG, their StepMania build probably handled it differently
                PREFSMAN:SetPreference("TimingWindowSecondsW1",0.028000);
                PREFSMAN:SetPreference("TimingWindowSecondsW2",0.058000);
                PREFSMAN:SetPreference("TimingWindowSecondsW3",0.115000);
                PREFSMAN:SetPreference("TimingWindowSecondsW4",0.160000);
                PREFSMAN:SetPreference("TimingWindowSecondsW5",0.200000);
            elseif list[5] == true then                                     -- GROOVE
                PREFSMAN:SetPreference("TimingWindowSecondsHold",0.32000);
                PREFSMAN:SetPreference("TimingWindowSecondsW1",0.021500);
                PREFSMAN:SetPreference("TimingWindowSecondsW2",0.043000);
                PREFSMAN:SetPreference("TimingWindowSecondsW3",0.102000);
                PREFSMAN:SetPreference("TimingWindowSecondsW4",0.135000);
                PREFSMAN:SetPreference("TimingWindowSecondsW5",0.180000);
            elseif list[6] == true then                                     -- HERO
                PREFSMAN:SetPreference("TimingWindowSecondsHold",0.062500); -- Just an approximation. I don't really care if it's accurate
                PREFSMAN:SetPreference("TimingWindowSecondsW1",0.062501);
                PREFSMAN:SetPreference("TimingWindowSecondsW2",0.062501);
                PREFSMAN:SetPreference("TimingWindowSecondsW3",0.062500);
                PREFSMAN:SetPreference("TimingWindowSecondsW4",0.062500);
                PREFSMAN:SetPreference("TimingWindowSecondsW5",0.062500);
            end;
        end;
    };
    setmetatable(t, t)
	  return t
end;

function OptionRowModeSelect()
    local t = {
        Name = "ModeSelCustom";
        LayoutType = "ShowAllInRow";
        SelectType = "SelectOne";
        OneChoiceForAllPlayers = true;
        Choices = {"Arcade", "Pro"};
        LoadSelections = function(self, list, pn)
            local mode = PREFSMAN:GetPreference("AllowW1")
            if mode == "AllowW1_Everywhere" then -- Pro Mode
                list[2] = true;
            else -- Arcade Mode
                list[1] = true;
            end;
        end;
        SaveSelections = function(self, list, pn)
            if list[2] == true then
                PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
            elseif list[1] == true then
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
