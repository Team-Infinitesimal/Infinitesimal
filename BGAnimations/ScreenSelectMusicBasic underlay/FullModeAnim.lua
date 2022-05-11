return Def.ActorFrame {
    Name="FullModeAnim",
    InitCommand=function(self) self:visible(false) end,
    AnimateCommand=function(self) self:visible(true) end,

    Def.Quad {
        Name="Background",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, 0)
            :diffuse(0,0,0,0.5)
            :fadetop(0.25):fadebottom(0.25)
            :Center(0)
        end,
        AnimateCommand=function(self)
            self:easeoutexpo(0.5):zoomy(200)
        end,
        OffCommand=function(self)
            self:easeinexpo(0.25)
            :zoomtoheight(0)
        end
    },

    Def.Sprite {
        Name="Full",
        Texture="Full Mode/Full",
        InitCommand=function(self)
            self:xy(SCREEN_LEFT - 150, SCREEN_CENTER_Y - 40):shadowlength(5)
        end,
        AnimateCommand=function(self)
            self:easeoutexpo(0.5)
            :x(SCREEN_CENTER_X)
        end,
        OffCommand=function(self)
            self:easeinexpo(0.25)
            :zoomto(600,0)
        end
    },

    Def.Sprite {
        Name="Mode",
        Texture="Full Mode/Mode",
        InitCommand=function(self)
            self:xy(SCREEN_RIGHT + 150, SCREEN_CENTER_Y + 40):shadowlength(5)
        end,
        AnimateCommand=function(self)
            self:easeoutexpo(0.5)
            :x(SCREEN_CENTER_X)
        end,
        OffCommand=function(self)
            self:easeinexpo(0.25)
            :zoomto(600,0)
        end
    },

}
