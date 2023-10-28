return function()
    local CurPrefTiming = LoadModule("Options.OverwriteTiming.lua")()
    local n = nil
    -- First, check the timings from our current timing window.
    for _,v in ipairs(TimingWindow) do
        local data = v()
        if data.Name == CurPrefTiming then
			data.Timings = LoadModule("Gameplay.UseTimingTable.lua")(data)
            return data
        end
    end

    -- We did not find anything. This might be cause as another theme used a custom timing process
    -- that is not present on the base configuration's Timing.lua file.
    if n == nil then
        local fallbacktime = TimingWindow[1]()
        Warn( ("[Options.ReturnCurrentTiming] Current Timing '%s' is not present on TimingWindows, using '%s' instead."):format( CurPrefTiming, fallbacktime.Name ) )
		fallbacktime.Timings = LoadModule("Gameplay.UseTimingTable.lua")(fallbacktime)
        return fallbacktime
    end

    return n
end