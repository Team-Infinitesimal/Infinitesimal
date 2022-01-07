return Def.ActorFrame{
    Def.Quad {
        InitCommand=function(self)
            self:diffuseshift()
            :effectcolor2(color("#000000"))
            :effectcolor1(color("#9334BD"))
            :effectperiod(0.75)
            :effectoffset(0.325)
            :zoomto(130,16)
            :fadeleft(0.25)
            :faderight(0.25)
            :blend(Blend.Add)
            :y(1)
        end
    },
    
    Def.Sprite {
        Texture=THEME:GetPathG("", "MusicWheel/Selector"),
        InitCommand=function(self)
            self:zoom(0.5)
            :pulse()
            :effectmagnitude(0.95,1,1)
            :effectperiod(0.75)
            :y(1)
        end
    }
}
