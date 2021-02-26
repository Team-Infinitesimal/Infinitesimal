--[[
	This code has been borrowed from the PIU Delta theme,
	credits goes to Luizsan, Rhythm Lunatic and everyone
	else who has contributed to that theme. This code has
	replaced all the cmd calls and removed basic mode.
]]

local baseZoom = 0.25
local spacing = 29
local delay = 2

local baseX = -(spacing*6.5)
local baseY = 20

local stepsArray, stepsSelected

function GetCurrentStepsIndex(pn)
	local playerSteps = GAMESTATE:GetCurrentSteps(pn)
	for i=1,#stepsArray do
		if playerSteps == stepsArray[i] then
			return i
		end
	end
	-- If it reaches this point, the selected steps doesn't equal anything.
	return -1
end

function SetCurrentStepsIndex(pn, index)
	for i=1,#stepsArray do
		if index == stepsArray[i] then
			GAMESTATE:SetCurrentSteps(pn, stepsArray[i])
		end
	end
end

local t = Def.ActorFrame {}

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

local DiffDisplay = Def.ActorFrame{
	CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
	CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
	CurrentSongChangedMessageCommand=function(self) self:playcommand("Refresh") end,
	NextSongMessageCommand=function(self) self:playcommand("Refresh") end,
	PreviousSongMessageCommand=function(self) self:playcommand("Refresh") end,
	
	RefreshCommand=function(self)
		self:stoptweening()

		local song = GAMESTATE:GetCurrentSong()
		if song then
			stepsArray = SongUtil.GetPlayableSteps(song)
		else
			stepsArray = nil
		end

		if stepsArray then
			local offset = 0
			-- Generate the index of steps to choose from.
			if GetCurrentStepsIndex(PLAYER_1) > 14 or GetCurrentStepsIndex(PLAYER_2) > 14 then
				if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
					offset = GetCurrentStepsIndex(PLAYER_1)-14;
				else
					offset = GetCurrentStepsIndex(PLAYER_2)-14;
				end;
			end;
			for i=1,14 do
				if stepsArray[ i+offset ] then
					local steps = stepsArray[ i+offset ]
					local meterset = "??"
					local StepTypeIndex = 10
					if steps:GetMeter() < 99 then
						meterset = steps:GetMeter()
					end

					for k,v in pairs(DiffLabelIndex) do
						if string.find(string.upper(steps:GetDescription()), v) then
							StepTypeIndex = k - 1
						end
					end
					
					if string.find(string.upper(steps:GetChartName()), "UCS CONTEST") then
						StepTypeIndex = 9
					end

					self:GetChild("")[i]:diffusealpha(1)
					self:GetChild("")[i]:GetChild("Icon"):setstate( ChartType[steps] )
					self:GetChild("")[i]:GetChild("Diff"):settext( meterset )
					self:GetChild("")[i]:GetChild("Label"):setstate( StepTypeIndex )
				else
					self:GetChild("")[i]:GetChild("Icon"):setstate(7)
					self:GetChild("")[i]:GetChild("Diff"):settext("--")
					self:GetChild("")[i]:diffusealpha(0.3)
					self:GetChild("")[i]:GetChild("Label"):setstate( 10 )
				end
			end
		else
			for i=1,14 do
				self:GetChild("")[i]:GetChild("Icon"):setstate(7)
				self:GetChild("")[i]:GetChild("Diff"):settext("--")
				self:GetChild("")[i]:diffusealpha(0.3)
				self:GetChild("")[i]:GetChild("Label"):setstate( 10 )
			end
		end
	end
}

for i=1,14 do
	-- The original code was an absolute fucking nightmare
	-- Re: I really do not want to know how it was. -Jose_Varela
	DiffDisplay[#DiffDisplay+1] = Def.ActorFrame {
		Def.Sprite{
			Texture="_icon",
			Name="Icon",
			InitCommand=function(self)
				self:zoom(baseZoom):xy(baseX+spacing*(i-1),baseY):animate(false)
			end,
		},

		Def.Sprite{
			Texture=THEME:GetPathG("", "DiffLabels"),
			Name="Label",
			InitCommand=function(self)
				self:zoom(baseZoom*2):xy(baseX+spacing*(i-1), baseY-8):animate(false)
			end,
		},

		Def.BitmapText{
			Font="montserrat semibold/_montserrat semibold 40px",
			Name="Diff",
			InitCommand=function(self)
				self:zoom(baseZoom):shadowlength(0.8):xy(baseX+spacing*(i-1),baseY)
			end
		}
	}
end


t[#t+1] = DiffDisplay

for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor("UnifiedCursor", pn)..{
		InitCommand=function(self)
			self:zoom(baseZoom):xy(baseX,baseY):visible(false)
		end,
		
		CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end,
		CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end,
		SongUnchosenMessageCommand=function(self) self:playcommand("HideCursor") end,
		
		SongChosenMessageCommand=function(self)
			stepsSelected = true
			if GAMESTATE:IsHumanPlayer(pn) then
				self:visible(true):playcommand("Set")
			end
		end,
		
		HideCursorCommand=function(self)
			stepsSelected = false
			self:visible(false)
		end,
		
		SetCommand=function(self)
			if stepsArray and stepsSelected and GAMESTATE:IsHumanPlayer(pn) then
				local ind = GetCurrentStepsIndex(pn)
				local offset = 0
				-- Generate the index of steps to choose from.
				if GetCurrentStepsIndex(PLAYER_1) > 14 or GetCurrentStepsIndex(PLAYER_2) > 14 then
					if GetCurrentStepsIndex(PLAYER_1) > GetCurrentStepsIndex(PLAYER_2) then
						offset = GetCurrentStepsIndex(PLAYER_1)-14;
					else
						offset = GetCurrentStepsIndex(PLAYER_2)-14;
					end;
				end;
				self:x( baseX + (ind-offset-1) * spacing )
				self:visible(not (ind-offset < 1 or ind-offset > 14))
			end
		end
	}
end

return t
