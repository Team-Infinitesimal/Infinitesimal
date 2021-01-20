local promode = PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Everywhere' and true or false;

local t = Def.ActorFrame {};

if promode then
    t[#t+1] = LoadActor(THEME:GetPathG("","EvalElements/ProCenterColumn"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoomy(0)
            :zoomx(0.4925)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            end;
        OnCommand=function(self)
            self:sleep(1)
            :diffusealpha(1)
            :decelerate(0.3)
            :zoomy(0.4925)
            end;
    };
else 
    t[#t+1] = LoadActor(THEME:GetPathG("","EvalElements/CenterColumn"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoomy(0)
            :zoomx(0.4925)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
            end;
        OnCommand=function(self)
            self:sleep(1)
            :diffusealpha(1)
            :decelerate(0.3)
            :zoomy(0.4925)
            end;
    };
end;

t[#t+1] = LoadActor(THEME:GetPathG("","ScreenHudFrame"));

--- ------------------------------------------------
--- Text/Song Info
--- ------------------------------------------------

t[#t+1] = LoadActor(THEME:GetPathG("","EvalElements/EvalSongTitle"))..{
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
		:maxwidth(700)
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
        :maxwidth(700)
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
--- Judgement counts, etc
--- ------------------------------------------------

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = LoadActor("PlayerNumbers", pn)..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,138)
        end;
    };

end;

return t;
