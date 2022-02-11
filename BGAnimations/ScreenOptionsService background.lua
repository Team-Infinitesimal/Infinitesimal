return LoadActor(THEME:GetPathG("", "Grid"))..{
    InitCommand=function(self)
        self:diffusealpha(0)
        :linear(1)
        :diffusealpha(0.5)
    end
}
