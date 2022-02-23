-- Believe it or not, but this module exists due to an extra "s" in GetTapNoteScores
-- and GetMaxCombo becoming MaxCombo when retrieving a score. Thanks StepMania devs

return function(PlayerScore)
    local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings", "Save/OutFoxPrefs.ini")
    local PumpTiming = string.find(CurPrefTiming, "Pump")
    local TNSPerfect = "TapNoteScore_W" .. (PumpTiming and "1" or "2")
    local TNSGreat = "TapNoteScore_W" .. (PumpTiming and "2" or "3")
    local TNSGood = "TapNoteScore_W" .. (PumpTiming and "3" or "4")
    local TNSBad = "TapNoteScore_W" .. (PumpTiming and "4" or "5")
    
    local Superbs 	= PumpTiming and 0 or PlayerScore:GetTapNoteScores("TapNoteScore_W1")
    local Perfects 	= PlayerScore:GetTapNoteScores(TNSPerfect)
    local Greats 	= PlayerScore:GetTapNoteScores(TNSGreat)
    local Goods 	= PlayerScore:GetTapNoteScores(TNSGood)
    local Bads	 	= PlayerScore:GetTapNoteScores(TNSBad)
    local Misses 	= PlayerScore:GetTapNoteScores("TapNoteScore_Miss") +
                      PlayerScore:GetTapNoteScores("TapNoteScore_CheckpointMiss")
    local MaxCombo	= PlayerScore:MaxCombo()  
    local FailGrade = PlayerScore:GetGrade()

    local GradeLetter = "F"
    local GradeCondition = "Fail"
    local TotalNotes = Perfects + Greats + Goods + Bads + Misses
    local PlayerAccuracy = ((Superbs + Perfects) * 1.2 + Greats * 0.9 + Goods * 0.6 + Bads * -0.45 + Misses * -0.9 + MaxCombo * 0.05) / TotalNotes
            
    -- The good ol' if staircase
    if Misses == 0 and PlayerAccuracy >= 1 then
        if Bads == 0 then
            if Goods == 0 then
                if Greats == 0 then
                    GradeLetter = "3S"
                else
                    GradeLetter = "2S"
                end
            else
                GradeLetter = "1S"
            end
        else
            GradeLetter = "1S"
        end
    else
        if PlayerAccuracy >= 0.95 then
            GradeLetter = "A"
        elseif PlayerAccuracy >= 0.90 then
            GradeLetter = "B"
        elseif PlayerAccuracy >= 0.85 then
            GradeLetter = "C"
        elseif PlayerAccuracy >= 0.75 then
            GradeLetter = "D"
        end
    end

    if FailGrade ~= "Grade_Failed" then
        GradeCondition = "Pass"
    end
    
    return GradeCondition .. GradeLetter
end