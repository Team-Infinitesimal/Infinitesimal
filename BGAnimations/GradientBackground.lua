return Def.Sprite {
    Texture=THEME:GetPathG("", "Gradient background"),
    InitCommand=function(self)
        self:Center():scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
    end
}
