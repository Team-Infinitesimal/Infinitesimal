-- A lot of this is referenced from/borrowed from the DDR XX -STARLiGHT- theme
-- Credit to the developers for their amazing work
-- https://bitbucket.org/inorizushi/xx-starlight-download/src/master/README.md

local pn = ...

local colours = {
	FullComboW1 = color("#febdff"),
	FullComboW2 = color("#81c1ff"),
	FullComboW3 = color("#59fe5d"),
	FullComboW4 = color("#fff46b"),
	Miss = color("#f04030")
}

local center1P    = PREFSMAN:GetPreference("Center1Player")
local stepType    = GAMESTATE:GetCurrentStyle():GetStepsType()
local numPlayers  = GAMESTATE:GetNumPlayersEnabled()
local playerStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
local numSides    = GAMESTATE:GetNumSidesJoined()

local function GetPos(pn)
  if stepType == "StepsType_Pump_Double" or stepType == "StepsType_Pump_Halfdouble" or center1P then
    return SCREEN_WIDTH/2
  else
    return THEME:GetMetric(Var "LoadingScreen","Player".. ToEnumShortString( pn ) .."OnePlayerOneSideX")
  end
end

local function GetWidth()
  if stepType == "StepsType_Pump_Double" or stepType == "StepsType_Pump_Halfdouble" then
    return (500)
  else
    return (250)
  end
end

local function isFC()
  if playerStats:FullCombo() then
    return true
  else
    return false
  end
end

local t = Def.ActorFrame{}

t[#t+1] = Def.Sound {
  File="FCSound",
  SupportPan=true,
  OffCommand=function(self)
    if isFC() then
      self:playforplayer(pn)
    end
  end
}

t[#t+1] = Def.ActorFrame{

  InitCommand=function(self)
    self:x(GetPos(pn))
    :diffusealpha(0)
  end,
  OffCommand=function(self)
    if isFC() then
      self:diffusealpha(1)
    end
  end,

  Def.Quad {
    InitCommand=function(self)
      self:zoomto(GetWidth(), 0)
      :diffusealpha(0)
      :fadetop(0.25)
      :fadebottom(0.25)
    end,
    OffCommand=function(self)
      if playerStats:FullComboOfScore("TapNoteScore_W1") then
        self:diffuse(colours.FullComboW1, 0.75)
      elseif playerStats:FullComboOfScore("TapNoteScore_W2") then
        self:diffuse(colours.FullComboW2, 0.75)
      elseif playerStats:FullComboOfScore("TapNoteScore_W3") then
        self:diffuse(colours.FullComboW3, 0.75)
      elseif playerStats:FullComboOfScore("TapNoteScore_W4") then
        self:diffuse(colours.FullComboW4, 0.75)
      end
      self:y(SCREEN_CENTER_Y)
      self:decelerate(0.5)
      :zoomto(GetWidth(), SCREEN_HEIGHT)
      :diffusealpha(0.75)
      :accelerate(0.5)
      :diffusealpha(0)
    end
  },

  Def.Sprite {
    Texture=THEME:GetPathG("", "ParticlesAndEffects/Circle"),
    InitCommand=function(self)
      self:zoom(0)
      :diffusealpha(0)
      :y(SCREEN_CENTER_Y)
    end,
    OffCommand=function(self)
      self:diffusealpha(1)
      :linear(1)
      :zoom(1.5)
      :diffusealpha(0)
    end
  },

  Def.Sprite {
    Texture="FullComboText",
    InitCommand=function(self)
      self:diffuseshift()
      :effectclock("bgm")
      :zoom(0.75)
      :diffusealpha(0)
    end,
    OffCommand=function(self)
      if playerStats:FullComboOfScore("TapNoteScore_W1") then
        self:effectcolor1(colours.FullComboW1)
      elseif playerStats:FullComboOfScore("TapNoteScore_W2") then
        self:effectcolor1(colours.FullComboW2)
      elseif playerStats:FullComboOfScore("TapNoteScore_W3") then
        self:effectcolor1(colours.FullComboW3)
      elseif playerStats:FullComboOfScore("TapNoteScore_W4") then
        self:effectcolor1(colours.FullComboW4)
      end
      self:y(SCREEN_CENTER_Y+50)
      self:decelerate(0.5)
      :diffusealpha(1)
      :y(SCREEN_CENTER_Y)
      :accelerate(0.5)
      :diffusealpha(0)
      :y(SCREEN_CENTER_Y-50)
    end
  }
}

return t
