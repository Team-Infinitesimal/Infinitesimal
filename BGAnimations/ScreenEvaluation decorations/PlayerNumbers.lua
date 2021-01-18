local player = ...

local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false;

local alignment = 0;
if player == "PlayerNumber_P2" then alignment = 1 end;

local offsetfromcenterx = -300;
if player == "PlayerNumber_P2" then offsetfromcenterx = 300 end;

local lgoffset = -190;
if player == "PlayerNumber_P2" then lgoffset = 190 end;

local dboffset = -95;
if player == "PlayerNumber_P2" then dboffset = 95 end;

local spacing = 29.2;
local showdelay = 0.08;
local playerstats = STATSMAN:GetCurStageStats():GetPlayerStageStats(player);

local superbs 	=	playerstats:GetTapNoteScores("TapNoteScore_W1");
local perfects 	= 	playerstats:GetTapNoteScores("TapNoteScore_W2");

if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then
	perfects 	= perfects + playerstats:GetTapNoteScores("TapNoteScore_CheckpointHit");
else
	superbs 	= superbs + playerstats:GetTapNoteScores("TapNoteScore_CheckpointHit");
end;

local greats 	= 	playerstats:GetTapNoteScores("TapNoteScore_W3");
local goods 	= 	playerstats:GetTapNoteScores("TapNoteScore_W4");
local bads 		= 	playerstats:GetTapNoteScores("TapNoteScore_W5");
local misses 	= 	playerstats:GetTapNoteScores("TapNoteScore_Miss") +
		            playerstats:GetTapNoteScores("TapNoteScore_CheckpointMiss");

local accuracy 	=	round(playerstats:GetPercentDancePoints()*100, 2);
local combo 	= 	playerstats:MaxCombo();
local score 	= 	scorecap(playerstats:GetScore());

if getenv(pname(player).."Failed") == true then
    lifeState = "Fail"
else
    lifeState = "Pass"
end;

local tripleS = "LetterGrades/"..lifeState.."3S"
local doubleS = "LetterGrades/"..lifeState.."2S"
local singleS = "LetterGrades/"..lifeState.."1S"
local letA = "LetterGrades/"..lifeState.."A"
local letB = "LetterGrades/"..lifeState.."B"
local letC = "LetterGrades/"..lifeState.."C"
local letD = "LetterGrades/"..lifeState.."D"
local letF = "LetterGrades/"..lifeState.."F"

local t = Def.ActorFrame {

	OnCommand=function(self)
		self:shadowlengthx(1)
		:shadowlengthy(1)
		:shadowcolor(0,0,0,1)
		if promode then
			self:addy(spacing/2);
		end;
	end;
	
	--Superbs
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(-spacing)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75)
			:decelerate(0.3)
			if promode then
				self:diffusealpha(1)
				:settext(superbs);
			end;
		end;
	};

	-- Perfects
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(perfects);
		end;
	};

	-- Greats
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(greats);
		end;
	};

	-- Goods
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing*2)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay*2)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(goods);
		end;
	};

	-- Bads
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing*3)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay*3)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(bads);
		end;
	};

	-- Misses
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing*4)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay*4)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(misses);
		end;
	};

	-- Max Combo
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing*5)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay*5)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(combo);
		end;
	};

	-- Accuracy
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing*6)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay*6)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(accuracy.."%");
		end;
	};

	-- Score
	LoadFont("montserrat/_montserrat 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:addy(spacing*7)
			:maxwidth(1000)
			:zoom(0.5);
		end;
		OnCommand=function(self)
			self:sleep(1.75+showdelay*7)
			:decelerate(0.3)
			:diffusealpha(1)
			:settext(score);
		end;
	};
};
--[[
    t[#t+1] = Def.ActorFrame {

        InitCommand=function(self)
            self:shadowlengthx(1)
            :shadowlengthy(1)
            :shadowcolor(0,0,0,1)
            
        end;

        
    };
]]--

--- ------------------------------------------------
--- Difficulty display
--- ------------------------------------------------

t[#t+1] = LoadActor(THEME:GetPathG("","DifficultyDisplay/_icon"))..{
    InitCommand=function(self)
        self:diffusealpha(0)
        :sleep(2)
        :x(dboffset)
        :addy(spacing*3)
        :zoom(0.4)
		:animate(false)
        :accelerate(0.2)
        :diffusealpha(1);

		local steps = GAMESTATE:GetCurrentSteps(player);
		if steps:GetStepsType() == "StepsType_Pump_Single" then
			if (string.find(steps:GetDescription(), "SP")) then
				self:setstate(5);
			else
				self:setstate(2);
			end;
		elseif steps:GetStepsType() == "StepsType_Pump_Double" then
			--Check for StepF2 Double Performance tag
			if string.find(steps:GetDescription(), "DP") then
				if string.find(steps:GetMeter(), "99") then
					self:setstate(1);
				else
					self:setstate(0);
				end;
			else
				self:setstate(6);
			end;
		elseif steps:GetStepsType() == "StepsType_Pump_Halfdouble" then
			self:setstate(5);
		elseif steps:GetStepsType() == "StepsType_Pump_Routine" then
			self:setstate(4);
		else
			self:setstate(3);
		end;
    end;
};

t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{
    InitCommand=function(self)
        steps = GAMESTATE:GetCurrentSteps(player);
        self:diffusealpha(0)
        :shadowlength(0.8)
		:shadowcolor(color("0,0,0,1"))
        :sleep(2)
        :x(dboffset)
        :addy(spacing*3)
        :zoom(0.5)
        :accelerate(0.2)
        :diffusealpha(1)
        :settext(steps:GetMeter());
    end;
};

--- ------------------------------------------------
--- Letter Grade
--- ------------------------------------------------

t[#t+1] = Def.Sprite {
	InitCommand=function(self)
		self:zoom(0.8):diffusealpha(0):addx(lgoffset):addy(spacing*3);
        self:sleep(2.5);
		if misses == 0 then
			if bads == 0 then
				if goods == 0 then
					if (PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' and greats or perfects) == 0 then
							self:Load(THEME:GetPathG("", ""..tripleS));
						else
							self:Load(THEME:GetPathG("", ""..doubleS));
						end;
				else
					self:Load(THEME:GetPathG("", ""..singleS));
				end;
			else
				self:Load(THEME:GetPathG("", ""..singleS));
			end;
		else
			if accuracy >= 50 then
				self:Load(THEME:GetPathG("", ""..letD));
				if accuracy >= 60 then
					self:Load(THEME:GetPathG("", ""..letC));
					if accuracy >= 70 then
						self:Load(THEME:GetPathG("", ""..letB));
						if accuracy >= 80 then
							self:Load(THEME:GetPathG("", ""..letA));
						end
					end
				end
			else
				self:Load(THEME:GetPathG("", ""..letF));
			end
		end;
		self:accelerate(0.3):diffusealpha(1):zoom(0.4);
	end;
};

return t;
