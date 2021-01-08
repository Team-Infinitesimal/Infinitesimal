local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","DiffBar"))..{
        InitCommand=function(self)
            self:zoom(0.73):vertalign(top)
            :x(SCREEN_CENTER_X)
            :y(SCREEN_CENTER_Y+28)
        end;
        SongChosenMessageCommand=function(self)
			self:stoptweening():decelerate(0.3):zoom(0.925)
		end;
		SongUnchosenMessageCommand=function(self)
			self:stoptweening():decelerate(0.3):zoom(0.73)
		end;
    };

    LoadActor(THEME:GetPathG("","DifficultyDisplay"))..{
        InitCommand=function(self)
            self:vertalign(top)
            :x(SCREEN_CENTER_X)
            :y(SCREEN_CENTER_Y+48.5)
            
        end;
        SongChosenMessageCommand=function(self)
			self:stoptweening():decelerate(0.3):zoom(1.275):y(SCREEN_CENTER_Y+54)
		end;
		SongUnchosenMessageCommand=function(self)
			self:stoptweening():decelerate(0.3):zoom(1):y(SCREEN_CENTER_Y+48.5)
		end;
    };
};

return t;
