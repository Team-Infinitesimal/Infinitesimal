local player = ...;
local colorVar;

if player == PLAYER_1 then
  colorVar = color("0.3,0.5,0.85,1");
else
  colorVar = color("0.85,0.5,0.3,1");
end;

local t = Def.ActorFrame{
	
	LoadActor("cursor_half")..{
		InitCommand=function(self)self:diffuse(colorVar):blend(Blend.Add)end;
		OnCommand=function(self)
			if player == PLAYER_2 then
				self:addrotationz(180);
			end;
		end;
	};
	
	LoadActor("cursor_half")..{
		InitCommand=function(self)self:diffuse(colorVar):blend(Blend.Add)end;
		OnCommand=function(self)
			if player == PLAYER_2 then
				self:addrotationz(180);
			end;
		end;
	};
}

return t;
