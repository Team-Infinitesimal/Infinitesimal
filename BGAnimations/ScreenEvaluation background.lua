return Def.ActorFrame {
	Def.Sprite {
		Texture=THEME:GetPathG("", "Gradient background"),
		InitCommand=function(self)
			self:Center():scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
		end
	},
	-- Background image
    Def.Sprite {
        InitCommand=function(self)
            local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
				self:Load(Path):scale_or_crop_background():diffusealpha(0.5)
            end
        end
    }
}