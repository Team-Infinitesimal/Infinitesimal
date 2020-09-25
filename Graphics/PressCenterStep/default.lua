local t = Def.ActorFrame{

    LoadActor("centerstep")..{
        InitCommand=function(self)
            self:y(55)
            :zoom(0.5,0.5)
            end;
    };

    LoadActor("centerstep")..{
        InitCommand=function(self)
            self:y(55)
            :zoom(0.5,0.5)
            :diffusealpha(0)
            :queuecommand("FadeEffect")
            end;
        FadeEffectCommand=function(self)
            self:stoptweening()
            :zoom(0.5,0.5)
            :diffusealpha(0.75)
            :decelerate(0.3947)
            :zoom(0.56,0.56)
            :diffusealpha(0)
            :queuecommand("FadeEffect")
            end;
    };

    LoadActor("press")..{
        InitCommand=function(self)
            self:zoom(0.8,0.8)
            end;
        OnCommand=function(self)
            self:bounce()
            :sleep(1.1)
            :effectmagnitude(0,-18,0)
            :effectperiod(0.3947)
            end;
    };
};

return t;
