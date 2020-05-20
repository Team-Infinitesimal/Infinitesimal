local t = Def.ActorFrame{

    LoadActor("centerstep")..{
        InitCommand=function(self)
            self:y(60)
            :zoom(0.2,0.2)
            end;
    };

    LoadActor("press")..{
        InitCommand=function(self)
            self:zoom(0.2,0.2)
            end;
        OnCommand=function(self)
            self:bounce()
            :effectmagnitude(0,-18,0)
            :effectperiod(0.75)
            end;
    };
};

return t;
