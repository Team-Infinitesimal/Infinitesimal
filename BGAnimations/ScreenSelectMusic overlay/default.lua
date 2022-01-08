-- A default file this simple? How does he do it?????
local t = Def.ActorFrame {
    LoadActor("../HudPanels"),
    
    LoadActor("../CornerArrows"),
    
    LoadActor("OptionsList"),
    
    LoadActor("GroupSelect", SCREEN_CENTER_X, 150),
}

return t

