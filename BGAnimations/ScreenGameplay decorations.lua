local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","Lifebar"))..{
        InitCommand=function(self)
            self:xy(SCREEN_LEFT,SCREEN_TOP+2)
        end;
    };
};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

	t[#t+1] = Def.Actor {
		InitCommand=function(self)
			setenv(pname(pn).."StageBreak",false)
		end;
		
		["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,param)
			if param.Life == 0 then
				setenv(pname(pn).."StageBreak",true)
			end;
		end;
	};

    t[#t+1] = LoadActor(THEME:GetPathG("", "GameplayNameBadge"), pn)

end;

return t;
