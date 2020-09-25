local t = Def.ActorFrame {
	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext(params.Message);
		self:playcommand( "On" );
		if params.NoAnimate then
			self:finishtweening();
		end;
		self:playcommand( "Off" );
	end;
	HideSystemMessageMessageCommand = cmd(finishtweening);

	--[[LoadActor(THEME:GetPathG("","coinmode"))..{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X)
			:y(SCREEN_BOTTOM-14.5)
			:zoom(0.16)
			:animate(false)
			:queuecommand('Refresh')
		end;
				
		RefreshCommand=function(self)
			local gMode = GAMESTATE:GetCoinMode();
			local eMode = GAMESTATE:IsEventMode();
			local screen = SCREENMAN:GetTopScreen();
			
			if eMode then
				self:visible(true);
				self:setstate(2);
			elseif gMode == 'CoinMode_Free' then
				self:visible(true);
				self:setstate(1);
			elseif gMode == 'CoinMode_Pay' then
				self:visible(true);
				self:setstate(0);
			else
				self:visible(false);
			end;
		end;
		
		OnCommand = cmd(playcommand,'Refresh');
		RefreshCreditTextMessageCommand = cmd(playcommand,'Refresh');
		CoinInsertedMessageCommand = cmd(playcommand,'Refresh');
		CoinModeChangedMessageCommand = cmd(playcommand,'Refresh');
		PlayerJoinedMessageCommand = cmd(playcommand,'Refresh');
	};]]

	LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-19.5)
			:queuecommand('Refresh')
			:zoom(1)
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
