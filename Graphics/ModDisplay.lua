local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

	local pos_x = SCREEN_LEFT+24.5
	local pos_y = SCREEN_CENTER_Y-100
	local pos_out_x = SCREEN_LEFT-24.5
	local pos_step_y = 30

	if GetScreenAspectRatio() >= 1.5 then
		pos_x = SCREEN_LEFT+30
	end

	if pn == PLAYER_2 then
		pos_x = SCREEN_RIGHT-24.5
		pos_out_x = SCREEN_RIGHT+24.5

		if GetScreenAspectRatio() >= 1.5 then
			pos_x = SCREEN_RIGHT-30
		end
	end

	-- Speed mods
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("","ModIcon"),
		InitCommand=function(self)
			self:xy(pos_out_x, pos_y)
			:zoom(0.35)
			:sleep(0.25)
			:decelerate(0.75)
			:x(pos_x)
		end
	}

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):skewx(-0.1)
			:xy(pos_out_x, pos_y)
			:playcommand("Refresh") -- playcommand is used here to define zoom before moving!!
			:sleep(0.25)
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local PlayerMods = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			if PlayerMods:AverageScrollBPM() > 0 then
				self:zoom(0.35)
				self:settext("AV "..PlayerMods:AverageScrollBPM())
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
		end
	}

	-- Noteskins
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("","ModIcon"),
		InitCommand=function(self)
			self:xy(pos_out_x, pos_y + pos_step_y)
			:zoom(0.35)
			:sleep(0.25 + 0.1)
			:decelerate(0.75)
			:x(pos_x)
		end
	}

	t[#t+1] = Def.ActorProxy{
		OnCommand=function(self)
			self:xy(pos_out_x, pos_y + pos_step_y)
			:zoom(0.45)
			:sleep(0.25 + 0.1)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		-- I'm sorry lmao
		RefreshCommand=function(self)
			if SCREENMAN:GetTopScreen() then
				local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
				self:SetTarget(SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)))
			end
		end
	}

	-- BGA Brightness
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("","ModIcon"),
		InitCommand=function(self)
			self:xy(pos_out_x, pos_y + pos_step_y * 2)
			:zoom(0.35)
			:sleep(0.25 + 0.2)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local DarkLevel = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/Infinitesimal.ini")
			if DarkLevel then
				self:visible( math.floor(DarkLevel*100) ~= 0 )
			end
		end
	}

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):skewx(-0.1)
			:xy(pos_out_x, pos_y + pos_step_y * 2)
			:zoom(0.35)
			:sleep(0.25 + 0.2)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local DarkLevel = LoadModule("Config.Load.lua")("BGAMode",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/Infinitesimal.ini")

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
		end
	}

	-- Judgment
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("","ModIcon"),
		InitCommand=function(self)
			self:xy(pos_out_x, pos_y + pos_step_y * 5)
			:zoom(0.35)
			:sleep(0.25 + 0.5)
			:decelerate(0.75)
			:x(pos_x)
		end
	}

	t[#t+1] = Def.Quad{
		InitCommand=function(self)
			self:zoomto(40, 25):diffusetopedge(0,0,0,0)
			:xy(pos_out_x, pos_y + pos_step_y * 5)
			:sleep(0.25 + 0.5)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local ProMode = LoadModule("Config.Load.lua")("ProMode",CheckIfUserOrMachineProfile(string.sub(GAMESTATE:GetMasterPlayerNumber(),-1)-1).."/Infinitesimal.ini")
			if ProMode == "AllowW1_Everywhere" then
				self:diffusebottomedge(color("#e78df3"))
			else
				self:diffusebottomedge(color("#3680ec"))
			end
		end
	}

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):skewx(-0.1)
			:xy(pos_out_x, pos_y + pos_step_y * 5)
			:zoom(0.45)
			:sleep(0.25 + 0.5)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local TimingMode = getenv("SmartTimings") and TimingWindow[getenv("SmartTimings")]() or LoadModule("Config.Load.lua")("SmartTimings","Save/Infinitesimal.ini") or "Unknown"
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
			end
		end
	}

	-- Rush
	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("","ModIcon"),
		InitCommand=function(self)
			self:xy(pos_out_x, pos_y + pos_step_y * 6)
			:zoom(0.35)
			:sleep(0.25 + 0.6)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

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
			end
		end
	}

	t[#t+1] = Def.Sprite {
		Texture=THEME:GetPathG("","MusicNote"),
		InitCommand=function(self)
			self:xy(pos_out_x, pos_y + pos_step_y * 6)
			:zoom(0.1)
			:sleep(0.25 + 0.6)
			:queuecommand("Refresh")
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local RushAmount = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()

			if RushAmount ~= nil then
				RushAmount = math.floor(RushAmount*100)
				self:visible(RushAmount ~= 100)
			end
		end
	}

	t[#t+1] = LoadFont("Montserrat semibold 40px")..{
		InitCommand=function(self)
			self:wrapwidthpixels(100):vertspacing(-20):skewx(-0.1)
			:xy(pos_out_x, pos_y + pos_step_y * 6)
			:zoom(0.3)
			:queuecommand("Refresh")
			:sleep(0.25 + 0.6)
			:decelerate(0.75)
			:x(pos_x)
		end,

		OptionsListStartMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListResetMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPopMessageCommand=function(self)self:queuecommand("Refresh")end,
		OptionsListPushMessageCommand=function(self)self:queuecommand("Refresh")end,

		RefreshCommand=function(self)
			local RushAmount = GAMESTATE:GetSongOptionsObject("ModsLevel_Song"):MusicRate()

			if RushAmount ~= nil then
				RushAmount = math.floor(RushAmount*100)
				self:visible(RushAmount ~= 100)
				self:settext("RUSH "..RushAmount.."%")
			end
		end
	}

	-- TODO: add more mod icons by going through current mods

end

return t
