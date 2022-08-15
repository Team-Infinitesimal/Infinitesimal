local Songs = {}

for Song in ivalues(SONGMAN:GetPreferredSortSongs()) do
	if SongUtil.GetPlayableSteps(Song) then
		Songs[#Songs+1] = Song
	end
end

local CurrentIndex = math.random(#Songs)
local PrevIndex = CurrentIndex
local SongIsChosen = false

local function InputHandler(event)
	local pn = event.PlayerNumber
    if not pn then return end
    
    -- To avoid control from a player that has not joined, filter the inputs out
    if pn == PLAYER_1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then return end
    if pn == PLAYER_2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then return end
    
    if not SongIsChosen then
        -- Don't want to move when releasing the button
        if event.type == "InputEventType_Release" then return end
        
        local button = event.button
        if button == "Left" or button == "MenuLeft" or button == "DownLeft" then
            PrevIndex = CurrentIndex
            CurrentIndex = CurrentIndex - 1
            if CurrentIndex < 1 then CurrentIndex = #Songs end
            GAMESTATE:SetCurrentSong(Songs[CurrentIndex])
            MESSAGEMAN:Broadcast("MusicWheelLeft")
            
        elseif button == "Right" or button == "MenuRight" or button == "DownRight" then
            PrevIndex = CurrentIndex
            CurrentIndex = CurrentIndex + 1
            if CurrentIndex > #Songs then CurrentIndex = 1 end
            GAMESTATE:SetCurrentSong(Songs[CurrentIndex])
            MESSAGEMAN:Broadcast("MusicWheelRight")
            
        elseif button == "Start" or button == "MenuStart" or button == "Center" then
            MESSAGEMAN:Broadcast("MusicWheelStart")
            
        elseif button == "Back" then
            SCREENMAN:GetTopScreen():Cancel()
        end
    end
	
	MESSAGEMAN:Broadcast("UpdateMusic")
end

local t = Def.ActorFrame {
    OnCommand=function(self)
        GAMESTATE:SetCurrentSong(Songs[CurrentIndex])
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler) 
        self:playcommand("Refresh")
    end,
    
    -- Prevent the song list from moving when transitioning
    OffCommand=function(self)
        SongIsChosen = true
    end,
    
    -- Update song list
    CurrentSongChangedMessageCommand=function(self) 
        self:playcommand("Refresh"):stoptweening()
        
        -- Play song preview
        SOUND:StopMusic()
        self:sleep(0.25):queuecommand("PlayMusic")
    end,
    
    -- Race condition workaround (yuck)
    MusicWheelStartMessageCommand=function(self) self:sleep(0.01):queuecommand("Confirm") end,
    ConfirmCommand=function(self) MESSAGEMAN:Broadcast("SongChosen") end,
    
    -- These are to control the functionality of the music wheel
    SongChosenMessageCommand=function(self) SongIsChosen = true self:playcommand("Refresh") end,
    SongUnchosenMessageCommand=function(self) SongIsChosen = false self:playcommand("Refresh") end,

    -- Play song preview (thanks Luizsan)
    PlayMusicCommand=function(self)
        local Song = GAMESTATE:GetCurrentSong()
        if Song then
            SOUND:PlayMusicPart(Song:GetMusicPath(), Song:GetSampleStart(), Song:GetSampleLength(), 0, 1, false, false, false, Song:GetTimingData())
        end
    end,
    
    Def.Sound {
        File=THEME:GetPathS("MusicWheel", "change"),
        IsAction=true,
        CurrentSongChangedMessageCommand=function(self) if CurrentIndex ~= PrevIndex then self:play() end end
    },
    
    Def.Sound {
        File=THEME:GetPathS("Common", "Start"),
        IsAction=true,
        MusicWheelStartMessageCommand=function(self) self:play() end
    },
}

local Scroller = Def.ActorScroller {
    NumItemsToDraw=9,
    SecondsPerItem=0.1,
    LoopScroller=true,
    WrapScroller=true,
    TransformFunction=function(self, OffsetFromCenter, ItemIndex, NumItems) 
        local Spacing = math.abs(math.sin(OffsetFromCenter / math.pi))
        self:x(OffsetFromCenter * (250 - Spacing * 100))
        self:rotationy(clamp(OffsetFromCenter * 36, -85, 85))
        self:z(-math.abs(OffsetFromCenter))
        
        self:zoom(clamp(1.1 - (math.abs(OffsetFromCenter) / 3), 0.8, 1.1))
    end,
    
    InitCommand=function(self) 
        self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 150):fov(90)
        :vanishpoint(SCREEN_CENTER_X,SCREEN_BOTTOM-150):SetDrawByZPosition(true)
    end,
    
    OnCommand=function(self)
        self:stoptweening():easeoutexpo(1):y(SCREEN_BOTTOM-150)
        :SetCurrentAndDestinationItem(CurrentIndex - 1)
    end,
    OffCommand=function(self) self:stoptweening():easeoutexpo(0.5):y(SCREEN_BOTTOM-150) end,
    
    CurrentSongChangedMessageCommand=function(self) 
        self:SetDestinationItem(CurrentIndex - 1)
    end,
    
    SongChosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.5):y(SCREEN_BOTTOM+150) end,
    SongUnchosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.5):y(SCREEN_BOTTOM-150) end,
}

for i,v in ipairs(Songs) do
    Scroller[#Scroller+1] = Def.ActorFrame {
        Def.Banner {
            InitCommand=function(self)
                self:LoadFromSongBanner(Songs[i]):scaletoclipped(212, 120)
            end
        },

        Def.Sprite {
            Texture=THEME:GetPathG("", "MusicWheel/SongFrame"),
        },

        Def.ActorFrame {
            Def.Quad {
                InitCommand=function(self)
                    self:zoomto(60, 18):addy(-50):diffuse(0,0,0,0.6):fadeleft(0.3):faderight(0.3)
                end
            },

            Def.BitmapText {
                Font="Montserrat semibold 40px",
                InitCommand=function(self)
                    self:addy(-50):zoom(0.4):skewx(-0.1):diffusetopedge(0.95,0.95,0.95,0.8):shadowlength(1.5):settext(i)
                end
            }
        }
    }
end

t[#t+1] = Scroller

return t