local t = Def.ActorFrame {

	Def.Quad {
		InitCommand=function(self)
			self:zoomtowidth(SCREEN_WIDTH)
			:zoomtoheight(28)
			:horizalign(left)
			:vertalign(top)
			:y(SCREEN_TOP)
			:diffuse(color("0,0,0,0"))
		end,
		OnCommand=function(self)
			self:finishtweening()
			:diffusealpha(0.8)
		end,
		OffCommand=function(self)
			self:sleep(3)
			:linear(0.5)
			:diffusealpha(0)
		end
	},

	Def.BitmapText {
		Font="Montserrat semibold 40px",
		Name="Text",
		InitCommand=function(self)
			self:maxwidth(SCREEN_WIDTH*2)
			:x(SCREEN_LEFT+8)
			:y(SCREEN_TOP+8)
			:horizalign(left)
			:vertalign(top)
			:diffusealpha(0)
		end,
		OnCommand=function(self)
			self:finishtweening()
			:diffusealpha(1)
			:zoom(0.35)
		end,
		OffCommand=function(self)
			self:sleep(3)
			:linear(0.5)
			:diffusealpha(0)
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

	HideSystemMessageMessageCommand = function(self)self:finishtweening()end,

	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,SCREEN_BOTTOM-17)
			:queuecommand('Refresh')
			:diffuse(1,1,1,1)
			:glow(color(0.8,0.8,1,1))
			:zoom(0.4)
			:settext("")
		end,

		OnCommand=function(self)self:playcommand('Refresh')end,
		RefreshCreditTextMessageCommand=function(self)self:playcommand('Refresh')end,
		CoinInsertedMessageCommand=function(self)self:playcommand('Refresh')end,
		CoinModeChangedMessageCommand=function(self)self:playcommand('Refresh')end,
		PlayerJoinedMessageCommand=function(self)self:playcommand('Refresh')end,

		RefreshCommand=function(self)
			local gMode = GAMESTATE:GetCoinMode()
			local eMode = GAMESTATE:IsEventMode()
			local Coins = GAMESTATE:GetCoins()

			-- no one wants screen burn-in at home!
			if gMode == "CoinMode_Home" then
				self:visible(false)
			elseif eMode then
				self:visible(true):settext("EVENT MODE")
			elseif gMode == 'CoinMode_Free' then
				self:visible(true):settext("FREE PLAY")
			elseif gMode == 'CoinMode_Pay' then
				self:visible(true):settext("CREDIT(S): "..Coins)
			end
		end
	},

	-- Instead of cockblocking users, we will just add a funny watermark instead
	Def.BitmapText {
		Font="Montserrat normal 20px",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X+(SCREEN_CENTER_X/2),SCREEN_CENTER_Y+(SCREEN_CENTER_Y/1.5))
			:diffuse(1,1,1,0)
			:horizalign(left)
			:zoom(0.75)
			:settext("Update StepMania")

			self:diffusealpha(string.find(ProductVersion(), "5.3") and 0 or 0.2)
		end
	},

	Def.BitmapText {
		Font="Montserrat normal 20px",
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X+(SCREEN_CENTER_X/2)+1,SCREEN_CENTER_Y+(SCREEN_CENTER_Y/1.5)+16)
			:diffuse(1,1,1,0)
			:horizalign(left)
			:zoom(0.5)
			:settext("Unsupported version detected.")

			self:diffusealpha(string.find(ProductVersion(), "5.3") and 0 or 0.2)
		end
	}
}

return t
