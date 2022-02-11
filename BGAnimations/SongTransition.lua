local ChartLabels = {
	"NEW",
	"ANOTHER",
	"PRO",
	"TRAIN",
	"QUEST",
	"UCS",
	"HIDDEN",
	"INFINITY",
	"JUMP",
}

local t = Def.ActorFrame {
	Def.Quad {
		OnCommand=function(self) self:playcommand("Refresh") end,
		StartTransitioningCommand=function(self) self:playcommand("Refresh") end,
		
		RefreshCommand=function(self)
			if SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
				self:FullScreen():diffuse(Color.Black)
			else
				self:visible(false)
			end
		end
	},

	Def.Sprite {
		OnCommand=function(self) self:playcommand("Refresh") end,
		StartTransitioningCommand=function(self) self:playcommand("Refresh") end,
		
		RefreshCommand=function(self)
			if SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
				local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
				if Path and FILEMAN:DoesFileExist(Path) then
					self:Load(Path):scale_or_crop_background()
                else
                    self:Load(THEME:GetPathG("Common", "fallback background")):scale_or_crop_background()
				end
			else
				self:Load(nil)
			end
		end
	},
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	local PlayerDirection = (pn == PLAYER_2 and 1 or -1)
	
	t[#t+1] = Def.ActorFrame {
		Def.ActorFrame {
			OnCommand=function(self)
				self:xy(pn == PLAYER_2 and SCREEN_RIGHT - 144 or 144, SCREEN_BOTTOM - 64):playcommand("Refresh")
			end,
			
			StartTransitioningCommand=function(self) self:playcommand("Refresh") end,
			
			RefreshCommand=function(self)
				if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) and 
				SCREENMAN:GetTopScreen():GetNextScreenName() ~= "ScreenSelectProfile" then
					self:visible(true)
					
					local Song = GAMESTATE:GetCurrentSong()
					local Chart = GAMESTATE:GetCurrentSteps(pn)
					
					local ChartMeter = Chart:GetMeter()
					if ChartMeter == 99 then ChartMeter = "??" end
					
					local ChartAuthor = Chart:GetAuthorCredit()
					if ChartAuthor == "" then ChartAuthor = "Unknown" end
					
					self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
					self:GetChild("Meter"):settext(ChartMeter)
					self:GetChild("Credit"):settext(ChartAuthor)
					
					local ChartLabelIndex = 0
					for Index, String in pairs(ChartLabels) do
						if string.find(ToUpper(Chart:GetDescription()), String) then
							ChartLabelIndex = Index
						end
					end
					
					if ChartLabelIndex ~= 0 then
						self:GetChild("Label"):visible(true):setstate(ChartLabelIndex - 1)
					else
						self:GetChild("Label"):visible(false)
					end
				else
					self:visible(false)
				end
			end,
			
			Def.Sprite {
				Name="Frame",
				Texture=THEME:GetPathG("", "UI/StepArtist" .. (pn == PLAYER_2 and "R" or "L")),
			},
			
			Def.Sprite {
				Name="Ball",
				Texture=THEME:GetPathG("", "DifficultyDisplay/LargeBall"),
				InitCommand=function(self) 
					self:xy(79.25 * PlayerDirection, 0.25):zoom(0.75)
				end
			},
			
			Def.Sprite {
				Name="BallTrim",
				Texture=THEME:GetPathG("", "DifficultyDisplay/LargeTrim"),
				InitCommand=function(self) 
					self:xy(79.25 * PlayerDirection, 0.25):zoom(0.75)
				end
			},
			
			Def.BitmapText {
				Name="Meter",
				Font="Montserrat numbers 40px",
				InitCommand=function(self)
					self:xy(79.25 * PlayerDirection, 0.25):zoom(0.88) 
				end
			},
			
			Def.Sprite {
				Name="Label",
				Texture=THEME:GetPathG("", "DifficultyDisplay/Labels"),
				InitCommand=function(self)
					self:xy(79.25 * PlayerDirection, 22.25):visible(false):animate(false)
				end
			},
			
			Def.BitmapText {
				Name="Credit",
				Font="Montserrat semibold 20px",
				InitCommand=function(self)
					self:xy(-41 * PlayerDirection, 22.5)
					:vertspacing(-8)
					:wrapwidthpixels(150)
					:maxheight(40)
					:maxwidth(150)
				end
			}
		}
	}
end

return t