local player = ...
local colorVar

if player == PLAYER_1 then
	colorVar = color("0.3,0.5,0.85,1")
else
	colorVar = color("0.85,0.5,0.3,1")
end

local t = Def.ActorFrame{}
for i=1,2 do
	t[#t+1] = Def.Sprite{
		Texture="cursor_half",
		InitCommand=function(self) self:diffuse(colorVar):blend(Blend.Add) end,
		OnCommand=function(self)
			self:addrotationz( player == PLAYER_2 and 180 or 0 )
		end
	}
end
return t