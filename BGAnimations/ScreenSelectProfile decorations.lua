local t = Def.ActorFrame {
    LoadActor(THEME:GetPathG("","BlankScreenHudFrame")),

    Def.BitmapText{
    	Font="Montserrat Semibold 40px",
    	Text="SELECT",
    	InitCommand=function(self)
    		self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and 250 or 170) )
    		:zoom(0.4)
    		:shadowcolor(0,0,0,0.25)
    		:shadowlength(0.75)
    		:diffuse(0,0,0,1)
    		:y(-150)
    	end,
    	OnCommand=function(self)
    		self:decelerate(1):y(GetScreenAspectRatio() >= 1.5 and 26 or 19)
    	end
    },

    Def.BitmapText{
    	Font="Montserrat normal 40px",
    	Text="PROFILE",
    	InitCommand=function(self)
    		self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and 183 or 170) )
    		:zoom(0.4)
    		:shadowcolor(0,0,0,0.25)
    		:shadowlength(0.75)
    		:diffuse(0,0,0,1)
    		:y(-150)
    	end,
    	OnCommand=function(self)
    		self:decelerate(1):y(GetScreenAspectRatio() >= 1.5 and 26 or 33)
    	end
    },

    LoadActor(THEME:GetPathG("", "CornerArrows"))
};

return t;
