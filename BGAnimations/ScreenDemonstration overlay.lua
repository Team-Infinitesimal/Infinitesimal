local t = LoadActor(THEME:GetPathB("ScreenGameplay", "overlay"))

t[#t+1] = Def.ActorFrame {
    Def.Quad {
        Name="DemoTextBox",
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y * 1.75):zoomto(250, 70)
            :diffuse(0,0,0,0.5)
        end
    },

    Def.BitmapText {
        Font="VCR OSD Mono 40px",
        InitCommand=function(self)
            self:settext("DEMO PLAY"):shadowlength(1)
            :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y * 1.75)
            :queuecommand("Flicker")
            :visible(0)
        end,
        FlickerCommand=function(self)
            self:sleep(1)
            :visible(not self:GetVisible())
            :queuecommand("Flicker")
        end
    }
}

return t
