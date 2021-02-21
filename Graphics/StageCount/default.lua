local pn = ...

local t = Def.ActorFrame {

  Def.Sprite {
    Texture="StageCount",
    OnCommand=function(self)
      self:zoom(0.3)
      if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
        if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
          local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)):GetX()
          if pn == PLAYER_1 then
            self:xy(pos-286, SCREEN_TOP+28)
          else
            self:xy(pos+286, SCREEN_TOP+28)
          end;
        end;
      else
        self:xy(SCREEN_CENTER_X, SCREEN_TOP+28)
      end;
    end;
  };

  LoadFont("Montserrat semibold 40px")..{
    OnCommand=function(self)
      local CurStage = string.format("%02d", GAMESTATE:GetCurrentStageIndex() + 1)
      self:zoom(0.5)
      :skewx(-0.1)
      if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
        if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
          local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)):GetX()
          if pn == PLAYER_1 then
            self:xy(pos-286, SCREEN_TOP+35)
          else
            self:xy(pos+286, SCREEN_TOP+35)
          end;
        end;
      else
        self:xy(SCREEN_CENTER_X, SCREEN_TOP+35)
      end;
      self:settext(CurStage)
    end;
  };


};

return t;
