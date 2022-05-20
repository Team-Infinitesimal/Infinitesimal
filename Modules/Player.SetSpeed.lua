return function(pn)
    local AV = tonumber(LoadModule("Config.Load.lua")("AutoVelocity", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini"))
    local AVType = LoadModule("Config.Load.lua")("AutoVelocityType", CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") or false
    if not AVType then
        GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):XMod(AV / 100)
    elseif AVType == "Auto" then
        local BPM = GAMESTATE:GetCurrentSong():GetDisplayBpms()[2]
        if GAMESTATE:GetCurrentSong():IsDisplayBpmRandom() or BPM == 0 then
            GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):MMod(AV)
        else
            AV = AV / math.ceil(BPM)
            GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):XMod(AV)
        end
    else
        GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):CMod(AV)
    end
end
