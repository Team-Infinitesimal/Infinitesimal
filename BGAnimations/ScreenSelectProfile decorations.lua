-- We're still selecting the profile here, so ScreenHudFrame (which contains profile name displaying) will not be used

local t = Def.ActorFrame {
    LoadActor(THEME:GetPathG("","BlankScreenHudFrame"))
};

return t;
