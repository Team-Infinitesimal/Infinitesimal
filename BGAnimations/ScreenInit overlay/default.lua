return Def.ActorFrame {

    Def.Quad {
      InitCommand=function(self)
          self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
          :diffuse(Color.Black)
      end
    },

    Def.Sound {
        File="BackgroundHum",
        OnCommand=function(self) self:play() end
    },

    Def.Sound {
        File="TVOff",
        OnCommand=function(self)
            self:sleep(4.5)
            self:queuecommand("Play")
        end,
        PlayCommand=function(self)
            self:play()
        end
    },

    Def.ActorFrame {
      	FOV=90,

      	Def.Sprite {
        		Name="GridTop",
        		Texture=THEME:GetPathG("", "Background/grid"),
        		InitCommand=function(self)
          			self:xy(SCREEN_CENTER_X, -475)
          			:zoomx(2.2)
          			:halign(0.5):valign(0)
          			:rotationx(84)
          			:texcoordvelocity(0, 0.25)
          			:diffusealpha(0.5)
          			:fadebottom(1)
        		end,
            OnCommand=function(self)
                self:easeoutquad(1.25)
                :y(0)
            end
        },

      	Def.Sprite {
        		Name="GridBottom",
        		Texture=THEME:GetPathG("", "Background/grid"),
        		InitCommand=function(self)
          			self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 475)
          			:zoomx(2.2)
          			:halign(0.5):valign(0)
          			:rotationx(98)
          			:texcoordvelocity(0, 0.25)
          			:diffusealpha(0.5)
          			:fadebottom(1)
        		end,
            OnCommand=function(self)
                self:easeoutquad(1.25)
                :y(SCREEN_BOTTOM)
            end
      	}
    },

    Def.BitmapText {
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

    Def.Sprite {
        Texture=THEME:GetPathG("", "Noise"),
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffusealpha(0.15)
            :blend("BlendMode_Add")
            :texcoordvelocity(24,16)
        end
    },

    Def.Quad {
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):Center()
            :diffuse(1,1,1,0)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(4.4)
            :easeoutquad(0.2)
            :diffusealpha(1)
            :linear(0)
            :diffuse(0,0,0,1)
        end
    },

    Def.Quad {
        Name="OffLine_Top",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, 10)
            :xy(SCREEN_CENTER_X, SCREEN_TOP - 10)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(4.6)
            :linear(0.15)
            :y(SCREEN_CENTER_Y)
            :easeoutquad(0.15)
            :zoomto(0, 10)
        end
    },

    Def.Quad {
        Name="OffLine_Bottom",
        InitCommand=function(self)
            self:zoomto(SCREEN_WIDTH, 10)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 10)
            :queuecommand("Shutdown")
        end,
        ShutdownCommand=function(self)
            self:sleep(4.6)
            :linear(0.15)
            :y(SCREEN_CENTER_Y)
            :easeoutquad(0.15)
            :zoomto(0, 10)
        end
    },

    Def.Quad {
    		InitCommand=function(self)
    			   self:diffuse(0,0,0,0):sleep(5):queuecommand("Transfer")
    		end,
    		TransferCommand=function(self)
    			   SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
    		end
  	}

}
