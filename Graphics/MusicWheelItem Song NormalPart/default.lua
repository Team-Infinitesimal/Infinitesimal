local bannerFirst = true
if GetUserPref("UserPrefWheelPriority") == "Banner" then
	--Don't need to assign, since it's already true
	--bannerFirst = true;
elseif GetUserPref("UserPrefWheelPriority") == "Background" then
	bannerFirst = false
else --Auto
	if GAMESTATE:GetCurrentGame():GetName() == "pump" then
		bannerFirst = true
	else
		bannerFirst = false --Prioritize jackets for every other game mode
	end
end

--local total = 0
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
			local path;
			if song then
				if bannerFirst then
					path = song:GetBannerPath()
					if not path then
						path = song:GetBackgroundPath()
					end;
				else
					path = song:GetBackgroundPath()
					if not path then
						path = song:GetBannerPath()
					end
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
