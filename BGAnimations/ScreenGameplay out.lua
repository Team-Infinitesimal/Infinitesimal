-- I'm so sorry
local function isFC()
  local FCStates = {}
  for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local playerStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
    if playerStats:FullCombo() then
      if pn == "PlayerNumber_P1" then
        FCStates[0] = true
      else
        FCStates[1] = true
      end
    else
      if pn == "PlayerNumber_P1" then
        FCStates[0] = false
      else
        FCStates[1] = false
      end
    end
  end
  if FCStates[0] == true or FCStates[1] == true then
    return true
  else
    return false
  end
end
-- There are probably many better ways to do this but I can't think of a single one
-- I just need the transition between screens to last a little longer if either player gets a full combo

return Def.ActorFrame {

  OnCommand=function(self)
    self:sleep(3)
  end,

  Def.Quad {
    InitCommand=function(self)
      self:Center()
      :zoomto(SCREEN_WIDTH+10,SCREEN_HEIGHT+10)
      :diffusealpha(0)
    end,
    StartTransitioningCommand=function(self)
      if isFC() then
        self:sleep(1.5)
        self:queuecommand("Fade")
      else
        self:queuecommand("Fade")
      end
    end,
    FadeCommand=function(self)
      self:diffuse(0,0,0,0)
      :tween(0.5, "Accelerate", {0,0,0,0})
      :diffuse(0,0,0,1)
      :sleep(0.5)
    end
  }
}
