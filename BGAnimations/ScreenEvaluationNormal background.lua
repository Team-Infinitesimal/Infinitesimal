local t = Def.ActorFrame {

    LoadActor(THEME:GetPathG("","EvalBGGradient"))..{
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBannerPath()
        end;
    };

    Def.Sprite {
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBannerPath()
            self:Load(bg):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
            self:diffusealpha(0.5);
        end
    };
};

return t;
