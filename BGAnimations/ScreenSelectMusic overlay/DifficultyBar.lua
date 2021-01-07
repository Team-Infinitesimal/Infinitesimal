local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","DiffBar"))..{
        InitCommand=function(self)
            self:zoom(0.73)
            :x(SCREEN_CENTER_X)
            :y(SCREEN_CENTER_Y+50)
        end;
    };

    LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
        InitCommand=function(self)
            self:x(SCREEN_CENTER_X)
            :y(99)
        end;
    };
};

return t;
