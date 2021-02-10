local t = Def.ActorFrame{

    LoadActor(THEME:GetPathG("", "GenericGradientBg"))..{
        InitCommand=function(self)
            self:Center()
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
        end
    };

    Def.Quad {
        InitCommand=function(self)
            self:diffuse(1,1,1,1)
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
            :linear(0.5)
            :diffusealpha(0)
        end;
    };

    LoadActor("Stars1")..{
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.5)
            :Center()
            :diffusealpha(0.5)
            :decelerate(1)
            :zoom(0.4)
            :diffusealpha(0)
        end;
    };

    LoadActor("Stars2")..{
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.5)
            :Center()
            :diffusealpha(0.5)
            :decelerate(1)
            :zoom(0.5)
            :diffusealpha(0)
        end;
    };

    LoadActor("Stars3")..{
        InitCommand=function(self)
            self:zoom(0.1)
            :diffusealpha(0)
            :sleep(0.5)
            :Center()
            :diffusealpha(0.75)
            :decelerate(1)
            :zoom(0.6)
            :diffusealpha(0)
        end;
    };

    LoadActor("Circle")..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-100)
            :diffusealpha(0)
            :sleep(0.5)
            :diffusealpha(0.1)
            :sleep(0.25)
            :zoom(0)
            :decelerate(5)
            :diffusealpha(1)
            :zoom(2)
        end;
    };

    LoadActor("Circle")..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+50)
            :diffusealpha(0)
            :sleep(0.5)
            :diffusealpha(0.1)
            :sleep(0.85)
            :zoom(0)
            :decelerate(5)
            :diffusealpha(1)
            :zoom(2)
        end;
    };

    LoadActor("Hey")..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y-100)
            :diffusealpha(0)
            :sleep(0.5)
            :shadowlength(3)
            :shadowcolor(0,0,0,0.25)
            :diffusealpha(0)
            :sleep(0.25)
            :zoom(0.35)
            :accelerate(0.25)
            :diffusealpha(1)
            :zoom(0.125)
        end;
    };

    LoadActor("GetUpAndDanceMan")..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y+50)
            :diffusealpha(0)
            :sleep(0.5)
            :shadowlength(3)
            :shadowcolor(0,0,0,0.25)
            :diffusealpha(0)
            :sleep(0.85)
            :zoom(0.25)
            :accelerate(0.25)
            :diffusealpha(1)
            :zoom(0.08)
        end;
    };
    
    Def.Quad {
        InitCommand=function(self)
            self:sleep(4)
            :diffuse(0,0,0,0)
            :scaletocover(0, 0, SCREEN_RIGHT, SCREEN_BOTTOM)
            :linear(1)
            :diffusealpha(1)
        end;
    };

    Def.Sound {
		File="Voice",
		OnCommand=function(self)
			self:sleep(0.6)
			:queuecommand("Play")
		end;
		PlayCommand=function(self)self:play()end
  	};
}

return t;
