local WheelSize = 13
local WheelCenter = math.ceil( WheelSize * 0.5 )
local WheelItem = { Width = 212, Height = 120 }
local WheelSpacing = 250
local WheelRotation = 0.1

local ScreenSelectMusic
local IsHome = GAMESTATE:GetCoinMode() == "CoinMode_Home"
local IsEvent = GAMESTATE:IsEventMode()
local TickCount = 0 -- Used for InputEventType_Repeat

local IsOptionsList = { PLAYER_1 = false, PLAYER_2 = false }
local IsBusy = false
local Groups = {}
local GroupSongNums = {}
local Targets = {}

local function BlockScreenInput(State)
    SCREENMAN:set_input_redirected(PLAYER_1, State)
    SCREENMAN:set_input_redirected(PLAYER_2, State)
end

-- If no groups (lol how) don't load anything
if SONGMAN:GetNumSongGroups() == 0 then
    return Def.Actor {}
else

-- Iterate through the song groups and check if they have AT LEAST one song with valid charts.
-- If so, add them to the group list.
for Group in ivalues(SONGMAN:GetSongGroupNames()) do
    for Song in ivalues(SONGMAN:GetSongsInGroup(Group)) do
        if #SongUtil.GetPlayableSteps(Song) > 0 then
            Groups[#Groups+1] = Group
            break
        end
    end
end

for Group in ivalues(Groups) do
    GroupSongNums[Group] = #SONGMAN:GetSongsInGroup(Group)
end

local CurrentIndex = 1

local IsSelectingGroup = false

local function InputHandler(event)
	local pn = event.PlayerNumber
    if not pn then return end
    
    -- Don't want to move when releasing the button
    if event.type == "InputEventType_Release" then 
        TickCount = 0 
        MESSAGEMAN:Broadcast("ExitTickDown")
        return
    end
    
    local button = event.button
    
    -- To avoid control from a player that has not joined, filter the inputs out
    if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
    if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end
    
    if IsSelectingGroup then
        if button == "Left" or button == "MenuLeft" or button == "DownLeft" then
            CurrentIndex = CurrentIndex - 1
            if CurrentIndex < 1 then CurrentIndex = #Groups end
            
            UpdateItemTargets(CurrentIndex)
            MESSAGEMAN:Broadcast("Scroll", { Direction = -1 })

        elseif button == "Right" or button == "MenuRight" or button == "DownRight" then
            CurrentIndex = CurrentIndex + 1
            if CurrentIndex > #Groups then CurrentIndex = 1 end
            
            UpdateItemTargets(CurrentIndex)
            MESSAGEMAN:Broadcast("Scroll", { Direction = 1 })

        elseif button == "Start" or button == "MenuStart" or button == "Center" then
            ScreenSelectMusic:GetChild('MusicWheel'):SetOpenSection(Groups[CurrentIndex])
            MESSAGEMAN:Broadcast("CloseGroupWheel")
            
        elseif button == "UpRight" or button == "UpLeft" or button == "Up" then
            if IsHome or IsEvent then MESSAGEMAN:Broadcast("ExitPressed") end
        end

        if IsHome or IsEvent then
            if event.type == "InputEventType_Repeat" then
                if button == "UpLeft" or button == "UpRight" or button == "Up" then
                    TickCount = TickCount + 1
                    MESSAGEMAN:Broadcast("ExitTickUp")
                    if TickCount == 15 then
                        BlockScreenInput(false)
                        SCREENMAN:GetTopScreen():Cancel()
                    end
                end
            end
        end
    end

	MESSAGEMAN:Broadcast("UpdateMusic")
end

-- Update Songs item targets
function UpdateItemTargets(val)
    for i = 1, WheelSize do
        Targets[i] = val + i - WheelCenter
        -- Wrap to fit to Songs list size
        while Targets[i] > #Groups do Targets[i] = Targets[i] - #Groups end
        while Targets[i] < 1 do Targets[i] = Targets[i] + #Groups end
    end
end

-- Manages banner on sprite
function UpdateBanner(self, Group)
    local Banner = SONGMAN:GetSongGroupBannerPath(Group)
    if Banner == "" then Banner = THEME:GetPathG("Common fallback", "banner") end
    self:Load(Banner):scaletofit(-WheelItem.Width / 2, -WheelItem.Height / 2, WheelItem.Width / 2, WheelItem.Height / 2)
end

local t = Def.ActorFrame {
    InitCommand=function(self)
        self:fov(90):SetDrawByZPosition(true)
        :vanishpoint(SCREEN_CENTER_X, SCREEN_CENTER_Y):diffusealpha(0)
        UpdateItemTargets(CurrentIndex)
    end,

    OnCommand=function(self)
        BlockScreenInput(false)
        ScreenSelectMusic = SCREENMAN:GetTopScreen()
        
        -- Make sure to start the group wheel where the current song is located (if available)
        if GAMESTATE:GetCurrentSong() then
            for Index, Group in ipairs(Groups) do
                if GAMESTATE:GetCurrentSong():GetGroupName() == Group then
                    -- SCREENMAN:SystemMessage(Index .. " - " .. Group)
                    CurrentIndex = Index
                    UpdateItemTargets(CurrentIndex)
                    break
                end
            end
        end
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
    end,
    
    OffCommand=function(self) BlockScreenInput(false) end,
    
    SongChosenMessageCommand=function(self) IsBusy = true end,
    SongUnchosenMessageCommand=function(self) self:queuecommand("NotBusy") end,
    NotBusyCommand=function(self) IsBusy = false end,
    
    OptionsListOpenedMessageCommand=function(self, params) IsOptionsList[params.Player] = true end,
    OptionsListClosedMessageCommand=function(self, params) IsOptionsList[params.Player] = false end,

    CodeMessageCommand=function(self, params)
        if params.Name == "GroupSelectPad1" or params.Name == "GroupSelectPad2" or 
        params.Name == "GroupSelectButton1" or params.Name == "GroupSelectButton2" then
            if not IsBusy and not IsOptionsList[PLAYER_1] and not IsOptionsList[PLAYER_2] then
                -- Prevent the song list from moving when transitioning
                BlockScreenInput(true)
                IsSelectingGroup = true
                MESSAGEMAN:Broadcast("OpenGroupWheel")
                self:finishtweening():easeoutexpo(1):diffusealpha(1)
            end
        end
    end,
    
    BusyCommand=function(self) IsBusy = true end,
    NotBusyCommand=function(self) IsBusy = false end,
    
    CloseGroupWheelMessageCommand=function(self)
        self:stoptweening():easeoutexpo(0.25):diffusealpha(0)
        
        BlockScreenInput(false)
        IsSelectingGroup = false
        
        -- The built in wheel needs to be told the group has been changed
        SCREENMAN:GetTopScreen():PostScreenMessage("SM_SongChanged", 0 )
        MESSAGEMAN:Broadcast("StartSelectingSong")
    end,

    Def.Sound {
        File=THEME:GetPathS("MusicWheel", "change"),
        IsAction=true,
        ScrollMessageCommand=function(self) self:play() end
    },

    Def.Sound {
        File=THEME:GetPathS("Common", "Start"),
        IsAction=true,
        CloseGroupWheelMessageCommand=function(self) self:play() end
    },
}

-- The Wheel: originally made by Luizsan
for i = 1, WheelSize do
    t[#t+1] = Def.ActorFrame{
        OnCommand=function(self)
            -- Load banner
            UpdateBanner(self:GetChild("Banner"), Groups[Targets[i]])

            -- Set initial position, Direction = 0 means it won't tween
            self:playcommand("Scroll", {Direction = 0})
        end,

        ScrollMessageCommand=function(self, params)
            self:stoptweening()

            -- Calculate position
            local xpos = SCREEN_CENTER_X + (i - WheelCenter) * WheelSpacing

            -- Calculate displacement based on input
            local displace = -params.Direction * WheelSpacing

            -- Only tween if a direction was specified
            local tween = params and params.Direction and math.abs(params.Direction) > 0
            
            -- Adjust and wrap actor index
            i = i - params.Direction
            while i > WheelSize do i = i - WheelSize end
            while i < 1 do i = i + WheelSize end

            -- If it's an edge item, load a new banner. Edge items should never tween
            if i == 2 or i == WheelSize - 1 then
				UpdateBanner(self:GetChild("Banner"), Groups[Targets[i]])
            elseif tween then
                self:easeoutexpo(0.4)
            end

            -- Animate!
            self:xy(xpos + displace, SCREEN_CENTER_Y)
            self:rotationy((SCREEN_CENTER_X - xpos - displace) * -WheelRotation)
            self:z(-math.abs(SCREEN_CENTER_X - xpos - displace) * 0.25)
            self:GetChild(""):GetChild("Index"):playcommand("Refresh")
            self:GetChild("GroupInfo"):playcommand("Refresh")
        end,
        
        Def.Sprite {
            Texture=THEME:GetPathG("", "MusicWheel/GradientBanner"),
            InitCommand=function(self) self:scaletoclipped(WheelItem.Width, WheelItem.Height) end
        },

        Def.Banner {
            Name="Banner",
        },

        Def.Sprite {
            Texture=THEME:GetPathG("", "MusicWheel/GroupFrame"),
        },

        Def.ActorFrame {
            Def.Quad {
                InitCommand=function(self)
                    self:zoomto(60, 18):addy(-50)
                    :diffuse(0,0,0,0.6)
                    :fadeleft(0.3):faderight(0.3)
                end
            },

            Def.BitmapText {
                Name="Index",
                Font="Montserrat semibold 40px",
                InitCommand=function(self)
                    self:addy(-50):zoom(0.4):skewx(-0.1):diffusetopedge(0.95,0.95,0.95,0.8):shadowlength(1.5)
                end,
                RefreshCommand=function(self, params) self:settext(Targets[i]) end
            }
        },
        
        Def.BitmapText {
            Name="GroupInfo",
            Font="Montserrat semibold 40px",
            InitCommand=function(self)
                self:addy(64):zoom(0.5):skewx(-0.1):diffusetopedge(0.95,0.95,0.95,0.8):shadowlength(1.5)
                :maxwidth(420):vertalign(0):wrapwidthpixels(420):vertspacing(-16)
            end,
            RefreshCommand=function(self, params) self:settext(Groups[Targets[i]] .. "\n" .. GroupSongNums[Groups[Targets[i]]] .. " Songs") end
        }
    }
end

t[#t+1] = Def.ActorFrame {
    Def.BitmapText {
        Font="Montserrat semibold 20px",
        Name="ExitText",
        InitCommand=function(self)
            self:diffusealpha(0)
            :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 125)
            :settext("Exiting...")
        end,
        ExitPressedMessageCommand=function(self)
            self:stoptweening():sleep(0.1)
            :linear(0.25)
            :diffusealpha(1)
        end,
        ExitTickDownMessageCommand=function(self)
            self:stoptweening()
            :easeoutexpo(0.25)
            :diffusealpha(0)
        end
    },

    Def.Quad {
        Name="ExitBar",
        InitCommand=function(self)
            self:zoomto(200,15)
            :cropright(1)
            :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 100)
            :diffuse(color("#f7931e")):diffusebottomedge(color("#ed1e79"))
        end,
        ExitTickUpMessageCommand=function(self)
            self:stoptweening()
            :linear(0.2)
            :cropright(1 - (TickCount + 1) / 15)
        end,
        ExitTickDownMessageCommand=function(self)
            self:stoptweening()
            :easeoutexpo(0.25)
            :cropright(1)
        end
    },

    Def.Quad {
        Name="ExitBarEnd",
        InitCommand=function(self)
            self:zoomto(5,15)
            :xy(SCREEN_CENTER_X - 100, SCREEN_CENTER_Y - 100)
            :diffuse(1,1,1,0)
        end,
        ExitPressedMessageCommand=function(self)
            self:sleep(0.2)
            :diffusealpha(1)
            :easeoutquad(0.5)
            :x(SCREEN_CENTER_X + 100)
        end,
        ExitTickDownMessageCommand=function(self)
            self:stoptweening()
            :easeoutquad(0.25)
            :diffusealpha(0)
            :x(SCREEN_CENTER_X - 100)
        end
    }
}

return t

end