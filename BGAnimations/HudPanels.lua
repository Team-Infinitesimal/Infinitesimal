local t = Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/PanelTop"),
        InitCommand=function(self)
            self:scaletofit(0, 0, 1280, 128)
            :xy(SCREEN_CENTER_X, -128)
            :halign(0.5):valign(0)
        end,
        OnCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, 0)
        end,
        OffCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, -128)
        end,
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/PanelBottom"),
        InitCommand=function(self)
            self:scaletofit(0, 0, 1280, 128)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128)
            :halign(0.5):valign(1)
        end,
        OnCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM)
        end,
        OffCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128)
        end,
    }
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	if PROFILEMAN:GetProfile(pn) then
		t[#t+1] = Def.ActorFrame {
			Def.ActorFrame {
				InitCommand=function(self) self:y(128) end,
				OnCommand=function(self) self:easeoutexpo(0.5):y(0) end,
				OffCommand=function(self) self:easeoutexpo(0.5):y(128) end,
		
				Def.Sprite {
					Texture=THEME:GetPathG("", "UI/AvatarSlotMask"),
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 172 or -172), SCREEN_BOTTOM - 39)
						:rotationy(pn == PLAYER_2 and 180 or 0):MaskSource()
					end
				},
				
				Def.Sprite {
					Texture=THEME:GetPathG("", "UI/NameTag" .. ToEnumShortString(pn)),
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 232 or -232), SCREEN_BOTTOM - 32)
						:halign(pn == PLAYER_2 and 0 or 1):valign(1):MaskDest()
					end
				},
				
				Def.BitmapText {
					Font="Montserrat semibold 20px",
					Text=PROFILEMAN:GetProfile(pn):GetDisplayName(),
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 292 or -292), SCREEN_BOTTOM - 48):zoom(0.9)
						:maxwidth(112 / self:GetZoom()):skewx(-0.2)
						
						if PROFILEMAN:GetProfile(pn):GetDisplayName() == "" then
							self:settext("No Profile")
						end
					end
				},
				
				Def.Sprite {
					Texture=THEME:GetPathG("", "UI/NameTag" .. ToEnumShortString(pn)),
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 212 or -212), SCREEN_BOTTOM - 10)
						:halign(pn == PLAYER_2 and 0 or 1):valign(1):MaskDest()
					end
				},
				
				Def.BitmapText {
					Font="Montserrat semibold 20px",
					-- This ingenious level system was made up at 4am
					Text="Level " .. math.floor(PROFILEMAN:GetProfile(pn):GetTotalDancePoints() / 10000) + 1,
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 281 or -281), SCREEN_BOTTOM - 26):zoom(0.9)
						:maxwidth(96 / self:GetZoom()):skewx(-0.2)
					end
				},
				
				Def.Sprite {
					Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
					InitCommand=function(self)
						self:scaletocover(0, 0, 128, 64)
						:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 172 or -172), SCREEN_BOTTOM - 39)
						:MaskDest():ztestmode("ZTestMode_WriteOnFail"):diffusealpha(0.5)
					end
				},
				
				Def.Sprite {
					Texture=THEME:GetPathG("", "UI/AvatarSlotOverlay"),
					InitCommand=function(self)
						self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 172 or -172), SCREEN_BOTTOM - 39)
						:rotationy(pn == PLAYER_2 and 180 or 0)
					end
				},
				
				Def.Sprite {
					Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
					InitCommand=function(self)
						self:scaletocover(0, 0, 64, 64)
						:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 172 or -172), SCREEN_BOTTOM - 39)
						:MaskDest():ztestmode("ZTestMode_WriteOnFail")
					end
				},
			}
		}
	end
end

return t