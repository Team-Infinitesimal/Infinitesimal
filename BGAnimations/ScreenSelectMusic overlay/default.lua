local t = Def.ActorFrame {
    LoadActor("../HudPanels"),
    
    LoadActor("../CornerArrows"),
    
    LoadActor("OptionsList"),
    
    LoadActor("GroupSelect", SCREEN_CENTER_X, SCREEN_CENTER_Y),
    
    Def.Sound {
        File=THEME:GetPathS("Common", "start"),
        PlayerJoinedMessageCommand=function(self)
            self:play()
			SOUND:DimMusic(0, 1)
            SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectProfile")
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }
}

return t

