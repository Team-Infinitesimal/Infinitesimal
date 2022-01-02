local t = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
        end,
        
        SongChosenMessageCommand=function(self) 
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y-40):zoom(0.9) 
        end,
        SongUnchosenMessageCommand=function(self) 
            self:stoptweening():easeoutexpo(0.5):y(SCREEN_CENTER_Y):zoom(1)
        end,
        
        LoadActor("ScoreDisplay", 0, -100),
        
        LoadActor("SongPreview", 0, -100),
        
        Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/Bar"),
            InitCommand=function(self) self:y(85):zoom(1.2) end
        },
        
        LoadActor("ChartDisplay", 0, 85, 12),
    }
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {        
        LoadActor("../ModIcons.lua", pn == PLAYER_2 and SCREEN_RIGHT - 16 or 16, 160, pn),
    }
end

return t