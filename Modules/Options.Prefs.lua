return {
	SmartTimings =
	{
		SaveSelections = {"SmartJudgments",LoadModule("Options.SmartJudgeChoices.lua")},
		GenForUserPref = true,
		Default = TimingModes[1],
		Choices = TimingModes,
		Values = TimingModes
	},
}