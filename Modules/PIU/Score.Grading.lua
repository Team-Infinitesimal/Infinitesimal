return function(PlayerScore)
    local TimingMode = LoadModule("Config.Load.lua")("SmartTimings", "Save/OutFoxPrefs.ini")
    local PumpTiming = string.find(TimingMode, "Pump")
    local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"

    local GradeLetter = "F"
    local GradeCondition = "Fail"
    local FailGrade = PlayerScore:GetGrade()

    if Scoring == "New" then
        -- Do some division to remove redundant zeros for checking
        local Score = PlayerScore:GetScore()
        local GradeRanges = {
            ["3PS"]     = {["Lower"] = 995000, ["Upper"] = 1000001},
            ["3S"]      = {["Lower"] = 990000, ["Upper"] = 995000},
            ["2PS"]     = {["Lower"] = 985000, ["Upper"] = 990000},
            ["2S"]      = {["Lower"] = 980000, ["Upper"] = 985000},
            ["PS"]      = {["Lower"] = 975000, ["Upper"] = 980000},
            ["S"]       = {["Lower"] = 970000, ["Upper"] = 975000},
            ["3PA"]     = {["Lower"] = 960000, ["Upper"] = 970000},
            ["3A"]      = {["Lower"] = 950000, ["Upper"] = 960000},
            ["2PA"]     = {["Lower"] = 925000, ["Upper"] = 950000},
            ["2A"]      = {["Lower"] = 900000, ["Upper"] = 925000},
            ["PA"]      = {["Lower"] = 825000, ["Upper"] = 900000},
            ["A"]       = {["Lower"] = 750000, ["Upper"] = 825000},
            ["B"]       = {["Lower"] = 650000, ["Upper"] = 750000},
            ["C"]       = {["Lower"] = 550000, ["Upper"] = 650000},
            ["D"]       = {["Lower"] = 450000, ["Upper"] = 550000}
        }

        if FailGrade ~= "Grade_Failed" then
            GradeCondition = "Pass"
        end

        for Grade, Value in pairs(GradeRanges) do
            if Score >= GradeRanges[Grade]["Lower"] and Score < GradeRanges[Grade]["Upper"] then
                return GradeCondition .. Grade
            end
        end

        return GradeCondition .. "F"
    else
        local TNSPerfect = "TapNoteScore_W" .. (PumpTiming and "1" or "2")
        local TNSGreat = "TapNoteScore_W" .. (PumpTiming and "2" or "3")
        local TNSGood = "TapNoteScore_W" .. (PumpTiming and "3" or "4")
        local TNSBad = "TapNoteScore_W" .. (PumpTiming and "4" or "5")

        local Checkpoints = PlayerScore:GetTapNoteScore("TapNoteScore_CheckpointHit")
        local Superbs 	= PumpTiming and 0 or PlayerScore:GetTapNoteScore("TapNoteScore_W1")
        local Perfects 	= PlayerScore:GetTapNoteScore(TNSPerfect) + Checkpoints
        local Greats 	= PlayerScore:GetTapNoteScore(TNSGreat)
        local Goods 	= PlayerScore:GetTapNoteScore(TNSGood)
        local Bads	 	= PlayerScore:GetTapNoteScore(TNSBad)
        local Misses 	= PlayerScore:GetTapNoteScore("TapNoteScore_Miss") +
                          PlayerScore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
        local MaxCombo	= PlayerScore:GetMaxCombo()

        local TotalNotes = Perfects + Greats + Goods + Bads + Misses
        local PlayerAccuracy = ((Superbs + Perfects) * 1.2 + Greats * 0.9 + Goods * 0.6 + Bads * -0.45 + Misses * -0.9 + Checkpoints * -0.2 + MaxCombo * 0.05) / TotalNotes

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
                    GradeLetter = "S"
                end
            else
                GradeLetter = "S"
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
end
