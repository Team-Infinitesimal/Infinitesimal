local pn = ...
local IconW = 64
local IconH = 44
local IconAmount = 8

local pnNum = (pn == PLAYER_1) and 0 or 1
local PlayerMods = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
local PlayerModsArray = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred")

-- A list of mods we do not want to display through the icons
local PlayerModsBlacklist = {
    "Overhead",
    "FailImmediateContinue",
    "FailAtEnd",
    "FailOff"
}

-- https://stackoverflow.com/a/32806646
local function removeFirst(tbl, val)
    for i, v in ipairs(tbl) do
        if ToLower(v) == ToLower(val) then
            return table.remove(tbl, i)
        end
    end
end

local t = Def.ActorFrame {
    -- Dynamic icons that will require updating at every options change
    InitCommand=function(self) self:queuecommand("Refresh") end,
    OptionsListStartMessageCommand=function(self) self:queuecommand("Refresh") end,
    RefreshCommand=function(self)
        -- Clean up the list of additional icons
        for i = 1, IconAmount do
            self:GetChild("IconFrame")[i]:GetChild("Icon"):visible(false)
            self:GetChild("IconFrame")[i]:GetChild("Text"):visible(false):settext("")
        end
        local IconCount = 1
        
        -- Update the local mods
        PlayerMods = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
        PlayerModsArray = GAMESTATE:GetPlayerState(pn):GetPlayerOptionsArray("ModsLevel_Preferred")
        
        -- Remove unneeded strings from the blacklist and Noteskin (displayed as an icon instead)
        for i, BlacklistedMod in ipairs(PlayerModsBlacklist) do
            if string.find(ToLower(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Current")), ToLower(BlacklistedMod)) ~= nil then
                removeFirst(PlayerModsArray, BlacklistedMod)
            end
        end
        
        local CurNoteSkin = PlayerMods:NoteSkin()
        local OptionsNoteskin = ToLower(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Current"))
        -- Hyphens will break string searching, we need to remove them and any anything else that could break
        if string.match(string.gsub(OptionsNoteskin, "%p", ""), string.gsub(CurNoteSkin, "%p", "")) ~= nil then
            removeFirst(PlayerModsArray, CurNoteSkin)
        end
        
        -- 1x is not included in the engine list by default, so we need to do... this. Ew.
        if (PlayerMods:XMod() == 1 and 
            PlayerMods:MMod() == nil and 
            PlayerMods:CMod() == nil and 
            PlayerMods:AMod() == nil) then
            table.insert(PlayerModsArray, 1, "1x")
        end
        
        -- The following are Lua mods not contained in the engine's PlayerOptions
        -- BGA darkness
        local BGAFilter = LoadModule("Config.Load.lua")("ScreenFilter",CheckIfUserOrMachineProfile(pnNum).."/OutFoxPrefs.ini") or 0
        -- Increase the value so that we can use it as percentage
        BGAFilter = round(BGAFilter * 100)
        if BGAFilter ~= 0 then
            table.insert(PlayerModsArray, 2, THEME:GetString("ModIcons", "Filter") .. " " .. (BGAFilter == 100 and "Off" or BGAFilter .. "%"))
        end
        
        -- Timing mode
        local TimingMode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"
        -- We don't want to display NJ!
        if TimingMode and TimingMode ~= "Pump Normal" then
            table.insert(PlayerModsArray, TimingMode)
        end
        
        -- Music rate
        local RushAmount = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
        if RushAmount ~= nil then
            RushAmount = math.floor(RushAmount * 100)
            if RushAmount ~= 100 then
                table.insert(PlayerModsArray, THEME:GetString("ModIcons", "Rush") .. "\n" .. RushAmount)
            end
        end
        
        -- Translate all strings that come after speed mods and BGA filter
        for i = (BGAFilter ~= 0 and 3 or 2), #PlayerModsArray do
            local ModText = THEME:GetString("ModIcons", PlayerModsArray[i])
            -- Only override strings if translations are available
            if ModText ~= "" then PlayerModsArray[i] = ModText end
        end
        
        -- Populate all of the available icons
        for i = 1, (#PlayerModsArray > IconAmount and IconAmount or #PlayerModsArray) do
            self:GetChild("IconFrame")[i]:GetChild("Icon"):visible(true)
            self:GetChild("IconFrame")[i]:GetChild("Text"):visible(true):settext(PlayerModsArray[i])
            IconCount = i + 1
        end
    end,
    
    -- Noteskin display
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/ModIcon"),
        InitCommand=function(self) self:y(IconH) end
    }
}

-- This will be responsible for displaying the selected noteskin
t[#t+1] = Def.ActorProxy {
    OnCommand=function(self)
        self:y(IconH - 1)
        :zoom(0.6)
        :playcommand("Refresh")
    end,
    OptionsListStartMessageCommand=function(self) self:queuecommand("Refresh") end,
    RefreshCommand=function(self)
        if SCREENMAN:GetTopScreen() then
            local CurNoteSkin = PlayerMods:NoteSkin()
            self:SetTarget(SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)))
        end
    end
}

-- Create template icons that will be used depending on the active mods
for i = 1, IconAmount do
    t[#t+1] = Def.ActorFrame {
        Name="IconFrame",
        Def.Sprite {
            Name="Icon",
            Texture=THEME:GetPathG("", "UI/ModIcon"),
            InitCommand=function(self) 
                self:y((i > 1 and IconH or 0) + IconH * (i - 1))
                :visible(false)
            end
        },
        Def.BitmapText {
            Name="Text",
            Font="Montserrat semibold 40px",
            InitCommand=function(self)
                self:y((i > 1 and IconH or 0) + IconH * (i - 1) - 1)
                :zoom(0.5):vertspacing(-20)
                :wrapwidthpixels((IconW - 4) / self:GetZoom())
                :maxwidth((IconW - 4) / self:GetZoom())
                :maxheight((IconH - 4) / self:GetZoom())
                :visible(false)
            end
        }
    }
end

return t