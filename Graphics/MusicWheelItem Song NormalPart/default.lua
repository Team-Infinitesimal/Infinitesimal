return Def.ActorFrame {
	OnCommand=function(self)
		self:diffusealpha(1):zoom(1)
	end,
	PlayerJoinedMessageCommand=function(self)
		self:playcommand("On")
	end,

	-- banners
	Def.Banner {
		Name="SongBanner",
		InitCommand=function(self)
			self:diffusealpha(1)
		end,
		SetMessageCommand=function(self,params)
			self:stoptweening()
			local song = params.Song
			local path
			if song then
				path = song:GetBannerPath()
				if not path then
					path = song:GetBackgroundPath()
				end
			end
			
			if not path then path = THEME:GetPathG("Common","fallback songbanner") end
			self:LoadFromCachedBanner(path)
			self:scaletoclipped(300,168)
		end
	},

	Def.Sprite {
		Texture=THEME:GetPathG("","SongFrame"),
		InitCommand=function(self)
			self:zoom(1.35):diffusealpha(1)
		end
	}
}
