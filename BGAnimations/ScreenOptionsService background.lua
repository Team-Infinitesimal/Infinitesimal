return Def.ActorFrame {

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
