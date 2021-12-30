return Def.Quad {
    InitCommand=function(self)
        self:zoomto(SCREEN_WIDTH, 480)
        :Center():diffuse(Color.Black):diffusealpha(0.75)
    end
}