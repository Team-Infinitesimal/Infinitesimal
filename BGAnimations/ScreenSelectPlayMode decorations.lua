local spacing = 300

local t = Def.ActorFrame {

	LoadActor(THEME:GetPathG("","ScreenHudFrame")),
    LoadActor(THEME:GetPathG("","CornerArrows")),
	
	-- Play Mode selection
	Def.ActorFrame {
	
		OnCommand=function(self) self:playcommand("RefreshPos") end,
		MenuLeftP1MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuLeftP2MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuUpP1MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuUpP2MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuRightP1MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuRightP2MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuDownP1MessageCommand=function(self) self:playcommand("RefreshPos") end,
		MenuDownP2MessageCommand=function(self) self:playcommand("RefreshPos") end,

		RefreshPosCommand=function(self)
			local selection = SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber())
			self:stoptweening()
			:decelerate(0.25)
			:x(-spacing*selection)
		end,

		Def.Sprite {
			Texture=THEME:GetPathG("","ModeSelect/ArcadeMode"),
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y)
				:zoom(0.5)
				:diffusealpha(0.6)
			end,
			OnCommand=function(self)
				self:playcommand("Refresh")
			end,
			MenuSelectionChangedMessageCommand=function(self)
				self:stoptweening()
				:playcommand("Refresh")
			end,
			RefreshCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 0 then
					for pn in ivalues(PlayerNumber) do
						Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/Infinitesimal.ini"
						LoadModule("Config.Save.lua")("SmartTimings", "Normal", "Save/Infinitesimal.ini")
						LoadModule("Config.Save.lua")("ProMode", "AllowW1_Never", Location)
						LoadModule("Config.Save.lua")("DeviationDisplay", tostring(false), Location)
						LoadModule("Config.Save.lua")("MeasureCounter", tostring(false), Location)
					end
					self:diffusealpha(1)
					:queuecommand("Zoom")
				else
					self:decelerate(0.2)
					:zoom(0.5)
					:diffusealpha(0.6)
				end
			end,
			ZoomCommand=function(self)
				self:decelerate(0.4286)
				:zoom(0.55)
				:accelerate(0.3947)
				:zoom(0.5)
				:queuecommand("Zoom")
			end
		},

		Def.Sprite {
			Texture=THEME:GetPathG("","ModeSelect/ProMode"),
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X+spacing,SCREEN_CENTER_Y)
				:zoom(0.5)
				:diffusealpha(0.6)
			end,
			OnCommand=function(self)
				self:playcommand("Refresh")
			end,
			MenuSelectionChangedMessageCommand=function(self)
				self:stoptweening()
				:playcommand("Refresh")
			end,
			RefreshCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 1 then
					for pn in ivalues(PlayerNumber) do
						Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/Infinitesimal.ini"
						LoadModule("Config.Save.lua")("SmartTimings", "Infinity", "Save/Infinitesimal.ini")
						LoadModule("Config.Save.lua")("ProMode", "AllowW1_Everywhere", Location)
						LoadModule("Config.Save.lua")("DeviationDisplay", tostring(true), Location)
						LoadModule("Config.Save.lua")("MeasureCounter", tostring(false), Location)
					end
					self:diffusealpha(1)
					:queuecommand("Zoom")
				else
					self:decelerate(0.2)
					:zoom(0.5)
					:diffusealpha(0.6)
				end
			end,
			ZoomCommand=function(self)
				self:decelerate(0.4286)
				:zoom(0.55)
				:accelerate(0.3947)
				:zoom(0.5)
				:queuecommand("Zoom")
			end
		},

		Def.Sprite {
			Texture=THEME:GetPathG("","ModeSelect/StaminaMode"),
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X+(spacing*2),SCREEN_CENTER_Y)
				:zoom(0.5)
				:diffusealpha(0.6)
			end,
			OnCommand=function(self)
				self:playcommand("Refresh")
			end,
			MenuSelectionChangedMessageCommand=function(self)
				self:stoptweening()
				:playcommand("Refresh")
			end,
			RefreshCommand=function(self)
				if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 2 then
					for pn in ivalues(PlayerNumber) do
						Location = CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/Infinitesimal.ini"
						LoadModule("Config.Save.lua")("SmartTimings", "Groove", "Save/Infinitesimal.ini")
						LoadModule("Config.Save.lua")("ProMode", "AllowW1_Everywhere", Location)
						LoadModule("Config.Save.lua")("DeviationDisplay", tostring(true), Location)
						LoadModule("Config.Save.lua")("MeasureCounter", "All", Location)
					end
					self:diffusealpha(1)
					:queuecommand("Zoom")
				else
					self:decelerate(0.2)
					:zoom(0.5)
					:diffusealpha(0.6)
				end
			end,
			ZoomCommand=function(self)
				self:decelerate(0.4286)
				:zoom(0.55)
				:accelerate(0.3947)
				:zoom(0.5)
				:queuecommand("Zoom")
			end
		}
	},
	
	-- Text
	Def.BitmapText {
		Font="Montserrat semibold 40px",
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and (GetScreenAspectRatio() * 108) + 58 or 165))
			:zoom(0.4)
			:shadowcolor(0,0,0,0.25)
			:shadowlength(0.75)
			:diffuse(0,0,0,1)
			:y(SCREEN_TOP-150)
			:settext("SELECT")
		end,
		OnCommand=function(self)
			self:decelerate(1):y(GetScreenAspectRatio() >= 1.5 and 26 or 19)
		end
	},
	
	Def.BitmapText {
		Font="Montserrat normal 40px",
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X - (GetScreenAspectRatio() >= 1.5 and (GetScreenAspectRatio() * 108) or 165))
			:zoom(0.4)
			:shadowcolor(0,0,0,0.25)
			:shadowlength(0.75)
			:diffuse(0,0,0,1)
			:y(SCREEN_TOP-150)
			:settext("MODE")
		end,
		OnCommand=function(self)
			self:decelerate(1):y(GetScreenAspectRatio() >= 1.5 and 26 or 33)
		end
	}
}

return t
