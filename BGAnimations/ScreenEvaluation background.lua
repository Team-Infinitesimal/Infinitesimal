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
    },

    -- Grid
    LoadActor(THEME:GetPathG("", "Grid"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :linear(1)
            :diffusealpha(0.5)
        end
    },

    Def.Sprite {
      Name="Scanlines",
      Texture=THEME:GetPathG("", "Scanline"),
        InitCommand=function(self)
            self:customtexturerect(0,0,SCREEN_WIDTH*4/16,SCREEN_HEIGHT*4/16)
            :zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffusealpha(0.25)
        end
    }

}
