local t = Def.ActorFrame {

    Def.Sprite {
        InitCommand=function(self)
            self:Center()
            local song = GAMESTATE:GetCurrentSong()
            local bg = song:GetBannerPath()
            self:Load(bg):zoomto(SCREEN_WIDTH,SCREEN_HEIGHT);
        end;

    };
};

return t;
