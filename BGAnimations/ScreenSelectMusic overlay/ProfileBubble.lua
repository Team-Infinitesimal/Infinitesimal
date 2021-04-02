local pn = ...

local function determineXPos(player)
  if player == "PlayerNumber_P1" then
    return SCREEN_CENTER_X - 140
  else
    return SCREEN_CENTER_X + 140
  end
end

local function getHAlignment(player)
  if player == "PlayerNumber_P1" then
    return 1
  else
    return 0
  end
end

return Def.ActorFrame {

  InitCommand=function(self)
    self:diffusealpha(0)
    :zoom(0)
    :sleep(1)
    :halign(getHAlignment(pn)):valign(1)
    :xy(determineXPos(pn), SCREEN_BOTTOM - 50)
  end,
  OnCommand=function(self)
    if GAMESTATE:IsHumanPlayer(pn) then
      self:decelerate(0.25)
      :diffusealpha(1)
      :zoom(1)
      :sleep(3)
      :accelerate(0.25)
      :zoom(0)
      :diffusealpha(0)
    else
      self:diffusealpha(0)
    end
  end,

  Def.Sprite {
    Texture=THEME:GetPathG("", "ProfileBubble"),
    InitCommand=function(self)
      self:zoom(0.5)
      :valign(1)
    end
  },

  --[[ Def.BitmapText {
    Font="Montserrat semibold 40px",
    InitCommand=function(self)
      self:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
      :zoom(0.5)
      :valign(1)
      :y(-90)
    end
  }, --]]

  Def.BitmapText {
    Font="Montserrat normal 40px",
    InitCommand=function(self)
      self:settext(PROFILEMAN:GetProfile(pn):GetTotalNumSongsPlayed().." Songs Played")
      :zoom(0.3)
      :valign(1)
      :y(-80)
      :maxwidth(390)
    end
  },

  Def.BitmapText {
    Font="Montserrat normal 40px",
    InitCommand=function(self)
      self:settext(PROFILEMAN:GetProfile(pn):GetTotalTapsAndHolds().." Steps")
      :zoom(0.3)
      :valign(1)
      :y(-60)
      :maxwidth(390)
    end
  },

  Def.BitmapText {
    Font="Montserrat normal 40px",
    InitCommand=function(self)
      self:settext(string.format("%02.2f", (
        PROFILEMAN:GetProfile(pn):GetSongsAndCoursesPercentCompleteAllDifficulties("StepsType_Pump_Single")
        + PROFILEMAN:GetProfile(pn):GetSongsAndCoursesPercentCompleteAllDifficulties("StepsType_Pump_Double")
        + PROFILEMAN:GetProfile(pn):GetSongsAndCoursesPercentCompleteAllDifficulties("StepsType_Pump_Halfdouble")
      )/2).."% Complete")
      :zoom(0.3)
      :valign(1)
      :y(-40)
      :maxwidth(390)
    end
  },

}
