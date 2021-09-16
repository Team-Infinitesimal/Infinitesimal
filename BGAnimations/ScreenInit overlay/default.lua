return Def.ActorFrame {

	InitCommand=function(self)
		self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
	end,

	OnCommand=function(self)
		for pn in ivalues(PlayerNumber) do
			Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/Infinitesimal.ini"
			LoadModule("Config.Save.lua")("ProMode", "AllowW1_Never", Location)
			LoadModule("Config.Save.lua")("DeviationDisplay", tostring(false), Location)
			LoadModule("Config.Save.lua")("ScoreDisplay", tostring(false), Location)
			LoadModule("Config.Save.lua")("MeasureCounter", tostring(false), Location)
		end
	end,

	Def.Quad {
		InitCommand=function(self)
			self:zoom(SCREEN_WIDTH*2,SCREEN_HEIGHT*2)
			:diffuse(color("#2D4ABD"))
		end
	},

	Def.Sprite {
		Texture="arrow",
		InitCommand=function(self)
			self:diffusealpha(0)
			:sleep(0.5)
			:zoomto(250,250)
			:linear(1)
			:diffusealpha(1)
			:decelerate(1.5)
			:rotationz(180)
		end
	},

	Def.Sprite {
		Texture="dj505",
		InitCommand=function(self)
			self:diffusealpha(0)
			:sleep(1.5)
			:zoomto(500,500)
			:linear(0.5)
			:diffusealpha(1)
		end
	},

	Def.Sound {
		File="LogoSound",
		OnCommand=function(self)
			self:sleep(1.5):queuecommand("Play")
		end,
		PlayCommand=function(self)self:play()end
	},

	Def.Quad {
		InitCommand=function(self)
			self:diffuse(0,0,0,0):sleep(5):queuecommand("Transfer")
		end,
		TransferCommand=function(self)
			SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
		end
	}
}
