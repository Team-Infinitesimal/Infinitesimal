--[[
        New K-Pump scoring system by SheepyChris, created on May 12, 2023
        Huge thanks to Mr. Weq for figuring it out: https://twitter.com/mr_weq/status/1656860777826091008
        For this module to work properly, you will need to zero out all metrics in [ScoreKeeperNormal].
]]

return function(Player)
    local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings", "Save/OutFoxPrefs.ini")
    local PumpTiming = string.find(CurPrefTiming, "Pump")
    
    local TNSPerfect = "TapNoteScore_W" .. (PumpTiming and "1" or "2")
    local TNSGreat = "TapNoteScore_W" .. (PumpTiming and "2" or "3")
    local TNSGood = "TapNoteScore_W" .. (PumpTiming and "3" or "4")
    local TNSBad = "TapNoteScore_W" .. (PumpTiming and "4" or "5")

    local TNSPoints = {
        TapNoteScore_CheckpointHit = 1,
        TapNoteScore_W1 = PumpTiming and 1 or 1,
        TapNoteScore_W2 = PumpTiming and 0.6 or 1,
        TapNoteScore_W3 = PumpTiming and 0.2 or 0.6,
        TapNoteScore_W4 = PumpTiming and 0.1 or 0.2,
        TapNoteScore_W5 = PumpTiming and 0 or 0.1, -- Unused in Pump timing
        TapNoteScore_Miss = 0,
        TapNoteScore_CheckpointMiss = 0,
        TapNoteScore_None =	0,
        TapNoteScore_HitMine = 0,
        TapNoteScore_AvoidMine = 0
    }
    
    local PlayerScore = 0
    local CurrentCombo = 0
    local MaxCombo = 0

    return Def.Actor {
        InitCommand=function(self)
            -- Reset your score, dummy
            local CSS = STATSMAN:GetCurStageStats()
            local PSS = CSS:GetPlayerStageStats(Player)
            PSS:SetScore(0)
        end,
        
        JudgmentMessageCommand=function(self, params)
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
            
            local Perfects  =   PSS:GetTapNoteScores(TNSPerfect) +
                                PSS:GetTapNoteScores("TapNoteScore_CheckpointHit") +
                                (PumpTiming and 0 or PSS:GetTapNoteScores("TapNoteScore_W1"))
            local Greats 	= 	PSS:GetTapNoteScores(TNSGreat)
            local Goods 	= 	PSS:GetTapNoteScores(TNSGood)
            local Bads 		= 	PSS:GetTapNoteScores(TNSBad)
            local Misses 	= 	PSS:GetTapNoteScores("TapNoteScore_Miss") +
                                PSS:GetTapNoteScores("TapNoteScore_CheckpointMiss")
            local Total     =   Perfects + Greats + Goods + Bads + Misses
            
            -- Make sure the player isn't AutoPlay
            if State:GetPlayerController() ~= "PlayerController_Autoplay" then                
                -- Count the combo from Lua due to some issues, don't ask me
                if TapNote and TapNote:GetTapNoteType() ~= "TapNoteType_HoldTail" then
                    CurrentCombo = CurrentCombo
                else
                    if (TapNoteScore <= TNSGreat and TapNoteScore >= "TapNoteScore_W1") or TapNoteScore == "TapNoteScore_CheckpointHit" then
                        CurrentCombo = CurrentCombo + 1
                        MaxCombo = CurrentCombo
                    elseif TapNoteScore == TNSGood then
                        CurrentCombo = CurrentCombo
                    else
                        CurrentCombo = 0
                    end
                end
                
                local NoteWeights = (TNSPoints[TNSPerfect] * Perfects) + 
                                    (TNSPoints[TNSGreat] * Greats) + 
                                    (TNSPoints[TNSGood] * Goods) + 
                                    (TNSPoints[TNSBad] * Bads) + 
                                    (TNSPoints["TapNoteScore_Miss"] * Misses)

                -- Remove extra combo/score count from the end of holds, don't ask me (again)
                if TapNote and TapNote:GetTapNoteType() ~= "TapNoteType_HoldTail" then
                    PlayerScore = PlayerScore
                else
                    PlayerScore = (((0.995 * NoteWeights) + (0.005 * MaxCombo)) / Total) * 1000000
                end
                
                -- We don't want negative scores
                if PlayerScore < 0 then PlayerScore = 0 end
                
                PlayerScore = math.floor(PlayerScore)
                
                PSS:SetScore(PlayerScore)
                
                MESSAGEMAN:Broadcast("UpdateScore", {Player = Player, Score = PlayerScore})
                
                -- Used for debugging
                -- SCREENMAN:SystemMessage(PlayerScore .. " - " .. NoteScore - ComboScore .. " - " .. ComboScore .. " - " .. CurrentCombo .. " - " .. LevelConstant .. " - " .. GradeBonus)
            end
        end
    }
end
