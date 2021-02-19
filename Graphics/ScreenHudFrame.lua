local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","ScreenHudTop"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(top)
			:zoom(0.835)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
            :diffusealpha(1)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_TOP)
        end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudBottom"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(bottom)
			:zoom(0.835)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100)
            :diffusealpha(1)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_BOTTOM)
        end;
    };

};

-- Avatars
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

  t[#t+1] = LoadActor(THEME:GetPathG("", "EmptyAvatarSlot"))..{
    InitCommand=function(self)
      self:zoom(0.26)
      if pn == "PlayerNumber_P1" then
        self:x(SCREEN_CENTER_X - 138)
        :y(SCREEN_BOTTOM + 80)
      elseif pn == "PlayerNumber_P2" then
        self:x(SCREEN_CENTER_X + 138)
        :y(SCREEN_BOTTOM + 80)
        :rotationy(180)
      end;
    end;

    PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end;
		PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end;
		ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end;

    OnCommand=function(self)
			self:sleep(0.25)
      :decelerate(0.75)
			:diffusealpha(1)
			:y(SCREEN_BOTTOM-28)
		end;
  }

  t[#t+1] = LoadActor(THEME:GetPathG("", "AvatarMask"))..{
    InitCommand=function(self)
      self:zoom(0.26)
      self:MaskSource()
      if pn == "PlayerNumber_P1" then
        self:x(SCREEN_CENTER_X - 138)
        :y(SCREEN_BOTTOM + 80)
      elseif pn == "PlayerNumber_P2" then
        self:x(SCREEN_CENTER_X + 138)
        :y(SCREEN_BOTTOM + 80)
        :rotationy(180)
      end;
    end;

    PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end;
		PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end;
		ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end;

    OnCommand=function(self)
			self:sleep(0.25)
      :decelerate(0.75)
			:diffusealpha(1)
			:y(SCREEN_BOTTOM-28)
		end;
  }

  t[#t+1] = Def.Sprite {
    Texture = GetPlayerAvatar(pn);
    InitCommand = function(self)
      if pn == "PlayerNumber_P1" then
        self:x(SCREEN_CENTER_X - 138)
      elseif pn == "PlayerNumber_P2" then
        self:x(SCREEN_CENTER_X + 138)
      end;
      self:y(SCREEN_BOTTOM + 80)
      :zoomto(130,130)
      :MaskDest();
    end;

    PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end;
		PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end;
		ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end;

    OnCommand=function(self)
			self:sleep(0.25)
      :decelerate(0.75)
			:diffusealpha(1)
			:y(SCREEN_BOTTOM-28)
		end;
  };

end;

-- Profile name display
for pn in ivalues(PlayerNumber) do

	t[#t+1] = LoadFont("Montserrat normal 40px")..{

		InitCommand=function(self)
			self:y(SCREEN_BOTTOM+85)
			:zoom(0.3)
			:diffuse(color("1,1,1,0"))
			:shadowlength(1)

			if (pn == PLAYER_1) then
				self:horizalign(right)
				self:x(SCREEN_CENTER_X-75)
			else
				self:horizalign(left)
				self:x(SCREEN_CENTER_X+75)
			end;

			self:queuecommand("On");
		end;

		PlayerJoinedMessageCommand=function(self)self:queuecommand("On")end;
		PlayerUnjoinedMessageCommand=function(self)self:queuecommand("On")end;
		ReloadedProfilesMessageCommand=function(self)self:queuecommand("On")end;

		-- Update when a player joins
		OnCommand=function(self)
			if GAMESTATE:IsHumanPlayer(pn) then
				GAMESTATE:LoadProfiles();
				local profile = PROFILEMAN:GetProfile(pn):GetDisplayName();
				if profile == "" then
					self:settext("")
				else
					self:settext(profile)
				end;
			end;

			self:sleep(0.25)
      :decelerate(0.75)
			:diffusealpha(1)
			:y(SCREEN_BOTTOM-15)
		end;
	};

end;

return t;
