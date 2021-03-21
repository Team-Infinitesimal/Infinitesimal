local player=...

return Def.ActorFrame {

  InitCommand=function(self)
    self:y(SCREEN_CENTER_Y + 75)
    :diffusealpha(0)
    if player == "PlayerNumber_P1" then
      self:halign(0)
      :x(SCREEN_CENTER_X - 85)
    else
      self:halign(1)
      :x(SCREEN_CENTER_X + 85)
    end
  end,

  SongChosenMessageCommand=function(self)
    self:stoptweening()
    :decelerate(0.25)
    :y(SCREEN_CENTER_Y + 140)
    :diffusealpha(1)
  end,

  SongUnchosenMessageCommand=function(self)
    self:stoptweening()
    :decelerate(0.25)
    :y(SCREEN_CENTER_Y + 75)
    :diffusealpha(0)
  end,

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Arrow"),
    Name="LeftArrow",
    InitCommand=function(self)
      self:zoom(0.2)
      :halign(0.5)
      :rotationy(180)
      :addx(-45)
    end,
  },

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/GreenSelect"),
    Name="Select",
    InitCommand=function(self)
      self:zoom(0.2)
      :halign(0.5)
    end
  },

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Arrow"),
    Name="RightArrow",
    InitCommand=function(self)
      self:zoom(0.2)
      :halign(0.5)
      :addx(45)
    end,
  }

}
