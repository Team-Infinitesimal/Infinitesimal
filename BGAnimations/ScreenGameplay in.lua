return Def.ActorFrame {
    LoadActor("SongTransition") .. {
        OnCommand=function(self)
            self:easeoutexpo(1):diffusealpha(0)
        end
    }
}
