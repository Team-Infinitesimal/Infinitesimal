local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","PreviewFrame"))..{
        InitCommand=function(self)
            self:horizalign(center)
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-53)
            :zoom(0.2405,0.2405)
            end;
    };

    LoadActor(THEME:GetPathG("","static"))..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-80)
            :diffusealpha(1)
            :zoomto(360,220)
            end;
    };

    Def.Sprite {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-80)
            :diffusealpha(0)
            end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            if GAMESTATE:GetCurrentSong() then
      					 if GAMESTATE:GetCurrentSong():GetPreviewVidPath() == nil then
      						    self:sleep(.4):queuecommand("Load2");
                 else
                      self:sleep(.4):queuecommand("LoadAnimated")
      			  	 end;
      			end;
        end;
        Load2Command=function(self)
            local bg = GetSongBackground(true)
            if bg then
                self:Load(bg):zoomto(360,220);
            else
                self:Load(THEME:GetPathG("","Common fallback background"));
            end;
            self:zoomto(360,220):linear(.2):diffusealpha(1);
        end;
        LoadAnimatedCommand=function(self)
            local path = GAMESTATE:GetCurrentSong():GetPreviewVidPath()
            if path then
                self:Load(path):zoomto(360,220);
            else
                self:Load(THEME:GetPathG("","Common fallback background"));
            end;
            self:zoomto(360,220):linear(.2):diffusealpha(1);
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
