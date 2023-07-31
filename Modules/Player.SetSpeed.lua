return function(pn)
    local AV = tonumber(LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini"))
    local AVType = LoadModule("Config.Load.lua")("AutoVelocityType", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") or false
    if not AVType then
        GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):XMod(AV / 100)
    elseif AVType == "Auto" then
        GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):AVMod(AV)
    else
        GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):CMod(AV)
    end
end
