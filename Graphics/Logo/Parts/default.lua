return Def.ActorFrame {

    LoadActor("AnimatedLoop")..{
        Name="Loop",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:GetChild("PlainLoop"):cropright(1)
            :sleep(0.5)
            :linear(0.4)
            :cropright(0)
            self:GetChild("ArrowPattern"):cropright(1)
            :sleep(0.5)
            :linear(0.4)
            :cropright(0)
        end
    },

    Def.Sprite {
        Texture="Loop",
        Name="Loop_Mask",
        InitCommand=function(self)
            self:MaskSource()
        end
    },

    Def.Quad {
        Name="Loop_Shine",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:zoomto(80, 400)
            :diffuse(1,1,1,0):blend("BlendMode_WeightedMultiply")
            :skewx(-1)
            :x(-415)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
            :queuecommand("Shine")
        end,
        ShineCommand=function(self)
            self:diffusealpha(0)
            :x(-415)
            :sleep(6.3576)
            :diffusealpha(0.5)
            :linear(0.5)
            :x(415)
            :queuecommand("Shine")
        end
    },

    Def.Sprite {
        Texture="Text",
        Name="Text",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:diffusealpha(0)
            :zoom(1.2)
            :sleep(1)
            :diffusealpha(1)
            :glow(1,1,1,1)
            :easeoutexpo(1)
            :zoom(1)
            :glow(1,1,1,0)
        end
    },

    Def.Sprite {
        Texture="Text",
        Name="Text_Mask",
        InitCommand=function(self)
            self:MaskSource()
        end
    },

    Def.Quad {
        Name="Text_Shine",
        OnCommand=function(self)
            self:queuecommand("Animate")
        end,
        AnimateCommand=function(self)
            self:zoomto(80, 400)
            :diffuse(1,1,1,0.75)
            :skewx(-1)
            :x(-535)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
            :sleep(0.5)
            :linear(0.4)
            :x(535)
        end
    },

}
