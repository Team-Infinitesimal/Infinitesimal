local t = Def.ActorFrame {
		SystemMessageMessageCommand = function(self, params)
				self:GetChild("Text"):settext( params.Message );
				self:playcommand( "On" );
				if params.NoAnimate then
						self:finishtweening();
				end
				self:playcommand( "Off" );
		end;
		HideSystemMessageMessageCommand = cmd(finishtweening);

		LoadActor(THEME:GetPathG("","coinmode"))..{
				InitCommand=function(self)
						self:x(SCREEN_CENTER_X)
						:y(SCREEN_BOTTOM-15)
						:zoom(0.18)
						:animate(false)
						:queuecommand('Refresh')
						end;
				RefreshCommand=function(self)
						local gMode = GAMESTATE:GetCoinMode();
						local eMode = GAMESTATE:IsEventMode();
						local screen = SCREENMAN:GetTopScreen();
						if eMode then
								self:setstate(2);
						else
								if gMode == 'CoinMode_Free' then
										self:setstate(1);
								elseif gMode == 'CoinMode_Pay' then
										self:setstate(0);
								end;
						end;
				end;
				OnCommand = cmd(playcommand,'Refresh');
				RefreshCreditTextMessageCommand = cmd(playcommand,'Refresh');
				CoinInsertedMessageCommand = cmd(playcommand,'Refresh');
				CoinModeChangedMessageCommand = cmd(playcommand,'Refresh');
				PlayerJoinedMessageCommand = cmd(playcommand,'Refresh');
		};

		LoadFont("Montserrat semibold 20px")..{
				InitCommand=function(self)
						self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-21)
						:queuecommand('Refresh')
						:zoom(0.75)
						end;
				RefreshCommand=function(self)
						local gMode = GAMESTATE:GetCoinMode();
						local eMode = GAMESTATE:IsEventMode();
						if eMode then
								self:visible(false);
						else
								if gMode == 'CoinMode_Free' then
										self:visible(false);
								elseif gMode == 'CoinMode_Pay' then
										self:visible(true);
										local Coins = GAMESTATE:GetCoins();
										self:settext("CREDIT(S): "..Coins);
								end;
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
