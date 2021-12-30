return function(streamMeasures, measureSequenceThreshold, totalMeasures)
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
			local breakEnd = (nextVal ~= -1) and nextVal - 1 or totalMeasures
			if (breakEnd - breakStart >= measureSequenceThreshold) then
				table.insert(streamSequences,
					{streamStart=breakStart, streamEnd=breakEnd, isBreak=true})
			end
			counter = 1
		end
	end

	return streamSequences
end