local t = Def.ActorFrame {
	
	LoadActor("ScorePanel");
	
	LoadActor("ChartInfo");
	
	LoadActor("DifficultyBar");
	
	LoadActor("SongPreview");
	
	LoadActor("CornerArrows");
	
};

for pn in ivalues(PlayerNumber) do

	t[#t+1] = LoadFont("Montserrat normal 40px")..{

		InitCommand=function(self)
			self:y(SCREEN_BOTTOM+80)
			:zoom(0.35)
			:diffuse(color("1,1,1,0"))

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

t[#t+1] = LoadActor("GroupSelect");

return t;
