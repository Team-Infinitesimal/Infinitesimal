local t = Def.ActorFrame {}

for player in ivalues(PlayerNumber) do
    
    t[#t+1] = Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X+(player == PLAYER_1 and -205 or 205),SCREEN_CENTER_Y+22)
            :zoomx(70):zoomy(15):diffuse(0,0,0,0)
        end,
        
        StepsChosenMessageCommand=function(self, params)
			if params.Player == player then
				self:stoptweening():decelerate(0.25)
				:diffuse(0,0,0,0.75)
				
				if params.Player == PLAYER_1 then
					self:diffuseleftedge(0,0,0,0)
				else
					self:diffuserightedge(0,0,0,0)
				end
			end
        end,
		
		StepsUnchosenMessageCommand=function(self) self:playcommand("Unchosen") end,
		SongUnchosenMessageCommand=function(self) self:playcommand("Unchosen") end,
		
        UnchosenCommand=function(self)
            self:stoptweening():decelerate(0.1)
            :diffuse(0,0,0,0)
        end
    }
    
    t[#t+1] = Def.Sprite {
		Texture="Ready"..pname(player),
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+22):zoom(0.25):visible(false)
        end,

        StepsChosenMessageCommand=function(self, params)
			if params.Player == player then
				self:stoptweening():visible(true)
				:decelerate(0.25):x(SCREEN_CENTER_X+(player == PLAYER_1 and -205 or 205))
			end
        end,
		
		StepsUnchosenMessageCommand=function(self) self:playcommand("Unchosen") end,
		SongUnchosenMessageCommand=function(self) self:playcommand("Unchosen") end,
		
        UnchosenCommand=function(self)
            self:stoptweening():visible(false)
            :decelerate(0.1):x(SCREEN_CENTER_X)
        end
    }
end

return t
