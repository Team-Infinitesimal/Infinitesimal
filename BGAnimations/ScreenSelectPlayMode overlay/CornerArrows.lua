local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","ShiftUL"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :xy(SCREEN_LEFT+200,SCREEN_TOP+200)
            :decelerate(0.75)
            :xy(SCREEN_LEFT+60,SCREEN_TOP+60)
        end;
    };

    LoadActor(THEME:GetPathG("","ShiftUR"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :xy(SCREEN_RIGHT-200,SCREEN_TOP+200)
            :decelerate(0.75)
            :xy(SCREEN_RIGHT-60,SCREEN_TOP+60)
        end;
    };

    LoadActor(THEME:GetPathG("","ShiftDL"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :xy(SCREEN_LEFT+200,SCREEN_BOTTOM-200)
            :decelerate(0.75)
            :xy(SCREEN_LEFT+60,SCREEN_BOTTOM-60)
        end;
    };

    LoadActor(THEME:GetPathG("","ShiftDR"))..{
        InitCommand=function(self)
            self:zoom(0.10)
            :xy(SCREEN_RIGHT-200,SCREEN_BOTTOM-200)
            :decelerate(0.75)
            :xy(SCREEN_RIGHT-60,SCREEN_BOTTOM-60)
        end;
    };

    --Glowy Arrows

    LoadActor(THEME:GetPathG("","GlowShiftDL"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoom(0.10)
            :xy(SCREEN_LEFT+60,SCREEN_BOTTOM-60)
        end;
        MenuLeftP1MessageCommand=function(self)
            self:stoptweening()
            :queuecommand("Refresh")
        end;
        MenuLeftP2MessageCommand=function(self)
            self:stoptweening()
            :queuecommand("Refresh")
        end;
        RefreshCommand=function(self)
            self:zoom(0.10)
            :diffusealpha(0.6)
            :decelerate(0.4)
            :zoom(0.12)
            :diffusealpha(0)
        end;
    };

    LoadActor(THEME:GetPathG("","GlowShiftDR"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :zoom(0.10)
            :xy(SCREEN_RIGHT-60,SCREEN_BOTTOM-60)
        end;
        MenuRightP1MessageCommand=function(self)
            self:stoptweening()
            :queuecommand("Refresh")
        end;
        MenuRightP2MessageCommand=function(self)
            self:stoptweening()
            :queuecommand("Refresh")
        end;
        RefreshCommand=function(self)
            self:zoom(0.10)
            :diffusealpha(0.75)
            :decelerate(0.4)
            :zoom(0.12)
            :diffusealpha(0)
        end;
    };
};

return t;
