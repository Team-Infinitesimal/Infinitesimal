local Title1 = THEME:GetString("MessageBoxes", "HowToPlayTitle1")
local Title2 = THEME:GetString("MessageBoxes", "HowToPlayTitle2")
local Title3 = THEME:GetString("MessageBoxes", "HowToPlayTitle3")

local Body1 = THEME:GetString("MessageBoxes", "HowToPlayBody1")
local Body2 = THEME:GetString("MessageBoxes", "HowToPlayBody2")
local Body3 = THEME:GetString("MessageBoxes", "HowToPlayBody3")

local t = Def.ActorFrame {
    Def.Quad {
        Name="DemoTextBox",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X - 240, SCREEN_CENTER_Y / 1.75):zoomto(300, 70)
            :diffuse(0,0,0,0.5)
        end
    },
    
    Def.BitmapText {
        Font="VCR OSD Mono 40px",
        InitCommand=function(self)
            self:settext("HOW TO PLAY"):shadowlength(1)
            :xy(SCREEN_CENTER_X - 240, SCREEN_CENTER_Y / 1.75)
            :queuecommand("Flicker")
            :visible(0)
        end,
        FlickerCommand=function(self)
            self:sleep(0.984)
            :visible(not self:GetVisible())
            :queuecommand("Flicker")
        end
    },
    
    LoadActor("FakeLifeMeter") .. {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 240, -70)
        end
    },
    
    InitCommand=function(self)
        self:queuecommand("Message1")
    end,
    
    LoadModule("UI.MessageBox.lua")(SCREEN_CENTER_X - 390, SCREEN_CENTER_Y - 80, 290, 0, 14, Title1, Body1),
    LoadModule("UI.MessageBox.lua")(SCREEN_CENTER_X - 390, SCREEN_CENTER_Y - 80, 290, 15, 5, Title2, Body2),
    LoadModule("UI.MessageBox.lua")(SCREEN_CENTER_X - 390, SCREEN_CENTER_Y - 80, 290, 21, 6, Title3, Body3),
    
    Message1Command=function(self)
        
    end,
}

return t