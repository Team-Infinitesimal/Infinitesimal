function OptionRowModeSelect()
    local t = {
        Name = "ModeSelCustom";
        LayoutType = "ShowAllInRow";
        SelectType = "SelectOne";
        OneChoiceForAllPlayers = true;
        Choices = {"Arcade", "Pro", "Stamina"};
        LoadSelections = function(self, list, pn)
            local mode = PREFSMAN:GetPreference("AllowW1")
            if mode == "AllowW1_Everywhere" then -- Pro Mode
                list[2] = true;
            else -- Arcade Mode
                list[1] = true;
            end;
        end;
        SaveSelections = function(self, list, pn)
            if list[3] or list[2] then
                PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
            elseif list[1] then
                PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
            end;
        end;
    };
    setmetatable(t, t)
	return t
end;

--Requires string:split from Utils
function OptionRowAvailableNoteskins()
  	local ns = NOTESKIN:GetNoteSkinNames();
  	local disallowedNS = THEME:GetMetric("Common","NoteSkinsToHide"):split(",");
  	for i = 1, #disallowedNS do
		for k,v in pairs(ns) do
			if v == disallowedNS[i] then
					table.remove(ns, k)
			end
		end;
  	end;

  	local t = {
		Name="NoteskinsCustom",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		Choices = ns,
		NumNoteskins = #ns,
		LoadSelections = function(self, list, pn)
			--This returns an instance of playerOptions, you need to set it back to the original
			local playerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local curNS = playerOptions:NoteSkin();
			local found = false;
			for i=1,#list do
				if ns[i] == curNS then
					list[i] = true;
					found = true;
				end;
			end;
			if not found then
				assert(found,"There was no noteskin selected, but the player's noteskin should be "..curNS);
				list[1] = true;
			end;
		end,
		SaveSelections = function(self, list, pn)
			local pName = ToEnumShortString(pn)
			--list[1] = true;
			local found = false
			for i=1,#list do
				if not found then
					if list[i] == true then
						GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin(ns[i]);
						found = true
						--SCREENMAN:SystemMessage("NS set to "..ns[i]);
					end
				end
			end
      	end,
  	};
  	setmetatable(t, t)
  	return t
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
		['TapNoteScore_Checkpoint']	= 0.125500,
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
		['TapNoteScore_Checkpoint']	= 0.108333,
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
		['TapNoteScore_Checkpoint']	= 0.083333,
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
		['TapNoteScore_Checkpoint']	= 0.166400,
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
		['TapNoteScore_Checkpoint']	= 0.166400,
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
		['TapNoteScore_Checkpoint']	= 0.166400,
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
