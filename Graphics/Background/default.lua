local t = Def.ActorFrame {}

-- Solid Background
t[#t+1] = Def.Quad {
	Name="Background",
	InitCommand=function(self)
		self:Center()
		:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
		:diffuse(color("#150F34"))
	end
}

-- Gradient overlay
t[#t+1] = Def.Sprite {
	Name="Gradient",
	Texture="gradient",
	InitCommand=function(self)
		self:Center()
	end
}

-- Squiggly Things (with random speed!)
for i=1,4 do
	t[#t+1] = Def.Sprite {
		Name="Squiggle" .. i,
		Texture="Squiggles/" .. i,
		InitCommand=function(self)
			self:Center()
			:zoom(1 + i / 8)
			:texcoordvelocity(math.random(-3, 3) / 10, 0)
			:diffusealpha(0.25)
		end
	}
end

-- Top/Bottom Grids
t[#t+1] = LoadActor(THEME:GetPathG("", "Grid"))

-- Circles (not the kind you click)
t[#t+1] = Def.Sprite {
	Name="Circle1",
	Texture="Circle",
	InitCommand=function(self)
		self:Center()
		:blend("BlendMode_Add")
		:queuecommand("Grow")
	end,
	GrowCommand=function(self)
		self:stoptweening()
		:zoom(0)
		:linear(3.4288)
		:zoom(3)
		:queuecommand("Grow")
	end
}

t[#t+1] = Def.Sprite {
	Name="Circle2",
	Texture="Circle",
	InitCommand=function(self)
		self:visible(false)
		:Center()
		:blend("BlendMode_Add")
		:sleep(1.7144)
		:queuecommand("Grow")
	end,
	GrowCommand=function(self)
		self:visible(true):stoptweening()
		:zoom(0)
		:linear(3.4288)
		:zoom(3)
		:queuecommand("Grow")
	end
}

return t
