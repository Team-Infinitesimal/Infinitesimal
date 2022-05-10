local t = Def.ActorFrame {
    OnCommand=function(self)
        -- Change default sort to Basic Mode songs only
        SCREENMAN:GetTopScreen():GetMusicWheel():ChangeSort("SortOrder_Preferred")
        SONGMAN:SetPreferredSongs("BasicMode")
    end,
    
    Def.Sound {
        File=THEME:GetPathS("Common", "start"),
        IsAction=true,
        CodeMessageCommand=function(self, params)
            if params.Name == "FullMode" then
                self:play()
                SOUND:DimMusic(0, 1)
                SCREENMAN:GetTopScreen():GetMusicWheel():Move(0)
                SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusic")
                SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
            end
        end
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

return t