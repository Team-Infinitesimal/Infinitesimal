local t = Def.ActorFrame {
	
	LoadActor("ScorePanel");
	
	LoadActor("ChartInfo");
	
	LoadActor("DifficultyBar");
	
	LoadActor("SongPreview");
	
	LoadActor(THEME:GetPathG("","CornerArrows"));
	
};

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
	OptionsListRightMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListLeftMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListQuickChangeMessageCommand=function(self)self:queuecommand("Refresh")end;
	RefreshCommand=function(self)
		self:play();
	end;
};

t[#t+1] = LoadActor(THEME:GetPathS("","OpListChoose"))..{
	OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
	OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
	RefreshCommand=function(self)
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
