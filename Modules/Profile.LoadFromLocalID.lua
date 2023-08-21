return function(k,table)
    local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
	local CurPref = LoadModule("Config.Load.lua")(k,Location)
	for i,v2 in ipairs(table) do
		if tostring(v2) == tostring(CurPref) then return i end
	end
end
