return Def.ActorFrame {

    Def.Sprite {
        Name="PartyHat",
        Texture="PartyHat",
        InitCommand=function(self)
            self:xy(325, -350):rotationz(28):diffusealpha(0)
        end,
        OnCommand=function(self)
            self:sleep(1)
            :easeoutexpo(0.5)
            :diffusealpha(1)
            :y(-250)
        end
    },

    Def.BitmapText {
        Font="Montserrat extrabold 40px",
        InitCommand=function(self)
            self:settext(string.format("%d YEAR ANNIVERSARY", (Year() - 2020)))
            :y(-350)
            :shadowlength(2)
            :diffusealpha(0)
        end,
        OnCommand=function(self)
            self:sleep(1)
            :easeoutexpo(0.5)
            :diffusealpha(1)
            :y(-250)
        end
    }

}
