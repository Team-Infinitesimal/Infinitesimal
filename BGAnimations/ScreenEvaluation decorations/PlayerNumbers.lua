local player = ...

local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false
local alignment = player == "PlayerNumber_P2" and 1 or 0

local offsetfromcenterx = GetScreenAspectRatio() >= 1.5 and 300 or 265
local lgoffset = GetScreenAspectRatio() >= 1.5 and 185 or 170
local dboffset = 40
local saoffset = 100

if player == "PlayerNumber_P1" then 
	offsetfromcenterx = -offsetfromcenterx
	lgoffset = -lgoffset
	dboffset = -dboffset
	saoffset = -saoffset
end

local spacing = 29.1
local showdelay = 0.08

local steps = GAMESTATE:GetCurrentSteps(player)
local playerstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player)

local superbs 	=	playerstats:GetTapNoteScores("TapNoteScore_W1") + 
					(promode and playerstats:GetTapNoteScores("TapNoteScore_CheckpointHit") or 0)
local perfects 	= 	playerstats:GetTapNoteScores("TapNoteScore_W2") + 
					(not promode and playerstats:GetTapNoteScores("TapNoteScore_CheckpointHit") or 0)
local greats 	= 	playerstats:GetTapNoteScores("TapNoteScore_W3")
local goods 	= 	playerstats:GetTapNoteScores("TapNoteScore_W4")
local bads 		= 	playerstats:GetTapNoteScores("TapNoteScore_W5")
local misses 	= 	playerstats:GetTapNoteScores("TapNoteScore_Miss") +
		            playerstats:GetTapNoteScores("TapNoteScore_CheckpointMiss")
					
local accuracy 	=	round(playerstats:GetPercentDancePoints()*100, 2)
local combo 	= 	playerstats:MaxCombo()
local score 	= 	scorecap(playerstats:GetScore())

local ChartType = setmetatable(
{
	Modes = {
		["StepsType_Pump_Single"] = function( steps )
			return string.find(steps:GetDescription(), "SP") and 3 or 2
		end,
		["StepsType_Pump_Double"] = function( steps )
			if string.find(steps:GetDescription(), "DP") then
				return steps:GetMeter() == 99 and 1 or 0
			end
			return 6
		end,
		["StepsType_Pump_Halfdouble"] = function() return 5 end,
		["StepsType_Pump_Routine"] = function() return 4 end,
	}
},
{
	__index = function( this, desc )
		local state = 7

		local type = desc:GetStepsType()
		if this.Modes[type] then
			state = this.Modes[type]( desc )
		end

		return state
	end
}
)

local DiffLabelIndex = {
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

local t = Def.ActorFrame {

	OnCommand=function(self)
		if promode then
			self:addy(spacing/2)
		end
	end,

	--Superbs
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, -spacing)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75):decelerate(0.3)
			if promode then
				self:diffusealpha(1):settext(superbs)
			end
		end
	},

	-- Perfects
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:x(offsetfromcenterx)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75):decelerate(0.3)
			:diffusealpha(1):settext(perfects)
		end
	},

	-- Greats
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay):decelerate(0.3)
			:diffusealpha(1):settext(greats)
		end
	},

	-- Goods
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing*2)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*2):decelerate(0.3)
			:diffusealpha(1):settext(goods)
		end
	},

	-- Bads
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing*3)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*3):decelerate(0.3)
			:diffusealpha(1):settext(bads)
		end
	},

	-- Misses
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing*4)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*4):decelerate(0.3)
			:diffusealpha(1):settext(misses)
		end
	},

	-- Max Combo
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing*5)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*5):decelerate(0.3)
			:diffusealpha(1):settext(combo)
		end
	},

	-- Accuracy
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing*6)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*6):decelerate(0.3)
			:diffusealpha(1):settext(accuracy.."%")
		end
	},

	-- Score
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:halign(alignment):diffusealpha(0)
			:xy(offsetfromcenterx, spacing*7)
			:shadowlength(0.8):zoom(0.5)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*7):decelerate(0.3)
			:diffusealpha(1):settext(score)
		end
	}
}

--- ------------------------------------------------
--- Difficulty display
--- ------------------------------------------------

t[#t+1] = Def.ActorFrame {
	Def.Sprite {
		Texture=THEME:GetPathG("","DifficultyDisplay/_icon"),
		InitCommand=function(self)
			self:diffusealpha(0):sleep(1.75+showdelay*9)
			:xy(dboffset, spacing*9 - (promode and 8 or 0))
			:zoom(0.5):animate(false)
			:accelerate(0.2):diffusealpha(1)

			local steps = GAMESTATE:GetCurrentSteps(player)
			
			if IsGame("pump") then
				self:setstate( ChartType[steps] )
			else
				self:setstate(7):diffuse(CustomDifficultyToColor(StepsOrTrailToCustomDifficulty(steps)))
			end
		end
	},
	
	Def.Sprite {
		Texture=THEME:GetPathG("", "DiffLabels"),
		InitCommand=function(self)
			self:diffusealpha(0):sleep(1.75+showdelay*9)
			:xy(dboffset, spacing*8.5 - (promode and 8 or 0))
			:zoom(0.75):animate(false)
			:accelerate(0.2):diffusealpha(1)
			
			local StepTypeIndex = 10
			for k,v in pairs(DiffLabelIndex) do
				if string.find(string.upper(steps:GetDescription()), v) then
					StepTypeIndex = k - 1
				end
			end
			if string.find(string.upper(steps:GetChartName()), "UCS CONTEST") then
				StepTypeIndex = 9
			end
			self:setstate(StepTypeIndex)
		end
	},
	
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			steps = GAMESTATE:GetCurrentSteps(player)
			self:diffusealpha(0):shadowlength(0.8)
			:sleep(1.75+showdelay*9)
			:xy(dboffset, spacing*9 - (promode and 8 or 0))
			:zoom(0.5):accelerate(0.2):diffusealpha(1)
			
			local meterset = "??"
			if steps:GetMeter() < 99 then
				meterset = steps:GetMeter()
			end
			self:settext(meterset)
		end
	}
}

--- ------------------------------------------------
--- Step Artist
--- ------------------------------------------------

t[#t+1] = Def.ActorFrame {
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:diffusealpha(0):halign(math.abs(alignment - 1))
			:xy(saoffset, spacing*8.7 - (promode and 8 or 0))
			:wrapwidthpixels(960):vertspacing(-10):maxheight(128)
			:shadowlength(0.8):zoom(0.35)
		end,
		OnCommand=function(self)
			self:sleep(1.75+showdelay*8)
			:decelerate(0.3):diffusealpha(1)
			
			local author = steps:GetAuthorCredit()
			if author == nil or author == "" then
				self:settext("Step Artist:\nUnknown")
			else
				self:settext("Step Artist:\n"..author)
			end
		end
	}
}

--- ------------------------------------------------
--- Letter Grade
--- ------------------------------------------------

t[#t+1] = Def.ActorFrame {
	Def.Sound {
		File=THEME:GetPathS("", "EvalLetterHit"),
		OnCommand=function(self)
			self:sleep(2.8):queuecommand("Play")
		end,
		PlayCommand=function(self) self:play() end
	},
	
	Def.Sprite {
		InitCommand=function(self)
			self:zoom(0.8):diffusealpha(0):xy(lgoffset, spacing*3):sleep(2.5)
			
			local gradeletter = "F"
			if misses == 0 then
				if bads == 0 and goods == 0 then
					if greats == 0 then
						gradeletter = promode and (perfects == 0 and "3S" or "2S") or "3S"
					else
						gradeletter = "2S"
					end
				else
					gradeletter = "1S"
				end
			else
				if accuracy >= 80 then
					gradeletter = "A"
				elseif accuracy >= 70 then
					gradeletter = "B"
				elseif accuracy >= 60 then
					gradeletter = "C"
				elseif accuracy >= 50 then
					gradeletter = "D"
				end
			end
			
			local lifeState = "Pass"
			if getenv(pname(player).."StageBreak") == true then
				lifeState = "Fail"
			end
			
			self:Load(THEME:GetPathG("","LetterGrades/"..lifeState..gradeletter))
			:accelerate(0.3):diffusealpha(1):zoom(0.4)
		end
	}
}

return t
