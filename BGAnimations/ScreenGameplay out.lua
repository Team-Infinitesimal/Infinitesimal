local function isFC()
  for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local playerStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
    if playerStats:FullCombo() then
      return true
    end;
  end
  return false
end
-- Thanks Accelerator/Rhythm Lunatic/however I should credit you for making the above code not horrible

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
