local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"
local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"

local t = Def.ActorFrame {}

if LoadModule("Config.Load.lua")("StarField","Save/OutFoxPrefs.ini") then
    t[#t+1] = Def.ActorFrame {
        LoadActor("StarField.lua")
    }
end

t[#t+1] = Def.ActorFrame {
    LoadActor("ScreenFilter.lua")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local NPSData = LoadModule("Chart.Density.lua")(pn)
    
    t[#t+1] = Def.ActorFrame {
        LoadModule("PIU/Gameplay." .. Scoring .. "Score.lua")(pn),
        LoadActor("NameBadge.lua", pn)
    }
    
    if LoadModule("Config.Load.lua")("MeasureCounter",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") then
        t[#t+1] = Def.ActorFrame { LoadActor("MeasureCount.lua", {Player = pn, NoteData = NPSData}) }
    end
    
    if string.find(TimingMode, "Pump") then
        t[#t+1] = Def.ActorFrame { LoadModule("PIU/Gameplay.Life.lua")(pn) }
    end
end

return t
