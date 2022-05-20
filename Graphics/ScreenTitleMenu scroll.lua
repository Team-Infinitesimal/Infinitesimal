local TextWidth = 112
local MaxZoom = 1.1

return Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/Button"),
        GainFocusCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(MaxZoom) end,
        LoseFocusCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(1) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/Button"),
        InitCommand=function(self)
            self:glowramp()
            :effectperiod(0.4286)
            :effectcolor1(1,1,1,0)
            :effectcolor2(1,1,1,0.5)
            :visible(false)
        end,
        GainFocusCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(MaxZoom):visible(true) end,
        LoseFocusCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(1):visible(false) end
    },

    Def.BitmapText {
        Font="Common Normal",
        Text=THEME:GetString("ScreenTitleMenu", Var("GameCommand"):GetText()),
        InitCommand=function(self) self:maxwidth(TextWidth) end,
        GainFocusCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(MaxZoom) end,
        LoseFocusCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(1) end
    }
}
