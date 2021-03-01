local gc = Var("GameCommand")

local t = Def.ActorFrame{

    LoadFont("Montserrat semibold 20px")..{
        Text=gc:GetText(),
        InitCommand=function(self)
            self:skewx(-0.1)
            :y(150)
            :zoom(0.75)
            :shadowlength(0.75)
            :diffusebottomedge(color("0.95,0.95,0.95,1"))
            :shadowcolor(color("0,0,0,1"))
        end,
        GainFocusCommand=function(self)
            self:diffuse(color("#25BCDC"))
            :zoom(0.85)
        end,
        LoseFocusCommand=function(self)
            self:diffuse(Color("White"))
            :zoom(0.75)
        end
    }
}

return t
