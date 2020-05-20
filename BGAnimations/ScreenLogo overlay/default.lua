local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","logo"))..{
        InitCommand=function(self)
            self:Center()
            :zoom(0.5,0.5)
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
