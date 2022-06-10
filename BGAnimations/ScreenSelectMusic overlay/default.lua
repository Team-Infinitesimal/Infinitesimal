local t = Def.ActorFrame {
    OnCommand=function(self)
        local pn = GAMESTATE:GetMasterPlayerNumber()
        GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(pn))
        if GAMESTATE:IsCourseMode() then
            GAMESTATE:UpdateDiscordScreenInfo("Selecting Course", "", 1)
        else
            local StageIndex = GAMESTATE:GetCurrentStageIndex()
            GAMESTATE:UpdateDiscordScreenInfo("Selecting Song (Stage " .. StageIndex+1 .. ")", "", 1)
        end
    end,
}

if GAMESTATE:GetNumSidesJoined() < 2 then
    t[#t+1] = Def.ActorFrame {
        LoadActor(THEME:GetPathG("", "PressCenterStep")) .. {
            InitCommand=function(self)
                local PosX = SCREEN_CENTER_X + SCREEN_WIDTH * (GAMESTATE:IsSideJoined(PLAYER_1) and 0.35 or -0.35)
                self:xy((IsUsingWideScreen() and PosX or (PosX * 1.045)), (IsUsingWideScreen() and (SCREEN_HEIGHT * 0.4) or SCREEN_HEIGHT * 0.35))
            end,
            OffCommand=function(self) self:stoptweening():easeoutexpo(0.25):zoom(2):diffusealpha(0) end,
        }
    }
end

t[#t+1] = Def.ActorFrame {
    LoadActor("../HudPanels"),

    LoadActor("../CornerArrows"),

    LoadActor("OptionsList"),

    LoadActor("GroupSelect", SCREEN_CENTER_X, SCREEN_CENTER_Y),

    Def.Sound {
        File=THEME:GetPathS("Common", "start"),
        IsAction=true,
        PlayerJoinedMessageCommand=function(self)
            self:play()
            SOUND:DimMusic(0, 1)
            SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectProfile")
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        end
    }
}

return t
