return function(PlayerScore)
    local Superbs 	= PlayerScore:GetTapNoteScore("TapNoteScore_W1")
    local Perfects 	= PlayerScore:GetTapNoteScore("TapNoteScore_W2")
    local Greats 	= PlayerScore:GetTapNoteScore("TapNoteScore_W3")
    local Goods 	= PlayerScore:GetTapNoteScore("TapNoteScore_W4")
    local Bads	 	= PlayerScore:GetTapNoteScore("TapNoteScore_W5")
    local Misses 	= PlayerScore:GetTapNoteScore("TapNoteScore_Miss") +
                      PlayerScore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
    local MaxCombo	= PlayerScore:GetMaxCombo()  
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