return Def.ActorFrame {
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y - 20)
        :queuecommand("ZoomY")
    end,

    OffCommand=function(self)
        self:stoptweening()
        :easeoutexpo(0.5)
        :zoom(1.5):diffusealpha(0)
    end,

    ZoomYCommand=function(self)
        self:accelerate(3.4288)
        :zoom(0.96)
        :decelerate(3.4288)
        :zoom(1)
        :queuecommand("ZoomY")
    end,

    Def.Sprite {
        Texture=THEME:GetPathG("", "Logo/Logo"),
        InitCommand=function(self)
            self:zoom(0.75)
        end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "Logo/Logo"),
        InitCommand=function(self)
            self:zoom(0.75)
            :queuecommand("Pulse")
        end,
        PulseCommand=function(self)
            self:sleep(3.4288)
            :diffusealpha(0.5)
            :zoom(0.75)
            :decelerate(1.7144)
            :zoom(0.85)
            :diffusealpha(0)
            :sleep(1.7144)
            :queuecommand("Pulse")
        end,
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "Logo/BlurLogo"),
        InitCommand=function(self)
            self:zoom(0.81)
            :diffusealpha(0)
            :queuecommand("Flash")
        end,
        FlashCommand=function(self)
            self:accelerate(3.4288)
            :diffusealpha(0.8)
            :decelerate(3.4288)
            :diffusealpha(0)
            :queuecommand("Flash")
        end,
        OffCommand=function(self)
            self:stoptweening()
            :diffusealpha(1)
            :easeoutexpo(1)
            :zoom(2):diffusealpha(0)
        end,
    }
}
