local player = ...
local colorVar

if player == PLAYER_1 then
	colorVar1 = color("0.85,0.5,0.3,1")
	colorVar2 = color("0.85,0.5,0.3,0.75")
else
	colorVar1 = color("0.3,0.5,0.85,1")
	colorVar2 = color("0.3,0.5,0.85,0.75")
end

local t = Def.ActorFrame{}
for i=1,2 do
	t[#t+1] = Def.Sprite{
		Texture="cursor_half",
		InitCommand=function(self) self:diffuseshift():effectcolor1(colorVar1):effectcolor2(colorVar2):blend(Blend.Add):effectclock("bgm") end,
		OnCommand=function(self)
			self:addrotationz( player == PLAYER_2 and 180 or 0 )
		end
	}
end
return t
