pn = ...

local offsetFromSide = 187
local xpos = SCREEN_CENTER_X - offsetFromSide

if pn == PLAYER_2 then
	xpos = SCREEN_CENTER_X + offsetFromSide
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
            :zoom(0.45)
        end;
    };

    LoadFont("Montserrat semibold 20px")..{
        InitCommand=function(self)
            self:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
            :horizalign(center)
            :xy(xpos, SCREEN_BOTTOM - 20)
            :shadowlength(1)
            :zoom(0.75)
        end;
    }
};

return t;
