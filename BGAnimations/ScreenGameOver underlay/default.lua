return Def.ActorFrame {
    Def.Sound {
        File=THEME:GetPathS("", "Pewwwww"),
        OnCommand=function(self)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },

    Def.Sound {
        File=THEME:GetPathS("", "Boom"),
        OnCommand=function(self)
            self:sleep(1.5)
            :queuecommand("Play")
        end,
        PlayCommand=function(self) self:play() end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):queuecommand("Expand")
        end,
        ExpandMessageCommand=function(self)
            self:diffusealpha(0.1):zoom(0)
            :linear(3)
            :diffusealpha(1):zoom(2)
            :queuecommand("Expand")
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
            :diffusealpha(0):sleep(1.5):queuecommand("Expand")
        end,
        ExpandMessageCommand=function(self)
            self:diffusealpha(0.1):zoom(0)
            :linear(3)
            :diffusealpha(1):zoom(2)
            :queuecommand("Expand")
        end
    },

    Def.Sprite{
        Texture="Game",
        InitCommand=function(self)
            self:xy(SCREEN_LEFT - 250, SCREEN_CENTER_Y - 60)
            :diffusealpha(0):zoom(0.5)
            :decelerate(0.5)
            :diffusealpha(1)
            :x(SCREEN_CENTER_X - 50)
            :linear(1)
            :x(SCREEN_CENTER_X + 50)
            :accelerate(0.5)
            :x(SCREEN_RIGHT + 250)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Stars1"),
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.5)
            :Center()
            :diffusealpha(0.5)
            :decelerate(1)
            :zoom(0.4)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Stars2"),
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.5)
            :Center()
            :diffusealpha(0.5)
            :decelerate(1)
            :zoom(0.5)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture=THEME:GetPathG("", "ParticlesAndEffects/Stars3"),
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.5)
            :Center()
            :diffusealpha(0.75)
            :decelerate(1)
            :zoom(0.6)
            :diffusealpha(0)
        end
    },

    Def.Sprite{
        Texture="Over",
        InitCommand=function(self)
            self:xy(SCREEN_RIGHT + 250, SCREEN_CENTER_Y + 60)
            :diffusealpha(0)
            :zoom(0.5)
            :decelerate(0.5)
            :diffusealpha(1)
            :x(SCREEN_CENTER_X + 50)
            :linear(1)
            :x(SCREEN_CENTER_X - 50)
            :accelerate(0.5)
            :x(SCREEN_LEFT - 250)
            :diffusealpha(0)
        end
    },
    
    Def.Quad {
        InitCommand=function(self)
            self:FullScreen():diffuse(Color.Black)
            :diffusealpha(0):sleep(2.5):easeoutexpo(0.5):diffusealpha(1)
            :queuecommand("Transition")
        end,
        TransitionMessageCommand=function(self)
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }
}
