local player = ...

local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false;

local alignment = 0;
if player == "PlayerNumber_P2" then alignment = 1 end;

local offsetfromcenterx = 265;
if GetScreenAspectRatio() >= 1.5 then
	offsetfromcenterx = 300;
end

local lgoffset = 170;
if GetScreenAspectRatio() >= 1.5 then
	lgoffset = 185;
end

local dboffset = 40;
local saoffset = 100;

if player == "PlayerNumber_P1" then 
	offsetfromcenterx = -offsetfromcenterx;
	lgoffset = -lgoffset;
	dboffset = -dboffset;
	saoffset = -saoffset;
end;

local spacing = 29.1;
local showdelay = 0.08;

local steps = GAMESTATE:GetCurrentSteps(player);
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

if getenv(pname(player).."StageBreak") == true then
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
		if promode then
			self:addy(spacing/2);
		end;
	end;

	--Superbs
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, -spacing)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:x(offsetfromcenterx)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing*2)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing*3)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing*4)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing*5)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing*6)
			:shadowlength(0.8)
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
	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:halign(alignment)
			:diffusealpha(0)
			:xy(offsetfromcenterx, spacing*7)
			:shadowlength(0.8)
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

--- ------------------------------------------------
--- Difficulty display
--- ------------------------------------------------

t[#t+1] = LoadActor(THEME:GetPathG("","DifficultyDisplay/_icon"))..{
    InitCommand=function(self)
        self:diffusealpha(0)
        :sleep(1.75+showdelay*9)
        :xy(dboffset, spacing*9 - (promode and 8 or 0))
        :zoom(0.5)
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

t[#t+1] = LoadFont("Montserrat semibold 40px")..{
    InitCommand=function(self)
        steps = GAMESTATE:GetCurrentSteps(player);
        self:diffusealpha(0)
        :shadowlength(0.8)
        :sleep(1.75+showdelay*9)
        :xy(dboffset, spacing*9 - (promode and 8 or 0))
        :zoom(0.5)
        :accelerate(0.2)
        :diffusealpha(1)
        :settext(steps:GetMeter());
    end;
};

--- ------------------------------------------------
--- Step Artist
--- ------------------------------------------------

t[#t+1] = LoadFont("Montserrat semibold 40px")..{
    InitCommand=function(self)
		self:diffusealpha(0)
		:halign(math.abs(alignment - 1))
		:xy(saoffset, spacing*8.7 - (promode and 8 or 0))
		:wrapwidthpixels(960):vertspacing(-10):maxheight(128)
		:shadowlength(0.8)
		:zoom(0.35);
	end;
	OnCommand=function(self)
		self:sleep(1.75+showdelay*8)
		:decelerate(0.3)
		:diffusealpha(1)
		:settext("Step Artist:\n"..steps:GetAuthorCredit() or "Unknown")
	end;
};

--- ------------------------------------------------
--- Letter Grade
--- ------------------------------------------------

t[#t+1] = Def.Sound {
	File=THEME:GetPathS("", "EvalLetterHit"),
	OnCommand=function(self)
		self:sleep(2.8)
		:queuecommand("Play")
	end;
	PlayCommand=function(self)
		self:play()
	end;
};

t[#t+1] = Def.Sprite {
	InitCommand=function(self)
		self:zoom(0.8):diffusealpha(0):xy(lgoffset, spacing*3);
        self:sleep(2.5);
        
        local gradeletter = "F";
		if misses == 0 then
			if bads == 0 and goods == 0 then
				if greats == 0 then
					gradeletter = promode and (perfects == 0 and "3S" or "2S") or "3S";
				else
					gradeletter = "2S";
				end;
			else
				gradeletter = "1S";
			end;
		else
			if accuracy >= 80 then
				gradeletter = "A";
			elseif accuracy >= 70 then
				gradeletter = "B";
			elseif accuracy >= 60 then
				gradeletter = "C";
			elseif accuracy >= 50 then
				gradeletter = "D";
			end;
		end;
		
		self:Load(THEME:GetPathG("","LetterGrades/"..lifeState..gradeletter));
		self:accelerate(0.3):diffusealpha(1):zoom(0.4);
	end;
};

return t;
