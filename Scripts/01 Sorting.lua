-- Our main table which will contain all sorted groups.
MasterGroupsList = {}
GroupsList = {}

local ShowUCS = LoadModule("Config.Load.lua")("ShowUCSCharts", "Save/OutFoxPrefs.ini")
local ShowQuest = LoadModule("Config.Load.lua")("ShowQuestCharts", "Save/OutFoxPrefs.ini")
local ShowHidden = LoadModule("Config.Load.lua")("ShowHiddenCharts", "Save/OutFoxPrefs.ini")

local function GetValue(t, value)
    for k, v in pairs(t) do
        if v == value then return k end
    end
    return nil
end

local function HasValue(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

local function PairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
    end
    return iter
end

local function SortSongsByTitle(a, b)
    return ToLower(a:GetTranslitFullTitle()) < ToLower(b:GetTranslitFullTitle())
end

function PlayableSongs(SongList)
	local SongTable = {}
	for Song in ivalues(SongList) do
        local Steps = SongUtil.GetPlayableSteps(Song)
		if #Steps > 0 then
			SongTable[#SongTable+1] = Song
		end
	end
	return SongTable
end

-- http://lua-users.org/wiki/CopyTable
function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function AssembleGroupSorting()
    Trace("Creating group sorts...")
    
	if not (SONGMAN and GAMESTATE) then
        Warn("SONGMAN or GAMESTATE were not ready! Aborting!")
        return
    end
	
	-- Empty current table
	MasterGroupsList = {}
    
    -- ======================================== All songs ========================================
    local AllSongs = SONGMAN:GetAllSongs()
    
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Special",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {
            {   
                Name = "All Tunes",
                Banner = THEME:GetPathG("", "Common fallback banner"),
                Songs = AllSongs
            }
        }
    }
    
    Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
    MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
    #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
    
    -- ======================================== Shortcuts ========================================
    local Shortcuts = {}
    for j, Song in ipairs(AllSongs) do
        if Song:GetLastSecond() < 75 or string.find(string.upper(Song:GetSongDir()), "[SHORT CUT]", nil, true) then
           table.insert(Shortcuts, Song)
        end
    end
    
    if #Shortcuts ~= nil then
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Shortcut",
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = Shortcuts,
        }
            
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
    end
    
    -- ======================================== Remixes ========================================
    local Remixes = {}
    for j, Song in ipairs(AllSongs) do
        if string.find(string.upper(Song:GetSongDir()), "[REMIX]", nil, true) then
           table.insert(Remixes, Song)
        end
    end
    
    if #Remixes ~= nil then
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Remix",
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = Remixes,
        }
            
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
    end
    
    -- ======================================== Full Songs ========================================
    local FullSongs = {}
    for j, Song in ipairs(AllSongs) do
        if string.find(string.upper(Song:GetSongDir()), "[FULL SONG]", nil, true) then
            table.insert(FullSongs, Song)
        elseif Song:GetLastSecond() > 150 and not string.find(string.upper(Song:GetSongDir()), "[REMIX]", nil, true) then
            table.insert(FullSongs, Song)
        end
    end
    
    if #FullSongs ~= nil then
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Full Song",
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = FullSongs,
        }
            
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
    end
    
    -- ======================================== Co-op charts ========================================
    local CoopSongs = {}
    for j, Song in ipairs(AllSongs) do
        for i, Chart in ipairs(Song:GetStepsByStepsType('StepsType_Pump_Double')) do
            -- Filter out unwanted charts
            local ShouldRemove = false

            if not ShowUCS and string.find(ToUpper(Chart:GetDescription()), "UCS") then ShouldRemove = true
            elseif not ShowQuest and string.find(ToUpper(Chart:GetDescription()), "QUEST") then ShouldRemove = true
            elseif not ShowHidden and string.find(ToUpper(Chart:GetDescription()), "HIDDEN") then ShouldRemove = true end
            
            if not ShouldRemove then
                local ChartMeter = Chart:GetMeter()
                local ChartDescription = Chart:GetDescription()
                
                ChartDescription:gsub("[%p%c%s]", "")
                if string.find(string.upper(ChartDescription), "DP") or
                string.find(string.upper(ChartDescription), "COOP") then
                    if ChartMeter == 99 then
                       table.insert(CoopSongs, Song)
                       break
                    end
                end
            end
		end
    end
    
    if #CoopSongs ~= nil then
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Co-op",
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = CoopSongs,
        }
            
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
    end

    -- ======================================== Song groups ========================================
	local SongGroups = {}
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Group",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {}
    }

	-- Iterate through the song groups and check if they have AT LEAST one song with valid charts.
	-- If so, add them to the group.
	for GroupName in ivalues(SONGMAN:GetSongGroupNames()) do
		for Song in ivalues(SONGMAN:GetSongsInGroup(GroupName)) do
			local Steps = Song:GetAllSteps()
			if #Steps > 0 then
				SongGroups[#SongGroups + 1] = GroupName
				break
			end
		end
	end
    table.sort(SongGroups)
    
	for i, v in ipairs(SongGroups) do
		MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
			Name = SongGroups[i],
			Banner = SONGMAN:GetSongGroupBannerPath(SongGroups[i]),
			Songs = SONGMAN:GetSongsInGroup(SongGroups[i])
		}
        
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
	end
    
    -- If nothing is available, remove the main entry completely
    if #MasterGroupsList[#MasterGroupsList].SubGroups == 0 then table.remove(MasterGroupsList) end
    
    -- ======================================== Song titles ========================================
    local Alphabet = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "#"}
    local TitleGroups = {}
    local SongInserted = false
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Title",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {}
    }
    
    for j, Song in ipairs(AllSongs) do
        SongInserted = false
        for i, Letter in ipairs(Alphabet) do
            if string.upper(Song:GetDisplayMainTitle():sub(1, 1)) == Letter then
                if TitleGroups[Letter] == nil then TitleGroups[Letter] = {} end
                table.insert(TitleGroups[Letter], Song)
                SongInserted = true
                break
            end
		end
        
        if SongInserted == false then
            if TitleGroups["#"] == nil then TitleGroups["#"] = {} end
            table.insert(TitleGroups["#"], Song)
        end
    end
    
    for i, v in pairs(Alphabet) do
        if TitleGroups[v] ~= nil then
            table.sort(TitleGroups[v], SortSongsByTitle)
            MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
                Name = v,
                Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
                Songs = TitleGroups[v],
            }
            
            Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
            MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
            #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
        end
	end
    
    -- If nothing is available, remove the main entry completely
    if #MasterGroupsList[#MasterGroupsList].SubGroups == 0 then table.remove(MasterGroupsList) end
    
    -- ======================================== Song artists ========================================
    local ArtistGroups = {}
    local SongInserted = false
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Artist",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {}
    }
    
    for j, Song in ipairs(AllSongs) do
        SongInserted = false
        
        for i, Letter in ipairs(Alphabet) do
            if string.upper(Song:GetDisplayArtist():sub(1, 1)) == Letter then
                if ArtistGroups[Letter] == nil then ArtistGroups[Letter] = {} end
                table.insert(ArtistGroups[Letter], Song)
                SongInserted = true
                break
            end
		end
        
        if SongInserted == false then
            if ArtistGroups["#"] == nil then ArtistGroups["#"] = {} end
            table.insert(ArtistGroups["#"], Song)
        end
    end
    
    for i, v in pairs(Alphabet) do
        if ArtistGroups[v] ~= nil then
            table.sort(ArtistGroups[v], SortSongsByTitle)
            MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
                Name = v,
                Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
                Songs = ArtistGroups[v],
            }
            
            Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
            MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
            #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
        end
	end
    
    -- If nothing is available, remove the main entry completely
    if #MasterGroupsList[#MasterGroupsList].SubGroups == 0 then table.remove(MasterGroupsList) end
    
    -- ======================================== Single levels ========================================
    local LevelGroups = {}
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Single",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {}
    }
    
    for j, Song in ipairs(AllSongs) do
        for i, Chart in ipairs(Song:GetAllSteps()) do
            -- Filter out unwanted charts
            local ShouldRemove = false

            if not ShowUCS and string.find(ToUpper(Chart:GetDescription()), "UCS") then ShouldRemove = true
            elseif not ShowQuest and string.find(ToUpper(Chart:GetDescription()), "QUEST") then ShouldRemove = true
            elseif not ShowHidden and string.find(ToUpper(Chart:GetDescription()), "HIDDEN") then ShouldRemove = true end
            
            if ToEnumShortString(ToEnumShortString(Chart:GetStepsType())) == "Single" and not ShouldRemove then
                local ChartLevel = Chart:GetMeter()
                if LevelGroups[ChartLevel] == nil then LevelGroups[ChartLevel] = {} end
                if not HasValue(LevelGroups[ChartLevel], Song) then
                    table.insert(LevelGroups[ChartLevel], Song) 
                end
            end
		end
    end
    
    for i, v in PairsByKeys(LevelGroups) do
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Single " .. i,
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = v,
        }
        
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
	end
    
    -- If nothing is available, remove the main entry completely
    if #MasterGroupsList[#MasterGroupsList].SubGroups == 0 then table.remove(MasterGroupsList) end
    
    -- ======================================== Halfdouble levels ========================================
    LevelGroups = {}
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Half-Double",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {}
    }
    
    for j, Song in ipairs(AllSongs) do
        for i, Chart in ipairs(Song:GetAllSteps()) do
            -- Filter out unwanted charts
            local ShouldRemove = false

            if not ShowUCS and string.find(ToUpper(Chart:GetDescription()), "UCS") then ShouldRemove = true
            elseif not ShowQuest and string.find(ToUpper(Chart:GetDescription()), "QUEST") then ShouldRemove = true
            elseif not ShowHidden and string.find(ToUpper(Chart:GetDescription()), "HIDDEN") then ShouldRemove = true end
            
            if ToEnumShortString(ToEnumShortString(Chart:GetStepsType())) == "Halfdouble" and not ShouldRemove then
                local ChartLevel = Chart:GetMeter()
                if LevelGroups[ChartLevel] == nil then LevelGroups[ChartLevel] = {} end
                if not HasValue(LevelGroups[ChartLevel], Song) then
                    table.insert(LevelGroups[ChartLevel], Song) 
                end
            end
		end
    end
    
    for i, v in PairsByKeys(LevelGroups) do
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Half-Double " .. i,
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = v,
        }
        
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
	end
    
    -- If nothing is available, remove the main entry completely
    if #MasterGroupsList[#MasterGroupsList].SubGroups == 0 then table.remove(MasterGroupsList) end
    
    -- ======================================== Double levels ========================================
    LevelGroups = {}
    MasterGroupsList[#MasterGroupsList + 1] = {
        Name = "Double",
        Banner = THEME:GetPathG("", "Common fallback banner"),
        SubGroups = {}
    }
    
    for j, Song in ipairs(AllSongs) do
        for i, Chart in ipairs(Song:GetAllSteps()) do
            -- Filter out unwanted charts
            local ShouldRemove = false

            if not ShowUCS and string.find(ToUpper(Chart:GetDescription()), "UCS") then ShouldRemove = true
            elseif not ShowQuest and string.find(ToUpper(Chart:GetDescription()), "QUEST") then ShouldRemove = true
            elseif not ShowHidden and string.find(ToUpper(Chart:GetDescription()), "HIDDEN") then ShouldRemove = true end
            
            if ToEnumShortString(ToEnumShortString(Chart:GetStepsType())) == "Double" and not ShouldRemove then
                local ChartLevel = Chart:GetMeter()
                if LevelGroups[ChartLevel] == nil then LevelGroups[ChartLevel] = {} end
                if not HasValue(LevelGroups[ChartLevel], Song) then
                    table.insert(LevelGroups[ChartLevel], Song) 
                end
            end
		end
    end
    
    for i, v in PairsByKeys(LevelGroups) do
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups + 1] = {
            Name = "Double " .. i,
            Banner = THEME:GetPathG("", "Common fallback banner"), -- something appending v at the end
            Songs = v,
        }
        
        Trace("Group added: " .. MasterGroupsList[#MasterGroupsList].Name .. "/" .. 
        MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Name  .. " - " .. 
        #MasterGroupsList[#MasterGroupsList].SubGroups[#MasterGroupsList[#MasterGroupsList].SubGroups].Songs .. " songs")
	end
    
    -- If nothing is available, remove the main entry completely
    if #MasterGroupsList[#MasterGroupsList].SubGroups == 0 then table.remove(MasterGroupsList) end
	
	Trace("Group sorting created!")
end

function UpdateGroupSorting()
    Trace("Creating group list copy from master...")
    GroupsList = deepcopy(MasterGroupsList)
    
    Trace("Removing unplayable songs from list...")
    for MainGroup in pairs(GroupsList) do
        for SubGroup in pairs(GroupsList[MainGroup].SubGroups) do
            GroupsList[MainGroup].SubGroups[SubGroup].Songs = PlayableSongs(GroupsList[MainGroup].SubGroups[SubGroup].Songs)
            
            if #GroupsList[MainGroup].SubGroups[SubGroup].Songs == 0 then
                table.remove(GroupsList[MainGroup].SubGroups, SubGroup)
            end
        end
        
        if #GroupsList[MainGroup].SubGroups == 0 then
            table.remove(GroupsList, MainGroup)
        end
    end
    
    MESSAGEMAN:Broadcast("UpdateChartDisplay")
    Trace("Group sorting updated!")
end
