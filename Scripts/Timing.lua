TimingWindow = {}

TimingWindow[#TimingWindow+1] = function()
	local Name = "Original"
	local Timings= {
		['TapNoteScore_W1']			= 0.062500,
		['TapNoteScore_W2']			= 0.062500,
		-- No W3/4/5 here
		['TapNoteScore_HitMine']	= 0.070000,
		['TapNoteScore_Attack']		= 0.130000,
		['TapNoteScore_Hold']		= 0.320000,
		['TapNoteScore_Roll']		= 0.350000,
		['TapNoteScore_Checkpoint']	= 0.1664, -- without this holds will never drop.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Advanced"
	local Timings= {
		['TapNoteScore_ProW1']=0.000703125,
		['TapNoteScore_ProW2']=0.00140625,
		['TapNoteScore_ProW3']=0.0028125,
		['TapNoteScore_ProW4']=0.005625,
		['TapNoteScore_ProW5']=0.01125,
		['TapNoteScore_W1']=0.0225,
		['TapNoteScore_W2']=0.0450,
		['TapNoteScore_W3']=0.0900,
		['TapNoteScore_W4']=0.1350,
		['TapNoteScore_W5']=0.1800,
		['TapNoteScore_HitMine']=0.0900,
		['TapNoteScore_Attack']=0.1350,
		['TapNoteScore_Hold']=0.2500,
		['TapNoteScore_Roll']=0.5000,
		['TapNoteScore_Checkpoint']=0.1664,
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "ITG"
	local Timings= {
		['TapNoteScore_W1']=0.021500,
		['TapNoteScore_W2']=0.043000,
		['TapNoteScore_W3']=0.102000,
		['TapNoteScore_W4']=0.135000,
		['TapNoteScore_W5']=0.180000,
		['TapNoteScore_HitMine']=0.070000,
		['TapNoteScore_Attack']=0.130000,
		['TapNoteScore_Hold']=0.320000,
		['TapNoteScore_Roll']=0.350000,
		['TapNoteScore_Checkpoint']=0.1664, -- without this holds will never drop.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "ITG Advanced"
	local Timings= {
		['TapNoteScore_ProW1']=0.000671875,
		['TapNoteScore_ProW2']=0.00134375,
		['TapNoteScore_ProW3']=0.00226875,
		['TapNoteScore_ProW4']=0.005375,
		['TapNoteScore_ProW5']=0.01075,
		['TapNoteScore_W1']=0.021500,
		['TapNoteScore_W2']=0.043000,
		['TapNoteScore_W3']=0.102000,
		['TapNoteScore_W4']=0.135000,
		['TapNoteScore_W5']=0.180000,
		['TapNoteScore_HitMine']=0.070000,
		['TapNoteScore_Attack']=0.130000,
		['TapNoteScore_Hold']=0.320000,
		['TapNoteScore_Roll']=0.350000,
		['TapNoteScore_Checkpoint']=0.1664, -- without this holds will never drop.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "ECFA"
	local Timings= {
		['TapNoteScore_ProW5']=0.0125,
		['TapNoteScore_W1']=0.021500,
		['TapNoteScore_W2']=0.043000,
		['TapNoteScore_W3']=0.102000,
		['TapNoteScore_W4']=0.135000,
		['TapNoteScore_W5']=0.180000,
		['TapNoteScore_HitMine']=0.070000,
		['TapNoteScore_Attack']=0.130000,
		['TapNoteScore_Hold']=0.320000,
		['TapNoteScore_Roll']=0.350000,
		['TapNoteScore_Checkpoint']=0.1664, -- without this holds will never drop.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "DDR"
	local Timings= {
		['TapNoteScore_W1']=0.0150, -- Marvelous
		['TapNoteScore_W2']=0.0300, -- Perfect
		['TapNoteScore_W3']=0.0590, -- Great
		['TapNoteScore_W4']=0.0890, -- Good
		['TapNoteScore_W5']=0.1190, -- Boo
		['TapNoteScore_HitMine']=0.0900, -- Dunno this value, use Original.
		['TapNoteScore_Attack']=0.1350, -- Dunno this value, use Original.
		['TapNoteScore_Hold']=0.2500, -- Dunno this value, use Original.
		['TapNoteScore_Roll']=0.5000, -- Dunno this value, use Original.
		['TapNoteScore_Checkpoint']=0.1664, -- Dunno this value, use Original.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "BeatmaniaIIDX"
	local Timings= {
		['TapNoteScore_W1']=0.0200, -- PGreat
		['TapNoteScore_W2']=0.0400, -- Great
		['TapNoteScore_W3']=0.1050, -- Good
		-- W4 and W5 don't exist.
		['TapNoteScore_HitMine']=0.0900, -- IIDX doesn't have, use Original.
		['TapNoteScore_Attack']=0.1350, -- IIDX doesn't have, use Original.
		['TapNoteScore_Hold']=0.2500, -- Dunno this value, use Original.
		['TapNoteScore_Roll']=0.5000, -- IIDX doesn't have, use Original.
		['TapNoteScore_Checkpoint']=0.1664, -- Dunno this value, use Original.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Pop'n Music"
	local Timings= {
		['TapNoteScore_W1']=0.0250, -- Cool
		['TapNoteScore_W2']=0.0500, -- Great
		['TapNoteScore_W3']=0.1000, -- Good
		-- W4 and W5 don't exist.
		['TapNoteScore_HitMine']=0.0900, -- Pop'n doesn't have, use Original.
		['TapNoteScore_Attack']=0.1350, -- Pop'n doesn't have, use Original.
		['TapNoteScore_Hold']=0.2500, -- Dunno this value, use Original.
		['TapNoteScore_Roll']=0.5000, -- Pop'n doesn't have, use Original.
		['TapNoteScore_Checkpoint']=0.1664, -- Dunno this value, use Original.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "GuitarFreaks"
	local Timings= {
		['TapNoteScore_W1']=0.0330, -- Perfect
		['TapNoteScore_W2']=0.0570, -- Great
		['TapNoteScore_W3']=0.0810, -- Good
		['TapNoteScore_W4']=0.1770, -- Ok
		-- W5 doesn't exist.
		['TapNoteScore_HitMine']=0.0900, -- GuitarFreaks doesn't have, use Original.
		['TapNoteScore_Attack']=0.1350, -- GuitarFreaks doesn't have, use Original.
		['TapNoteScore_Hold']=0.2500, -- Dunno this value, use Original.
		['TapNoteScore_Roll']=0.5000, -- GuitarFreaks doesn't have, use Original.
		['TapNoteScore_Checkpoint']=0.1664, -- Dunno this value, use Original.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "Drummania"
	local Timings= {
		['TapNoteScore_W1']=0.0270, -- Perfect
		['TapNoteScore_W2']=0.0480, -- Great
		['TapNoteScore_W3']=0.0720, -- Good
		['TapNoteScore_W4']=0.0960, -- Ok
		-- W5 doesn't exist.
		['TapNoteScore_HitMine']=0.0900, -- Drummania doesn't have, use Original.
		['TapNoteScore_Attack']=0.1350, -- Drummania doesn't have, use Original.
		['TapNoteScore_Hold']=0.2500, -- Dunno this value, use Original.
		['TapNoteScore_Roll']=0.5000, -- Drummania doesn't have, use Original.
		['TapNoteScore_Checkpoint']=0.1664, -- Dunno this value, use Original.
	};
	return Name, Timings
end

TimingWindow[#TimingWindow+1] = function()
	local Name = "ParaParaParadise"
	local Timings= {
		['TapNoteScore_W1']=0.080, -- Great
		['TapNoteScore_W2']=0.180, -- Good
		-- W3/4/5 don't exist.
		['TapNoteScore_HitMine']=0.0900, -- Para doesn't have, use Original.
		['TapNoteScore_Attack']=0.1350, -- Para doesn't have, use Original.
		['TapNoteScore_Hold']=0.2500, -- Dunno this value, use Original.
		['TapNoteScore_Roll']=0.5000, -- Para doesn't have, use Original.
		['TapNoteScore_Checkpoint']=0.1664, -- Dunno this value, use Original.
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
