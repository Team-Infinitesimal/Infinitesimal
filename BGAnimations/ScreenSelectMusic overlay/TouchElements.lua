return Def.ActorFrame {

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Select"),
    InitCommand=function(self)
      self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 50)
      :zoom(0.3)
    end,
    OnCommand=function(self)
      self:sleep(0.25)
      :decelerate(0.75)
      :y(SCREEN_BOTTOM - 50)
    end,
    SongChosenMessageCommand=function(self)
      self:stoptweening()
      :decelerate(0.25)
      :y(SCREEN_BOTTOM)
      :diffusealpha(0)
    end,
    SongUnchosenMessageCommand=function(self)
      self:stoptweening()
      :decelerate(0.25)
      :y(SCREEN_BOTTOM - 50)
      :diffusealpha(1)
    end,
  },

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Arrow"),
    Name="LeftArrow",
    InitCommand=function(self)
      self:xy(SCREEN_CENTER_X - 100, SCREEN_BOTTOM - 110)
      :zoom(0.3)
      :rotationy(180)
      :sleep(0.25)
      :queuecommand("Bounce")
    end,
    BounceCommand=function(self)
      self:bounce()
      :effectclock("beat")
      :effectmagnitude(-2.5,0,0)
    end,
    SongChosenMessageCommand=function(self)
      self:stoptweening()
      :linear(0.25)
      :diffusealpha(0)
      :x(SCREEN_LEFT - 50)
    end,
    SongUnchosenMessageCommand=function(self)
      self:stoptweening()
      :linear(0.25)
      :diffusealpha(1)
      :x(SCREEN_CENTER_X - 100)
    end,
  },

  Def.Sprite {
    Texture=THEME:GetPathG("", "TouchElements/Arrow"),
    Name="RightArrow",
    InitCommand=function(self)
      self:xy(SCREEN_CENTER_X + 100, SCREEN_BOTTOM - 110)
      :zoom(0.3)
      :queuecommand("Bounce")
    end,
    BounceCommand=function(self)
      self:bounce()
      :effectclock("beat")
      :effectmagnitude(2.5,0,0)
    end,
    SongChosenMessageCommand=function(self)
      self:stoptweening()
      :linear(0.25)
      :diffusealpha(0)
      :x(SCREEN_RIGHT + 50)
    end,
    SongUnchosenMessageCommand=function(self)
      self:stoptweening()
      :linear(0.25)
      :diffusealpha(1)
      :x(SCREEN_CENTER_X + 100)
    end,
  },

}
