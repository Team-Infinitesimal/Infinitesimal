local t = Def.ActorFrame{

    Def.Quad {
        InitCommand=function(self)
            self:Center()
            :zoomto(SCREEN_WIDTH+10,SCREEN_HEIGHT+10)
            end;

        OnCommand=function(self)
            self:diffuse(0,0,0,1)
            :decelerate(0.5)
            :diffusealpha(0)
            :sleep(0.5)
            end;
    };
};

return t;
