return Def.Quad{
    StartTransitioningCommand=function(self)
        self:FullScreen():diffuse(Color.Black):sleep(1)
        :diffusealpha(0):easeoutexpo(1):diffusealpha(1)
    end
}