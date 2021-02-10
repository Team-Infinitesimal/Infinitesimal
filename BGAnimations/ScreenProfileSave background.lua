local t = Def.ActorFrame {

		LoadActor(THEME:GetPathG("", "GenericGradientBg"))..{
				InitCommand=function(self)
						self:scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
				end;
		};

		Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
						:zoomx(SCREEN_WIDTH)
						:zoomy(SCREEN_HEIGHT)
            :diffuse(0,0,0,0.50)
        end;
    };

}

return t;
