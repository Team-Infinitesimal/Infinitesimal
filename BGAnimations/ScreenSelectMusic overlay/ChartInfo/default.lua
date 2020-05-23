local t = Def.ActorFrame {};

for player in ivalues(GAMESTATE:GetEnabledPlayers()) do
    t[#t+1] = LoadActor("ChartInfo"..pname(player))..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y-75)
            :zoom(0.10)
        end;
        SongChosenMessageCommand=function(self)
            self:stoptweening();
            if player == PLAYER_1 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X-255);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X+255);
            end;
        end;
        SongUnchosenMessageCommand=function(self)
            self:stoptweening();
            if player == PLAYER_1 then
                self:accelerate(0.25);
                self:x(SCREEN_CENTER_X);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X);
            end;
        end;
    };
end;

return t;
