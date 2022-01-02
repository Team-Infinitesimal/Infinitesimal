return Def.ActorFrame{
    Def.Banner {
		SetMessageCommand=function(self, params)
			if params.Song then
				local Path = params.Song:GetBannerPath()
				if not Path then
					Path = params.Song:GetBackgroundPath()
					if not Path then 
						Path = THEME:GetPathG("Common fallback", "banner")
					end
				end
                -- Make the banner slightly larger than 210x118 to avoid garbled edges
                -- (if only AFTs could be done here)
				self:LoadFromCachedBanner(Path):scaletoclipped(212, 120) 
			end
		end
	},
    
    Def.Sprite {
		Texture=THEME:GetPathG("", "MusicWheel/SongFrame"),
	},
    
    Def.BitmapText {
		Font="Combo Numbers",
		InitCommand=function(self) 
			self:addy(-50):zoom(0.25)
		end,
		SetMessageCommand=function(self, params)
			if params.Index then
				self:settext(params.Index + 1)
                --[[
				if params.HasFocus ~= nil and params.HasFocus then
					self:diffusealpha(1)
				else
					self:diffusealpha(0.5)
				end
                ]]
			end
		end
	}
}