local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"

local t = Def.ActorFrame {
    LoadActor("ScreenFilter")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.ActorFrame {
        LoadModule("PIU/Gameplay.Score.lua")(pn),
        LoadActor("NameBadge", pn)
    }
    
    if LoadModule("Config.Load.lua")("MeasureCounter",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") then
		t[#t+1] = Def.ActorFrame { LoadActor("MeasureCount", pn) }
	end
    
    if string.find(TimingMode, "Pump") then
        t[#t+1] = Def.ActorFrame { LoadModule("PIU/Gameplay.Life.lua")(pn) }
    end
end

return t
