local player = ...

local alignment = 0;
if player == "PlayerNumber_P2" then alignment = 1 end;

local offsetfromcenterx = -300;
if player == "PlayerNumber_P2" then offsetfromcenterx = 300 end;

local lgoffset = -190;
if player == "PlayerNumber_P2" then lgoffset = 190 end;

local dboffset = -95;
if player == "PlayerNumber_P2" then dboffset = 95 end;

local spacing = 29.18;
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

local t = Def.ActorFrame {};

if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then
    t[#t+1] = Def.ActorFrame {

        InitCommand=function(self)
            self:shadowlengthx(1)
            :shadowlengthy(1)
            :shadowcolor(0,0,0,1)
        end;

        -- Perfects
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(perfects)
            end;
        };

        -- Greats
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(greats)
            end;
        };

        -- Goods
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*2)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*2)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(goods)
            end;
        };

        -- Bads
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*3)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*3)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(bads)
            end;
        };

        -- Misses
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*4)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*4)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(misses)
            end;
        };

        -- Max Combo
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*5)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*5)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(combo)
            end;
        };

        -- Accuracy
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*6)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*6)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(accuracy.."%")
            end;
        };

        -- Score
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*7)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*7)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(score)
            end;
        };
    };
else
    t[#t+1] = Def.ActorFrame {

        InitCommand=function(self)
            self:shadowlengthx(1)
            :shadowlengthy(1)
            :shadowcolor(0,0,0,1)
            :addy(spacing/2)
        end;

        --Superbs
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(-spacing)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(superbs)
            end;
        };

        -- Perfects
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(perfects)
            end;
        };

        -- Greats
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(greats)
            end;
        };

        -- Goods
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*2)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*2)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(goods)
            end;
        };

        -- Bads
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*3)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*3)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(bads)
            end;
        };

        -- Misses
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*4)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*4)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(misses)
            end;
        };

        -- Max Combo
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*5)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*5)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(combo)
            end;
        };

        -- Accuracy
        LoadFont("montserrat/_montserrat 40px")..{
            InitCommand=function(self)
                self:halign(alignment)
                :diffusealpha(0)
                :skewx(-0.1)
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
                :skewx(-0.1)
                :x(offsetfromcenterx)
                :addy(spacing*7)
                :maxwidth(1000)
                :zoom(0.5);
            end;
            OnCommand=function(self)
                self:sleep(1.75+showdelay*7)
                :decelerate(0.3)
                :diffusealpha(1)
                :settext(score)
            end;
        };
    };
end;

--- ------------------------------------------------
--- Difficulty display
--- ------------------------------------------------

t[#t+1] = LoadActor(THEME:GetPathG("","DifficultyDisplay/_icon"))..{
    InitCommand=function(self)
        self:diffusealpha(0);
        self:sleep(2);
        self:x(dboffset);
        self:addy(spacing*3);
        self:zoom(0.4);
		self:animate(false);
        self:accelerate(0.2);
        self:diffusealpha(1);

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
        self:diffusealpha(0);
        self:sleep(2);
        self:x(dboffset);
        self:addy(spacing*3);
        self:zoom(0.5);
        self:accelerate(0.2);
        self:diffusealpha(1);
        self:settext(steps:GetMeter());
    end;
};

--- ------------------------------------------------
--- Letter Grade
--- ------------------------------------------------

t[#t+1] = LoadActor(THEME:GetPathG("","LetterGrades"), {lgoffset,superbs,perfects,greats,goods,bads,misses,accuracy,player})..{
    InitCommand=function(self)
        self:addy(spacing*3);
    end;
};

return t;
