return function(Mode)
	local JG = LoadModule("Options.SmartJudgments.lua")("Show")
	local Name = getenv("SmartTimings") and TimingWindow[getenv("SmartTimings")]() or LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"
	if Name == nil then Name = "" end
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
end
