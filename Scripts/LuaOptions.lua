function OptionNameString(str)
	return THEME:GetString('OptionNames',str)
end

TimingWindow = {}

TimingWindow[#TimingWindow+1] = function()
	local Name = "Normal"
	local Timings= {
		['TapNoteScore_W1']			= 0.031250,
		['TapNoteScore_W2']			= 0.062500,
		['TapNoteScore_W3']			= 0.104166,
		['TapNoteScore_W4']			= 0.145833,
		['TapNoteScore_W5']			= 0.187500,
		
		['TapNoteScore_HitMine']	= 0.145833,
		['TapNoteScore_Attack']		= 0.104166,
		['TapNoteScore_Hold']		= 0.125000,
		['TapNoteScore_Roll']		= 0.350000,
		['TapNoteScore_Checkpoint']	= 0,
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Hard"
	local Timings= {
		['TapNoteScore_W1']			= 0.022916,
		['TapNoteScore_W2']			= 0.045833,
		['TapNoteScore_W3']			= 0.087500,
		['TapNoteScore_W4']			= 0.129166,
		['TapNoteScore_W5']			= 0.170833,
		
		['TapNoteScore_HitMine']	= 0.129166,
		['TapNoteScore_Attack']		= 0.087500,
		['TapNoteScore_Hold']		= 0.108333,
		['TapNoteScore_Roll']		= 0.350000,
		['TapNoteScore_Checkpoint']	= 0,
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Very Hard"
	local Timings= {
		['TapNoteScore_W1']			= 0.014583,
		['TapNoteScore_W2']			= 0.029166,
		['TapNoteScore_W3']			= 0.062500,
		['TapNoteScore_W4']			= 0.095833,
		['TapNoteScore_W5']			= 0.129166,
		
		['TapNoteScore_HitMine']	= 0.095833,
		['TapNoteScore_Attack']		= 0.062500,
		['TapNoteScore_Hold']		= 0.083333,
		['TapNoteScore_Roll']		= 0.350000,
		['TapNoteScore_Checkpoint']	= 0,
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Infinity"
	local Timings= {
		['TapNoteScore_W1']			= 0.028000,
		['TapNoteScore_W2']			= 0.058000,
		['TapNoteScore_W3']			= 0.115000,
		['TapNoteScore_W4']			= 0.160000,
		['TapNoteScore_W5']			= 0.200000,
		
		['TapNoteScore_HitMine']	= 0.130000,
		['TapNoteScore_Attack']		= 0.135000,
		['TapNoteScore_Hold']		= 0.320000,
		['TapNoteScore_Roll']		= 0.450000,
		['TapNoteScore_Checkpoint']	= 0,
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Groove"
	local Timings= {
		['TapNoteScore_W1']			= 0.021500,
		['TapNoteScore_W2']			= 0.043000,
		['TapNoteScore_W3']			= 0.102000,
		['TapNoteScore_W4']			= 0.135000,
		['TapNoteScore_W5']			= 0.180000,
		
		['TapNoteScore_HitMine']	= 0.070000,
		['TapNoteScore_Attack']		= 0.130000,
		['TapNoteScore_Hold']		= 0.320000,
		['TapNoteScore_Roll']		= 0.350000,
		['TapNoteScore_Checkpoint']	= 0,
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Hero"
	local Timings= {
		['TapNoteScore_W1']			= 0.062500,
		['TapNoteScore_W2']			= 0.062500,
		
		['TapNoteScore_HitMine']	= 0.070000,
		['TapNoteScore_Attack']		= 0.130000,
		['TapNoteScore_Hold']		= 0.320000,
		['TapNoteScore_Roll']		= 0.350000,
		['TapNoteScore_Checkpoint']	= 0,
	};
	return Name, Timings
end

function GetWindowSeconds(TimingWindow, Scale, Add)
	local fSecs = TimingWindow
	fSecs = fSecs * (Scale or 1.0) -- Timing Window Scale
	fSecs = fSecs + (Add or 0) --Timing Window Add
	return fSecs
end

------------------------------------------------------------------------------
-- Timing Call Definitions. -- Dont edit below this line - Jous
------------------------------------------------------------------------------

TimingModes = {}
for i,v in ipairs(TimingWindow) do
	Name,_ = TimingWindow[i]()
	table.insert(TimingModes,Name)
end

function TimingOrder(TimTab)
	local con = {}
	local availableJudgments = {
		"ProW1","ProW2","ProW3","ProW4","ProW5",
		"W1","W2","W3","W4","W5",
		"HitMine","Attack","Hold","Roll","Checkpoint"
	}
	
	-- Iterate all judgments that are available.
	for k,v in pairs(TimTab) do
		for a,s in pairs( availableJudgments ) do
			if k == 'TapNoteScore_' .. s  then
				con[ #con+1 ] = {k,v,a}
				break
			end
		end
	end

	-- Sort for later use.
	table.sort( con, function(a,b) return a[3] < b[3] end )
	return con
end

LoadModule("Row.Prefs.lua")(LoadModule("Options.Prefs.lua"))
