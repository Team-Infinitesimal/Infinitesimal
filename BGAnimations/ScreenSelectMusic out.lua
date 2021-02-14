local t = Def.ActorFrame {

	StartTransitioningCommand=function(self)
		for ip, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
			local ProMode = LoadModule("Config.Load.lua")("ProMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini");
			if ProMode ~= nil then
				PREFSMAN:SetPreference("AllowW1", ProMode);
			end;
			
			local BGAMode = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini");
			if BGAMode ~= nil then
				GAMESTATE:ApplyGameCommand("mod,"..BGAMode, pn);
			end;
		end;
	end;
};

t[#t+1] = LoadActor("fadeout_black");

return t;
