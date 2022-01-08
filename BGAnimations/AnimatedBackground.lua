return LoadActor(THEME:GetPathG("", "Background"))..{
    InitCommand=function(self)
        self:scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM):Center()
    end
}
