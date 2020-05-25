local t = Def.ActorFrame {};

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = LoadActor("PlayerNumbers", pn)..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,138)
            end;
    };

end;

return t;
