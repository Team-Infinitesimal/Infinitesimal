return Def.Quad{
    StartTransitioningCommand=function(self)
        self:FullScreen():diffuse(Color.Black)
        :diffusealpha(0):easeoutexpo(0.25):diffusealpha(1)
    end
}
