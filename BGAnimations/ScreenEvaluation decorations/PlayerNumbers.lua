local player = ...
local alignment = 0;
if player == "PlayerNumber_P2" then alignment = 1 end;
local offsetfromcenterx = -300;
if player == "PlayerNumber_P2" then offsetfromcenterx = 300 end;
local spacing = 29.15;

perfects = STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W2") +
           STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointHit");
local greats = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W3");
local goods = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W4");
local bads = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_W5");
local misses = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_Miss") +
		            STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetTapNoteScores("TapNoteScore_CheckpointMiss");

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
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :diffusealpha(1)
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
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :addy(spacing)
            :diffusealpha(1)
            :maxwidth(1000)
            :zoom(0.5);
        end;
        OnCommand=function(self)
            self:sleep(1.75)
            :decelerate(0.3)
            :diffusealpha(1)
            :settext(greats)
        end;
    };

    -- Goods
    LoadFont("montserrat/_montserrat 40px")..{
        InitCommand=function(self)
            self:halign(alignment)
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :addy(spacing*2)
            :diffusealpha(1)
            :maxwidth(1000)
            :zoom(0.5);
        end;
        OnCommand=function(self)
            self:sleep(1.75)
            :decelerate(0.3)
            :diffusealpha(1)
            :settext(goods)
        end;
    };

    -- Bads
    LoadFont("montserrat/_montserrat 40px")..{
        InitCommand=function(self)
            self:halign(alignment)
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :addy(spacing*3)
            :diffusealpha(1)
            :maxwidth(1000)
            :zoom(0.5);
        end;
        OnCommand=function(self)
            self:sleep(1.75)
            :decelerate(0.3)
            :diffusealpha(1)
            :settext(bads)
        end;
    };

    -- Misses
    LoadFont("montserrat/_montserrat 40px")..{
        InitCommand=function(self)
            self:halign(alignment)
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :addy(spacing*4)
            :diffusealpha(1)
            :maxwidth(1000)
            :zoom(0.5);
        end;
        OnCommand=function(self)
            self:sleep(1.75)
            :decelerate(0.3)
            :diffusealpha(1)
            :settext(misses)
        end;
    };

    -- Max Combo
    LoadFont("montserrat/_montserrat 40px")..{
        InitCommand=function(self)
            self:halign(alignment)
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :addy(spacing*5)
            :diffusealpha(1)
            :maxwidth(1000)
            :zoom(0.5);
        end;
        OnCommand=function(self)
            self:sleep(1.75)
            :decelerate(0.3)
            :diffusealpha(1)
            :settext(combo)
        end;
    };

    -- Score
    LoadFont("montserrat/_montserrat 40px")..{
        InitCommand=function(self)
            self:halign(alignment)
            :skewx(-0.1)
            :x(offsetfromcenterx)
            :addy(spacing*7)
            :diffusealpha(1)
            :maxwidth(1000)
            :zoom(0.5);
        end;
        OnCommand=function(self)
            self:sleep(1.75)
            :decelerate(0.3)
            :diffusealpha(1)
            :settext(score)
        end;
    };
};

return t;
