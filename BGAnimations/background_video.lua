local t = Def.ActorFrame {
   Def.Sprite {
		Texture=THEME:GetPathG("","bg"),
        InitCommand=function(self)
            self:Center()
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
        end
    }
}

return t
