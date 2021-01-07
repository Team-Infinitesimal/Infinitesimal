local t = Def.ActorFrame {

	Def.Quad {
		InitCommand=function(self)
			self:zoomtowidth(SCREEN_WIDTH)
			:zoomtoheight(28)
			:horizalign(left)
			:vertalign(top)
			:y(SCREEN_TOP)
			:diffuse(color("0,0,0,0"));
		end;
		OnCommand=function(self)
			self:finishtweening()
			:diffusealpha(0.8);
		end;
		OffCommand=function(self)
			self:sleep(3)
			:linear(0.5)
			:diffusealpha(0);
		end;
	};

	LoadFont("montserrat semibold/_montserrat semibold 40px") .. {
		Name="Text";
		InitCommand=function(self)
			self:maxwidth(SCREEN_WIDTH*2)
			:x(SCREEN_LEFT+8)
			:y(SCREEN_TOP+8)
			:horizalign(left)
			:vertalign(top)
			:diffusealpha(0);
		end;
		OnCommand=function(self)
			self:finishtweening()
			:diffusealpha(1)
			:zoom(0.35);
		end;
		OffCommand=function(self)
			self:sleep(3)
			:linear(0.5)
			:diffusealpha(0);
		end;
	};

	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext(params.Message);
		self:playcommand( "On" );
		if params.NoAnimate then
			self:finishtweening();
			
		end;
		self:playcommand( "Off" );
	end;

	HideSystemMessageMessageCommand = function(self)self:finishtweening()end;

	LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-17)
			:queuecommand('Refresh')
			:diffuse(1,1,1,1)
			:glow(color(0.8,0.8,1,1))
			:zoom(0.4);
		end;

		RefreshCommand=function(self)
			local gMode = GAMESTATE:GetCoinMode();
			local eMode = GAMESTATE:IsEventMode();

			if eMode then
				self:settext("EVENT MODE");
			elseif gMode == 'CoinMode_Free' then
				self:settext("FREE PLAY");
			elseif gMode == 'CoinMode_Pay' then
				local Coins = GAMESTATE:GetCoins();
				self:settext("CREDIT(S): "..Coins);
			else
				self:settext("HOME");
			end;

			if screen then
				if screen:GetScreenType() ~= 'ScreenType_Attract' then
					self:visible(true);
				else
					self:visible(false);
				end;
			end;
		end;

		OnCommand = cmd(playcommand,'Refresh');
		RefreshCreditTextMessageCommand = cmd(playcommand,'Refresh');
		CoinInsertedMessageCommand = cmd(playcommand,'Refresh');
		CoinModeChangedMessageCommand = cmd(playcommand,'Refresh');
		PlayerJoinedMessageCommand = cmd(playcommand,'Refresh');
	};
};

return t;
