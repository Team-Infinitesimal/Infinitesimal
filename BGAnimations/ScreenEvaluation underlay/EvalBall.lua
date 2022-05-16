local pn = ...
local BasicMode = getenv("IsBasicMode")

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

local function ColourSteps(meter, type)
    if type == "Double" then return {color("#21db30"), "DOUBLE"} end
    if meter <= 2 then return {color("#209be3"), "EASY"} end
    if meter <= 4 then return {color("#fff700"), "NORMAL"} end
    if meter <= 7 then return {color("#ff3636"), "HARD"} end
    if meter <= 12 then return {color("#d317e8"), "VERY HARD"} end
    return {Color.White, "idk lol"} -- failsafe to prevent errors, should never be displayed anyway
end

return Def.ActorFrame {
	InitCommand=function(self)
		if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
			local Song = GAMESTATE:GetCurrentSong()
			local Chart = GAMESTATE:GetCurrentSteps(pn)
			local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
			
			local ChartMeter = Chart:GetMeter()
			if ChartMeter == 99 then ChartMeter = "??" end
			
			local StepData = ColourSteps(ChartMeter, ChartType)
			
			self:GetChild("Ball"):diffuse(BasicMode and StepData[1] or ChartTypeToColor(Chart))
			self:GetChild("Meter"):settext(ChartMeter)
			self:GetChild("Difficulty"):visible(BasicMode):settext(StepData[2])
			
			local ChartLabelIndex = 0
			for Index, String in pairs(ChartLabels) do
				if string.find(ToUpper(Chart:GetDescription()), String) then
					ChartLabelIndex = Index
				end
			end
			
			if ChartLabelIndex ~= 0 then
				self:GetChild("Label"):visible(not BasicMode):setstate(ChartLabelIndex - 1)
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
	
	Def.BitmapText {
		Font="Montserrat extrabold 20px",
		Name="Difficulty",
		InitCommand=function(self)
			self:y(-23):visible(false):zoom(0.75):maxwidth(80):shadowlength(2):skewx(-0.1)
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