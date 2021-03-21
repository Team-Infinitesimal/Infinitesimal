return Def.ActorFrame {

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Continue"),
    Name="Left",
    InitCommand=function(self)
      self:xy(SCREEN_LEFT + 10, SCREEN_BOTTOM + 50)
      :halign(0)
      :zoom(0.3)
    end,
    OnCommand=function(self)
      self:sleep(0.25)
      :decelerate(0.75)
      :y(SCREEN_BOTTOM - 28)
    end,
  },

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Continue"),
    Name="Right",
    InitCommand=function(self)
      self:xy(SCREEN_RIGHT - 10, SCREEN_BOTTOM + 50)
      :halign(1)
      :zoom(0.3)
    end,
    OnCommand=function(self)
      self:sleep(0.25)
      :decelerate(0.75)
      :y(SCREEN_BOTTOM - 28)
    end,
  },

}
