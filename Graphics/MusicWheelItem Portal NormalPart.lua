return Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "MusicWheel/SongFrame"),
    },
        
    Def.Banner {
        InitCommand=function(self)
            self:Load(THEME:GetPathG("", "MusicWheel/RandomBanner"))
            :zoomto(212, 120)
        end
    }
}
