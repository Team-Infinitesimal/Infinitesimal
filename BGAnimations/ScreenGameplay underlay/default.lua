-- Originally from Soundwaves/OutFox

local t = Def.ActorFrame {};

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do
	local peak,npst,NMeasure,mcount = LoadModule("Chart.GetNPS.lua")( GAMESTATE:GetCurrentSteps(pn) )
	GAMESTATE:Env()["ChartData"..pn] = {peak,npst,NMeasure,mcount}

	if LoadModule("Config.Load.lua")("MeasureCounter",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") then
		t[#t+1] = LoadActor("MeasureCount", pn)
	end
end

return t;
