local t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
  	InitCommand=function(self)
        self:diffuseshift()
        :effectcolor2(color("#000000"))
        :effectcolor1(color("0.1,0.5,0.7,0.6"))
  	    :effectperiod(0.75)
        :effectoffset(0.325)
        :zoomto(130,16)
        :fadeleft(0.25)
        :faderight(0.25)
        :blend(Blend.Add)
        :y(1);
    end;
}

t[#t+1] = LoadActor("Selector")..{
	 InitCommand=cmd(zoom,0.65;pulse;effectmagnitude,0.95,1,1;effectperiod,0.75;y,1);
}

return t
