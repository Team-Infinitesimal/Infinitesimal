return Def.ActorFrame {
    -- Up Left
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/ShiftUL"),
        OnCommand=function(self) self:zoom(0.5):xy(-72, -72):easeoutexpo(1):xy(72, 72) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(-72, -72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/GlowShiftUL"),
        InitCommand=function(self) self:xy(72, 72):zoom(0.5):blend('add'):diffusealpha(0) end,
        SongUnchosenMessageCommand=function(self) self:playcommand("Glow") end,
        StartSelectingGroupMessageCommand=function(self) self:playcommand("Glow") end,
        GlowCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.5):linear(0.25):diffusealpha(0):zoom(0.6)
        end
    },

    -- Up Right
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/ShiftUR"),
        OnCommand=function(self) self:zoom(0.5):xy(SCREEN_RIGHT + 72, -72):easeoutexpo(1):xy(SCREEN_RIGHT - 72, 72) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(SCREEN_RIGHT + 72, -72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/GlowShiftUR"),
        InitCommand=function(self) self:xy(SCREEN_RIGHT - 72, -72):zoom(0.5):blend('add'):diffusealpha(0) end,
        SongUnchosenMessageCommand=function(self) self:playcommand("Glow") end,
        StartSelectingGroupMessageCommand=function(self) self:playcommand("Glow") end,
        GlowCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.5):linear(0.25):diffusealpha(0):zoom(0.6)
        end
    },

    -- Down Left
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/ShiftDL"),
        OnCommand=function(self) self:zoom(0.5):xy(-72, SCREEN_BOTTOM + 72):easeoutexpo(1):xy(72, SCREEN_BOTTOM - 72) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(-72, SCREEN_BOTTOM + 72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/GlowShiftDL"),
        InitCommand=function(self) self:xy(72, SCREEN_BOTTOM - 72):zoom(0.5):blend('add'):diffusealpha(0) end,
        PreviousSongMessageCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.5):linear(0.25):diffusealpha(0):zoom(0.6)
        end,
        ScrollMessageCommand=function(self, params) if params.Direction == -1 then
            self:stoptweening():diffusealpha(1):zoom(0.5):linear(0.25):diffusealpha(0):zoom(0.6) end
        end
    },

    -- Down Right
    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/ShiftDR"),
        OnCommand=function(self) self:zoom(0.5):xy(SCREEN_RIGHT + 72, SCREEN_BOTTOM + 72):easeoutexpo(1):xy(SCREEN_RIGHT - 72, SCREEN_BOTTOM - 72) end,
        OffCommand=function(self) self:stoptweening():easeoutexpo(1):xy(SCREEN_RIGHT + 72, SCREEN_BOTTOM + 72) end
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "CornerArrows/GlowShiftDR"),
        InitCommand=function(self) self:xy(SCREEN_RIGHT - 72, SCREEN_BOTTOM - 72):zoom(0.5):blend('add'):diffusealpha(0) end,
        NextSongMessageCommand=function(self)
            self:stoptweening():diffusealpha(1):zoom(0.5):linear(0.25):diffusealpha(0):zoom(0.6)
        end,
        ScrollMessageCommand=function(self, params) if params.Direction == 1 then
            self:stoptweening():diffusealpha(1):zoom(0.5):linear(0.25):diffusealpha(0):zoom(0.6) end
        end
    }
}
