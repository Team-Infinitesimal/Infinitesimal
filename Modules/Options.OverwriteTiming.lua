return function()
    if GAMESTATE:GetCurrentGame():GetName() == "para" then
        return "ParaParaParadise"
    end
    return LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini")
end