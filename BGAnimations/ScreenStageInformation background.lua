local t = Def.ActorFrame {

  	Def.Sprite {
    		InitCommand=function(self)
            self:LoadFromSongBackground(GAMESTATE:GetCurrentSong())
            :Center()
            :decelerate(1)
            :diffusealpha(0.5);
        end;
    		OnCommand=function(self)
      			local bgSetting = PREFSMAN:GetPreference("BackgroundFitMode")
      			if bgSetting == "FitInsideAvoidLetter" then
                return
      			else
      			    self:zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
      			end;
    		end;
  	};

    Def.Sprite {
        InitCommand=function(self)
            if GAMESTATE:GetCurrentSong():HasBanner() then
                self:Load(GAMESTATE:GetCurrentSong():GetBannerPath());
            else
                self:Load(THEME:GetPathG("","Common fallback songbanner"))
            end;
            self:scaletoclipped(300,300)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
            :decelerate(1)
            :y(SCREEN_CENTER_Y)
            :accelerate(1)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100);
        end;
    };
};

return t
