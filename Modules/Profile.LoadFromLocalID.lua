return function(k,table,default)
    local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
	local CurPref = LoadModule("Config.Load.lua")(k,Location)
	if not CurPref then
		return default
	else
		for i,v2 in ipairs(table) do
			if tostring(v2) == tostring(CurPref) then return i end
		end
	end
	return nil
end