local t = Def.ActorFrame {

    OffCommand=function(self)
        if SCREENMAN:GetTopScreen():GetSelectionIndex(GAMESTATE:GetMasterPlayerNumber()) == 0 then
            PREFSMAN:SetPreference("AllowW1",'AllowW1_Never');
        else
            PREFSMAN:SetPreference("AllowW1",'AllowW1_Everywhere');
        end;
		
        PREFSMAN:SetPreference("TimingWindowSecondsHold",0.104166);
        PREFSMAN:SetPreference("TimingWindowSecondsMine",0.130000);
        PREFSMAN:SetPreference("TimingWindowSecondsRoll",0.450000);
		PREFSMAN:SetPreference("TimingWindowSecondsW1",0.031250);
		PREFSMAN:SetPreference("TimingWindowSecondsW2",0.062500);
		PREFSMAN:SetPreference("TimingWindowSecondsW3",0.104166);
		PREFSMAN:SetPreference("TimingWindowSecondsW4",0.145833);
		PREFSMAN:SetPreference("TimingWindowSecondsW5",0.187500);
    end;

    LoadActor(THEME:GetPathG("","ScreenHudTop"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(top)
			:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/8)
            :xy(SCREEN_CENTER_X,SCREEN_TOP-100)
            :diffusealpha(1)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_TOP)
        end;
    };

    LoadActor(THEME:GetPathG("","ScreenHudBottom"))..{
        InitCommand=function(self)
            self:diffusealpha(0)
            :vertalign(bottom)
			:scaletocover(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/8)
            :xy(SCREEN_CENTER_X,SCREEN_BOTTOM+100)
            :diffusealpha(1)
            :sleep(0.25)
            :decelerate(0.75)
            :y(SCREEN_BOTTOM)
        end;
    };

    LoadActor("CornerArrows");

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
                self:diffusealpha(1)
                :queuecommand("Zoom")
            else
                self:decelerate(0.2)
                :zoom(0.5)
                :diffusealpha(0.6)
            end;
        end;
        ZoomCommand=function(self)
            self:decelerate(0.3947)
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
                self:diffusealpha(1)
                :queuecommand("Zoom")
            else
                self:decelerate(0.2)
                :zoom(0.5)
                :diffusealpha(0.6)
            end;
        end;
        ZoomCommand=function(self)
            self:decelerate(0.3947)
            :zoom(0.55)
            :accelerate(0.3947)
            :zoom(0.5)
            :queuecommand("Zoom")
        end;
    };
};

return t;
