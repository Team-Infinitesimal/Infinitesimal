local t = Def.ActorFrame {}

local isdouble = GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides"
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

	t[#t+1] = LoadActor( THEME:GetPathG("","Lifebar"), { Player = pn, Double = isdouble } )..{
		InitCommand=function(self)
			local xpos = THEME:GetMetric(Var "LoadingScreen","Player".. ToEnumShortString( pn ) .."OnePlayerOneSideX")
			self:xy( isdouble and SCREEN_CENTER_X or xpos , 18 )
		end
	}

	t[#t+1] = Def.Actor {
		InitCommand=function(self)
			setenv(pname(pn).."StageBreak",false)
		end,

		["LifeMeterChanged"..pname(pn).."MessageCommand"]=function(self,param)
			if param.Life <= 0 then
				setenv(pname(pn).."StageBreak",true)
			end
		end
	}

  t[#t+1] = LoadActor(THEME:GetPathG("", "GameplayNameBadge"), pn)
  t[#t+1] = LoadActor(THEME:GetPathG("", "StageCount"), pn)

end

return t
