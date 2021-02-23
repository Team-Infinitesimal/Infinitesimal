local t = Def.ActorFrame {

    Def.Sprite {
        Texture=THEME:GetPathG("","logo"),
        InitCommand=function(self)
            self:Center()
            :zoom(0.5,0.5)
            :diffusealpha(1)
		end
    },

    Def.Sprite {
		Texture=THEME:GetPathG("","blurLogo"),
        InitCommand=function(self)
            self:Center()
            :zoom(0.49,0.49)
            :diffusealpha(0)
            :queuecommand("Flash")
        end,
        FlashCommand=function(self)
            self:accelerate(3.4288)
            :diffusealpha(1)
            :decelerate(3.4288)
            :diffusealpha(0)
            :queuecommand("Flash")
        end
    }
}

return t
