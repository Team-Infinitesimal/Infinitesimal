return Def.ActorFrame {
    -- bro wake up it's 2008
    CodeMessageCommand=function(self, param)
        if param.Name == "Secret" then
            if _G["Secret"] == true then
                _G["Secret"] = false
                MESSAGEMAN:Broadcast("SecretUpdated")
                SCREENMAN:SystemMessage("returning to "..Year())
            else
                _G["Secret"] = true
                MESSAGEMAN:Broadcast("SecretUpdated")
                SCREENMAN:SystemMessage("bro wake up it's 2008")
            end
        end
    end,

    -- Possibly unnecessary but last time I tried this it didn't work without
    -- it for ??? reasons so I'm not taking any risks
    Def.Quad {
      Name="Background",
      InitCommand=function(self)
          self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
          :diffuse(Color.Black)
      end
    },

    Def.Sound {
        Name="BackgroundHum",
        File="BackgroundHum",
        OnCommand=function(self) self:play() end
    },

    Def.Sound {
        Name="TVOff",
        File="TVOff",
        OnCommand=function(self)
            self:sleep(4.5)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self)
            self:play()
        end
    },

    LoadActor(THEME:GetPathG("", "Grid"))..{
        InitCommand=function(self)
            self:GetChild("GridTop"):y(-475):easeoutquad(1.25):y(0)
            self:GetChild("GridBottom"):y(SCREEN_BOTTOM + 475):easeoutquad(1.25):y(SCREEN_BOTTOM)
        end
    },

    -- Maybe a janky hack? Idk, it works fine
    -- Adds looping dots after the "PLAY" text
    Def.BitmapText {
        Name="PlayText",
        Font="VCR OSD Mono 40px",
        InitCommand=function(self)
            self:settext("PLAY")
            :halign(0):valign(0)
            :xy(SCREEN_LEFT + 20, SCREEN_TOP + 20)
            :queuecommand("Dot")
        end,
        DotCommand=function(self)
            self:sleep(0.5)
            text = self:GetText()
            if text ~= "PLAY..." then
                self:settext(text..".")
            else
                self:settext("PLAY")
            end
            self:queuecommand("Dot")
        end
    },

    Def.Sprite {
        Name="OutFoxLogo",
        Texture="OutFox",
        InitCommand=function(self)
            self:Center()
            :cropright(1)
        end,
        OnCommand=function(self)
            self:sleep(0.725)
            :linear(0.55)
            :cropright(0)
        end
    },

    Def.Sprite {
        Name="LogoMask",
        Texture="OutFox",
        InitCommand=function(self)
            self:Center():MaskSource()
        end
    },

    -- Instead of loading a separate texture, a quad with a slight skew
    -- and an inverted mask (using ZTestMode_WriteOnFail) works very well
    Def.Quad {
        Name="LogoShine",
        InitCommand=function(self)
            self:zoomto(50, 150)
            :skewx(1.5)
            :xy(SCREEN_CENTER_X - 430, SCREEN_CENTER_Y)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end,
        OnCommand=function(self)
            self:sleep(0.75)
            :linear(0.5)
            :x(SCREEN_CENTER_X + 450)
            :queuecommand("Shine2")
        end,
        Shine2Command=function(self)
            self:x(SCREEN_CENTER_X - 430)
            :diffusealpha(0.5)
            :blend("BlendMode_Add")
            :sleep(0.5)
            :linear(0.5)
            :x(SCREEN_CENTER_X + 460)
        end
    },

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

    -- customtexturerect() practice, looks cool tho so I'm keeping it
    Def.Sprite {
        Name="Scanlines",
        Texture=THEME:GetPathG("", "Scanline"),
        InitCommand=function(self)
            self:customtexturerect(0,0,SCREEN_WIDTH*4/16,SCREEN_HEIGHT*4/16)
            :zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffusealpha(0.25)
        end
    },

    -- Obscures the other stuff
    Def.Quad {
        Name="ShutdownDark",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffuse(0,0,0,0)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(4.55)
            :diffuse(0,0,0,1)
        end
    },

    -- Flashes the screen white, then fades to black
    Def.Quad {
        Name="ShutdownFlash",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :valign(0.5)
            :diffuse(1,1,1,0)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(4.4)
            :easeoutquad(0.2)
            :diffusealpha(1)
            :linear(0.15)
            :zoomto(SCREEN_WIDTH, 10)
            :easeoutquad(0.15)
            :zoomto(0, 10)
        end
    },

    -- Transitions to the next screen after 5 seconds
    Def.Quad {
        Name="ScreenTransferActor",
        InitCommand=function(self)
               self:diffuse(0,0,0,0):sleep(5):queuecommand("Transfer")
        end,
        TransferCommand=function(self)
               SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }

}
