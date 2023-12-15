-- Define the taps that are allowed to be detected.
local AllowedTaps = {
	["TapNoteType_Tap"] = true,
	["TapNoteSubType_Hold"] = false,
	["TapNoteSubType_Roll"] = false,
}

local t = {
    --[[
        Multidimensional array, can have several songs.
        Data is provided with the following elements.

        Density = Array of elements that determine the NPS on a specific measure. ( [int] )
        PeakNPS = Maximum NPS across the entire chart. (float)
        StreamMeasures = Array of measures that have arrays. ( [int] )
        MeasureCount = Total ammount of measures calculated. (int)
    ]]
    Data = {},
    -- Player that will be considered to.
    PlayerAssigned = nil,
    __call = function( this, pn )
        this.PlayerAssigned = pn
        return this
    end,
    Clear = function( this ) this.Data = {} end,
    GenerateData = function( this, ForceData )
        if not this.PlayerAssigned then return end
        -- If it's a course, iterate through every song in the TrailEntries, to prevent midsong loading.
        if GAMESTATE:IsCourseMode() then
            local course = GAMESTATE:GetCurrentCourse()
            if course then
                local UserTrail = GAMESTATE:GetCurrentTrail( this.PlayerAssigned )
                if UserTrail then

                    local stats = STATSMAN:GetCurStageStats()
                    if not stats then return end

                    local mpStats = stats:GetPlayerStageStats( GAMESTATE:GetMasterPlayerNumber() )

                    -- Special case: We don't want to generate all the notedata for
                    -- endless mode, because it can become massive.
                    if GAMESTATE:GetPlayMode() ~= "PlayMode_Endless" then
                        -- We already generated the data, don't bother.
                        if #this.Data > 0 then return end

                        -- Generate entries for every song in the list.
                        for ind, Trail in pairs( UserTrail:GetTrailEntries() ) do
                            -- Trace( "Generating data for: ".. Trail:GetSong():GetSongDir() )
                            this.Data[ ind ] = this:ObtainSongInformation( Trail:GetSteps(), Trail:GetSong() )
                        end
                        return -- We're done, stop operation.
                    else
                        -- If it's endless, instead of all, generate the data just like regular gameplay,
                        -- by getting it on every load.
                        local CurrentIndex = mpStats:GetSongsPassed()
                        local Trail = UserTrail:GetTrailEntry( CurrentIndex )
                        this.Data[ 1 ] = this:ObtainSongInformation( Trail:GetSteps(), Trail:GetSong() )
                        return -- We're done, stop operation.
                    end
                end
            end
        end

        -- If it's a single song, perform the load and return that item.
        local UserSteps = GAMESTATE:GetCurrentSteps( this.PlayerAssigned )
        if ForceData then
            UserSteps = ForceData
        end
        if UserSteps then
            this.Data[ 1 ] = this:ObtainSongInformation( UserSteps )
        end

    end,
    GetCurrentData = function( this )
        if not this.PlayerAssigned then return end

        local stats = STATSMAN:GetCurStageStats()
        if not stats then return end
        local mpStats = stats:GetPlayerStageStats( this.PlayerAssigned or GAMESTATE:GetMasterPlayerNumber() )

        return this:GetDataFromIndex( mpStats:GetSongsPassed() + 1 )
    end,
    GetDataFromIndex = function( this, index )
        if not this.PlayerAssigned then return end

        if( type(index) ~= "number" ) then error( "Value is not a number, must be index." ) end

        if(index < 1) then Trace( "GetDataFromIndex: Returning 1st value." ) return this.Data[1] end
        if(index > #this.Data) then Trace( "GetDataFromIndex: Returning last value (".. #this.Data ..")." ) return this.Data[1] end

        return this.Data[ index ]
    end,
    ObtainSongInformation = function( this, Steps, Song )
        if not this.PlayerAssigned then return end
        if not Steps then return end

        local usesong = Song or GAMESTATE:GetCurrentSong()

        if not usesong then return end


        -- let the engine calculate these.
        local n = {
            Density = Steps:GenerateDensityDataForSteps(),
            StreamMeasures = Steps:GenerateStreamMeasures(),
            PeakNPS = Steps:GetMaxNPS(),
            MeasureCount = Steps:GetNumDensityMeasures() -- Keep track of the measure
        }

        -- Calculate an average NPS with the generated data.
		local avgNPS = 0
		local c = 0
		for k,v in ipairs(n.Density) do
			-- Don't count entries that have no notes at all, as that will make the
			-- result smaller that it should be.
			if v ~= 0 then
				avgNPS = avgNPS + v
				c = c + 1
			end
		end
		avgNPS = avgNPS / c

	    n.AverageNPS = avgNPS

        return n
    end,
    GetStreamSequenceForIndex = function( this, index, measureSequenceThreshold )
        local nindex = index or 1
        if not this.Data[nindex] then SM("No index!") return end

        local streamMeasures = this.Data[nindex].StreamMeasures
        local streamSequences = {}

        local counter = 1
        local streamEnd = nil

        -- First add an initial break if it's larger than measureSequenceThreshold
        if(#streamMeasures > 0) then
            local breakStart = 0
            local k, v = next(streamMeasures) -- first element of a table
            local breakEnd = streamMeasures[k] - 1
            if (breakEnd - breakStart >= measureSequenceThreshold) then
                table.insert(streamSequences,
                    {streamStart=breakStart, streamEnd=breakEnd, isBreak=true})
            end
        end

        -- Which sequences of measures are considered a stream?
        for k,v in pairs(streamMeasures) do
            local curVal = streamMeasures[k]
            local nextVal = streamMeasures[k+1] and streamMeasures[k+1] or -1

            -- Are we still in sequence?
            if(curVal + 1 == nextVal) then
                counter = counter + 1
                streamEnd = curVal + 1
            else
                -- Found the first section that counts as a stream
                if(counter >= measureSequenceThreshold) then
                    local streamStart = (streamEnd - counter)
                    -- Add the current stream.
                    table.insert(streamSequences,
                        {streamStart=streamStart, streamEnd=streamEnd, isBreak=false})
                end

                -- Add any trailing breaks if they're larger than measureSequenceThreshold
                local breakStart = curVal
                local breakEnd = (nextVal ~= -1) and nextVal - 1 or this.Data[nindex].MeasureCount
                if (breakEnd - breakStart >= measureSequenceThreshold) then
                    table.insert(streamSequences,
                        {streamStart=breakStart, streamEnd=breakEnd, isBreak=true})
                end
                counter = 1
            end
        end

        return streamSequences
    end,
    GetStreamBreakDownForIndex = function( this, index, threshold )
        return table.concat(this:GetStreams( index, threshold ), "/")
    end,
    GetStreams = function( this, index, threshold )
        local streams = this:GetStreamSequenceForIndex( index, threshold or 2 )
        if not streams then return "" end

        local streamLengths = {}

        for i, stream in ipairs(streams) do
            local streamCount = tostring(stream.streamEnd - stream.streamStart)
            if not stream.isBreak then
                streamLengths[#streamLengths + 1] = streamCount
            end
        end

        return streamLengths
    end
}

return setmetatable(t,t)
