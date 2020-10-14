local t = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","SongFrame"))..{
		InitCommand=function(self)
			self:zoom(0.69) -- nice
			:x(SCREEN_CENTER_X)
			:y(SCREEN_CENTER_Y+135)
			:decelerate(0.2)
			:diffusealpha(1);
		end;
		
		CurrentSongChangedMessageCommand=function(self)
			self:stoptweening()
			:zoom(0.74)
			:decelerate(0.4)
			:zoom(0.69);
		end;
		
		SongUnchosenMessageCommand=function(self)self:playcommand("On");end;
		PlayerJoinedMessageCommand=function(self)self:playcommand("On");end;
		
		OnCommand=function(self)
			self:stoptweening()
			:zoom(0.69)
			:decelerate(0.2)
			:diffusealpha(1);
		end;
		
		SongChosenMessageCommand=function(self)
			self:stoptweening()
			:decelerate(0.2)
			:diffusealpha(0);
		end;
	};

	LoadActor("SongPreview");

	Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-175)
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
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-2)
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
            :maxwidth(850)
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
            :y(SCREEN_CENTER_Y-2)
            :zoom(0.4,0.4)
            :skewx(-0.2)
            :maxwidth(550)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(song:GetDisplayArtist());
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
            :y(SCREEN_CENTER_Y-2)
            :zoom(0.4,0.4)
			:maxwidth(300)
        end;

        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0)
            self:queuecommand("SetBPM");
        end;

        SetBPMCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            self:diffusealpha(0);
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
                self:settext("BPM "..speedvalue);
                self:decelerate(0.2)
                self:diffusealpha(1)
                self:skewx(-0.2)
            else
                self:stoptweening():linear(0.25):diffusealpha(0);
            end;
            self:sleep(2):decelerate(0.2):diffusealpha(0);
            self:queuecommand("SetLength");
        end;

        SetLengthCommand=function(self)
            local song = GAMESTATE:GetCurrentSong();
            self:diffusealpha(0);
            if song then
                local lengthseconds = SecondsToMMSS(GAMESTATE:GetCurrentSong():MusicLengthSeconds());
                self:settext(lengthseconds);
                self:decelerate(0.2)
                self:diffusealpha(1)
                self:skewx(-0.2)
            else
                self:stoptweening():linear(0.25):diffusealpha(0);
            end;
            self:sleep(2):decelerate(0.2):diffusealpha(0);
            self:queuecommand("SetBPM");
        end;
    };

  	LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(93);
		end;
  	};

    --LoadActor(THEME:GetPathG("","Readies"));
};

t[#t+1] = LoadActor("GroupSelect");

for pn in ivalues(PlayerNumber) do

	t[#t+1] = LoadFont("montserrat semibold/_montserrat semibold 40px")..{

		InitCommand=function(self)
			self:y(SCREEN_BOTTOM+79)
			:zoom(0.4)
			:diffuse(color("0,0,0,0"))
			
			if (pn == PLAYER_1) then
				self:horizalign(right)
				self:x(SCREEN_CENTER_X-110)
			else
				self:horizalign(left)
				self:x(SCREEN_CENTER_X+110)
			end;
			
			self:queuecommand("Set");
		end;
		
		OnCommand=function(self)self:queuecommand("Set")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Set")end;
		PlayerUnjoinedMessageCommand=function(self)self:queuecommand("Set")end;

		-- Update when a player joins
		SetCommand=function(self)
			if GAMESTATE:IsHumanPlayer(pn) then
				self:visible(true);
				local profile = PROFILEMAN:GetProfile(pn):GetDisplayName();
				if profile == "" then
					if (pn == PLAYER_1) then
						self:settext("Player 1");
					else
						self:settext("Player 2");
					end;
				else
					self:settext(profile)
				end;
			end;
			
			self:sleep(0.25)
			self:decelerate(0.75)
			self:diffusealpha(1)
			self:y(SCREEN_BOTTOM-21)
		end;
	};
end;

t[#t+1] = LoadActor(THEME:GetPathS("","OpenCommandWindow"))..{
	CodeMessageCommand=function(self, params)
		if params.Name == "OpenOpList" then
			opListPn = params.PlayerNumber;
			SCREENMAN:GetTopScreen():OpenOptionsList(opListPn);
			self:play();
		end;
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","CloseCommandWindow"))..{
	OptionsListClosedMessageCommand=function(self)
		self:play();
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","OpListScroll"))..{
	OptionsListRightMessageCommand=function(self)
		self:play();
	end;
	OptionsListLeftMessageCommand=function(self)
		self:play();
	end;
	OptionsListQuickChangeMessageCommand=function(self)
		self:play();
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","OpListChoose"))..{
	OptionsListStartMessageCommand=function(self)
		self:play();
	end;
	OptionsListResetMessageCommand=function(self)
		self:play();
	end;
	OptionsListPopMessageCommand=function(self)
		self:play();
	end;
	OptionsListPushMessageCommand=function(self)
		self:play();
	end;
};

for pn in ivalues(PlayerNumber) do
	t[#t+1] = LoadActor(THEME:GetPathG("","OpList")) ..{
		InitCommand=function(self,params)
			self:draworder(100)
			:diffusealpha(0)
			:zoom(0.5)
			:y(SCREEN_CENTER_Y);

			if pn then
				if pn == PLAYER_1 then
					self:x(SCREEN_LEFT-100);
				elseif pn == PLAYER_2 then
					self:x(SCREEN_RIGHT+100);
				end;
			end;
		end;

		OptionsListOpenedMessageCommand=function(self,params)
			if params.Player == pn then
				self:playcommand("slideOn");
			end;
		end;

		OptionsListClosedMessageCommand=function(self,params)
			if params.Player == pn then
				self:playcommand("slideOff");
			end;
		end;

		slideOnCommand=function(self)
			self:diffusealpha(1):decelerate(0.25);
			if pn then
				if pn == PLAYER_1 then
					self:x(SCREEN_LEFT+100);
				elseif pn == PLAYER_2 then
					self:x(SCREEN_RIGHT-100);
				end;
			end;
		end;

		slideOffCommand=function(self)
			self:diffusealpha(1):decelerate(0.25);
			if pn then
				if pn == PLAYER_1 then
					self:x(SCREEN_LEFT-100);
				elseif pn == PLAYER_2 then
					self:x(SCREEN_RIGHT+100);
				end;
			end;
		end;
	};
end;

return t;
