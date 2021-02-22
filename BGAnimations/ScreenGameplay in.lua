local t = Def.ActorFrame {
  	Def.Sprite {
    	InitCommand=function(self)
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
