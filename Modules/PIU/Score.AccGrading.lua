return function(PlayerScore)
    local Misses 	= PlayerScore:GetTapNoteScore("TapNoteScore_Miss") +
                      PlayerScore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
    local GradeLetter = "F"
    local GradeCondition = "Fail"
    local PlayerAccuracy = round(PlayerScore:GetPercentDancePoints() * 100, 2)
            
    -- The good ol' if staircase
    
    if Misses == 0 then
        if PlayerAccuracy >= 96 then
            if PlayerAccuracy >= 98 then
                if PlayerAccuracy >= 100 then
                        GradeLetter = "3S"
                    end
                else
                    GradeLetter = "2S"
                end
            else
                GradeLetter = "1S"
            end
        else
            -- Could possibly become Blue S?
            GradeLetter = "1S"
        end
    elseif PlayerAccuracy >= 80 then
        GradeLetter = "A"
    elseif PlayerAccuracy >= 70 then
        GradeLetter = "B"
    elseif PlayerAccuracy >= 60 then
        GradeLetter = "C"
    elseif PlayerAccuracy >= 50 then
        GradeLetter = "D"
    end

    if FailGrade ~= "Grade_Failed" then
        GradeCondition = "Pass"
    end
    
    return GradeCondition .. GradeLetter
end