local t = Def.ActorFrame {
    LoadActor("../HudPanels"),
    
    LoadActor("../CornerArrows"),
    
    LoadActor("OptionsList"),
    
    LoadActor("GroupSelect", SCREEN_CENTER_X, 150),
    
    Def.Sound {
        File=THEME:GetPathS("Common", "start"),
        PlayerJoinedMessageCommand=function(self)
            self:play()
            SOUND:DimMusic(0,65536)
            SCREENMAN:GetTopScreen():SetPrevScreenName("ScreenSelectProfile");
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToPrevScreen");
        end
    }
}

return t

