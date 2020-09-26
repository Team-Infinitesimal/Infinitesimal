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

	LoadFont("Montserrat semibold 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-19.5)
			:queuecommand('Refresh')
			:diffuse(0.9,0.9,1,1)
			:glow(color(1,1,1,1))
			:zoom(1);
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
