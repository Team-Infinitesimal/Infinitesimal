return Def.ActorFrame {

	InitCommand=function(self)self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)end;

	Def.Quad {
		InitCommand=function(self)
			self:zoom(SCREEN_WIDTH*2,SCREEN_HEIGHT*2)
			self:diffuse(color("Black"))
			self:linear(1)
			self:diffuse(color("#2D4ABD"))
		end
	},

	LoadActor("arrow")..{
		InitCommand=function(self)
			self:diffusealpha(0)
			:sleep(1.5)
			:zoomto(250,250)
			:linear(1)
			:diffusealpha(1)
			:decelerate(1.5)
			:rotationz(180)
		end;
	};

	LoadActor("dj505")..{
		InitCommand=function(self)
			self:diffusealpha(0)
			:sleep(2.5)
			:zoomto(500,500)
			:linear(0.5)
			:diffusealpha(1)
		end;
	};

	Def.Sound {
		File="LogoSound",
		OnCommand=function(self)
			self:sleep(2.5):queuecommand("Play")
		end;
		PlayCommand=function(self)self:play()end
	};

	Def.Quad {
		InitCommand=function(self)
			self:diffuse(0,0,0,0):sleep(9.2):queuecommand("Transfer")
		end,
		TransferCommand=function(self)
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		end
	}

};
