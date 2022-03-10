return Def.ActorFrame {

  Def.Quad {
    Name="DemoTextBox",
    InitCommand=function(self)
      self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 100):zoomto(250, 70)
      :diffuse(0,0,0,0.5)
    end
  },

  Def.BitmapText {
    Font="VCR OSD Mono 40px",
    InitCommand=function(self)
      self:settext("DEMO PLAY")
      :xy(SCREEN_CENTER_X, SCREEN_CENTER_Y + 100)
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
