local function obf(st)
    return base64decode(st)
end

local t = Def.ActorFrame {

  Def.Sound {
		File="stop",
		OnCommand=function(self)self:play()end
	},

  Def.BitmapText {
    Font="Montserrat normal 40px",
    InitCommand=function(self)
      self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+20)
      :zoom(0.5)
      :diffusealpha(0)
      :settext(obf("VGhpcyB0aGVtZSBkb2VzIG5vdCBzdXBwb3J0IHBheSBtb2RlLgpQbGVhc2UgcHJlc3MgRjMrMSB0byBkaXNhYmxlIHBheSBtb2RlIGFuZCBleGl0IHRoaXMgc2NyZWVuLg=="))
      :sleep(8)
      :decelerate(1.5)
      :diffusealpha(1)
      :y(SCREEN_CENTER_Y)
    end
  },

  Def.Sprite {
		Texture="bg_stop",
		InitCommand=function(self)
			self:Center()
			:scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
      :sleep(8)
      :linear(1)
      :diffusealpha(0)
		end
	},

  Def.Quad {
    InitCommand=function(self)
      self:visible(false)
    end,
    CoinModeChangedMessageCommand=function(self)
      local gMode = GAMESTATE:GetCoinMode()
      if gMode == obf("Q29pbk1vZGVfSG9tZQ==") or gMode == obf("Q29pbk1vZGVfRnJlZQ==") then
        SCREENMAN:GetTopScreen():SetNextScreenName("ScreenTitleMenu");
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
      end
    end
  }

}

return t;
