-- 3D synthwave-style grids require the actor they're contained in
-- to have an FOV value set, 90 seems to work well
return Def.ActorFrame {
    Name="GridFrame",
    FOV=90,

    Def.Sprite {
        Name="GridTop",
        Texture="grid",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, 0)
            :zoomx(2.2)
            :halign(0.5):valign(0)
            :rotationx(84)
            :texcoordvelocity(0, 0.25)
            :diffusealpha(0.5)
            :fadebottom(1)
        end
    },

    Def.Sprite {
        Name="GridBottom",
        Texture="grid",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM)
            :zoomx(2.2)
            :halign(0.5):valign(0)
            :rotationx(98)
            :texcoordvelocity(0, 0.25)
            :diffusealpha(0.5)
            :fadebottom(1)
        end
    }
}
