local t = Def.ActorFrame {};

local song = GAMESTATE:GetCurrentSong();

t[#t+1] = Def.ActorFrame {
    LoadActor(THEME:GetPathG("","EvalElements/EvalBGGradient"))..{
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBackgroundPath()
        end;
    };

    Def.Sprite {
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBackgroundPath()
            self:Load(bg):scaletocover(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
            self:diffusealpha(0.25);
        end
    };
};

return t;
