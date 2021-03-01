local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	  InitCommand=function(self)
        self:draworder(200)
        :diffuseshift()
        :effectcolor1(color("#9334BD"))
        :effectcolor2(color("#4E25A2"))
        :zoomto(75,3)
        :fadeleft(0.75)
        :faderight(0.75)
        :blend(Blend.Add)
        :y(6)
    end
}
t[#t+1] = Def.Quad{
	  InitCommand=function(self)
        self:draworder(200)
        :diffuseshift()
        :effectcolor1(color("#9334BD"))
        :effectcolor2(color("#4E25A2"))
        :zoomto(75,3)
        :fadeleft(0.75)
        :faderight(0.75)
        :blend(Blend.Add)
        :y(6)
    end
}

return t
