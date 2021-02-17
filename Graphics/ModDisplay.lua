local t = Def.ActorFrame {};

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do

	-- Speed mods
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-100):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-100):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):playcommand("Refresh");
			if pn == PLAYER_1 then
				self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y-100):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
			else
				self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y-100):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local PlayerMods = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			if PlayerMods:AvarageScrollBPM() > 0 then
				self:zoom(0.35)
				self:settext("AV "..PlayerMods:AvarageScrollBPM())
			elseif PlayerMods:MaxScrollBPM() > 0 then
				self:zoom(0.35)
				self:settext("M "..PlayerMods:MaxScrollBPM())
			elseif PlayerMods:TimeSpacing() > 0 then
				self:zoom(0.35)
				self:settext("C "..PlayerMods:ScrollBPM())
			else
				self:zoom(0.4)
				self:settext(math.round(PlayerMods:ScrollSpeed()).."X")
			end
		end;
	}

	-- Noteskins
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):sleep(0.1)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = Def.ActorProxy{
		OnCommand=function(self)
			if SCREENMAN:GetTopScreen() then
				local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
				self:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)) )
				:zoom(0.45):sleep(0.1)

				if pn == PLAYER_1 then
					self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
				else
					self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
				end;
			end;
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		-- I'm sorry lmao
		RefreshCommand=function(self)
			local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
			self:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)) )
		end,
	}

	-- BG Brightness
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):sleep(0.2)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-40):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-40):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.35):sleep(0.2):playcommand("Refresh");
			if pn == PLAYER_1 then
				self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y-40):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
			else
				self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y-40):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local DarkLevel, CoverSpeed = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):Cover()
			self:settext("BGA "..CoverSpeed)
			SCREENMAN:SystemMessage(DarkLevel)
		end;
	}

	-- Judgment
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):sleep(0.3)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-10):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-10):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.25):sleep(0.3):playcommand("Refresh");
			if pn == PLAYER_1 then
				self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y-10):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
			else
				self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y-10):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local TimingMode = getenv("SmartTimings") and TimingWindow[getenv("SmartTimings")]() or LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"
			self:settext("Judge "..TimingMode)
		end;
	}

	-- TODO: add more mod icons by going through current mods

end;

return t;
