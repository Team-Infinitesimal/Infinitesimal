local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","bg"))..{
        InitCommand=function(self)
            self:Center()
            :diffusealpha(0.25)
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
            end;
    };
};

return t;
