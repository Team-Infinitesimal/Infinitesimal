local t = Def.ActorFrame {
    Def.Sprite {
        InitCommand=function(self) self:playcommand("Refresh") end,
        StartTransitioningCommand=function(self) self:playcommand("Refresh") end,
        
        RefreshCommand=function(self)
            local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
				self:Load(Path):scale_or_crop_background()
            end
        end
    },
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    local PlayerDirection = (pn == PLAYER_2 and 1 or -1)
    
    t[#t+1] = Def.ActorFrame {
        Def.ActorFrame {
            InitCommand=function(self)
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT - 144 or 144, SCREEN_BOTTOM - 64):playcommand("Refresh")
            end,
            
            StartTransitioningCommand=function(self) self:playcommand("Refresh") end,
            
            RefreshCommand=function(self)
                if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
                    local Song = GAMESTATE:GetCurrentSong()
                    local Chart = GAMESTATE:GetCurrentSteps(pn)
                    
                    local ChartMeter = Chart:GetMeter()
                    if ChartMeter == 99 then ChartMeter = "??" end
                    
                    local ChartAuthor = Chart:GetAuthorCredit()
                    if ChartAuthor == "" then ChartAuthor = "Unknown" end
                    
                    self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
                    self:GetChild("Meter"):settext(ChartMeter)
                    self:GetChild("Credit"):settext(ChartAuthor)
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
            
            Def.BitmapText {
                Name="Meter",
                Font="Montserrat numbers 40px",
                InitCommand=function(self)
                    self:xy(79.25 * PlayerDirection, 0.25):zoom(0.88) 
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