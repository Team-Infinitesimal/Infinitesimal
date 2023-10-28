return function( TimingSet )
	local set = {}
	if type(TimingSet.Timings) == "function" then
		set = TimingSet.Timings( GAMESTATE:GetEasiestStepsDifficulty() )
	else
		set = TimingSet.Timings
	end

	return set
end