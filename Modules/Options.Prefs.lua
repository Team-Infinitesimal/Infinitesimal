return {
	AlwaysShowPlayMode =
	{
		Default = false,
		OneChoiceForAllPlayers = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	LuaNoteSkins =
	{
		Default = "default",
		UserPref = true,
		OneInRow = true,
		Choices = NOTESKIN:GetNoteSkinNames(),
		Values = NOTESKIN:GetNoteSkinNames(),
		LoadFunction = function(self,list,pn)
			local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
			for i,v2 in ipairs(self.Choices) do
				if string.lower(tostring(v2)) == string.lower(tostring(CurNoteSkin)) then
					list[i] = true return
				end
			end
			list[1] = true
		end,
		SaveFunction = function(self,list,pn)
			for i,v2 in ipairs(self.Choices) do
				if list[i] then
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(v2)
				end
			end
		end,
	},
	BGAMode =
	{
		UserPref = true,
		Default = 0,
		Choices = { OptionNameString('On'), OptionNameString('20% Cover'), OptionNameString('40% Cover'), OptionNameString('60% Cover'), OptionNameString('80% Cover'), OptionNameString('Off') },
		Values = { 0, 0.2, 0.4, 0.6, 0.8, 1 },
		LoadFunction = function(self,list,pn)
			local PlayerProfile = PROFILEMAN:GetProfileDir(string.sub(pn,-1)-1)
			if PlayerProfile ~= "" then
				local BGAMode = LoadModule("Config.Load.lua")("BGAMode",PlayerProfile.."/Infinitesimal.ini")
				local PlayerMods = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
				for i,v2 in ipairs(self.Values) do
					if tostring(v2) == tostring(BGAMode) then
						list[i] = true
						PlayerMods:Cover( self.Values[i], 1 )
					end
				end
			end
		end,
		SaveFunction = function(self,list,pn)
			local PlayerMods = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			for i,v2 in ipairs(self.Choices) do
				if list[i] then
					PlayerMods:Cover( self.Values[i], 1 )
				end
			end
		end,
	},
	SmartTimings =
	{
		SaveSelections = {"SmartJudgments",LoadModule("Options.SmartJudgeChoices.lua")},
		UserPref = false, -- for now
		OneChoiceForAllPlayers = true,
		Default = TimingModes[1],
		Choices = TimingModes,
		Values = TimingModes
	},
	ProMode =
	{
		UserPref = true,
		OneChoiceForAllPlayers = true,
		Default = "AllowW1_Never",
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { "AllowW1_Never", "AllowW1_Everywhere" },
		LoadFunction = function(self,list,pn)
			local PlayerProfile = PROFILEMAN:GetProfileDir(string.sub(pn,-1)-1)
			if PlayerProfile ~= "" then
				local ProMode = LoadModule("Config.Load.lua")("ProMode",PlayerProfile.."/Infinitesimal.ini")
				for i,v2 in ipairs(self.Values) do
					if tostring(v2) == tostring(ProMode) then
						list[i] = true
						PREFSMAN:SetPreference("AllowW1", self.Values[i]);
					end
				end
			end
		end,
		SaveFunction = function(self,list,pn)
			for i,v2 in ipairs(self.Choices) do
				if list[i] then
					PREFSMAN:SetPreference("AllowW1", self.Values[i]);
				end
			end
		end,
	},
	DeviationDisplay =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
	MeasureCounter =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('Stream Only'), OptionNameString('All') },
        Values = {false, "Stream", "All"}
    },
}
