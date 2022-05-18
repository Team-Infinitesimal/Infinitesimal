local t = Def.ActorFrame {}

for i=1,20 do
    t[#t+1] = Def.ActorFrame {
        Name="Confetto",
        InitCommand=function(self)
            self:queuecommand("Fall")
        end,
        FallCommand=function(self)
            self:diffusealpha(1):y(SCREEN_TOP)
            :accelerate(math.random(1, 5))
            :y(SCREEN_BOTTOM - math.random(100))
            :diffusealpha(0)
            :queuecommand("Fall")
        end,

        Def.Sprite {
            Name="ConfettoSprite",
            OnCommand=function(self)
                ConfettoList = {"BlueArrow", "CenterArrow", "RedArrow"}

                self:Load(THEME:GetPathG("", "UI/Icon/"..ConfettoList[math.random(#ConfettoList)]))
                :setsize(math.random(20, 50), math.random(20, 50))
                :xy(math.random(SCREEN_WIDTH), SCREEN_TOP - 50)
                :diffusealpha(1)
                :spin()
                :effectmagnitude(math.random(100), math.random(100), math.random(10))
            end
        }
    }
end

return t
