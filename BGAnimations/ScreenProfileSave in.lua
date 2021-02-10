local t = Def.ActorFrame {
    Def.Quad {
        InitCommand=function(self)
            self:diffuse(0,0,0,1)
            :linear(0.5)
            :diffusealpha(0)
        end;
    };
};

return t;
