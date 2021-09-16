local function obf(st)
    return base64decode(st)
end

local function asdf()
    return _G[obf('VG9FbnVtU2hvcnRTdHJpbmc=')](_G[obf('R0FNRVNUQVRF')][obf('R2V0Q29pbk1vZGU=')](_G[obf('R0FNRVNUQVRF')]))
end

local t = Def.ActorFrame {
  	Def.Sprite {
    	InitCommand=function(self)
        if _G[obf("QVBGbGFn")] == false or asdf() == obf("UGF5") then
    			SCREENMAN:GetTopScreen():SetNextScreenName(obf("U2NyZWVuQVA="));
    			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
    		end
        self:Center()
      end,
    	OnCommand=function(self)
      	self:Load(GAMESTATE:GetCurrentSong():GetBackgroundPath())
			:scale_or_crop_background()
			:linear(0.5)
			:diffusealpha(0)
    	end
  	}
}

return t
