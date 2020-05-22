local t = Def.ActorFrame {

    LoadActor("songPreview");

    LoadFont("montserrat semibold/_montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(left)
            :x(SCREEN_CENTER_X-90)
            :y(SCREEN_CENTER_Y+70)
            :zoom(0.28,0.28)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0)
            local song = GAMESTATE:GetCurrentSong();
            if song then
                local speedvalue;
                if song:IsDisplayBpmRandom() then
                    speedvalue = "???";
                else
                    local rawbpm = GAMESTATE:GetCurrentSong():GetDisplayBpms();
                    local lobpm = math.ceil(rawbpm[1]);
                    local hibpm = math.ceil(rawbpm[2]);
                    if lobpm == hibpm then
                        speedvalue = hibpm
                    else
                        speedvalue = lobpm.." - "..hibpm
                    end;
                end;
            self:settext("BPM: "..speedvalue);
            self:decelerate(0.2)
            self:diffusealpha(1)
            else
                self:stoptweening():linear(0.25):diffusealpha(0);
            end;
        end;
    };

    Def.Quad {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y+14)
            :diffuse(0,0,0,0.6)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            self:zoomx(0);
            self:decelerate(0.2);
            self:diffusealpha(0.75);
            self:sleep(0.2);
            self:zoomy(20);
            self:decelerate(0.35);
            self:zoomx(350);
        end;
    };

    LoadFont("montserrat semibold/_montserrat semibold 40px")..{
        InitCommand=function(self)
            self:horizalign(center)
            :x(SCREEN_CENTER_X)
            :y(SCREEN_CENTER_Y+13)
            :zoom(0.4,0.4)
            :skewx(-0.2)
            :maxwidth(800)
        end;
        CurrentSongChangedMessageCommand=function(self)
            self:stoptweening():diffusealpha(0);
            local song = GAMESTATE:GetCurrentSong();
            if song then
                self:settext(song:GetDisplayMainTitle());
            end;
            self:decelerate(0.2)
            self:diffusealpha(1)
        end;
    };
};

return t;
