local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","bg"))..{
        InitCommand=function(self)
            self:Center()
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
            :diffusealpha(0.8)
            end;
    };
    
    LoadActor(THEME:GetPathG("","ScreenHudTop"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(top)
			:zoom(0.835)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
            :diffusealpha(1)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_TOP)
        end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudBottom"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(bottom)
			:zoom(0.835)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100)
            :diffusealpha(1)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_BOTTOM)
        end;
    };
};

return t;
