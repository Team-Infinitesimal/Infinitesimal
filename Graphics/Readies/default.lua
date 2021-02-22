local t = Def.ActorFrame {};

for player in ivalues(PlayerNumber) do

    t[#t+1] = Def.Sprite {
      Texture="Ready"..pname(player),

        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+50)
            :zoom(0.05)
        end;

        StepsChosenMessageCommand=function(self)
            self:stoptweening();
            self:visible(GAMESTATE:IsHumanPlayer(player));
            if player == PLAYER_1 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X-255);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X+255);
            end;
        end;

        StepsUnchosenMessageCommand=function(self)
            self:stoptweening();
            if player == PLAYER_1 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X);
            elseif player == PLAYER_2 then
                self:decelerate(0.25);
                self:x(SCREEN_CENTER_X);
            end;
        end;
    };
end;

return t;
