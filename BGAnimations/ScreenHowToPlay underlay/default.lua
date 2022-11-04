local Title1 = THEME:GetString("MessageBoxes", "HowToPlayTitle1")
local Title2 = THEME:GetString("MessageBoxes", "HowToPlayTitle2")
local Title3 = THEME:GetString("MessageBoxes", "HowToPlayTitle3")

local Body1 = THEME:GetString("MessageBoxes", "HowToPlayBody1")
local Body2 = THEME:GetString("MessageBoxes", "HowToPlayBody2")
local Body3 = THEME:GetString("MessageBoxes", "HowToPlayBody3")

local t = Def.ActorFrame {

    -- Same noise sprite used in the preview video above the song wheel
    Def.Sprite {
        Name="Noise",
        Texture=THEME:GetPathG("", "Noise"),
        InitCommand=function(self)
            self:CropTo(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffusealpha(0.15)
            :blend("BlendMode_Add")
            :texcoordvelocity(24,16)
        end
    },

    Def.Quad {
        Name="BlackFade",
        InitCommand=function(self)
            self:diffuse(0,0,0,1):zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :sleep(2)
            :linear(0.5):diffusealpha(0.25)
        end
    },

    LoadActor("Pad")..{
        FOV=45,
        InitCommand=function(self)
            self:diffusealpha(0):xy(SCREEN_CENTER_X + 250, SCREEN_CENTER_Y + 100):zoom(0.75)
            :rotationx(-45)
        end,
        OnCommand=function(self)
            self:sleep(2)
            :easeoutquad(0.5)
            :y(SCREEN_CENTER_Y + 140):diffusealpha(1)
        end
    },

    Def.Quad {
        Name="HowToPlayBarBG",
        InitCommand=function(self)
            self:halign(0):valign(0):diffuse(0,0,0,0.5):zoomto(550, 65):xy(0, 80):cropright(1)
            :sleep(2)
            :easeoutquad(0.5):cropright(0)
        end
    },

    Def.Sprite {
        Name="HowToPlay",
        Texture=THEME:GetPathG("", "UI/HowToPlay"),
        InitCommand=function(self)
            self:diffusealpha(0):sleep(0.25):xy(SCREEN_CENTER_X - self:GetWidth() / 2, SCREEN_CENTER_Y - self:GetHeight() / 2 - 20):halign(0):valign(0)
            :easeoutquad(0.5)
            :y(SCREEN_CENTER_Y - self:GetHeight() / 2):diffusealpha(1)
            :sleep(1)
            :easeinoutquad(0.5)
            :xy(20, 80):zoom(0.5)
        end
    },

    --[[ Def.Quad {
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
    }, --]]

    LoadActor("FakeLifeMeter") .. {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X + 240, -70)
        end
    },

    InitCommand=function(self)
        self:queuecommand("Message1")
    end,

    LoadModule("UI.MessageBox.lua")(SCREEN_CENTER_X - 390, SCREEN_CENTER_Y / 1.75, 290, 2, 14, Title1, Body1),
    LoadModule("UI.MessageBox.lua")(SCREEN_CENTER_X - 390, SCREEN_CENTER_Y / 1.75, 290, 17, 5, Title2, Body2),
    LoadModule("UI.MessageBox.lua")(SCREEN_CENTER_X - 390, SCREEN_CENTER_Y / 1.75, 290, 23, 6, Title3, Body3),

    Message1Command=function(self)

    end,
}

return t
