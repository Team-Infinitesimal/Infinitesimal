return function( song, chart, timing, player )
    if not song or not chart or not NETMAN then return nil end

    local rate = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred"):MusicRate()

    if type(chart) ~= "table" then
        local key = chart:GetChartKey()
        return NETMAN:HighScoresForChart( key, timing, rate )
    end

    if player then
        return NETMAN:HighScoresFromUser(player, chart, timing, rate)
    else
        return NETMAN:HighScoresFromChartList(chart, timing, rate)
    end
end
