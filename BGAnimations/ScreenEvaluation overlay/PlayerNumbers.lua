local player = ...
local alignment = 0;
if player == "PlayerNumber_P2" then alignment = 1 end;
local offsetfromcenterx = -300;
if player == "PlayerNumber_P2" then offsetfromcenterx = 300 end;
local lgoffset = -190;
if player == "PlayerNumber_P2" then lgoffset = 190 end;
local spacing = 29.18;
local showdelay = 0.08;

perfects = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2") +
           STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointHit");
local greats = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
local goods = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
local bads = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");
local misses = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss") +
		            STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");

local accuracy = 	round(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints()*100, 2);
local combo = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):MaxCombo();
local score = 	scorecap(STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetScore());

local t = Def.ActorFrame {

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
            :settext(accuracy)
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

    --- ------------------------------------------------
    --- Letter Grade
    --- ------------------------------------------------

    LoadActor(THEME:GetPathG("","LetterGrades"), {lgoffset,perfects,greats,goods,bads,misses,accuracy})..{
        InitCommand=function(self)
            self:addy(spacing*3)
        end;
    };
};

return t;
