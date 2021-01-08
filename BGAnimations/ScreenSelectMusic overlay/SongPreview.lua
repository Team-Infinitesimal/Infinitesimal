local PreviewX = SCREEN_CENTER_X
local PreviewY = SCREEN_CENTER_Y-70;
local PreviewWidth = 340;
local PreviewHeight = 191.25;

local t = Def.ActorFrame {
	
	-- Frame
    LoadActor(THEME:GetPathG("","PreviewFrame"))..{
        InitCommand=function(self)
            self:horizalign(center)
            :xy(PreviewX,PreviewY)
            :zoom(0.75,0.75)
        end;
    };
    
    LoadActor(THEME:GetPathG("","noise"))..{
		InitCommand=function(self)
            self:xy(PreviewX,PreviewY)
            :zoomto(PreviewWidth,PreviewHeight)
            :texcoordvelocity(24,16);
        end;
	};
	
	LoadActor(THEME:GetPathG("","pixelLogo"))..{
		InitCommand=function(self)
            self:xy(PreviewX,PreviewY)
            :zoomto(PreviewWidth*0.8,PreviewHeight*0.8);
        end;
	};
	
	-- Video display
    Def.Sprite {
        InitCommand=function(self)
            self:xy(PreviewX,PreviewY)
        end;

        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0):sleep(0.4);
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
                self:Load(bg);
            else
                self:Load(THEME:GetPathG("","Common fallback background"));
            end;
            self:zoomto(PreviewWidth,PreviewHeight);
        end;

        LoadAnimatedCommand=function(self)
        	self:Load(nil); -- an attempt to clear out previous preview to conserve on memory usage
            local path = GAMESTATE:GetCurrentSong():GetPreviewVidPath()
            if path then
                self:Load(path);
            else
                self:Load(THEME:GetPathG("","static"));
            end;
            self:zoomto(PreviewWidth,PreviewHeight):decelerate(0.2):diffusealpha(1);
        end;
    };
    
    -- Top info panel
    Def.Quad {
        InitCommand=function(self)
            self:xy(PreviewX,PreviewY-86)
			:zoomx(PreviewWidth)
			:zoomy(20)
            :diffuse(0,0,0,0.75)
        end;
    };
    
    -- Title
    LoadFont("Montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(left)
            :x(PreviewX-(PreviewWidth/2)+4)
            :y(PreviewY-86)
            :zoom(0.35)
            :maxwidth(800)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(song:GetDisplayMainTitle()):diffusealpha(1);
            end;
        end;
    };
    
    -- Length
    LoadFont("Montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(right)
            :x(PreviewX+(PreviewWidth/2)-4)
            :y(PreviewY-86)
            :zoom(0.35)
            :maxwidth(550)
        end;

        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            self:stoptweening():diffusealpha(0);
            if song then
                local lengthseconds = SecondsToMMSS(GAMESTATE:GetCurrentSong():MusicLengthSeconds());
                self:settext(lengthseconds):diffusealpha(1);
            end;
        end;
    };
    
    -- Bottom info panel
    Def.Quad {
        InitCommand=function(self)
            self:xy(PreviewX,PreviewY+85.5)
			:zoomx(PreviewWidth)
			:zoomy(20)
            :diffuse(0,0,0,0.75)
        end;
    };
	
	-- Artist
    LoadFont("Montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(left)
            :x(PreviewX-(PreviewWidth/2)+4)
            :y(PreviewY+85.5)
            :zoom(0.35)
            :maxwidth(650)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(song:GetDisplayArtist()):diffusealpha(1);
            end;
        end;
    };
	
	-- BPM
	LoadFont("Montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(right)
            :x(PreviewX+(PreviewWidth/2)-4)
            :y(PreviewY+85.5)
            :zoom(0.35)
            :maxwidth(550)
        end;

        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            self:stoptweening():diffusealpha(0);
            if song then
                local speedvalue;
                if song:IsDisplayBpmRandom() then
                    speedvalue = "???";
                else
                    local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
                    local lobpm = math.ceil(rawbpm[1]);
                    local hibpm = math.ceil(rawbpm[2]);
                    if lobpm == hibpm then
                        speedvalue = hibpm
                    else
                        speedvalue = lobpm.."-"..hibpm
                    end;
                end;
                self:settext(speedvalue.." BPM"):diffusealpha(1);
            end;
        end;
    };

    --[[ 
    Def.ActorFrame {
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
    };
    ]]--
};

return t;
