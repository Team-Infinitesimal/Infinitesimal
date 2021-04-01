if IsGame("pump") then
	return Def.ActorFrame {
		Def.Sprite {
			Texture="centerstep",
			InitCommand=function(self)
				self:y(55)
				:zoom(0.5,0.5)
			end
		},

		Def.Sprite {
		   Texture="centerstep",
			InitCommand=function(self)
				self:y(55)
				:zoom(0.5,0.5)
				:diffusealpha(0)
				:queuecommand("FadeEffect")
			end,
			FadeEffectCommand=function(self)
				self:stoptweening()
				:zoom(0.5,0.5)
				:diffusealpha(0.75)
				:decelerate(0.4286)
				:zoom(0.6,0.6)
				:diffusealpha(0)
				:queuecommand("FadeEffect")
			end
		},

		Def.Sprite {
			Texture="press",
			InitCommand=function(self)
				self:zoom(0.8,0.8)
			end,
			OnCommand=function(self)
				self:bounce()
				:sleep(1.1)
				:effectmagnitude(0,-18,0)
				:effectperiod(0.4286)
			end
		}
	}
else
	return LoadActor("_press dance 5x2")..{
		Frames = Sprite.LinearFrames(10,.4286),
		InitCommand=function(self)self:y(20):zoom(0.5)end
	}
end
