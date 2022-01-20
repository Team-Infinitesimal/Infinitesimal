local pn = ...

local ChartLabels = {
	"NEW",
	"ANOTHER",
	"PRO",
	"TRAIN",
	"QUEST",
	"UCS",
	"HIDDEN",
	"INFINITY",
	"JUMP",
}

return Def.ActorFrame {
	InitCommand=function(self)
		if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
			local Song = GAMESTATE:GetCurrentSong()
			local Chart = GAMESTATE:GetCurrentSteps(pn)
			
			local ChartMeter = Chart:GetMeter()
			if ChartMeter == 99 then ChartMeter = "??" end
			
			self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
			self:GetChild("Meter"):settext(ChartMeter)
			
			local ChartLabelIndex = 0
			for Index, String in pairs(ChartLabels) do
				if string.find(ToUpper(Chart:GetDescription()), String) then
					ChartLabelIndex = Index
				end
			end
			
			if ChartLabelIndex ~= 0 then
				self:GetChild("Label"):visible(true):setstate(ChartLabelIndex - 1)
			else
				self:GetChild("Label"):visible(false)
			end
		end
	end,
	
	Def.Sprite {
		Name="Ball",
		Texture=THEME:GetPathG("", "DifficultyDisplay/LargeBall"),
		InitCommand=function(self) 
			self:zoom(0.75)
		end
	},
	
	Def.Sprite {
		Name="BallTrim",
		Texture=THEME:GetPathG("", "DifficultyDisplay/LargeTrim"),
		InitCommand=function(self) 
			self:zoom(0.75)
		end
	},
	
	Def.BitmapText {
		Name="Meter",
		Font="Montserrat numbers 40px",
		InitCommand=function(self)
			self:zoom(0.88) 
		end
	},
	
	Def.Sprite {
		Name="Label",
		Texture=THEME:GetPathG("", "DifficultyDisplay/Labels"),
		InitCommand=function(self)
			self:y(24):visible(false):animate(false)
		end
	}
}