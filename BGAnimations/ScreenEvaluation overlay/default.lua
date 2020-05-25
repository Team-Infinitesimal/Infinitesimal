local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","EvalElements/GridLines"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoomx(0)
            :zoomy(0.1)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            end;
        OnCommand=function(self)
            self:sleep(1.25)
            :diffusealpha(0.25)
            :decelerate(0.5)
            :zoomx(0.15)
            end;
    };

    LoadActor(THEME:GetPathG("","EvalElements/CenterColumn"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoomy(0)
            :zoomx(0.1)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            end;
        OnCommand=function(self)
            self:sleep(1)
            :diffusealpha(1)
            :decelerate(0.3)
            :zoomy(0.1)
            end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudTop"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(top)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
            :diffusealpha(1)
            :zoom(0.2135,0.2135)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_TOP)
        end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudBottom"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(bottom)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100)
            :diffusealpha(1)
            :zoom(0.2135,0.2135)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_BOTTOM)
        end;
    };
};

return t;
