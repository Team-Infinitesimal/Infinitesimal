local t = Def.ActorFrame{

    LoadActor(THEME:GetPathG("","logo"))..{
        InitCommand=function(self)
            self:Center()
            :zoom(0.5,0.5)
            end;
    };

    LoadActor(THEME:GetPathG("","logoBlur"))..{
        InitCommand=function(self)
            self:Center()
            :zoom(0.49,0.49)
            :diffusealpha(0)
            :queuecommand("Flash")
            end;
        FlashCommand=function(self)
            self:sleep(3)
            :decelerate(1)
            :diffusealpha(0.75)
            :sleep(0.75)
            :accelerate(1)
            :diffusealpha(0)
            :queuecommand("Flash")
            end;
    };

    LoadActor(THEME:GetPathG("","PressCenterStep"))..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X-320,300)
            :zoom(0.75,0.75)
            end;
    };

    LoadActor(THEME:GetPathG("","PressCenterStep"))..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X+320,300)
            :zoom(0.75,0.75)
            end;
    };
};

return t;
