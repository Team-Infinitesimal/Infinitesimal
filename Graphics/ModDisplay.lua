local t = Def.ActorFrame {};

for pn in ivalues( GAMESTATE:GetHumanPlayers() ) do

	-- Speed mods
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):xy(-9999,-9999)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-100):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-100):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):skewx(-0.1):xy(-9999,-9999):playcommand("Refresh")
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
			self:zoom(0.35):xy(-9999,-9999):sleep(0.1)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = Def.ActorProxy{
		OnCommand=function(self)
			self:zoom(0.45):xy(-9999,-9999):sleep(0.1):playcommand("Refresh")
			if pn == PLAYER_1 then
				self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
			else
				self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y-70):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
			end;
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		-- I'm sorry lmao
		RefreshCommand=function(self)
			if SCREENMAN:GetTopScreen() then
				local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
				self:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)) )
			end;
		end,
	}

	-- BG Brightness
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):xy(-9999,-9999):sleep(0.2):playcommand("Refresh")
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y-40):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y-40):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local DarkLevel = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")

			if math.floor(DarkLevel*100) == 0 then
				self:visible(false)
			else
				self:visible(true)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.35):skewx(-0.1):xy(-9999,-9999):sleep(0.2):playcommand("Refresh")
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
			local DarkLevel = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
			if math.floor(DarkLevel*100) == 0 then
				self:visible(false)
				self:settext("")
			else
				self:visible(true)
				if math.floor(DarkLevel*100) == 100 then
					self:settext("BGA OFF")
				else
					self:settext("BGA "..math.floor(DarkLevel*100).."%")
				end;
			end;
		end;
	}

	-- Judgment
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):xy(-9999,-9999):sleep(0.5)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y+50):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y+50):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;
	};

	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(41, 26):diffusetopedge(0,0,0,0):xy(-9999,-9999):sleep(0.5):playcommand("Refresh")
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y+50):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+4)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y+50):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-4)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local ProMode = LoadModule("Config.Load.lua")("ProMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini");
			if ProMode == "AllowW1_Everywhere" then
				self:diffusebottomedge(color("#e78df3"))
			else
				self:diffusebottomedge(color("#3680ec"))
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.45):skewx(-0.1):xy(-9999,-9999):sleep(0.5):playcommand("Refresh")
			if pn == PLAYER_1 then
				self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y+50):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
			else
				self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y+50):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local TimingMode = getenv("SmartTimings") and TimingWindow[getenv("SmartTimings")]() or LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Unknown"
			if TimingMode == "Normal" then
				self:settext("NJ")
			elseif TimingMode == "Hard" then
				self:settext("HJ")
			elseif TimingMode == "Very Hard" then
				self:settext("VJ")
			elseif TimingMode == "Infinity" then
				self:settext("INF")
			elseif TimingMode == "Groove" then
				self:settext("ITG")
			elseif TimingMode == "Hero" then
				self:settext("GH")
			else
				self:settext("???")
			end;
		end;
	}

	-- Rush
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:queuecommand("Refresh")
			self:zoom(0.35):xy(-9999,-9999):sleep(0.6)
			if pn == PLAYER_1 then
				self:halign(0):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y+80):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+2)
			else
				self:halign(1):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y+80):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-2)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local RushAmount = math.round(GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate())
			if RushAmount == 1 then
				self:visible(false)
			else
				self:visible(true)
			end;
		end;
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","MusicNote"))..{
		InitCommand=function(self)
			self:queuecommand("Refresh")
			self:zoom(0.1):xy(-9999,-9999):sleep(0.6)
			if pn == PLAYER_1 then
				self:halign(1):xy(SCREEN_LEFT-52,SCREEN_CENTER_Y+80):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+36)
			else
				self:halign(0):xy(SCREEN_RIGHT+52,SCREEN_CENTER_Y+80):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-36)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local RushAmount = math.round(GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate())
			if RushAmount == 1 then
				self:visible(false)
			else
				self:visible(true)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.3):skewx(-0.1):xy(-9999,-9999):sleep(0.6):playcommand("Refresh")
			if pn == PLAYER_1 then
				self:xy(SCREEN_LEFT-25.5,SCREEN_CENTER_Y+80):sleep(0.25):decelerate(0.75):x(SCREEN_LEFT+24.5)
			else
				self:xy(SCREEN_RIGHT+25.5,SCREEN_CENTER_Y+80):sleep(0.25):decelerate(0.75):x(SCREEN_RIGHT-24.5)
			end;
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			local RushAmount = math.round(GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate())
			if RushAmount == 1 then
				self:visible(false)
			else
				self:visible(true)
				if RushAmount == 0.8 then
					self:settext("RUSH 80%")
				elseif RushAmount == 0.9 then
						self:settext("RUSH 90%")
				elseif RushAmount == 1.1 then
						self:settext("RUSH 110%")
				elseif RushAmount == 1.2 then
						self:settext("RUSH 120%")
				elseif RushAmount == 1.3 then
						self:settext("RUSH 130%")
				elseif RushAmount == 1.4 then
						self:settext("RUSH 140%")
				elseif RushAmount == 1.5 then
						self:settext("RUSH 150%")
				elseif RushAmount == 2 then
						self:settext("RUSH 200%")
				end;
			end;
		end;
	}

	-- TODO: add more mod icons by going through current mods

end;

return t;
