return function(Steps)
    local chartint = 1
    local Density = {}
    local streamMeasures = {}
    local PeakNPS = 0
    -- Keep track of the measure
    local measureCount = 0
    
    if Steps then
        for k,v in pairs( GAMESTATE:GetCurrentSong():GetAllSteps() ) do
            if v == Steps then chartint = k break end
        end
        -- Trace("[GetNPS] Loading Chart... ".. chartint)
        local TD = Steps:GetTimingData()
        -- Keep track of the number of notes in the current measure while we iterate
        local measureNotes = 0
        local measureNPS = 0
        local mDuration = TD:GetElapsedTimeFromBeat((measureCount+1)*4) - TD:GetElapsedTimeFromBeat(measureCount*4)
        local mMargin = (TD:GetElapsedTimeFromBeat(measureCount*4) + mDuration)

        for k,v in pairs( GAMESTATE:GetCurrentSong():GetNoteData(chartint) ) do
            if TD:GetElapsedTimeFromBeat(v[1]) > mMargin then
                local originalval = mDuration == 0 and 0 or measureNotes/mDuration
                measureNPS = math.round(originalval)
                PeakNPS = (measureNPS > PeakNPS or originalval > PeakNPS) and originalval or PeakNPS
                if(measureNotes >= 15) then
                    streamMeasures[#streamMeasures+1] = measureCount+1
                end

                -- Reset stuff
                measureNotes = 0
                Density[measureCount+1] = measureNPS
                
                measureCount = measureCount + 1
                mDuration = TD:GetElapsedTimeFromBeat((measureCount+1)*4) - TD:GetElapsedTimeFromBeat(measureCount*4)
                mMargin = (TD:GetElapsedTimeFromBeat(measureCount*4) + mDuration)
            else
                if v[3] ~= "TapNoteType_Mine" and v[3] ~= "TapNoteType_Fake" then
                    measureNotes = measureNotes + 1
                end
            end
        end

        Density[measureCount+1] = measureNPS
        Density[measureCount+2] = 0
    end
    return PeakNPS,Density,streamMeasures,measureCount
end