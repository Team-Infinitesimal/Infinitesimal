return Def.ActorFrame {
    OnCommand=function(self)
        self:bounce():sleep(1.1)
        :effectmagnitude(0, -8, 0)
        :effectperiod(0.4286)
    end,
            
    Def.Sprite {
        Texture="InsertCredit",
    },
    
    Def.Sprite {
        Texture="InsertCredit",
        InitCommand=function(self)
            self:zoom(1):diffusealpha(0)
            :queuecommand("FadeEffect")
        end,
        FadeEffectCommand=function(self)
            self:stoptweening()
            :zoom(1):diffusealpha(0.75)
            :decelerate(0.8572)
            :zoom(1.25):diffusealpha(0)
            :queuecommand("FadeEffect")
        end
    }
}