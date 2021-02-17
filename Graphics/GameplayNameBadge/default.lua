local pn = ...

if PROFILEMAN:GetProfile(pn):GetDisplayName() ~= "" then
    displayname = PROFILEMAN:GetProfile(pn):GetDisplayName()
else
    displayname = "No Name"
end;

t = Def.ActorFrame {

    LoadActor("badge")..{
        OnCommand=function(self)
			if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
				local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)):GetX()
				self:xy(pos, SCREEN_BOTTOM - 20)
				:zoom(0.45)
            end
        end;
    };

    LoadFont("Montserrat semibold 20px")..{
        OnCommand=function(self)
			if SCREENMAN:GetTopScreen() and SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)) then
				local pos = SCREENMAN:GetTopScreen():GetChild("PlayerP"..string.sub(pn,-1)):GetX()
				self:settext(PROFILEMAN:GetProfile(pn):GetDisplayName())
				:horizalign(center)
				:xy(pos, SCREEN_BOTTOM - 20)
				:shadowlength(1)
				:zoom(0.75)
			end;
        end;
    }
};

return t;
