-- Smart Scoring
-- A module that allows custom scoring methods for timing modes.

-- This is separated into three categories, Score, Percent and Grade.
-- Each represents a method of scoring performed by the engine.
-- Score is the regular - (usually) 9 digit - score.
-- Percent is your percentage that you see on the score.
-- and Grade is what actually gets rewarded by the engine to the player.

local PercentTable = {
    ["HoldNoteScore_Held"] = IsGame("pump") and 0 or 3,
    ["HoldNoteScore_MissedHold"] = 0,
    ["HoldNoteScore_LetGo"] = 0,
    ["TapNoteScore_HitMine"] = -2,
	["TapNoteScore_AvoidMine"] = 0,
	["TapNoteScore_CheckpointMiss"] = 0,
	["TapNoteScore_Miss"] = 0,
	["TapNoteScore_ProW5"] = 4,
	["TapNoteScore_ProW4"] = 5,
	["TapNoteScore_ProW3"] = 6,
	["TapNoteScore_ProW2"] = 7,
	["TapNoteScore_ProW1"] = 8,
	["TapNoteScore_W5"] = 0,
	["TapNoteScore_W4"] = 0,
	["TapNoteScore_W3"] = 1,
	["TapNoteScore_W2"] = GAMESTATE:ShowW1() and 2 or 3,
	["TapNoteScore_W1"] = 3,
    ["TapNoteScore_MaxScore"] = 3,
	["TapNoteScore_CheckpointHit"] = 0
}

local GradeTable = {
    ["HoldNoteScore_Held"] = IsGame("pump") and 0 or 6,
    ["HoldNoteScore_MissedHold"] = 0,
    ["HoldNoteScore_LetGo"] = 0,
    ["TapNoteScore_HitMine"] = -8,
	["TapNoteScore_AvoidMine"] = 0,
	["TapNoteScore_CheckpointMiss"] = -8,
	["TapNoteScore_Miss"] = -8,
	["TapNoteScore_ProW5"] = 2,
	["TapNoteScore_ProW4"] = 2,
	["TapNoteScore_ProW3"] = 2,
	["TapNoteScore_ProW2"] = 2,
	["TapNoteScore_ProW1"] = 2,
	["TapNoteScore_W5"] = -4,
	["TapNoteScore_W4"] = 0,
	["TapNoteScore_W3"] = 1,
	["TapNoteScore_W2"] = 2,
	["TapNoteScore_W1"] = 2,
    ["TapNoteScore_MaxScore"] = 2,
	["TapNoteScore_CheckpointHit"] = 0
}

local LifeTable = {
    ["HoldNoteScore_Held"] = (IsGame("pump") or IsGame("smx")) and 0.000 or 0.008,
    ["HoldNoteScore_MissedHold"] = 0.000,
    ["HoldNoteScore_LetGo"] = (IsGame("pump") or IsGame("smx")) and 0.000 or -0.080,
    ["TapNoteScore_HitMine"] = -0.160,
	["TapNoteScore_AvoidMine"] = 0.000,
	["TapNoteScore_CheckpointMiss"] = IsGame("smx") and -0.020 or -0.080,
	["TapNoteScore_Miss"] = -0.080,
	["TapNoteScore_ProW5"] = 0.008,
	["TapNoteScore_ProW4"] = 0.008,
	["TapNoteScore_ProW3"] = 0.008,
	["TapNoteScore_ProW2"] = 0.008,
	["TapNoteScore_ProW1"] = 0.008,
	["TapNoteScore_W5"] = -0.040,
	["TapNoteScore_W4"] = 0.000,
	["TapNoteScore_W3"] = 0.004,
	["TapNoteScore_W2"] = 0.008,
	["TapNoteScore_W1"] = 0.008,
	["TapNoteScore_CheckpointHit"] = IsGame("smx") and 0.01 or 0.008
}

local ScoreLimit = 100000000

return Def.ActorFrame{
	InitCommand=function(self)
		-- Load any custom timing sets set by the current TimingWindow.
		-- This will be performed by overwriting existing values from the local tables above.
		self.mode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"

		for k,v in pairs( TimingWindow ) do
			local TW = TimingWindow[k]()
            if self.mode == TW.Name then

				-- if there is a table that will share values with multiple sets, overwrite them.
				if( TW.Shared ) then
					for a,b in pairs( TW.Shared ) do
						PercentTable[a] = b
						GradeTable[a] = b
					end
				end
                -- We found out table, time to replace settings.
				if( TW.Percent ) then
					for a,b in pairs( TW.Percent ) do PercentTable[a] = b end
				end
				if( TW.Grade ) then
					for a,b in pairs( TW.Grade ) do GradeTable[a] = b end
				end
				if( TW.Life ) then
					for a,b in pairs( TW.Life ) do LifeTable[a] = b end
				end
				if ( TW.ScoreLimit ) then
					ScoreLimit = TW.ScoreLimit
				end
                break
            end
        end
	end,
    PercentWindowMessageCommand=function(self, params)
        params.Weight = PercentTable[params.Type] or 0
    end,
    GradeWindowMessageCommand=function(self, params)
        params.Weight = GradeTable[params.Type] or 0
    end,
	LifeScoreMessageCommand=function(self, params)
        params.Life = LifeTable[params.Type] or 0
    end
}