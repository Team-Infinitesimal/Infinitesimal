pn = ...

offsetFromSide = 240

if pn == "PlayerNumber_P1" then
    xpos = SCREEN_LEFT + offsetFromSide
else
    xpos = SCREEN_RIGHT - offsetFromSide
end;

if PROFILEMAN:GetProfile(pn):GetDisplayName() ~= "" then
    displayname = PROFILEMAN:GetProfile(pn):GetDisplayName()
else
    displayname = "No Name"
end;

t = Def.ActorFrame {

    LoadActor("badge")..{
        InitCommand=function(self)
            self:xy(xpos, SCREEN_BOTTOM - 20)
            :zoom(0.15)
        end;
    };

    LoadFont("Montserrat semibold 40px")..{
        InitCommand=function(self)
            self:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
            :horizalign(center)
            :xy(offsetFromSide, SCREEN_BOTTOM - 20)
            :zoom(0.25)
        end;
    }
};

return t;
