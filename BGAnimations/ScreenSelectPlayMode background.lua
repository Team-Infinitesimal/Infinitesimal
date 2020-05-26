local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","bg"))..{
        InitCommand=function(self)
            self:Center()
            :zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
            :diffusealpha(0.8)
            end;
    };
};

return t;
