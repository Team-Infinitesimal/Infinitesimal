local pn = ...
local BasicMode = getenv("IsBasicMode")

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

return Def.ActorFrame {
    InitCommand=function(self)
        if GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSteps(pn) then
            local Song = GAMESTATE:GetCurrentSong()
            local Chart = GAMESTATE:GetCurrentSteps(pn)
            local ChartType = ToEnumShortString(ToEnumShortString(Chart:GetStepsType()))
            local ChartMeter = Chart:GetMeter()
            
            if ChartMeter == 99 then ChartMeter = "??" end
            
            self:GetChild("Ball"):diffuse(ChartTypeToColor(Chart))
            self:GetChild("Meter"):settext(ChartMeter)
            self:GetChild("Difficulty"):settext(BasicMode and BasicChartLabel(Chart) or FullModeChartLabel(Chart))
            
            local ChartLabelIndex = 0
            for Index, String in pairs(ChartLabels) do
                if string.find(ToUpper(Chart:GetDescription()), String) then
                    ChartLabelIndex = Index
                end
            end
            
            if ChartLabelIndex ~= 0 then
                self:GetChild("Label"):visible(not BasicMode):setstate(ChartLabelIndex - 1)
            else
                self:GetChild("Label"):visible(false)
            end
        end
    end,
    
    Def.Sprite {
        Name="Ball",
        Texture=THEME:GetPathG("", "DifficultyDisplay/LargeBall"),
        InitCommand=function(self) 
            self:zoom(0.75)
        end
    },
    
    Def.Sprite {
        Name="BallTrim",
        Texture=THEME:GetPathG("", "DifficultyDisplay/LargeTrim"),
        InitCommand=function(self) 
            self:zoom(0.75)
        end
    },
    
    Def.BitmapText {
        Name="Meter",
        Font="Montserrat numbers 40px",
        InitCommand=function(self)
            self:y(1):zoom(0.88)
        end
    },
    
    Def.BitmapText {
        Font="Montserrat extrabold 20px",
        Name="Difficulty",
        InitCommand=function(self)
            self:y(-21):visible(true):zoom(0.7):maxwidth(80):shadowlength(2):skewx(-0.1)
        end
    },
    
    Def.Sprite {
        Name="Label",
        Texture=THEME:GetPathG("", "DifficultyDisplay/Labels"),
        InitCommand=function(self)
            self:y(23):visible(false):animate(false)
        end
    }
}
