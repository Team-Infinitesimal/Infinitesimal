local t = Def.ActorFrame {
	StartTransitioningCommand=function(self)
		if GAMESTATE:IsHumanPlayer(PLAYER_1) then
			local GameMode = LoadModule("Config.Load.lua")("GameMode",CheckIfUserOrMachineProfile(0).."/OutFoxPrefs.ini")
			if GameMode ~= nil then
				if GameMode == false then
					PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
				else
					PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
				end;
			end
		end

		if GAMESTATE:IsHumanPlayer(PLAYER_2) then
			local GameMode = LoadModule("Config.Load.lua")("GameMode",CheckIfUserOrMachineProfile(1).."/OutFoxPrefs.ini")
			if GameMode ~= nil then
				if GameMode == false then
					PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
				else
					PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
				end;
			end
		end
	end;
};

t[#t+1] = LoadActor("fadeout_black");

return t;
