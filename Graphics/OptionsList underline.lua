local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	  InitCommand=function(self)
        self:draworder(200)
        :diffuseshift()
        :effectcolor1(color("0,0.55,0.6,0.6"))
        :effectcolor2(color("0,0.7,0.8,0.8"))
        :zoomto(75,3)
        :fadeleft(0.75)
        :faderight(0.75)
        :blend(Blend.Add)
        :y(6);
    end;
}
t[#t+1] = Def.Quad{
	  InitCommand=function(self)
        self:draworder(200)
        :diffuseshift()
        :effectcolor1(color("0,0.55,0.6,0.6"))
        :effectcolor2(color("0,0.7,0.8,0.8"))
        :zoomto(75,3)
        :fadeleft(0.75)
        :faderight(0.75)
        :blend(Blend.Add)
        :y(6);
    end;
}

return t
