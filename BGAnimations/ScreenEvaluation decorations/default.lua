local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false;
local CurPrefTiming = LoadModule("Config.Load.lua")("SmartTimings","Save/Infinitesimal.ini")

local t = Def.ActorFrame {};

if promode then
    t[#t+1] = Def.Sprite {
        Texture=THEME:GetPathG("","EvalElements/ProCenterColumn"),
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoomy(0)
            :zoomx(0.83)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            end;
        OnCommand=function(self)
            self:sleep(1)
            :diffusealpha(1)
            :decelerate(0.3)
            :zoomy(0.83)
            end;
    };
else
    t[#t+1] = Def.Sprite {
        Texture=THEME:GetPathG("","EvalElements/CenterColumn"),
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoomy(0)
            :zoomx(0.83)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            end;
        OnCommand=function(self)
            self:sleep(1)
            :diffusealpha(1)
            :decelerate(0.3)
            :zoomy(0.83)
            end;
    };
end;

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenHudFrame"));

--- ------------------------------------------------
--- Text/Song Info
--- ------------------------------------------------

t[#t+1] = Def.Sprite {
  Texture=THEME:GetPathG("","EvalElements/EvalSongTitle"),
	InitCommand=function(self)
		self:diffusealpha(0)
		:zoomy(0)
		:zoomx(0.65)
		:xy(SCREEN_CENTER_X,SCREEN_TOP+85)
	end;
	OnCommand=function(self)
		self:sleep(1)
		:diffusealpha(1)
		:decelerate(0.3)
		:zoomy(0.65)

		if not promode then self:addy(5) end;
	end;
};

t[#t+1] = LoadFont("Montserrat semibold 20px")..{
    InitCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
        self:diffusealpha(0)
        :sleep(1.75)
        :horizalign(center)
        :diffuse(0,0,0,1)
        :settext(song:GetDisplayMainTitle())
		:maxwidth(400)
		:x(SCREEN_CENTER_X):zoom(0.7);

		if song:GetDisplaySubTitle() ~= "" then
			self:y(73);
		else
			self:y(75);
		end;

		if not promode then self:addy(5) end;

        self:decelerate(0.25):diffusealpha(1);
    end;
};

t[#t+1] = LoadFont("Montserrat normal 20px")..{
    InitCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
        self:diffusealpha(0)
        :sleep(1.75)
        :horizalign(center)
        :diffuse(0,0,0,1)
        :maxwidth(400)
        :x(SCREEN_CENTER_X):y(82):zoom(0.35);

        if not promode then self:addy(5) end;

        if song:GetDisplaySubTitle() then
            self:settext(song:GetDisplaySubTitle())
            :decelerate(0.25):diffusealpha(1);
        else
            self:settext(""):diffusealpha(0);
        end;
    end;
};

t[#t+1] = LoadFont("Montserrat normal 20px")..{
    InitCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
        self:diffusealpha(0)
        :sleep(1.75)
        :horizalign(center)
        :diffuse(0,0,0,1)
		:settext(song:GetDisplayArtist())
        :maxwidth(700)
        :x(SCREEN_CENTER_X):zoom(0.6);

		if song:GetDisplaySubTitle() ~= "" then
			self:y(90);
		else
			self:y(88);
		end;

		if not promode then self:addy(5) end;

        self:decelerate(0.25):diffusealpha(1);
    end;
};

--- ------------------------------------------------
--- Judgement counts, score, step artist, etc
--- ------------------------------------------------

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = LoadActor("PlayerNumbers", pn)..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,138)
        end;
    };
end;

--local column = GAMESTATE:GetCurrentStyle():GetColumnInfo( GAMESTATE:GetMasterPlayerNumber(), 2 )
for _,v in pairs(NOTESKIN:GetNoteSkinNames()) do
	-- GetCurrentStyle returns nil whenever the screen is first initialized. If you want support for
	-- other gamemodes than Pump with different arrows, uncomment the line above and replace "UpLeft" with column["Name"]
	t[#t+1] = NOTESKIN:LoadActorForNoteSkin( "UpLeft" , "Tap Note", v )..{
		Name="NS"..string.lower(v), InitCommand=function(s) s:visible(false) end;
		OnCommand=function(s) s:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1) end;
	}
end;

t[#t+1] = LoadActor(THEME:GetPathG("","ModDisplay"));

--- --------------------------
--- Top Left Text
--- --------------------------

-- Text
t[#t+1] = LoadFont("Montserrat Semibold 40px")..{
	InitCommand=function(self)
    if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-250)
		else
			self:x(SCREEN_CENTER_X-220)
		end;
		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("DANCE")
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+26)
	end;
};

t[#t+1] = LoadFont("Montserrat normal 40px")..{
	InitCommand=function(self)
    if GetScreenAspectRatio() >= 1.5 then
			self:x(SCREEN_CENTER_X-190)
		else
			self:x(SCREEN_CENTER_X-160)
		end;
		self:zoom(0.4)
		:shadowcolor(0,0,0,0.25)
		:shadowlength(0.75)
		:diffuse(0,0,0,1)
		:y(SCREEN_TOP-150)
		:settext("GRADE")
	end;
	OnCommand=function(self)
		self:decelerate(1)
		:y(SCREEN_TOP+26)
	end;
};

return t;
