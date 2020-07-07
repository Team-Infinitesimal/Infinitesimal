local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","bg"))..{
        InitCommand=function(self)
            self:Center()
            :diffusealpha(0.25)
            :zoomto(SCREEN_WIDTH,SCREEN_HEIGHT)
            end;
    };
};

return t;
