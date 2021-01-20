local t = Def.ActorFrame {

	Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
			:zoomx(255)
			:zoomy(SCREEN_HEIGHT)
            :diffuse(0,0,0,0.75)
        end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudFrame"));

}

return t;
