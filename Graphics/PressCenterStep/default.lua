if IsGame("pump") or IsGame("piu") then
    return Def.ActorFrame {
        Def.Sprite {
            Texture="CenterStep",
            InitCommand=function(self) self:y(55):zoom(0.5) end
        },

        Def.Sprite {
           Texture="CenterStep",
            InitCommand=function(self)
                self:y(55):zoom(0.5):diffusealpha(0)
                :queuecommand("FadeEffect")
            end,
            FadeEffectCommand=function(self)
                self:stoptweening()
                :zoom(0.5):diffusealpha(0.75)
                :decelerate(0.4286)
                :zoom(0.6):diffusealpha(0)
                :queuecommand("FadeEffect")
            end
        },

        Def.Sprite {
            Name="Press",
            Texture="Press",
            InitCommand=function(self) self:zoom(0.8) end,
            OnCommand=function(self)
                self:bounce():sleep(1.1)
                :effectmagnitude(0, -18, 0)
                :effectperiod(0.4286)
            end
        }
    }
else
    return LoadActor("ButtonPress 5x2") .. {
        Frames=Sprite.LinearFrames(10, .4286),
        InitCommand=function(self) self:y(20) end
    }
end
