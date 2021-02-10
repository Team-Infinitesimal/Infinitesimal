local t = Def.ActorFrame {
    Def.Quad {
        InitCommand=function(self)
            self:diffuse(0,0,0,0)
            :linear(0.5)
            :diffusealpha(1)
        end;
    };
};

return t;
