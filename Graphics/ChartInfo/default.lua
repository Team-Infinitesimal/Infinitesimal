local t = Def.ActorFrame {};

for player in ivalues(GAMESTATE:GetEnabledPlayers()) do
    t[#t+1] = LoadActor("ChartInfo"..pname(player))..{
    InitCommand=function(self)
        self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-53)
        :diffusealpha(0)
        :zoom(0.2405)
    end;
    SongChosenMessageCommand=function(self)
        self:diffusealpha(1);
        if player == PLAYER_1 then
            self:decelerate(0.25)
            :x(SCREEN_CENTER_X-100);
        elseif player == PLAYER_2 then
            self:decelerate(0.25)
            :x(SCREEN_CENTER_X+100);
        end;
    };
end;

return t;
