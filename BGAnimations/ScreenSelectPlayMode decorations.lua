local t = Def.ActorFrame {
	
	LoadActor(THEME:GetPathG("","ScreenHudFrame"));

    LoadActor(THEME:GetPathG("","CornerArrows"));

    LoadActor(THEME:GetPathG("","ModeSelect/ArcadeMode"))..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X-160,SCREEN_CENTER_Y)
            :zoom(0.5)
            :diffusealpha(0.6)
        end;
        OnCommand=function(self)
            self:playcommand("Refresh")
        end;
        MenuSelectionChangedMessageCommand=function(self)
            self:stoptweening()
            :playcommand("Refresh")
        end;
        RefreshCommand=function(self)
            if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 0 then
				PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
                self:diffusealpha(1)
                :queuecommand("Zoom")
            else
                self:decelerate(0.2)
                :zoom(0.5)
                :diffusealpha(0.6)
            end;
        end;
        ZoomCommand=function(self)
            self:decelerate(0.4286)
            :zoom(0.55)
            :accelerate(0.3947)
            :zoom(0.5)
            :queuecommand("Zoom")
        end;
    };

    LoadActor(THEME:GetPathG("","ModeSelect/ProMode"))..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X+160,SCREEN_CENTER_Y)
            :zoom(0.5)
            :diffusealpha(0.6)
        end;
        OnCommand=function(self)
            self:playcommand("Refresh")
        end;
        MenuSelectionChangedMessageCommand=function(self)
            self:stoptweening()
            :playcommand("Refresh")
        end;
        RefreshCommand=function(self)
            if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 1 then
				PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
                self:diffusealpha(1)
                :queuecommand("Zoom")
            else
                self:decelerate(0.2)
                :zoom(0.5)
                :diffusealpha(0.6)
            end;
        end;
        ZoomCommand=function(self)
            self:decelerate(0.4286)
            :zoom(0.55)
            :accelerate(0.3947)
            :zoom(0.5)
            :queuecommand("Zoom")
        end;
    };
};

return t;
