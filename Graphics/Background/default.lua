return Def.ActorFrame {

  Def.Quad {
    InitCommand=function(self)
      self:Center()
      :zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
      :diffuse(color("#150F34"))
    end
  },

  Def.Sprite {
    Texture="gradient",
    InitCommand=function(self)
      self:Center()
    end
  },

  Def.ActorFrame {
    FOV=90,

    Def.Sprite {
      Name="GridTop",
      Texture="grid",
      InitCommand=function(self)
        self:xy(SCREEN_CENTER_X, 0)
        :zoomx(2.2)
        :halign(0.5):valign(0)
        :rotationx(84)
        :texcoordvelocity(0, 0.25)
        :fadebottom(1)
      end
    },

    Def.Sprite {
      Name="GridBottom",
      Texture="grid",
      InitCommand=function(self)
        self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM)
        :zoomx(2.2)
        :halign(0.5):valign(0)
        :rotationx(102)
        :texcoordvelocity(0, 0.25)
        :fadebottom(1)
      end
    }

  },

  Def.Sprite {
    Name="Circle1",
    Texture="Circle",
    InitCommand=function(self)
      self:Center()
      :blend("BlendMode_Add")
      :queuecommand("Grow")
    end,
    GrowCommand=function(self)
      self:stoptweening()
      :zoom(0)
      :linear(3.4288)
      :zoom(3)
      :queuecommand("Grow")
    end
  },

  Def.Sprite {
    Name="Circle2",
    Texture="Circle",
    InitCommand=function(self)
      self:visible(false)
      :Center()
      :blend("BlendMode_Add")
      :sleep(1.7144)
      :queuecommand("Grow")
    end,
    GrowCommand=function(self)
      self:visible(true):stoptweening()
      :zoom(0)
      :linear(3.4288)
      :zoom(3)
      :queuecommand("Grow")
    end
  }

}
