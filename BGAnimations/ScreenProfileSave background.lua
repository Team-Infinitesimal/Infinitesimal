local t = Def.ActorFrame {

		Def.Sprite {
				Texture=THEME:GetPathG("", "GenericGradientBg"),
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

		Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
						:zoomx(SCREEN_WIDTH)
						:zoomy(SCREEN_HEIGHT)
            :diffuse(0,0,0,1)
						:linear(0.5)
						:diffusealpha(0)
        end;
    };

}

return t;
