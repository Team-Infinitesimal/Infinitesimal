local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","Lifebar"))..{
        InitCommand=function(self)
            self:xy(SCREEN_LEFT,SCREEN_TOP+10)
            end;
    };
};

return t;
