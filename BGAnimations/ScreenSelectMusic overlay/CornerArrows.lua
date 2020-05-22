local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","ShiftUL"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :horizalign(left)
            :vertalign(top)
            :xy(SCREEN_LEFT+200,SCREEN_TOP+200)
            :decelerate(0.75)
            :xy(SCREEN_LEFT+10,SCREEN_TOP+10)
        end;
    };

    LoadActor(THEME:GetPathG("","ShiftUR"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :horizalign(right)
            :vertalign(top)
            :xy(SCREEN_RIGHT-200,SCREEN_TOP+200)
            :decelerate(0.75)
            :xy(SCREEN_RIGHT-10,SCREEN_TOP+10)
        end;
    };

    LoadActor(THEME:GetPathG("","ShiftDL"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :horizalign(left)
            :vertalign(bottom)
            :xy(SCREEN_LEFT+200,SCREEN_BOTTOM-200)
            :decelerate(0.75)
            :xy(SCREEN_LEFT+10,SCREEN_BOTTOM-10)
        end;
    };

    LoadActor(THEME:GetPathG("","ShiftDR"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :horizalign(right)
            :vertalign(bottom)
            :xy(SCREEN_RIGHT-200,SCREEN_BOTTOM-200)
            :decelerate(0.75)
            :xy(SCREEN_RIGHT-10,SCREEN_BOTTOM-10)
        end;
    };
};

return t;
