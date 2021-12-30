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
	AutoSetStyle =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowStepsDisplay =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayShowScore =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayReadyPrompt =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ShowLotsaOptions =
	{
		Default = true,
		Choices = { OptionNameString('Many'), OptionNameString('Few') },
		Values = { true, false }
	},
	LongFail =
	{
		Default = false,
		Choices = { OptionNameString('Short'), OptionNameString('Long') },
		Values = { false, true }
	},
	NotePosition =
	{
		Default = true,
		Choices = { OptionNameString('Normal'), OptionNameString('Lower') },
		Values = { true, false }
	},
	ComboOnRolls =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FlashyCombo =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ComboUnderField =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayBPM =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	FancyUIBG =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ShowMascotCharacter =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	TimingDisplay =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	GameplayFooter =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	PreferredMeter =
	{
		Default = "old",
		Choices = { OptionNameString('MeterClassic'), OptionNameString('MeterX'), OptionNameString('MeterPump') },
		Values = { "old", "X", "pump" }
	},
	GameplayBPM =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	CustomComboContinue =
	{
		Default = "default",
		Choices = { OptionNameString('Default'), OptionNameString('TNS_W1'), OptionNameString('TNS_W2'), OptionNameString('TNS_W3'), OptionNameString('TNS_W4'), OptionNameString('TNS_PRO_W1'), OptionNameString('TNS_PRO_W2'), OptionNameString('TNS_PRO_W3'), OptionNameString('TNS_PRO_W4'), OptionNameString('TNS_PRO_W5')  },
		Values = { "default", "TapNoteScore_W1", "TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4", "TapNoteScore_ProW1", "TapNoteScore_ProW2", "TapNoteScore_ProW3", "TapNoteScore_ProW4", "TapNoteScore_ProW5" }
	},
	CustomComboMaintain =
	{
		Default = "default",
		Choices = { OptionNameString('Default'), OptionNameString('TNS_W1'), OptionNameString('TNS_W2'), OptionNameString('TNS_W3'), OptionNameString('TNS_W4'), OptionNameString('TNS_PRO_W1'), OptionNameString('TNS_PRO_W2'), OptionNameString('TNS_PRO_W3'), OptionNameString('TNS_PRO_W4'), OptionNameString('TNS_PRO_W5')  },
		Values = { "default", "TapNoteScore_W1", "TapNoteScore_W2", "TapNoteScore_W3", "TapNoteScore_W4", "TapNoteScore_ProW1", "TapNoteScore_ProW2", "TapNoteScore_ProW3", "TapNoteScore_ProW4", "TapNoteScore_ProW5" }
	},
	ForcedExtraMods =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	AllowAudioInEvaluation =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	ComboIsPerRow =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	CurrentStageLocation =
	{
		Default = "None",
		Choices = LoadModule("Characters.LoadStageNames.lua")(),
		Values = LoadModule("Characters.LoadStageNames.lua")()
	},
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
		Default = 1,
		Choices = { OptionNameString('DarkPlayerScreenFilter'), OptionNameString('DarkScreenFilter'), OptionNameString('LightPlayerScreenFilter'), OptionNameString('LightScreenFilter'), OptionNameString('GrayScreenFilter') },
		Values = {1,2,3,4,5}
    },
    MeasureCounter =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
    MeasureCounterDivisions =
    {
        UserPref = true,
        Default = 12,
        Choices = { THEME:GetString('OptionNames', 'Div_4ths'), THEME:GetString('OptionNames', 'Div_8ths'), THEME:GetString('OptionNames', 'Div_12ths'), THEME:GetString('OptionNames', 'Div_16ths'), THEME:GetString('OptionNames', 'Div_24ths'), THEME:GetString('OptionNames', 'Div_32nds') },
        Values = {4, 8, 12, 16, 24, 32}
    },
    MeasureCounterBreaks =
    {
        UserPref = true,
        Default = false,
        Choices = { OptionNameString('Off'), OptionNameString('On') },
        Values = {false, true}
    },
	JudgmentItems =
	{
		UserPref = true,
		SelectMultiple = true,
		Default = false,
		Choices = { OptionNameString('OffsetBar'), OptionNameString('MSTiming'), OptionNameString('Blind') },
		Values = { "OffsetBar", "ProTiming", "HideJudgment" },
	},
	JudgmentEval =
	{
		UserPref = true,
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	StatsPane =
	{
		UserPref = true,
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On'), OptionNameString('DetailedStats') },
		Values = { false, 1, 2 }
	},
	OverTopGraph =
	{
		UserPref = true,
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	SmartJudgments =
	{
		UserPref = true,
		OneInRow = true,
		Default = THEME:GetMetric("Common","DefaultJudgment"),
		Choices = LoadModule("Options.SmartJudgeChoices.lua")(),
		Values = LoadModule("Options.SmartJudgeChoices.lua")("Value")
	},
	SmartTimings =
	{
		GenForOther = {"SmartJudgments",LoadModule("Options.SmartJudgeChoices.lua")},
		GenForUserPref = true,
		Default = TimingModes[1],
		Choices = TimingModes,
		Values = TimingModes
	},
	DisableLowerWindows =
	{
		Default = 0,
		Choices = { OptionNameString('Off'), THEME:GetString("JudgmentDisplay","JudgmentW5"), THEME:GetString("JudgmentDisplay","JudgmentW4") .. " & ".. THEME:GetString("JudgmentDisplay","JudgmentW5") },
		Values = { 0, 1, 2 }
	},
	SmartToasties =
	{
		UserPref = true,
		Default = THEME:GetMetric("Common","DefaultToasty"),
		Choices = LoadModule("Options.SmartToastieChoices.lua")("Show"),
		Values = LoadModule("Options.SmartToastieChoices.lua")("Show")
	},
	BackPlates =
	{
		UserPref = true,
		Default = THEME:GetMetric("Common","DefaultBackPlate"),
		Choices = LoadModule("Options.BackPlates.lua")("Show"),
		Values = LoadModule("Options.BackPlates.lua")("Show")
	},
	ToastiesDraw =
	{
		UserPref = true,
		Default = true,
		Choices = { OptionNameString('Front'), OptionNameString('Back') },
		Values = { true, false }
	},
	MiniSelector =
	{
		UserPref = true,
		Default = 100,
		OneInRow = true,
		Choices = fornumrange(0,200,5),
		Values = fornumrange(0,200,5),
	},
	RotateFieldZ =
	{
		UserPref = true,
		Default = 0,
		OneInRow = true,
		Choices = fornumrange(0,360,10),
		Values = fornumrange(0,360,10),
	},
	RotateFieldX =
	{
		UserPref = true,
		Default = 0,
		OneInRow = true,
		Choices = fornumrange(0,360,10),
		Values = fornumrange(0,360,10),
	},
	NoteFieldLength =
	{
		Default = SCREEN_HEIGHT,
		Choices = {"Normal", "Long"},
		Values = {SCREEN_HEIGHT, 9000},
	},
	experimentNPSDiagram =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true }
	},
	NoteDrawOrder =
	{
		Default = "Reverse",
		Choices = { "Reverse", "Forward" },
		Values = { "Reverse", "Forward" }
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
	PlayerOptionNextScreen =
	{
		Default = "ScreenGameplay",
		Choices = {
			THEME:GetString("OptionNames","OptionSong"),
			THEME:GetString("OptionNames","OptionMain"),
			THEME:GetString("OptionNames","OptionSpecial"),
			THEME:GetString("OptionNames","OptionEffects"),
			THEME:GetString("OptionNames","OptionSelectMusic"),
		},
		Values = {
			"ScreenLoadGameplayElements",
			"ScreenPlayerOptions",
			"ScreenPlayerOptions",
			"ScreenPlayerOptions",
			"ScreenSelectMusic"
		},
		LoadFunction = function(self,list)
			list[1] = true
			GAMESTATE:Env()["PlayerOptionsNextScreen"] = Branch.SongOptions()
		end,
		SaveFunction = function(self,list)
			local entnames = { "Main","Special","Effects" }
			for i,v2 in ipairs(self.Values) do
				if list[i] and i ~= 1 then
					setenv("DifferentScreen",true)
					if i > 1 and i < #self.Values then
						setenv("NewOptions", entnames[i-1] )
					end
				end
			end
		end,
	},
	SpeedModType =
	{
		Default = "x",
		UserPref = true,
		Choices = { THEME:GetString("OptionNames","SpeedX"), THEME:GetString("OptionNames","SpeedA"), THEME:GetString("OptionNames","SpeedM"), THEME:GetString("OptionNames","SpeedC") },
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
	SpeedMargin =
	{
		Default = 0.25,
		Choices = fornumrange(0.1,1,0.05),
		Values = fornumrange(0.1,1,0.05),
	},
	SoundwavesSubTheme =
	{
		Default = 1,
		Choices = { OptionNameString('swClassic'), OptionNameString('swVaporwave'), OptionNameString('swGrass'), OptionNameString('swRetro'), OptionNameString('swFire'), "Dark", "Chaos", "Ice", "Wave", "Alien Alien", "BISTRO", "Invert Standard", "Rainbow FUN", "Baby Pink", "Sunny Day", "The Blood", "Virtual LED", "Night Emotions", "Cool Blues", "Dragonfire", "Y2K", "Golden Dawn"},
		Values = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22}
	},
	LifeType =
	{
		Default = "Bar",
		UserPref = true,
		Choices = GAMESTATE:IsCourseMode() and { THEME:GetString("OptionNames","Bar"), THEME:GetString("OptionNames","Battery"), THEME:GetString("OptionNames","LifeTime") } or { THEME:GetString("OptionNames","Bar"), THEME:GetString("OptionNames","Battery") },
		Values = GAMESTATE:IsCourseMode() and { "Bar", "Battery", "Time" } or { "Bar", "Battery" },
		LoadFunction = function(self,list,pn)
			local mod = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):LifeSetting()
			for i,v2 in ipairs(self.Values) do
				if tostring(v2) == ToEnumShortString(tostring(mod)) then
					list[i] = true return
				end
			end
			list[1] = true
		end,
		SaveFunction = function(self,list,pn)
			for i,v2 in ipairs(self.Values) do
				if list[i] then
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):LifeSetting( "LifeType_"..v2 )
				end
			end
		end,
	},
	BarDrain =
	{
		Default = "Bar",
		UserPref = true,
		Choices = { THEME:GetString("OptionNames","Normal"), THEME:GetString("OptionNames","NoRecover"), THEME:GetString("OptionNames","SuddenDeath") },
		Values = { "Normal", "NoRecover", "SuddenDeath" },
		LoadFunction = function(self,list,pn)
			local mod = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):DrainSetting()
			for i,v2 in ipairs(self.Values) do
				if tostring(v2) == ToEnumShortString(tostring(mod)) then
					list[i] = true return
				end
			end
			list[1] = true
		end,
		SaveFunction = function(self,list,pn)
			for i,v2 in ipairs(self.Values) do
				if list[i] then
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):DrainSetting( "DrainType_"..v2 )
				end
			end
		end,
	},
	Fail =
	{
		Default = "Bar",
		UserPref = true,
		Choices = { THEME:GetString("OptionNames","Immediate"), THEME:GetString("OptionNames","ImmediateContinue"), THEME:GetString("OptionNames","EndOfSong"), THEME:GetString("OptionNames","Off") },
		Values = { "Immediate", "ImmediateContinue", "EndOfSong", "Off" },
		LoadFunction = function(self,list,pn)
			local mod = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):FailSetting()
			for i,v2 in ipairs(self.Values) do
				if tostring(v2) == ToEnumShortString(tostring(mod)) then
					list[i] = true return
				end
			end
			list[1] = true
		end,
		SaveFunction = function(self,list,pn)
			for i,v2 in ipairs(self.Values) do
				if list[i] then
					GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):FailSetting( "FailType_"..v2 )
				end
			end
		end,
	},
	Haste = 
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self,list,pn)
			local mod = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):Haste()
			if mod == 1 then
				list[2] = true
				return
			end
			list[1] = true
		end,
		SaveFunction = function(self, list)
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):Haste( list[2] and 1 or 0 )
		end,
		NotifyOfSelection = function(self, pn, choice)
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):Haste( choice-1 )
		end,
	},
	Rate =
	{
		Default = 1,
		Choices = Rates.Str,
		Values = Rates.Val,
		LoadFunction = function(self,list)
			-- Detect the speed mod being provided from the list.
			-- Math can be weird, so we need to format the value.
			local msrate = string.format( "%.2f", GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate() )
			--[[
				Unlike other options, this one can be messy with its formatting
				So we'll setup an enviroment that will house the original rate mod.
				This is for the occasion that the user backs out of the screen and does not confirm the chosen rate.
			]]
			setenv( "originalRate", msrate )
			-- Now check all available speeds to the rate.
			for k,v2 in pairs(self.Values) do
				if tostring(v2) == msrate then
					list[k] = true
					return
				end
			end
			list[15] = true
		end,
		SaveFunction = function(self, list)
			if GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):Haste() ~= 0.0 then
				-- Reset the music rate and apply the haste.
				GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate(1.0)
			end
		end,
		NotifyOfSelection = function(self, pn, choice)
			-- Special case for regular players who want an unified slider that manages both options at once, which
			-- then can decide which to use via the SoundEffect option.
			local isInPlayerOptions = SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetName() == "ScreenPlayerOptions"
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate( self.Values[choice] )
			if( isInPlayerOptions ) then
				GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):PitchRate( self.Values[choice] )
			end
		end,
	},
	Pitch =
	{
		Default = 1,
		Choices = Rates.Str,
		Values = Rates.Val,
		LoadFunction = function(self,list)
			-- Detect the speed mod being provided from the list.
			-- Math can be weird, so we need to format the value.
			local msrate = string.format( "%.2f", GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):PitchRate() )
			--[[
				Unlike other options, this one can be messy with its formatting
				So we'll setup an enviroment that will house the original rate mod.
				This is for the occasion that the user backs out of the screen and does not confirm the chosen rate.
			]]
			setenv( "originalRate", msrate )
			-- Now check all available speeds to the rate.
			for k,v2 in pairs(self.Values) do
				if tostring(v2) == msrate then
					list[k] = true
					return
				end
			end
			list[15] = true
		end,
		SaveFunction = function(self, list)
			if GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):Haste() ~= 0.0 then
				-- Reset the music rate and apply the haste.
				GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):PitchRate(1.0)
			end
		end,
		NotifyOfSelection = function(self, pn, choice)
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):PitchRate( self.Values[choice] )
		end,
	},
	SoundEffect = 
	{
		Default = "SoundEffect_Both",
		Choices = { OptionNameString('Off'), OptionNameString('EffectSpeed'), OptionNameString('EffectPitch'), OptionNameString('EffectBoth') },
		Values = { "SoundEffectType_Off", "SoundEffectType_Speed", "SoundEffectType_Pitch", "SoundEffectType_Both" },
		LoadFunction = function(self, list)
			local mode = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):SoundEffectSetting()
			for k,v2 in pairs(self.Values) do
				if v2 == mode then
					list[k] = true
					return
				end
			end
			list[2] = true
		end,
		SaveFunction = function(self, list)
			for i,_ in ipairs(self.Values) do
				if list[i] then
					GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):SoundEffectSetting( _ )
				end
			end
		end,
		NotifyOfSelection = function(self, pn, choice)
			GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):SoundEffectSetting( self.Values[choice] )
		end,
	},
	judgmentscatter =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("judgmentscatter",self.Values,1) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("judgmentscatter",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	npsscatter =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("npsscatter",self.Values,2) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("npsscatter",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	lifescatter =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("lifescatter",self.Values,2) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("lifescatter",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	progressquad =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("progressquad",self.Values,2) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("progressquad",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	labelnps =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("labelnps",self.Values,2) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("labelnps",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	scattery =
	{
		Default = 200,
		OneInRow = true,
		Choices = fornumrange(100,600,50),
		Values = fornumrange(100,600,50),
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("scattery",self.Values,3) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("scattery",tostring(self.Values[i]),Location)
				end
			end
			list[36] = true
		end,
	},
	judgmenty =
	{
		Default = -80,
		OneInRow = true,
		Choices = fornumrange(-300,100,20),
		Values = fornumrange(-300,100,20),
		LoadFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			local CurPref = LoadModule("Config.Load.lua")("judgmenty",Location)
			for i,v2 in ipairs(self.Values) do
				if tostring(v2) == tostring(CurPref) then list[i] = true return end
			end
			list[12] = true
		end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("judgmenty",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	showmiscjud =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false, true },
		LoadFunction = function(self, list) list[ LoadModule("Profile.LoadFromLocalID.lua")("showmiscjud",self.Values,2) ] = true end,
		SaveFunction = function(self, list)
			local Location = "Save/LocalProfiles/".. GAMESTATE:GetEditLocalProfileID() .."/OutFoxPrefs.ini"
			for i,_ in ipairs(self.Values) do
				if list[i] == true then
					LoadModule("Config.Save.lua")("showmiscjud",tostring(self.Values[i]),Location)
				end
			end
		end,
	},
	SongSampleMode =
	{
		Default = "SampleMusicPreviewMode_Normal",
		Choices = {"Normal","Screen Music","Last Song","Continuous"},
		Values = { "SampleMusicPreviewMode_Normal","SampleMusicPreviewMode_ScreenMusic",
		"SampleMusicPreviewMode_LastSong","SampleMusicPreviewMode_Continuous" }
	},
	SongToggleLoop =
	{
		Default = true,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false,true }
	},
	CasualGameplay =
	{
		Default = false,
		Choices = { OptionNameString('Off'), OptionNameString('On') },
		Values = { false,true }
	},
	SoundwavesMenuBG =
	{
		Default = "Ocular",
		Choices = { OptionNameString('swBGCircle'), OptionNameString('swBGTriangle'), OptionNameString('swBGHexagon'), OptionNameString('swBGSquare'), OptionNameString('swBGSolid'), OptionNameString('swBGBlack') },
		Values = { "Ocular", "Triangles", "HexagonPattern", "CheckerBoard", "ColorBackground", "BlackBackground" }
	},

	-- System Related Options
	VideoRenderer =
	{
		Choices = {"GLAD", "OpenGL"},
		Values = {"glad", "opengl"},
		LoadFunction = function(self,list)
			local savedRender = PREFSMAN:GetPreference("VideoRenderers")
			for i,v2 in ipairs(self.Values) do
				if savedRender == v2 then list[i] = true return end
			end
			list[1] = true
		end,
		SaveFunction = function(self,list)
			for i,v2 in ipairs(self.Values) do
				if list[i] then PREFSMAN:SetPreference("VideoRenderers",v2) return end
			end
		end
	}
}
