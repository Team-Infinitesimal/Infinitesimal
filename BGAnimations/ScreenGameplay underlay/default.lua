local t = Def.ActorFrame {
    LoadActor("ScreenFilter")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	t[#t+1] = Def.ActorFrame {
		LoadModule("PIU/Gameplay.Score.lua")(pn),
		LoadModule("PIU/Gameplay.Life.lua")(pn),
	}
end

return t
