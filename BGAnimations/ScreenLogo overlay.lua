local t = Def.ActorFrame {

  Def.ActorFrame {
    InitCommand=function(self)
      self:Center()
      :queuecommand("ZoomY")
    end,

    ZoomYCommand=function(self)
      self:accelerate(3.4288)
      :zoom(0.96)
      :decelerate(3.4288)
      :zoom(1)
      :queuecommand("ZoomY")
    end,

    Def.Sprite {
      Texture=THEME:GetPathG("","logo"),
      InitCommand=function(self)
        self:zoom(0.5,0.5)
      end
    },

    Def.Sprite {
      Texture=THEME:GetPathG("","logo"),
      InitCommand=function(self)
        self:zoom(0.5,0.5)
        :queuecommand("Pulse")
      end,
      PulseCommand=function(self)
        self:sleep(3.4288)
        :diffusealpha(0.5)
        :zoom(0.5)
        :decelerate(1.7144)
        :zoom(0.65)
        :diffusealpha(0)
        :sleep(1.7144)
        :queuecommand("Pulse")
      end
    },

    Def.Sprite {
      Texture=THEME:GetPathG("","blurLogo"),
      InitCommand=function(self)
        self:zoom(0.8,0.8)
        :diffusealpha(0)
        :queuecommand("Flash")
      end,
      FlashCommand=function(self)
        self:accelerate(3.4288)
        :diffusealpha(0.8)
        :decelerate(3.4288)
        :diffusealpha(0)
        :queuecommand("Flash")
      end
    }
  }
}

return t
