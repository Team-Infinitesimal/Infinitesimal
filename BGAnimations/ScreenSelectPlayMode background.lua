local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","bg"))..{
        InitCommand=function(self)
            self:Center()
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
            :diffusealpha(0.8)
            end;
    };
};

return t;
