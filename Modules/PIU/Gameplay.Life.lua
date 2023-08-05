--[[
        K-Pump life gauge system by SheepyChris, created on June 11, 2021
        For this module to work properly, you will need to zero out all metrics in [LifeMeterBar].
]]

return function(pn)
    
    local TapNoteScoreLife = {
        TapNoteScore_CheckpointHit = 12,	-- HOLD PERFECT
        TapNoteScore_W1 = 12,				-- PERFECT
        TapNoteScore_W2 = 10,				-- GREAT
        TapNoteScore_W3 = 0,				-- GOOD
        TapNoteScore_W4 = -50,				-- BAD
        TapNoteScore_W5 = 0,				-- UNUSED
        TapNoteScore_Miss = -500,			-- MISS
        TapNoteScore_CheckpointMiss = -500,	-- HOLD MISS
        TapNoteScore_None =	0,
        TapNoteScore_HitMine = -490,
        TapNoteScore_AvoidMine = 0
    }

    local LifeValue = 500
    local LifeMin = 0
    local LifeMax = 1000

    --local FactorMin = HardMode and 100 or (EasyMode and 200 or 0) -- leaving these here in case we ever want to do legacy "Game Difficulty" operator settings
    --local FactorMax = HardMode and 900 or (EasyMode and 1000 or 800)
    --local FactorMultiplier = Hard and 300 or Easy and 500 or 100
    local FactorMin = 0
    local FactorMax = 800
    local FactorMultiplier = 100
    local FactorMiss = -700
    

    local LevelConstant = 1

    return Def.Actor {
        InitCommand=function(self)
            local StepData = GAMESTATE:GetCurrentSteps(pn)
            local StepLevel = StepData:GetMeter()
            
            -- Limit co-op and other level >30 charts
            if StepLevel > 30 then
                LifeMax = LifeMax + 2700
            else
                LifeMax = LifeMax + StepLevel * StepLevel * 3
            end
        end,
        JudgmentMessageCommand=function(self, params)
            local iStepsCount = 0
            local TapNote = params.TapNote
            local TapNoteScore = params.TapNoteScore
            local CSS = STATSMAN:GetCurStageStats()
            
            if pn ~= params.Player or not TapNoteScore or params.HoldNoteScore then return end
            
            local State = GAMESTATE:GetPlayerState(pn)
            -- make sure the player isn't autoplay
            if State:GetPlayerController() ~= "PlayerController_Autoplay" then
                local NoteLife = TapNoteScoreLife[TapNoteScore]
                
                if TapNoteScore == "TapNoteScore_Miss" or TapNoteScore == "TapNoteScore_HitMine" or 
                    TapNoteScore == "TapNoteScore_CheckpointMiss" then
                    LifeValue = LifeValue + NoteLife * (LifeValue > 1000 and 1000 or LifeValue) / 2000 - 20
                    FactorMultiplier = FactorMultiplier + FactorMiss
                elseif TapNoteScore == "TapNoteScore_W4" then
                    LifeValue = LifeValue + NoteLife
                    FactorMultiplier = FactorMultiplier + FactorMiss / 2
                elseif TapNoteScore == "TapNoteScore_W2" then
                    LifeValue = LifeValue + NoteLife * FactorMultiplier / 1000
                    FactorMultiplier = FactorMultiplier + 16
                elseif TapNoteScore == "TapNoteScore_W1" or 
                    TapNoteScore == "TapNoteScore_CheckpointHit" then
                    LifeValue = LifeValue + NoteLife * FactorMultiplier / 1000
                    FactorMultiplier = FactorMultiplier + 20
                end
                
                -- Value clamping
                if LifeValue < LifeMin then LifeValue = LifeMin end
                if LifeValue > LifeMax then LifeValue = LifeMax end
                if FactorMultiplier < FactorMin then FactorMultiplier = FactorMin end
                if FactorMultiplier > FactorMax then FactorMultiplier = FactorMax end
                
                local LifeOutput = LifeValue / 1000
                --if LifeOutput > 1 then LifeOutput = 1 end
                --SCREENMAN:SystemMessage(LifeValue / 1000 .. " / " .. FactorMultiplier)
                
                MESSAGEMAN:Broadcast("UpdateLife", {Player = pn, Life = LifeOutput})
                
                if State:GetHealthState() ~= "HealthState_Dead" then
                    -- I will forever thank Inori and tertu for this bit of lua
                    local PlayerChild = SCREENMAN:GetTopScreen():GetChild("Player"..ToEnumShortString(pn))
                    PlayerChild:SetLife(LifeOutput)
                end
            end
        end
    }
end
