local t =  Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
  t[#t+1] = LoadActor("FullComboAnim", pn)
end

return t


