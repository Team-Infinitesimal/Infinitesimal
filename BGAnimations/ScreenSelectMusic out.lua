return Def.ActorFrame {
    LoadActor("SongTransition"),
    
    Def.Quad {
        StartTransitioningCommand=function(self)
            self:FullScreen():diffuse(Color.White)
            :diffusealpha(1):easeoutexpo(1):diffusealpha(0)
        end
    }
}