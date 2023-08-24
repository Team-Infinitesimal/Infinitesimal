return Def.ActorFrame {
    OnCommand=function(self)
        self:GetChild("Background"):visible(false)
        self:GetChild("Flash"):visible(false)
    end,
    
    StartTransitioningCommand=function(self)
        SOUND:StopMusic()
        
        if SCREENMAN:GetTopScreen():GetNextScreenName() == "ScreenStageInformation" then
            self:GetChild("Background"):visible(true)
            self:GetChild("SFX"):play()
            self:GetChild("Flash"):visible(true):FullScreen()
            :diffuse(Color.White):easeoutexpo(1):diffusealpha(0):sleep(2)
        else
            self:sleep(1)
        end
    end,
        
    LoadActor("SongTransition") .. {
        Name="Background"
    },

    Def.Sound {
        Name="SFX",
        File=THEME:GetPathS("", "StartSong")
    },

    Def.Quad {
        Name="Flash",
    }
}
