return {
	GameMode =
	{
		Default = false,
		Choices = { OptionNameString('Arcade'), OptionNameString('Pro'), OptionNameString('Stamina') },
		Values = { false, 1, 2 }
	},
	SmartTimings =
	{
		SaveSelections = {"SmartJudgments",LoadModule("Options.SmartJudgeChoices.lua")},
		GenForUserPref = true,
		Default = TimingModes[1],
		Choices = TimingModes,
		Values = TimingModes
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
}
