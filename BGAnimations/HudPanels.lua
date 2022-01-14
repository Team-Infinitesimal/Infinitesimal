return Def.ActorFrame {
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/PanelTop"),
        InitCommand=function(self)
            self:scaletofit(0, 0, 1280, 128)
            :xy(SCREEN_CENTER_X, -128)
            :halign(0.5):valign(0)
        end,
        OnCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, 0)
        end,
        OffCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, -128)
        end,
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/PanelBottom"),
        InitCommand=function(self)
            self:scaletofit(0, 0, 1280, 128)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128)
            :halign(0.5):valign(1)
        end,
        OnCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM)
        end,
        OffCommand=function(self)
            self:easeoutexpo(0.5)
            :xy(SCREEN_CENTER_X, SCREEN_BOTTOM + 128)
        end,
    }
}