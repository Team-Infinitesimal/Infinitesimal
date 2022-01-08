local ModIconX = IsUsingWideScreen() and 16 or 4

local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {
        LoadActor("../ModIcons", pn == PLAYER_2 and SCREEN_RIGHT - ModIconX or ModIconX, 160, pn),
    }
end

t[#t+1] = Def.ActorFrame {        
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y):zoom(0.5)
        end,
        SongChosenMessageCommand=function(self) 
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y + 95):zoom(1)
        end,
        SongUnchosenMessageCommand=function(self) 
            self:stoptweening():easeoutexpo(0.25):y(SCREEN_CENTER_Y):zoom(0.5)
        end,
        
        Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/InfoPanel"),
            InitCommand=function(self) self:y(85):zoom(0.75) end
        },
        
        LoadActor("ChartInfo")
    }
}

t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self) self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y) end,
        
        SongChosenMessageCommand=function(self) 
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y-40):zoom(0.9) 
        end,
        SongUnchosenMessageCommand=function(self) 
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y):zoom(1)
        end,
        
        LoadActor("ScoreDisplay") .. {
            InitCommand=function(self) self:y(-100) end
        },
        
        LoadActor("SongPreview") .. {
            InitCommand=function(self) self:y(-100) end
        },
        
        Def.ActorFrame {
            InitCommand=function(self) self:y(85) end,
            
            SongChosenMessageCommand=function(self) 
                self:stoptweening():easeoutexpo(0.5):y(94):zoom(1.25) 
            end,
            SongUnchosenMessageCommand=function(self) 
                self:stoptweening():easeoutexpo(0.5):y(85):zoom(1)
            end,
            
            Def.Sprite {
                Texture=THEME:GetPathG("", "DifficultyDisplay/Bar"),
                InitCommand=function(self) self:zoom(1.2) end,
                
            },
            
            LoadActor("ChartDisplay", 12)
        }
    }
}

return t