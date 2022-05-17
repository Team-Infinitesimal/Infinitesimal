return Def.ActorFrame {
    InitCommand=function(self)
        self:xy(SCREEN_LEFT + 140, SCREEN_BOTTOM - 60)
    end,

    LoadActor(THEME:GetPathG("", "Logo/Parts/AnimatedLoop"))..{
        InitCommand=function(self)
            self:zoom(0.25)
        end
    },

    Def.BitmapText {
        Font="Montserrat extrabold 40px",
        Text="SAVING PROFILE DATA...",
        InitCommand=function(self)
            self:skewx(-0.1):shadowlength(2):zoom(0.5)
        end
    },

    Def.Actor {
    	BeginCommand=function(self)
    		if SCREENMAN:GetTopScreen():HaveProfileToSave() then self:sleep(1) end
    		self:queuecommand("Load")
    	end,
    	LoadCommand=function() SCREENMAN:GetTopScreen():Continue() end
    }
}
