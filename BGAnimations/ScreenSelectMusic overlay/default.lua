local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","ScreenHudTop"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(top)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
            :diffusealpha(1)
            :zoom(0.2135,0.2135)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_TOP)
        end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudBottom"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(bottom)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100)
            :diffusealpha(1)
            :zoom(0.2135,0.2135)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_BOTTOM)
        end;
    };

    LoadActor("ChartInfo");

    LoadActor("songPreview");

    LoadActor("CornerArrows");

	Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-174)
            :diffuse(0,0,0,0.6)
        end;
        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:stoptweening():diffusealpha(0);
                self:zoomx(0);
                self:decelerate(0.2);
                self:diffusealpha(0.75);
                self:sleep(0.2);
                self:zoomy(20);
                self:decelerate(0.35);
                self:zoomx(350);
            else
                self:stoptweening():diffusealpha(0);
            end;
        end;
    };

    Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+14)
            :diffuse(0,0,0,0.6)
        end;
        CurrentSongChangedMessageCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:stoptweening():diffusealpha(0);
                self:zoomx(0);
                self:decelerate(0.2);
                self:diffusealpha(0.75);
                self:sleep(0.2);
                self:zoomy(20);
                self:decelerate(0.35);
                self:zoomx(350);
            else
                self:stoptweening():diffusealpha(0);
            end;
        end;
    };

    LoadFont("montserrat semibold/_montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(center)
            :x(SCREEN_CENTER_X)
            :y(SCREEN_CENTER_Y-175)
            :zoom(0.4,0.4)
            :skewx(-0.2)
            :maxwidth(800)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(song:GetDisplayMainTitle());
                self:decelerate(0.2);
                self:diffusealpha(1);
            else
                self:stoptweening():linear(0.25):diffusealpha(0);
            end;
        end;
    };

    LoadFont("montserrat semibold/_montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(left)
            :x(SCREEN_CENTER_X-170)
            :y(SCREEN_CENTER_Y+14)
            :zoom(0.4,0.4)
            :skewx(-0.2)
            :maxwidth(800)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:maxwidth(480);
                self:settext("ARTIST: "..song:GetDisplayArtist());
                self:decelerate(0.2);
                self:diffusealpha(1);
            else
                self:stoptweening():linear(0.25):diffusealpha(0);
            end;
        end;
    };

	LoadFont("montserrat semibold/_montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(right)
            :x(SCREEN_CENTER_X+172)
            :y(SCREEN_CENTER_Y+14)
            :zoom(0.4,0.4)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0)
            local song = GAMESTATE:GetCurrentSong();
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
                        speedvalue = lobpm.." - "..hibpm
                    end;
                end;
                self:settext("BPM: "..speedvalue);
                self:decelerate(0.2)
                self:diffusealpha(1)
                self:skewx(-0.2)
            else
                self:stoptweening():linear(0.25):diffusealpha(0);
            end;
        end;
    };

	LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(111);
		end;
	};
};

for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{

		InitCommand=function(self)
			self:y(SCREEN_BOTTOM+100)
			:zoom(0.4,0.4)
			:diffuse(color("0,0,0,1"))
			:visible(GAMESTATE:IsHumanPlayer(pn))

			local profile = PROFILEMAN:GetProfile(pn);
			local name = profile:GetDisplayName();
			if (name == "") then
				self:settext("No Name")
			else
				self:settext(name)
			end;

			if (pn == PLAYER_1) then
				self:horizalign(left)
				self:x(SCREEN_CENTER_X-190)
			else
				self:horizalign(right)
				self:x(SCREEN_CENTER_X+190)
			end;

			self:diffusealpha(0)
			self:decelerate(1)
			self:diffusealpha(1)
			self:y(SCREEN_BOTTOM-21)

		end;

		-- Update when a player joins
		PlayerJoinedMessageCommand=function(self)
			self:visible(GAMESTATE:IsHumanPlayer(pn))

			local profile = PROFILEMAN:GetProfile(pn);
			local name = profile:GetDisplayName();
			if (name == "") then
				self:settext("No Name")
			else
				self:settext(name)
			end;
		end;
	};
end;

return t;
