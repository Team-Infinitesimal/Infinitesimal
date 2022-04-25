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

  Def.ActorFrame {
    Def.Quad {
      InitCommand=function(self)
        self:zoomto(60, 18):addy(-50)
        :diffuse(0,0,0,0.6)
        :fadeleft(0.3):faderight(0.3)
      end
    },

    Def.BitmapText {
  		Font="Montserrat semibold 40px",
  		InitCommand=function(self)
  			self:addy(-50):zoom(0.4):skewx(-0.1):diffusetopedge(0.95,0.95,0.95,0.8):shadowlength(1.5)
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
}
