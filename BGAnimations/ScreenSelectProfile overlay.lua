local CardItemW = 268
local CardItemH = 64

function GetLocalProfiles()
    local t = {}

    local NoProfileCard = Def.ActorFrame {
        Def.Sprite {
            Texture=THEME:GetPathG("UserProfile", "generic icon"),
            InitCommand=function(self)
                self:scaletofit(0, 0, 64, 64):xy(-CardItemW / 2 + 32, -3):ztest(true)
            end
        },

        Def.BitmapText {
            Font="Montserrat semibold 40px",
            Text="Guest",
            InitCommand=function(self)
                self:shadowlength(1):xy(CardItemW / 2 - 8, -3)
                :zoom(0.75):halign(1):maxwidth(250):ztest(true)
            end,
        }
    }
    t[#t+1] = NoProfileCard

    function GetSongsPlayedString(NumSongs)
        return NumSongs == 1 and Screen.String("SingularSongPlayed") or Screen.String("SeveralSongsPlayed")
    end

    for p = 0, PROFILEMAN:GetNumLocalProfiles() - 1 do
        local Profile = PROFILEMAN:GetLocalProfileFromIndex(p)
        local ProfileCard = Def.ActorFrame {
            Def.Sprite {
                Texture=THEME:GetPathG("UserProfile", "generic icon"),
                InitCommand=function(self)
                    local CustomAvatar = LoadModule("Config.Load.lua")("AvatarImage", "/Save/LocalProfiles/" .. PROFILEMAN:GetLocalProfileIDFromIndex(p) .. "/OutFoxPrefs.ini")
                    if CustomAvatar then self:Load(CustomAvatar) end

                    self:scaletofit(0, 0, 64, 64):xy(-CardItemW / 2 + 32, -3):ztest(true)
                end
            },

            Def.BitmapText {
                Font="Montserrat semibold 40px",
                Text=Profile:GetDisplayName(),
                InitCommand=function(self)
                    self:shadowlength(1):xy(CardItemW / 2 - 8, -14)
                    :zoom(0.75):halign(1):maxwidth(250):ztest(true)
                end,
            },

            Def.BitmapText {
                Font="Montserrat normal 20px",
                InitCommand=function(self) self:shadowlength(1):xy(CardItemW / 2 - 8, 14):zoom(0.75):halign(1):ztest(true) end,
                BeginCommand=function(self)
                    local NumSongsPlayed = Profile:GetNumTotalSongsPlayed()
                    self:settext(string.format(GetSongsPlayedString(NumSongsPlayed), NumSongsPlayed))
                end
            }
        }

        t[#t+1] = ProfileCard
    end

    return t
end

function LoadCard(cColor)
    local t = Def.ActorFrame {
        InitCommand=function(self) self:y(15):diffusealpha(0.75) end,

        Def.Sprite {
            Texture=THEME:GetPathG("", "UI/CardBackground"),
            InitCommand=function(self) self:y(15):zoom(0.75):diffuse(cColor) end
        },

        Def.Sprite {
            Texture=THEME:GetPathG("", "UI/CardFrame"),
            InitCommand=function(self) self:y(-15):zoom(0.75) end,
        }
    }

    return t
end

function LoadPlayerStuff(Player)
    local t = {}

    local pn = (Player == PLAYER_1) and 1 or 2

    t[#t+1] = Def.ActorFrame {
        Name = "JoinFrame",
        LoadCard(Color("Black")),

        LoadActor(THEME:GetPathG("", "PressCenterStep"))..{
            InitCommand=function(self) self:queuecommand("Refresh") end,
            StorageDevicesChangedMessageCommand=function(self)self:queuecommand("Refresh")end,
            RefreshCommand=function(self)
    			CardState = MEMCARDMAN:GetCardState(Player)
    			if CardState == "MemoryCardState_none" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/Press"))
    			elseif CardState == "MemoryCardState_ready" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/USB"))
    			elseif CardState == "MemoryCardState_error" then
    				self:GetChild("Press"):Load(THEME:GetPathG("", "PressCenterStep/Error"))
    			end
    		end
        }
    }

    t[#t+1] = Def.ActorFrame {
        Name = "BigFrame",
        LoadCard(Color("Black"))
    }

    t[#t+1] = Def.ActorFrame {
        Name = "SmallFrame",
        InitCommand=function(self) self:y(27) end,

        Def.Quad {
            InitCommand=function(self) self:zoomto(CardItemW, CardItemH) end,
            OnCommand=function(self) self:diffuse(Color("Black")):diffusealpha(0.5) end
        },

        Def.Quad {
            InitCommand=function(self) self:zoomto(CardItemW, CardItemH) end,
            OnCommand=function(self) self:diffuse(Color("Black")):fadeleft(0.25):faderight(0.25):glow(color("1,1,1,0.25")) end
        },

        Def.Quad {
            InitCommand=function(self) self:zoomto(CardItemW, CardItemH):y(-40 / 2 + 20) end,
            OnCommand=function(self) self:diffuse(Color("Black")):fadebottom(1):diffusealpha(0.35) end
        }
    }

    t[#t+1] = Def.ActorFrame {
        Name="GuestText",
        Def.BitmapText {
            Font="Montserrat semibold 40px",
            Text="No profile!",
            InitCommand=function(self) self:shadowlength(1) end
        }
    }

    t[#t+1] = Def.ActorScroller{
        Name="Scroller",
        NumItemsToDraw=8,
        OnCommand=function(self) self:y(30):SetFastCatchup(true):SetMask(300, 259):SetSecondsPerItem(0.1) end,
        TransformFunction=function(self, offset, itemIndex, numItems)
            self:visible(false):y(math.floor(offset * 64))
        end,
        children = GetLocalProfiles()
    }

    t[#t+1] = Def.ActorFrame {
        Name="EffectFrame",
        Def.Quad {
            InitCommand=function(self)
                self:zoomto(CardItemW, CardItemH):y(27)
                :diffuse(Color("White")):diffusealpha(0)
            end,
            OffCommand=function(self)
                self:diffusealpha(1):easeoutexpo(0.5)
                :zoomto(CardItemW * 2, CardItemH * 2):diffusealpha(0)
            end
        },
    }

    return t
end

function UpdateInternal3(self, Player)
    local pn = (Player == PLAYER_1) and 1 or 2
    local frame = self:GetChild(string.format("P%uFrame", pn))
    local scroller = frame:GetChild("Scroller")
    local seltext = frame:GetChild("SelectedProfileText")
    local joinframe = frame:GetChild("JoinFrame")
    local smallframe = frame:GetChild("SmallFrame")
    local bigframe = frame:GetChild("BigFrame")
    local guesttext = frame:GetChild("GuestText")
    local effectframe = frame:GetChild("EffectFrame")

    if GAMESTATE:IsHumanPlayer(Player) then
        frame:visible(true)
        if MEMCARDMAN:GetCardState(Player) == "MemoryCardState_none" then
            -- Using profile if any
            joinframe:visible(false)
            smallframe:visible(true)
            bigframe:visible(true)
            scroller:visible(true)
            effectframe:visible(true)
            guesttext:visible(false)
            local ind = SCREENMAN:GetTopScreen():GetProfileIndex(Player)
            if ind > 0 then
                scroller:SetDestinationItem(ind)
            else
                if SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0) then
                    scroller:SetDestinationItem(0)
                    --self:queuecommand("UpdateInternal2")
                else
                    joinframe:visible(false)
                    smallframe:visible(false)
                    bigframe:visible(true)
                    scroller:visible(false)
                    guesttext:visible(true)
                    effectframe:visible(false)
                    --seltext:settext("No profile")
                end
            end
        else
            -- Using card
            smallframe:visible(false)
            scroller:visible(false)
            guesttext:visible(false)
            effectframe:visible(true)
            SCREENMAN:GetTopScreen():SetProfileIndex(Player, 0)
        end
    else
        joinframe:visible(true)
        scroller:visible(false)
        smallframe:visible(false)
        bigframe:visible(false)
        guesttext:visible(false)
        effectframe:visible(false)
    end
end

local function InputHandler(event)
	local pn = event.PlayerNumber
    if not pn then return end

    -- Don't want to move when releasing the button
    if event.type == "InputEventType_Release" then return end

    local button = event.button
    if button == "Start" or button == "Center" then
        MESSAGEMAN:Broadcast("StartButton")
        if not GAMESTATE:IsHumanPlayer(pn) then
            SCREENMAN:GetTopScreen():SetProfileIndex(pn, -1)
        else
            if SCREENMAN:GetTopScreen():GetProfileIndex(pn) == 0 then
                setenv("IsBasicMode", true)
                SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
            else
                setenv("IsBasicMode", false)
                SCREENMAN:GetTopScreen():Finish()
            end
        end

    elseif button == "Up" or button == "MenuUp" or button == "MenuLeft" or button == "DownLeft" then
        if GAMESTATE:IsHumanPlayer(pn) then
            local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn)
            if ind >= 1 then
                if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind - 1) then
                    MESSAGEMAN:Broadcast("DirectionButton")
                end
            end
        end

    elseif button == "Down" or button == "MenuDown" or button == "MenuRight" or button == "DownRight" then
        if GAMESTATE:IsHumanPlayer(pn) then
            local ind = SCREENMAN:GetTopScreen():GetProfileIndex(pn)
            if ind >= 0 then
                if SCREENMAN:GetTopScreen():SetProfileIndex(pn, ind + 1) then
                    MESSAGEMAN:Broadcast("DirectionButton")
                end
            end
        end

    elseif button == "Back" then
        -- Let"s simplify things to avoid crashes whenever being utilized out of order
        SCREENMAN:GetTopScreen():Cancel()
    end
end

local t = Def.ActorFrame {
    OnCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
        self:queuecommand("UpdateInternal2")
    end,

    StorageDevicesChangedMessageCommand=function(self)
        self:queuecommand("UpdateInternal2")
    end,

    PlayerJoinedMessageCommand=function(self)
        self:queuecommand("UpdateInternal2")
    end,

    PlayerUnjoinedMessageCommand=function(self)
        self:queuecommand("UpdateInternal2")
    end,

    DirectionButtonMessageCommand=function(self)
        self:queuecommand("UpdateInternal2")
    end,

    UpdateInternal2Command=function(self)
        UpdateInternal3(self, PLAYER_1)
        UpdateInternal3(self, PLAYER_2)
    end,

    children = {
        Def.ActorFrame {
            Name="P1Frame",
            OnCommand=function(self) self:x(SCREEN_CENTER_X-200):y(SCREEN_CENTER_Y):zoom(0):easeoutexpo(1):zoom(1) end,
            OffCommand=function(self) self:stoptweening():easeinback(0.5):zoom(0) end,
            PlayerJoinedMessageCommand=function(self, params)
                if params.Player == PLAYER_1 then
                    self:stoptweening():zoom(1.15):easeoutexpo(0.25):zoom(1)
                end
            end,
            children=LoadPlayerStuff(PLAYER_1)
        },

        Def.ActorFrame {
            Name="P2Frame",
            OnCommand=function(self) self:x(SCREEN_CENTER_X+200):y(SCREEN_CENTER_Y):zoom(0):easeoutexpo(1):zoom(1) end,
            OffCommand=function(self) self:stoptweening():easeinback(0.5):zoom(0) end,
            PlayerJoinedMessageCommand=function(self, params)
                if params.Player == PLAYER_2 then
                    self:stoptweening():zoom(1.15):easeoutexpo(0.25):zoom(1)
                end
            end,
            children=LoadPlayerStuff(PLAYER_2)
        },

        -- Sounds!
        Def.Sound {
            File=THEME:GetPathS("Common", "start"),
            IsAction=true,
            StartButtonMessageCommand=function(self) self:play() end
        },

        Def.Sound {
            File=THEME:GetPathS("Common", "cancel"),
            IsAction=true,
            BackButtonMessageCommand=function(self) self:play() end
        },

        Def.Sound {
            File=THEME:GetPathS("Common", "value"),
            IsAction=true,
            DirectionButtonMessageCommand=function(self) self:play() end
        }
    }
}

return t
