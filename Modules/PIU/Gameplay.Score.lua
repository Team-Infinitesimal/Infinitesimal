--[[
		K-Pump scoring system by SheepyChris, created on October 17, 2019
		For this module to work properly, you will need to zero out all metrics in [ScoreKeeperNormal].
]]

return function(Player)
	local function NumberOfElements(t)
		local count = 0
		if t then
			for index in pairs(t) do
				count = count + 1
			end
		end
		return count
	end

	local TapNoteScorePoints = {
		TapNoteScore_CheckpointHit = 1000,
		TapNoteScore_W1 = 1000,
        TapNoteScore_W2 = 1000,
		TapNoteScore_W3 = 500,
		TapNoteScore_W4 = 100,
		TapNoteScore_W5 = -200,
		TapNoteScore_Miss = -500,
		TapNoteScore_CheckpointMiss = -300,
		TapNoteScore_None =	0,
		TapNoteScore_HitMine = 0,
		TapNoteScore_AvoidMine = 0
	}

	local PlayerScore = 300000
	local GradeBonus = 300000
	local LevelConstant = 1
	local CurrentCombo = 0
	local MaxCombo = 0

	local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings", "Save/OutFoxPrefs.ini")

	return Def.Actor {
		InitCommand=function(self)
			local StepData = GAMESTATE:GetCurrentSteps(Player)
			local StepLevel = StepData:GetMeter()
			local StepType = StepData:GetStepsType()
			
			-- Get the chart level + game type multipler used to increase scores on such
			if (StepType == "StepsType_Pump_Double" or 
				StepType == "StepsType_Pump_Halfdouble" or 
				StepType == "StepsType_Pump_Routine") then
				if StepLevel > 10 then
					LevelConstant = (StepLevel / 10) * 1.2
				else
					LevelConstant = 1.2
				end
			else
				if StepLevel > 10 then
					LevelConstant = StepLevel / 10
				end
			end
			
			if CurPrefTiming == "Pump Very Hard" then
				LevelConstant = LevelConstant * 1.2
			end
            
            -- Reset your score, dummy
            local CSS = STATSMAN:GetCurStageStats()
            local PSS = CSS:GetPlayerStageStats(Player)
            PSS:SetScore(0)
		end,
		
		JudgmentMessageCommand=function(self, params)
			local Notes = {}
			local Holds = {}
			local StepsCount = 0
			local TapNote = params.TapNote
			local TapNoteScore = params.TapNoteScore
			local CSS = STATSMAN:GetCurStageStats()
			
			if Player ~= params.Player or not TapNoteScore or params.HoldNoteScore then
				local PSS = CSS:GetPlayerStageStats(Player)
				PSS:SetScore(PlayerScore)
				return
			end
			
			local State = GAMESTATE:GetPlayerState(Player)
			local PSS = CSS:GetPlayerStageStats(Player)
			
			local Perfects 	= 	PSS:GetTapNoteScores("TapNoteScore_W1")
			local Greats 	= 	PSS:GetTapNoteScores("TapNoteScore_W2")
			local Goods 	= 	PSS:GetTapNoteScores("TapNoteScore_W3")
			local Bads 		= 	PSS:GetTapNoteScores("TapNoteScore_W4")
			local Misses 	= 	PSS:GetTapNoteScores("TapNoteScore_Miss") +
								PSS:GetTapNoteScores("TapNoteScore_CheckpointMiss")
			
			-- Make sure the player isn't AutoPlay
			if State:GetPlayerController() ~= "PlayerController_Autoplay" then
				-- Now we can safely calculate the number of notes from the judgement
				Holds = params.Holds
				Notes = params.Notes
				StepsCount = NumberOfElements(Holds) + NumberOfElements(Notes)
				
				-- Count the combo from Lua due to some issues, don't ask me
				if TapNote and TapNote:GetTapNoteType() ~= "TapNoteType_HoldTail" then
					CurrentCombo = CurrentCombo
				else
					if (TapNoteScore <= "TapNoteScore_W4" and TapNoteScore >= "TapNoteScore_W1") or TapNoteScore == "TapNoteScore_CheckpointHit" then
						CurrentCombo = CurrentCombo + 1
						MaxCombo = CurrentCombo
					else
						CurrentCombo = 0
					end
				end
				
				-- Remove current grade bonus and reevaluate it
				PlayerScore = PlayerScore - GradeBonus

				if Misses > 0 then
					GradeBonus = 0
				elseif Bads > 0 or Goods > 0 then
					GradeBonus = 100000
				elseif Greats > 0 then
					GradeBonus = 150000
				end
				
				local ComboScore = 0
				local NoteScore = TapNoteScorePoints[TapNoteScore]
				
				if TapNoteScore <= "TapNoteScore_W4" then
					-- Add bonus above 50 combo
					if CurrentCombo > 50 then ComboScore = 1000 end
					NoteScore = NoteScore + ComboScore

					-- Triple/quad+ note multiplier
					if StepsCount >= 4 then
						NoteScore = NoteScore * 2
					elseif StepsCount == 3 then
						NoteScore = NoteScore * 1.5
					end
				end

				-- Remove extra combo/score count from the end of holds, don't ask me (again)
				if TapNote and TapNote:GetTapNoteType() ~= "TapNoteType_HoldTail" then
					PlayerScore = PlayerScore + GradeBonus
				else
					PlayerScore = PlayerScore + (NoteScore * LevelConstant) + GradeBonus
				end
				
				-- We don't want negative scores
				if PlayerScore < 0 then PlayerScore = 0 end
				
				PlayerScore = PlayerScore - (PlayerScore % 100)
                
				PSS:SetScore(PlayerScore)
                
                MESSAGEMAN:Broadcast("UpdateScore", {Score = PlayerScore})
                
				-- Used for debugging
				-- SCREENMAN:SystemMessage(PlayerScore .. " - " .. NoteScore - ComboScore .. " - " .. ComboScore .. " - " .. CurrentCombo .. " - " .. LevelConstant .. " - " .. GradeBonus)
			end
		end
	}
end
