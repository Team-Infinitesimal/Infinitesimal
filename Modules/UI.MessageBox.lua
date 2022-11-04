-- Display a message box with a custom title and body!
-- Call with arguments X position , Y position, maximum width,
-- length of time to display in seconds, title text, and body text.

return function(PosX, PosY, BoxWidth, DelayTime, DisplayTime, Title, Body)

    return Def.ActorFrame {
        Name="MessageBox",
        OffCommand=function(self)
            self:finishtweening()
        end,

        Def.Quad {
            Name="BackgroundMask",
            InitCommand=function(self)
                self:halign(0):valign(0)
                :xy(PosX, PosY):MaskSource()
            end,
            OnCommand=function(self)
                self:sleep(DelayTime):zoomto(BoxWidth + 10, self:GetParent():GetChild("BodyText"):GetHeight()*0.75+20)
            end
        },

        Def.Quad {
            Name="BodyBackground",
            InitCommand=function(self)
                self:diffuse(0,0,0,0.75):halign(0):valign(0)
                :xy(PosX, PosY):zoomtowidth(BoxWidth + 10)
            end,
            OnCommand=function(self)
                self:sleep(DelayTime):easeoutexpo(0.5)
                :zoomtoheight(self:GetParent():GetChild("BodyText"):GetHeight()*0.75+20)
                :sleep(DisplayTime):queuecommand("Off")
            end,
            OffCommand=function(self)
                self:easeoutexpo(0.5)
                :zoomtoheight(0)
            end
        },

        Def.Quad {
            Name="TitleBackground",
            InitCommand=function(self)
                self:diffuse(color("#ab78f5")):diffusebottomedge(color("#1fbcff")):diffusealpha(1)
                :halign(0):valign(0)
                :xy(PosX, PosY)
                :MaskDest()
            end,
            OnCommand=function(self)
                TitleText = self:GetParent():GetChild("TitleText")
                TargetWidth = TitleText:GetWidth() * 0.5 + 11
                if TargetWidth > (BoxWidth) then TargetWidth = BoxWidth + 5 end
                self:sleep(DelayTime)
                :zoomto(TargetWidth, TitleText:GetHeight() * 0.75)
                :easeoutexpo(0.5)
                :y(PosY - TitleText:GetHeight() * 0.75)
                :sleep(DisplayTime):queuecommand("Off")
            end,
            OffCommand=function(self)
                self:easeoutexpo(0.5)
                :y(PosY)
            end
        },

        Def.BitmapText {
            Name="TitleText",
            Font="Montserrat semibold 40px",
            InitCommand=function(self)
                self:zoom(0.5):skewx(-0.1):halign(0):valign(0):shadowlength(1):diffusealpha(0)
                :maxwidth(BoxWidth / 0.5 - 5)
                :xy(PosX + 5, PosY + 5)
                :settext(Title)
                :MaskDest()
            end,
            OnCommand=function(self)
                self:sleep(DelayTime)
                :diffusealpha(1)
                :easeoutexpo(0.5)
                :y(PosY - 18)
                :sleep(DisplayTime):queuecommand("Off")
            end,
            OffCommand=function(self)
                self:easeoutexpo(0.5)
                :y(PosY + 5)
            end
        },

        Def.BitmapText {
            Name="BodyText",
            Font="Montserrat semibold 20px",
            InitCommand=function(self)
                self:zoom(0.75):halign(0):valign(0)
                :wrapwidthpixels((BoxWidth/0.75) - 5)
                :xy(-BoxWidth - 10, PosY + 10)
                :settext(Body)
                :MaskDest():ztestmode("ZTestMode_WriteOnFail")
            end,
            OnCommand=function(self)
                self:sleep(DelayTime)
                :easeoutexpo(0.5)
                :x(PosX + 5)
                :sleep(DisplayTime):queuecommand("Off")
            end,
            OffCommand=function(self)
                self:easeoutexpo(0.5)
                :x(-BoxWidth - 5)
            end
        }

    }

end
