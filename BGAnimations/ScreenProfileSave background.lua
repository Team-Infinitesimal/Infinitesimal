local t = Def.ActorFrame {

	Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			:zoomx(SCREEN_WIDTH)
			:zoomy(SCREEN_HEIGHT)
            :diffuse(1,1,1,1)
        end;
    };

}

return t;
