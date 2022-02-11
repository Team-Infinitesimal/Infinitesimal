-- For the time being, Infinitesimal will have its
-- own timing windows to accomodate for the scoring,
-- grading and lifebar modules. Hopefully some of the
-- current issues will be resolved in the near future
-- to allow more timing windows to be utilized.

InfTimingWindow = {}

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Original",
		Timings = {
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
		},
        Shared = {
            ["TapNoteScore_CheckpointHit"] = 0
        },
        -- Stub this out for the module
        Scoring = {
            ["TapNoteScore_W1"] = 0,
            ["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
	}
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "ITG",
		Timings = {
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
		},
		Shared = {
			--Others not used here will be taken from a fallback value.
			["TapNoteScore_W1"] = 5,
			["TapNoteScore_W2"] = GAMESTATE:ShowW1() and 4 or 5,
			["TapNoteScore_W3"] = 2,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = -6,
			["TapNoteScore_Miss"] = -12,
			["TapNoteScore_Held"] = 5,
			["TapNoteScore_HitMine"] = -6,
			["TapNoteScore_MaxScore"] = 5,
            ["TapNoteScore_CheckpointHit"] = 0,
		},
        Percent = {
            ["TapNoteScore_CheckpointHit"] = 0
        },
        -- Stub this out for the module
        Scoring = {
            ["TapNoteScore_W1"] = 0,
            ["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
	}
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Pump Normal",
		Timings = {
			['TapNoteScore_W2']			= 0.062500,
			['TapNoteScore_W3']			= 0.104166,
			['TapNoteScore_W4']			= 0.145833,
			['TapNoteScore_W5']			= 0.187500,
			['TapNoteScore_HitMine']	= 0.145833,
			['TapNoteScore_Attack']		= 0.104166,
			['TapNoteScore_Hold']		= 0.125000,
			['TapNoteScore_Roll']		= 0.350000,
			['TapNoteScore_Checkpoint']	= 0,
		},
		Shared = {
			["TapNoteScore_W2"] = 6,
			["TapNoteScore_W3"] = 4,
			["TapNoteScore_W4"] = 2,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = -3,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = -1,
			["TapNoteScore_MaxScore"] = 6,
		},
        -- Stub these out for the modules
        Scoring = {
            ["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
        Life = {
            ["TapNoteScore_W2"] = 0,
            ["TapNoteScore_W3"] = 0,
            ["TapNoteScore_W4"] = 0,
            ["TapNoteScore_W5"] = 0,
            ["TapNoteScore_Miss"] = 0,
            ["TapNoteScore_HitMine"] = 0,
            ["TapNoteScore_CheckpointHit"] = 0,
            ["TapNoteScore_CheckpointMiss"] = 0,
        }
	}
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Pump Hard",
		Timings = {
			['TapNoteScore_W2']			= 0.045833,
			['TapNoteScore_W3']			= 0.087500,
			['TapNoteScore_W4']			= 0.129166,
			['TapNoteScore_W5']			= 0.170833,
			['TapNoteScore_HitMine']	= 0.145833,
			['TapNoteScore_Attack']		= 0.104166,
			['TapNoteScore_Hold']		= 0.125000,
			['TapNoteScore_Roll']		= 0.350000,
			['TapNoteScore_Checkpoint']	= 0,
		},
		Shared = {
			["TapNoteScore_W2"] = 6,
			["TapNoteScore_W3"] = 4,
			["TapNoteScore_W4"] = 2,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = -3,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = -1,
			["TapNoteScore_MaxScore"] = 6,
		},
        -- Stub these out for the modules
        Scoring = {
            ["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
        Life = {
            ["TapNoteScore_W2"] = 0,
            ["TapNoteScore_W3"] = 0,
            ["TapNoteScore_W4"] = 0,
            ["TapNoteScore_W5"] = 0,
            ["TapNoteScore_Miss"] = 0,
            ["TapNoteScore_HitMine"] = 0,
            ["TapNoteScore_CheckpointHit"] = 0,
            ["TapNoteScore_CheckpointMiss"] = 0,
        }
	}
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Pump Very Hard",
		Timings = {
			['TapNoteScore_W2']			= 0.029166,
			['TapNoteScore_W3']			= 0.062500,
			['TapNoteScore_W4']			= 0.095833,
			['TapNoteScore_W5']			= 0.129166,
			['TapNoteScore_HitMine']	= 0.095833,
			['TapNoteScore_Attack']		= 0.062500,
			['TapNoteScore_Hold']		= 0.083333,
			['TapNoteScore_Roll']		= 0.350000,
			['TapNoteScore_Checkpoint']	= 0,
		},
		Shared = {
			["TapNoteScore_W2"] = 6,
			["TapNoteScore_W3"] = 4,
			["TapNoteScore_W4"] = 2,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = -3,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = -1,
			["TapNoteScore_MaxScore"] = 6,
		},
        -- Stub these out for the modules
        Scoring = {
            ["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
        Life = {
            ["TapNoteScore_W2"] = 0,
            ["TapNoteScore_W3"] = 0,
            ["TapNoteScore_W4"] = 0,
            ["TapNoteScore_W5"] = 0,
            ["TapNoteScore_Miss"] = 0,
            ["TapNoteScore_HitMine"] = 0,
            ["TapNoteScore_CheckpointHit"] = 0,
            ["TapNoteScore_CheckpointMiss"] = 0,
        }
	}
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Infinity",
		Timings = {
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
		},
		Shared = {
			["TapNoteScore_W1"] = 7,
            ["TapNoteScore_W2"] = 6,
			["TapNoteScore_W3"] = 4,
			["TapNoteScore_W4"] = 2,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = -3,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = -1,
			["TapNoteScore_MaxScore"] = 7,
		},
        Life = {
            ["TapNoteScore_W1"] = 0.010,
            ["TapNoteScore_W2"] = 0.010,
            ["TapNoteScore_W3"] = 0.006,
            ["TapNoteScore_W4"] = 0,
            ["TapNoteScore_W5"] = -0.050,
            ["TapNoteScore_Miss"] = -0.100,
            ["TapNoteScore_HitMine"] = -0.160,
            ["TapNoteScore_CheckpointHit"] = 0.025,
            ["TapNoteScore_CheckpointMiss"] = -0.100,
        },
        -- Stub this out for the module
        Scoring = {
            ["TapNoteScore_W1"] = 0,
            ["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_W5"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
    }
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Pro",
		Timings = {
            ['TapNoteScore_W1']			= 0.026000,
			['TapNoteScore_W2']			= 0.055000,
			['TapNoteScore_W3']			= 0.100000,
			['TapNoteScore_W4']			= 0.145000,
			['TapNoteScore_HitMine']	= 0.070000,
			['TapNoteScore_Attack']		= 0.135000,
			['TapNoteScore_Hold']		= 0.320000,
			['TapNoteScore_Roll']		= 0.350000,
			['TapNoteScore_Checkpoint']	= 0.060000,
		},
		Shared = {
            ["HoldNoteScore_Held"] = 6,
			["TapNoteScore_W1"] = 10,
            ["TapNoteScore_W2"] = 8,
			["TapNoteScore_W3"] = 6,
			["TapNoteScore_W4"] = 2,
			["TapNoteScore_Miss"] = -2,
			["TapNoteScore_HitMine"] = -8,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 10,
		},
        Life = {
            ["HoldNoteScore_Held"] = 0.008,
            ["TapNoteScore_W1"] = 0.008,
            ["TapNoteScore_W2"] = 0.008,
            ["TapNoteScore_W3"] = 0.004,
            ["TapNoteScore_W4"] = 0,
            ["TapNoteScore_Miss"] = -0.080,
            ["TapNoteScore_HitMine"] = -0.160,
            ["TapNoteScore_CheckpointHit"] = 0.004,
            ["TapNoteScore_CheckpointMiss"] = -0.015,
        },
        -- Stub this out for the module
        Scoring = {
            ["TapNoteScore_W1"] = 0,
			["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_W4"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
    }
end

InfTimingWindow[#InfTimingWindow+1] = function()
	return {
		Name = "Jump",
		Timings = {
            ['TapNoteScore_W1']			= 0.090000,
			['TapNoteScore_W2']			= 0.160000,
			['TapNoteScore_W3']			= 0.220000,
			['TapNoteScore_HitMine']	= 0.070000,
			['TapNoteScore_Attack']		= 0.135000,
			['TapNoteScore_Hold']		= 0.320000,
			['TapNoteScore_Roll']		= 0.350000,
			['TapNoteScore_Checkpoint']	= 0.060000,
		},
		Shared = {
            ["HoldNoteScore_Held"] = 1,
			["TapNoteScore_W1"] = 3,
            ["TapNoteScore_W2"] = 2,
			["TapNoteScore_W3"] = 1,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 3,
		},
        Life = {
            ["HoldNoteScore_Held"] = 0.040,
            ["TapNoteScore_W1"] = 0.040,
            ["TapNoteScore_W2"] = 0.040,
            ["TapNoteScore_W3"] = 0.040,
            ["TapNoteScore_Miss"] = -0.080,
            ["TapNoteScore_HitMine"] = -0.080,
            ["TapNoteScore_CheckpointHit"] = 0.010,
            ["TapNoteScore_CheckpointMiss"] = -0.005,
        },
        -- Stub this out for the module
        Scoring = {
            ["TapNoteScore_W1"] = 0,
			["TapNoteScore_W2"] = 0,
			["TapNoteScore_W3"] = 0,
			["TapNoteScore_Miss"] = 0,
			["TapNoteScore_HitMine"] = 0,
			["TapNoteScore_CheckpointHit"] = 0,
			["TapNoteScore_CheckpointMiss"] = 0,
			["TapNoteScore_MaxScore"] = 0,
        },
    }
end

function GetWindowSeconds(InfTimingWindow, Scale, Add)
	local fSecs = InfTimingWindow
	fSecs = fSecs * (Scale or 1.0) -- Timing Window Scale
	fSecs = fSecs + (Add or 0) --Timing Window Add
	return fSecs
end

------------------------------------------------------------------------------
-- Timing Call Definitions. -- Dont edit below this line - Jous
------------------------------------------------------------------------------

InfTimingModes = {}
for i,v in ipairs(InfTimingWindow) do
	local TW = InfTimingWindow[i]()
	table.insert(InfTimingModes,TW.Name)
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
			if k == ('TapNoteScore_' .. s)  then
				con[ #con+1 ] = {k,v,a}
				break
			end
		end
	end
	
	-- Sort for later use.
	table.sort( con, function(a,b) return a[3] < b[3] end )
	return con
end