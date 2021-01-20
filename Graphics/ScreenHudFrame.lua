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

-- Profile name display
for pn in ivalues(PlayerNumber) do

	t[#t+1] = LoadFont("Montserrat normal 40px")..{

		InitCommand=function(self)
			self:y(SCREEN_BOTTOM+80)
			:zoom(0.35)
			:diffuse(color("1,1,1,0"))
			:shadowlength(1)

			if (pn == PLAYER_1) then
				self:horizalign(right)
				self:x(SCREEN_CENTER_X-110)
			else
				self:horizalign(left)
				self:x(SCREEN_CENTER_X+110)
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
			:y(SCREEN_BOTTOM-20)
		end;
	};
	
end;

return t;
