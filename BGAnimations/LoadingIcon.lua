return Def.ActorFrame {
    InitCommand=function(self)
        self:xy(SCREEN_LEFT + 140, SCREEN_BOTTOM - 100):diffusealpha(0)
    end,
    OnCommand=function(self)
        self:easeoutexpo(0.5):y(SCREEN_BOTTOM - 60):diffusealpha(1)
    end,
    OffCommand=function(self)
        self:easeoutexpo(0.5):y(SCREEN_BOTTOM - 40):diffusealpha(0)
    end,

    LoadActor(THEME:GetPathG("", "Logo/Parts/AnimatedLoop"))..{
        InitCommand=function(self)
            self:zoom(0.25)
        end
    },

    Def.BitmapText {
        Name="Text",
        Font="Montserrat extrabold 40px",
        InitCommand=function(self)
            self:skewx(-0.1):shadowlength(2):zoom(0.5)
        end
    }
}
