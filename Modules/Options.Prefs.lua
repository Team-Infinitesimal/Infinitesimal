return {
	SpeedModType =
	{
		Default = "x",
		UserPref = true,
		Choices = { OptionNameString("SpeedX"), OptionNameString("SpeedA"), OptionNameString("SpeedM"), OptionNameString("SpeedC") },
		Values = {"x","a","m","c"},
		LoadFunction = function(self,list,pn)
			if GAMESTATE:IsHumanPlayer(pn) then
				local po = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
				if po:AvarageScrollBPM() > 0 then list[2] = true return
					elseif po:MaxScrollBPM() > 0 then list[3] = true return 
					elseif po:TimeSpacing() > 0 then list[4] = true return 
					else list[1] = true return 
				end
			end
		end,
		SaveFunction = function(self,list,pn)
		end,
	},
	SpeedModVal =
	{
		Default = 1,
		OneInRow = true,
		UserPref = true,
		Choices = {" "},
		Values = {" "},
		LoadFunction = function(self,list,pn)
			list[1] = true
		end,
		SaveFunction = function(self,list,pn)
		end,
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
		Default = "no cover",
		Choices = { OptionNameString('On'), OptionNameString('20% Cover'), OptionNameString('40% Cover'), OptionNameString('60% Cover'), OptionNameString('80% Cover'), OptionNameString('Off') },
		Values = { "no cover", "20% cover", "40% cover", "60% cover", "80% cover", "cover" }
	},
	SmartTimings =
	{
		SaveSelections = {"SmartJudgments",LoadModule("Options.SmartJudgeChoices.lua")},
		GenForUserPref = true,
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
		Values = { "AllowW1_Never", "AllowW1_Everywhere" }
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
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
}
