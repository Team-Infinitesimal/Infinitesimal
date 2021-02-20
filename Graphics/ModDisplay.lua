local t = Def.ActorFrame {};

for pn in ivalues(PlayerNumber) do
	
	local pos_x = SCREEN_LEFT+24.5
	local pos_y = SCREEN_CENTER_Y-100
	local pos_out_x = SCREEN_LEFT-24.5
	local pos_step_y = 30
	
	if GetScreenAspectRatio() >= 1.5 then
		pos_x = SCREEN_LEFT+30
	end;
	
	if pn == PLAYER_2 then
		pos_x = SCREEN_RIGHT-24.5
		pos_out_x = SCREEN_RIGHT+24.5
		
		if GetScreenAspectRatio() >= 1.5 then
			pos_x = SCREEN_RIGHT-30
		end;
	end

	-- Speed mods
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):visible(GAMESTATE:IsSideJoined(pn))
			:xy(pos_out_x, pos_y):sleep(0.25):decelerate(0.75):x(pos_x)
		end;
		
		PlayerJoinedMessageCommand=function(self) self:visible(GAMESTATE:IsSideJoined(pn)) end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):skewx(-0.1):playcommand("Refresh") -- playcommand is used here to define zoom before moving!!
			:xy(pos_out_x, pos_y):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
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
			else
				self:visible(false)
			end;
		end;
	}

	-- Noteskins
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):visible(false):sleep(0.1):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y):sleep(0.25):decelerate(0.75):x(pos_x)
		end;
		
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;
		
		RefreshCommand=function(self) self:visible(GAMESTATE:IsSideJoined(pn)) end;
	};

	t[#t+1] = Def.ActorProxy{
		OnCommand=function(self)
			self:zoom(0.45):visible(false):sleep(0.1):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		-- I'm sorry lmao
		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
				if SCREENMAN:GetTopScreen() then
					local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
					self:SetTarget(SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)))
				end;
			else
				self:visible(false)
			end;
		end;
	}

	-- BGA Brightness
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):visible(false):sleep(0.2):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 2):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				local DarkLevel = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
				if DarkLevel then
					self:visible( math.floor(DarkLevel*100) == 0 )
				end
			else
				self:visible(false)
			end
		end
	}

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.35):skewx(-0.1):visible(false):sleep(0.2):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 2):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				local DarkLevel = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini")
				
				if DarkLevel then
					if math.floor(DarkLevel*100) == 0 then
						self:visible(false)
						self:settext("")
					else
						self:visible(true)
						if math.floor(DarkLevel*100) == 100 then
							self:settext("BGA OFF")
						else
							self:settext("BGA "..math.floor(DarkLevel*100).."%")
						end
					end
				end
			else
				self:visible(false);
			end;
		end;
	}

	-- Judgment
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):visible(false):sleep(0.5):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 5):sleep(0.25):decelerate(0.75):x(pos_x)
		end;
		
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;
		
		RefreshCommand=function(self) self:visible(GAMESTATE:IsSideJoined(pn)) end;
	};

	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(40, 25):diffusetopedge(0,0,0,0):visible(false):sleep(0.5):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 5):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;
		
		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
				local ProMode = LoadModule("Config.Load.lua")("ProMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini");
				if ProMode == "AllowW1_Everywhere" then
					self:diffusebottomedge(color("#e78df3"))
				else
					self:diffusebottomedge(color("#3680ec"))
				end;
			else
				self:visible(false)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.45):skewx(-0.1):visible(false):sleep(0.5):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 5):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
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
			else
				self:visible(false)
			end;
		end;
	}

	-- Rush
	t[#t+1] = LoadActor(THEME:GetPathG("","ModIcon"))..{
		InitCommand=function(self)
			self:zoom(0.35):visible(false):sleep(0.6):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 6):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
				local RushAmount = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
				
				if RushAmount ~= nil then
					RushAmount = math.floor(RushAmount*100)
					self:visible(RushAmount ~= 100)
				end;
			else
				self:visible(false)
			end;
		end;
	};

	t[#t+1] = LoadActor(THEME:GetPathG("","MusicNote"))..{
		InitCommand=function(self)
			self:zoom(0.1):visible(false):sleep(0.6):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 6):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
				local RushAmount = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
					
				if RushAmount ~= nil then
					RushAmount = math.floor(RushAmount*100)
					self:visible(RushAmount ~= 100)
				end;
			else
				self:visible(false)
			end;
		end;
	};

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):zoom(0.3):skewx(-0.1):visible(false):sleep(0.6):queuecommand("Refresh")
			:xy(pos_out_x, pos_y + pos_step_y * 6):sleep(0.25):decelerate(0.75):x(pos_x)
		end;

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end;
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end;
		PlayerJoinedMessageCommand=function(self)self:queuecommand("Refresh")end;

		RefreshCommand=function(self)
			if GAMESTATE:IsSideJoined(pn) then
				self:visible(true)
				
				local RushAmount = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()
				
				if RushAmount ~= nil then
					RushAmount = math.floor(RushAmount*100)
					self:visible(RushAmount ~= 100)
					self:settext("RUSH "..RushAmount.."%")
				end;
			else
				self:visible(false)
			end;
		end;
	}

	-- TODO: add more mod icons by going through current mods

end;

return t;
