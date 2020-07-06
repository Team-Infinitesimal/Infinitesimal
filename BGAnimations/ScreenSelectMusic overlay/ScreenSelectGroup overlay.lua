local t = Def.ActorFrame {

    OnCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback(inputs);
    end;

    Def.Quad{
        InitCommand=function(self)
            self:zoomto(100,100)
            :diffusealpha(0)
            :diffuse(Color('White'))
            :xy(SCREEN_CENTER_X,SCREEN_CENTER_Y);
        end;

        StartSelectingGroupMessageCommand=function(self)
        		self:diffusealpha(1);
    	  end;

        StartSelectingSongMessageCommand=function(self)
        		self:stoptweening():linear(.5):diffusealpha(0);
      	end;
    };
};

return t;
