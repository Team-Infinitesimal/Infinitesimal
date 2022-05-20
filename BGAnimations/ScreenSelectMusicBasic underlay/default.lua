local t = Def.ActorFrame {
    Name="Base",
    OnCommand=function(self)
        -- Change default sort to Basic Mode songs only
        SONGMAN:SetPreferredSongs("BasicMode")
        SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort("SortOrder_Preferred")
        -- Also change the default song to start on... 
        -- If the game doesn't pick up the first song of the first folder available.
        local Songs = SONGMAN:GetPreferredSortSongs()
        SCREENMAN:GetTopScreen():GetMusicWheel():SelectSong(Songs[10])
        MESSAGEMAN:Broadcast("CurrentSongChanged")
    end,

    Def.Sound {
        Name="FullModeSound",
        File=THEME:GetPathS("", "FullMode"),
        IsAction=true
    }
}

t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, -SCREEN_CENTER_Y)
            :easeoutexpo(1):y(SCREEN_CENTER_Y)
        end,
        OffCommand=function(self)
            self:stoptweening():easeoutexpo(1):y(-SCREEN_CENTER_Y)
        end,

        LoadActor("SongPreview") .. {
            InitCommand=function(self) self:y(-100) end
        },

        Def.ActorFrame {
            InitCommand=function(self) self:y(85) end,

            SongChosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.5):y(160):zoom(2)
            end,
            SongUnchosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.5):y(85):zoom(1)
            end,

            Def.Sprite {
                Texture=THEME:GetPathG("", "DifficultyDisplay/ShortBar"),
                InitCommand=function(self) self:zoom(1.2) end
            },

            LoadActor("BasicChartDisplay", 4)
        }
    }
}

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
    local spacing = (IsUsingWideScreen() and 80 or 15)
    local width = (IsUsingWideScreen() and 200 or 175)
    local posx = (pn == PLAYER_1 and SCREEN_LEFT + spacing or SCREEN_RIGHT - (spacing + width + 10) )
    local title = "How To Play"
    local body = "Use &DOWNLEFT; and &DOWNRIGHT; to scroll through songs.\n" ..
                 "When you find a song you want to play, select it with "..
                 "&CENTER;, then pick a difficulty.\n"..
                 "If you change your mind, use &UPLEFT; or &UPRIGHT; "..
                 "to back out and pick another song."

    t[#t+1] = Def.ActorFrame {
        Name="TutorialMessage"..pn,
        LoadModule("UI.MessageBox.lua")(posx, SCREEN_CENTER_Y - 125, width, 15, title, body)
    }
end

t[#t+1] = Def.ActorFrame {

    LoadActor("FullModeAnim"),

    CodeCommand=function(self, params)
        if params.Name == "FullMode" then
            self:GetParent():GetChild("FullModeSound"):play()
            self:GetChild("FullModeAnim"):playcommand("Animate")
            self:sleep(1):queuecommand("FullModeTransition")
        end
    end,

    FullModeTransitionCommand=function()
        setenv("IsBasicMode", false)
        SCREENMAN:GetTopScreen():GetMusicWheel():Move(0)
        SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusic")
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    end
}

return t
