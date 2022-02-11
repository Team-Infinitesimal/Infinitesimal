local Rates = {
	Val = {},
	Str = {},
}
for i = 0.3, 2.01, 0.01 do
	table.insert( Rates.Val, string.format( "%.2f",i ) )	
	table.insert( Rates.Str, string.format( "%.2fx",i ) )	
end
--table.insert( Rates.Str, "Haste" )
--table.insert( Rates.Val, "haste" )


return {
	ScreenFilter =
	{
		UserPref = true,
		Default = 0,
		Choices = { THEME:GetString('OptionNames','Off'), '0.1', '0.2', '0.3', '0.4', '0.5', '0.6', '0.7', '0.8', '0.9', '1.0' },
		Values = { 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 },
    },
	ScreenFilterColor =
	{
		UserPref = true,
		Default = 2, -- Since the filter is now full screen by default, it makes more sense making it black.
		Choices = { OptionNameString('DarkPlayerScreenFilter'), OptionNameString('DarkScreenFilter'), OptionNameString('LightPlayerScreenFilter'), OptionNameString('LightScreenFilter'), OptionNameString('GrayScreenFilter') },
		Values = {1,2,3,4,5}
    },
    ScreenFilterSize =
	{
		UserPref = true,
        Default = false,
        Choices = { OptionNameString('ScreenFilterFull'), OptionNameString('ScreenFilterLane') },
        Values = { "Full", "Lane" }
    },
    MeasureCounter =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('StreamOnly'), OptionNameString('All') },
        Values = {false, 'StreamOnly', 'All' }
    },
    MeasureCounterDivisions =
    {
        UserPref = true,
        Default = 12,
        Choices = { THEME:GetString('OptionNames', 'Div_4ths'), THEME:GetString('OptionNames', 'Div_8ths'), THEME:GetString('OptionNames', 'Div_12ths'), THEME:GetString('OptionNames', 'Div_16ths'), THEME:GetString('OptionNames', 'Div_24ths'), THEME:GetString('OptionNames', 'Div_32nds') },
        Values = {4, 8, 12, 16, 24, 32}
    },
    JudgmentItems =
	{
		UserPref = true,
		SelectMultiple = true,
		Default = false,
		Choices = { OptionNameString('OffsetBar'), OptionNameString('ProTiming'), OptionNameString('HideJudgment') },
		Values = { "OffsetBar", "ProTiming", "HideJudgment" },
	},
	SmartJudgments =
	{
		UserPref = true,
		OneInRow = true,
		Default = THEME:GetMetric("Common","DefaultJudgment"),
		Choices = LoadModule("Options.SmartJudgeChoices.lua")(),
		Values = LoadModule("Options.SmartJudgeChoices.lua")("Value"),
        ReloadRowMessages = { "ReloadJudgments" },
        Reload = function(self)
            SCREENMAN:SystemMessage("Reloading SmartJudgments!")
			self.Choices = LoadModule("Options.SmartJudgeChoices.lua")()
            self.ChoiceVals = LoadModule("Options.SmartJudgeChoices.lua")("Value")
			return "ReloadChanged_All"
		end
	},
	SmartTimings =
	{
		SaveSelections = {"SmartJudgments", LoadModule("Options.SmartJudgeChoices.lua")},
		GenForUserPref = true,
		Default = InfTimingModes[3], -- Pump Normal is now our standard
		Choices = InfTimingModes,
		Values = InfTimingModes,
        NotifyOfSelection = function(self, pn, choice)
            MESSAGEMAN:Broadcast("ReloadJudgments")
        end
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
	
    -- Infinitesimal mods
    ScoreDisplay =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('Score'), OptionNameString('Percent') },
        Values = {false, "Score", "Percent"}
    },
    SongProgress =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
    CenterChartList =
    {
        Default = true,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
    ChartPreview =
    {
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
	ImagePreviewOnly = 
    {
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
}
