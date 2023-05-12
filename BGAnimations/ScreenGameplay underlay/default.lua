local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"
local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"

local t = Def.ActorFrame {}

if LoadModule("Config.Load.lua")("StarField","Save/OutFoxPrefs.ini") then
    t[#t+1] = Def.ActorFrame {
        LoadActor("StarField")
    }
end

t[#t+1] = Def.ActorFrame {
    LoadActor("ScreenFilter")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local peak, npst, NMeasure, mcount = LoadModule("Chart.GetNPS.lua")(GAMESTATE:GetCurrentSteps(pn))
    GAMESTATE:Env()["ChartData" .. pn] = {peak, npst, NMeasure, mcount}
    
    t[#t+1] = Def.ActorFrame {
        LoadModule("PIU/Gameplay." .. Scoring .. "Score.lua")(pn),
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
