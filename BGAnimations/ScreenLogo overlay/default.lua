local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","logo"))..{
        InitCommand=function(self)
            self:Center()
            :zoom(0.5,0.5)
            :diffusealpha(1)
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

    Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            :zoomto(SCREEN_WIDTH+10,SCREEN_HEIGHT+10)
            end;

        OnCommand=function(self)
            self:sleep(0.5)
            :diffuse(1,1,1,1)
            :decelerate(1)
            :diffusealpha(0)
            end;
    };
};

return t;
