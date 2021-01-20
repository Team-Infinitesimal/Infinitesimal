-- Function originally written by quietly-turning for Simply Love
local function SMSupport()

	-- ensure that we're using StepMania
	if type(ProductFamily) ~= "function" or ProductFamily():lower() ~= "stepmania" then return false end

	-- ensure that a global ProductVersion() function exists before attempting to call it
	if type(ProductVersion) ~= "function" then return false end

	-- get the version string, e.g. "5.0.11" or "5.1.0" or "5.2-git-96f9771" or etc.
	local version = ProductVersion()
	if type(version) ~= "string" then return false end

	-- remove the git hash if one is present in the version string
	version = version:gsub("-.+", "")

	-- split the remaining version string on periods; store each segment in a temp table
	local t = {}
	for i in version:gmatch("[^%.]+") do
		table.insert(t, tonumber(i))
	end

	-- if we didn't detect SM5.x.x then Something Is Terribly Wrong.
	if not (t[1] and t[1]==5) then return false end

	-- SM5.3 is supported
	if not (t[2] and t[2]==3) then return false end

	return true
end

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
			
			-- no one wants screen burn-in at home!
			if gMode == "CoinMode_Home" then
				self:visible(false);
			elseif eMode then
				self:visible(true);
				self:settext("EVENT MODE");
			elseif gMode == 'CoinMode_Free' then
				self:visible(true);
				self:settext("FREE PLAY");
			elseif gMode == 'CoinMode_Pay' then
				PREFSMAN:SetPreference("CoinMode","Home");
			end;
		end;

		OnCommand=function(self)self:playcommand('Refresh')end;
		RefreshCreditTextMessageCommand=function(self)self:playcommand('Refresh')end;
		CoinInsertedMessageCommand=function(self)self:playcommand('Refresh')end;
		CoinModeChangedMessageCommand=function(self)self:playcommand('Refresh')end;
		PlayerJoinedMessageCommand=function(self)self:playcommand('Refresh')end;
	};
	
	-- Instead of cockblocking users, we will just add a small watermark instead
	LoadFont("Montserrat normal 20px")..{
		InitCommand=function(self)
			self:xy(SCREEN_CENTER_X,8)
			:diffuse(1,1,1,0.2)
			:zoom(0.5);
		end;
		
		RefreshCommand=function(self)
			if not SMSupport() then
				self:settext("Unsupported version of StepMania detected!");
			end;
		end;
		
		OnCommand=function(self)self:playcommand('Refresh')end;
		RefreshCreditTextMessageCommand=function(self)self:playcommand('Refresh')end;
		CoinInsertedMessageCommand=function(self)self:playcommand('Refresh')end;
		CoinModeChangedMessageCommand=function(self)self:playcommand('Refresh')end;
		PlayerJoinedMessageCommand=function(self)self:playcommand('Refresh')end;
	};
};

return t;
