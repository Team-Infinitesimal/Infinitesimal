local t = Def.ActorFrame {

    Def.Sprite {
        Texture=THEME:GetPathG("","ShiftUL"),
        InitCommand=function(self)
            self:zoom(0.2)
            :xy(SCREEN_LEFT+200,SCREEN_TOP+200)
            :decelerate(0.75)
            :xy(SCREEN_LEFT+60,SCREEN_TOP+60)
        end;
    };

    Def.Sprite {
        Texture=THEME:GetPathG("","ShiftUR"),
        InitCommand=function(self)
            self:zoom(0.2)
            :xy(SCREEN_RIGHT-200,SCREEN_TOP+200)
            :decelerate(0.75)
            :xy(SCREEN_RIGHT-60,SCREEN_TOP+60)
        end;
    };

    Def.Sprite {
        Texture=THEME:GetPathG("","ShiftDL"),
        InitCommand=function(self)
            self:zoom(0.2)
            :xy(SCREEN_LEFT+200,SCREEN_BOTTOM-200)
            :decelerate(0.75)
            :xy(SCREEN_LEFT+60,SCREEN_BOTTOM-60)
        end;
    };

    Def.Sprite {
        Texture=THEME:GetPathG("","ShiftDR"),
        InitCommand=function(self)
            self:zoom(0.2)
            :xy(SCREEN_RIGHT-200,SCREEN_BOTTOM-200)
            :decelerate(0.75)
            :xy(SCREEN_RIGHT-60,SCREEN_BOTTOM-60)
        end;
    };

    --Glowy Arrows

    Def.Sprite {
        Texture=THEME:GetPathG("","GlowShiftDL"),
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoom(0.2)
            :xy(SCREEN_LEFT+60,SCREEN_BOTTOM-60)
        end;
        PreviousSongMessageCommand=function(self)
            self:stoptweening()
            :zoom(0.2)
            :diffusealpha(0.6)
            :decelerate(0.4)
            :zoom(0.25)
            :diffusealpha(0)
        end;
    };

    Def.Sprite {
        Texture=THEME:GetPathG("","GlowShiftDR"),
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoom(0.2)
            :xy(SCREEN_RIGHT-60,SCREEN_BOTTOM-60)
        end;
        NextSongMessageCommand=function(self)
            self:stoptweening()
            :zoom(0.2)
            :diffusealpha(0.75)
            :decelerate(0.4)
            :zoom(0.25)
            :diffusealpha(0)
        end;
    };
};

return t;
