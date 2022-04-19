if IsVideoBackground then
    return Def.Sprite {
        Texture=THEME:GetPathG("", "_Background.mp4"),
        InitCommand=function(self)
            self:scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM):Center()
        end
    }
else
    return LoadActor(THEME:GetPathG("", "Background"))
end