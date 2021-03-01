local t = Def.ActorFrame{
	Def.Banner{
		InitCommand=function(self)
			self:scaletoclipped(300,168)
			:rotationx(-50)
		end,
		SetMessageCommand=function(self,params)
			local group = params.Text
			if group then
				local bannerPath = SONGMAN:GetSongGroupBannerPath(group)
				if bannerPath ~= "" then
					self:Load(bannerPath)
				else
					self:Load(THEME:GetPathG("","Common fallback songbanner") )
				end
			end
		end
	}
}

return t
