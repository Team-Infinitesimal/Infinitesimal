local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"

local t = Def.ActorFrame {
    LoadActor("ScreenFilter")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.ActorFrame { LoadModule("PIU/Gameplay.Score.lua")(pn) }
end

if string.find(TimingMode, "Pump") then
    for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
        t[#t+1] = Def.ActorFrame { LoadModule("PIU/Gameplay.Life.lua")(pn) }
    end
end

return t
