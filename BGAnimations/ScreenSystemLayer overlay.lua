local t = Def.ActorFrame {
    Def.BitmapText {
        Font="Common normal",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM - 22):shadowlength(1):queuecommand('Refresh')
		end,
		
		OnCommand=function(self) self:playcommand('Refresh') end,
		RefreshCreditTextMessageCommand=function(self) self:playcommand('Refresh') end,
		CoinInsertedMessageCommand=function(self) self:playcommand('Refresh') end,
		CoinModeChangedMessageCommand=function(self) self:playcommand('Refresh') end,
		PlayerJoinedMessageCommand=function(self) self:playcommand('Refresh') end,

		RefreshCommand=function(self)
			local CoinMode = GAMESTATE:GetCoinMode()
			local EventMode = GAMESTATE:IsEventMode()
			
			-- no one wants screen burn-in at home!
			if CoinMode == "CoinMode_Home" then
				self:visible(false)
			elseif EventMode then
				self:visible(true):settext("EVENT MODE")
			elseif CoinMode == 'CoinMode_Free' then
				self:visible(true):settext("FREE PLAY")
			elseif CoinMode == 'CoinMode_Pay' then
                local CreditText = "CREDIT(S) " .. GAMESTATE:GetCoins() .. "/" .. GAMESTATE:GetCoinsNeededToJoin()
				self:visible(true):settext(CreditText)
			end
		end
	}
}

-- SCREENMAN:SystemMessage display
t[#t+1] = Def.ActorFrame {
	Def.Quad {
		InitCommand=function (self)
			self:zoomtowidth(SCREEN_WIDTH):zoomtoheight(30):horizalign(left):vertalign(top):y(SCREEN_TOP):diffuse(color("0,0,0,0"))
		end,
		OnCommand=function (self)
			self:finishtweening():diffusealpha(0.85)
		end,
		OffCommand=function (self)
			self:sleep(3):linear(0.5):diffusealpha(0)
		end
	},
    
	Def.BitmapText{
		Font="Common Normal",
		Name="Text",
		InitCommand=function (self)
			self:maxwidth(750):horizalign(left):vertalign(top):y(SCREEN_TOP+10):x(SCREEN_LEFT+10):shadowlength(1):diffusealpha(0)
		end,
		OnCommand=function (self)
			self:finishtweening():diffusealpha(1):zoom(0.5)
		end,
		OffCommand=function (self)
			self:sleep(3):linear(0.5):diffusealpha(0)
		end
	},
    
	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext(params.Message)
		self:playcommand("On")
		if params.NoAnimate then
			self:finishtweening()
		end
		self:playcommand("Off")
	end,
    
	HideSystemMessageMessageCommand = function (self)
		self:finishtweening()
	end
}

return t
