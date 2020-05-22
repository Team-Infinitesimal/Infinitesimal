local t = Def.ActorFrame {

    LoadActor("ChartInfoP1")..{
        Initcommand=function(self)
            self:diffusealpha(0)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
        end;
    };

    LoadActor("ChartInfoP2")..{
        Initcommand=function(self)
            self:diffusealpha(0)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
        end;
    };
};

return t;
