return function(Mode)
	local JG = LoadModule("Options.SmartJudgments.lua")("Show")
	local TW = nil
	local Name = ""

	TW = LoadModule("Options.ReturnCurrentTiming.lua")().Name

	-- local TW = getenv("SmartTimings") and TimingWindow[getenv("SmartTimings")]() or LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"
	if TW ~= nil then Name = TW end

	local JudgmentGraphics = {}
	for _,v in ipairs(TimingWindow) do
		local m = v()
		JudgmentGraphics[ m.Name ] = {}
	end
	
	-- Deal with graphic data for each timing mode.
	for i,v in ipairs(JG) do
		-- We only need to obtain the ones from the current timing mode available,
		-- so check if it's the same as the key.
		local v2 = string.match(v,"(.-) %[")
		local typemode = string.match(v,"%[%a*]")
		if typemode then
			local datatype = (Mode == "Value" and v or (v2 ~= nil and v2 or v))
			-- It's exclusive, add it to the specific mode.
			-- lua.ReportScriptError( v .. " - ".. typemode:sub(2,-2) .. " - ".. Name )
			-- lua.ReportScriptError( ("Found %s in %s: %s"):format( Name, typemode:sub(2.-2), tostring(string.find( Name, typemode:sub(2,-2) )) ) )
			if string.find( Name, typemode:sub(2,-2) ) then
				table.insert( JudgmentGraphics[Name], datatype )
			end
		end
	end

	-- lua.ReportScriptError( v .. " - ".. Name )
	-- It's not exclusive to a particular game mode, add it to all modes.
	--[[
	for _,a in ipairs(TimingWindow) do
		local m = a()
		-- However, if it already exists on the timing window, then don't add it.
		local isalreadythere = false
	end
	]]
	-- If there's no available graphics to grab from, then we might have to load the fallback judgments.
	if #JudgmentGraphics[Name] == 0 then
		for i,v in ipairs(JG) do
			local typemode = string.match(v,"%[%a*]")
			if not typemode then
				table.insert( JudgmentGraphics[Name], v )
			end
		end
	end

	-- rec_print_table( JudgmentGraphics )

	return JudgmentGraphics[Name]

	--[[
	local Pro = {}
	local ECFA = {}
	local Normal = {}
	for i,v in ipairs(JG) do
		local v2 = string.match(v,"(.-) %[")
		if string.find(v, "%[Pro%]") then if Mode == "Value" then Pro[#Pro+1] = v else Pro[#Pro+1] = v2 end
		elseif string.find(v, "%[ECFA%]") then if Mode == "Value" then ECFA[#ECFA+1] = v else ECFA[#ECFA+1] = v2 end
		elseif Mode == "Value" then Normal[#Normal+1] = v else if v2 then Normal[#Normal+1] = v2 else Normal[#Normal+1] = v end
		end
	end
	if string.find(Name,"Advanced") then
		return Pro
	elseif string.find(Name,"ECFA") then
		return ECFA
	end
	return Normal
	]]
end