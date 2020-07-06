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

--This defines the custom player options. PlayerDefaults is initialized from resetGame() in utils
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
    		ExportOnChange = false,
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

function adjustPlayerAMod(pn, amount)
	--SCREENMAN:SystemMessage(playerState);
  	local playerState = GAMESTATE:GetPlayerState(pn);
  	--This returns an instance of playerOptions, you need to set it back to the original
  	local playerOptions = playerState:GetPlayerOptions("ModsLevel_Preferred")
  	--SCREENMAN:SystemMessage(PlayerState:GetPlayerOptionsString("ModsLevel_Current"));
  	assert(playerOptions:AMod(),"NO AMod SET!!!!")
  	if amount+playerOptions:AMod() < 100 then
  		  playerOptions:AMod(800);
  	elseif amount+playerOptions:AMod() > 1000 then
  		  playerOptions:AMod(100);
  	else
  		  playerOptions:AMod(playerOptions:AMod()+amount);
  	end;
  	GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
  	--SCREENMAN:SystemMessage(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"));
  	return playerOptions:AMod();
end

--AMod only
function AutoVelocity()
  	local t = {
    		Name = "UserPrefSpeedMods";
    		LayoutType = "ShowAllInRow";
    		SelectType = "SelectMultiple";
    		GoToFirstOnStart= false;
    		OneChoiceForAllPlayers = false;
    		ExportOnChange = false;
    		Choices = { "ON", "AV -100", "AV -10","AV +10", "AV +100"};
    		LoadSelections = function(self, list, pn)
      			if GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):AMod() then
        				list[1] = true
        				--SCREENMAN:SystemMessage("AMod!")
      			end;
    		end;
    		--We're not saving anything!
    		SaveSelections = function(self, list, pn)

    		end;
    		--Abuse the heck out of this one since we're checking what button they pressed and not what's selected or deselected
    		NotifyOfSelection = function(self,pn,choice)
      			--SCREENMAN:SystemMessage("choice "..choice)
  			local speed;
  			if choice == 1 then
    				--If AMod isn't on, turn it on
    				if not GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):AMod() then
      					local playerState = GAMESTATE:GetPlayerState(pn);
      					--This returns an instance of playerOptions, you need to set it back to the original
      					local playerOptions = playerState:GetPlayerOptions("ModsLevel_Preferred")
      					playerOptions:AMod(200)
      					GAMESTATE:GetPlayerState(pn):SetPlayerOptions('ModsLevel_Preferred', playerState:GetPlayerOptionsString("ModsLevel_Preferred"));
      					--SCREENMAN:SystemMessage("New AMod: "..GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():AMod())
    				else --If AMod is on, turn it off.
    					   GAMESTATE:ApplyGameCommand("mod,2x",pn);
    				end;
  			elseif GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):AMod() then
    				if choice == 2 then
    				    speed = adjustPlayerAMod(pn, -100);
    				elseif choice == 3 then
    				    speed = adjustPlayerAMod(pn, -10);
    				elseif choice == 4 then
    					   speed = adjustPlayerAMod(pn, 10);
    				elseif choice == 5 then
    					   speed = adjustPlayerAMod(pn, 100);
    				end;
      			end;
      			--MESSAGEMAN:Broadcast("AModChanged", {Player=pn,Speed=speed});
      			MESSAGEMAN:Broadcast("SpeedModChanged",{Player=pn});
      			--Always return true because we don't want anything to get highlighted.
      			return true;

      			--self.Choices = {"asdON", "AasdadV -100", "AV222 -10","A21313V +10", "AV +1asdad00"};
    		end;
  	};
  	setmetatable( t, t );
  	return t;
end

 --[[ function OptionRowBackgroundDim()
    local t = {
        Name="UserPrefBackgroundDim"
        LayoutType="ShowAllInRow"
        SelectType="SelectOne"
        OneChoiceForAllPlayers=false
        ExportOnChange=true
        Choices = {"OFF", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "ON"}
        LoadSelections=function(self, list, pn)
            if choice ==
        end;
    }
    setmetatable( t, t );
	  return t;
end; --]]
