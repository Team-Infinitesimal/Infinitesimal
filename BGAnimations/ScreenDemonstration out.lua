local t = Def.ActorFrame{

    Def.Quad {
        InitCommand=function(self)
            self:Center()
            :zoomto(SCREEN_WIDTH+10,SCREEN_HEIGHT+10)
            end;

        OnCommand=function(self)
            self:diffuse(1,1,1,0)
            :accelerate(0.5)
            :diffusealpha(1)
            :sleep(0.5)
            end;
    };
};

return t;
