local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","PreviewFrame"))..{
        InitCommand=function(self)
            self:horizalign(center)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-53)
            :zoom(0.8,0.8)
        end;
    };

    Def.Sprite {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-88.5)
            :Load(THEME:GetPathG("","static"));
        end;
		
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(1):Load(THEME:GetPathG("","static")):zoomto(360,202.5):decelerate(0.4);
            if GAMESTATE:GetCurrentSong() then
				if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil then
      				self:queuecommand("Load2");
                else
                    self:queuecommand("LoadAnimated")
      			end;
			end;
        end;
		
        Load2Command=function(self)
            local bg = GetSongBackground(true)
            if bg then
                self:Load(bg):zoomto(360,202.5);
            else
                self:Load(THEME:GetPathG("","Common fallback background"));
            end;
            self:zoomto(360,202.5);
        end;
		
        LoadAnimatedCommand=function(self)
        	self:Load(nil); -- an attempt to clear out previous preview to conserve on memory usage
            local path = GAMESTATE:GetCurrentSong():GetPreviewVidPath()
            if path then
                self:Load(path):zoomto(360,202.5);
            else
                self:Load(THEME:GetPathG("","Common fallback background"));
            end;
            self:zoomto(360,202.5);
        end;
    };

    --[[ Def.ActorFrame {
        OnCommand=function(self)
            self:xy(SCREEN_CENTER_X+125,SCREEN_CENTER_Y-140)
            :zoomto(0.1,0.1)
        end;
        Def.Sprite {
            InitCommand=function(self)
                self:diffusealpha(0)
                end;
            CurrentSongChangedMessageCommand=function(self)
                self:stoptweening():diffusealpha(0);
                if GAMESTATE:GetCurrentSong() then
          					 if GAMESTATE:GetCurrentSong():GetCDTitlePath() then
          						    self:Load(GAMESTATE:GetCurrentSong():GetCDTitlePath());
                          self:diffusealpha(1);
          			  	 end;
          			end;
            end;
        };
    }; --]]
};

return t;
