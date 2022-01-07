local t = Def.ActorFrame {
    LoadActor("../HudPanels"),
    
    LoadActor("../CornerArrows"),
    
    LoadActor("GroupSelect", SCREEN_CENTER_X, 150),
}

-- OptionsList shenanigans
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	Def.ActorFrame {
        Def.Sprite {
            Texture=THEME:GetPathG("", "MusicWheel/Options"),
            InitCommand=function(self,params)
                self:xy(pn == PLAYER_1 and -200 or SCREEN_RIGHT + 200, SCREEN_CENTER_Y - 100)
            end,
            OptionsListOpenedMessageCommand=function(self,params)
                if params.Player == pn then 
                    self:stoptweening():easeoutexpo(0.25):x(pn == PLAYER_1 and 200 or SCREEN_RIGHT - 200)
                end
            end,
            OptionsListClosedMessageCommand=function(self,params)
                if params.Player == pn then 
                    self:stoptweening():easeoutexpo(0.25):x(pn == PLAYER_1 and -200 or SCREEN_RIGHT + 200)
                end
            end
        }
    }
end

t[#t+1] = Def.ActorFrame {
    Def.Sound {
        File=THEME:GetPathS("Common", "start"),
        PlayerJoinedMessageCommand=function(self) self:play() end
    },
    
    Def.Sound {
        File=THEME:GetPathS("", "OpenCommandWindow"),
        CodeMessageCommand=function(self, params)
            if params.Name == "OpenOpList" then
                SCREENMAN:GetTopScreen():OpenOptionsList(params.PlayerNumber)
                self:play()
            end
        end
    },

    Def.Sound {
        File=THEME:GetPathS("", "CloseCommandWindow"),
        OptionsListClosedMessageCommand=function(self) self:play() end
    },

    Def.Sound {
        File=THEME:GetPathS("", "MoveCommandWindow"),
        OptionsListRightMessageCommand=function(self) self:queuecommand("Refresh") end,
        OptionsListLeftMessageCommand=function(self) self:queuecommand("Refresh") end,
        OptionsListQuickChangeMessageCommand=function(self) self:queuecommand("Refresh") end,
        RefreshCommand=function(self) self:play() end
    },

    Def.Sound {
        File=THEME:GetPathS("", "StartCommandWindow"),
        -- No idea why we need all of this. OptionsList sucks.
        OptionsListStartMessageCommand=function(self) self:queuecommand("Refresh") end,
        OptionsListResetMessageCommand=function(self) self:queuecommand("Refresh") end,
        OptionsListPopMessageCommand=function(self) self:queuecommand("Refresh") end,
        OptionsListPushMessageCommand=function(self) self:queuecommand("Refresh") end,
        RefreshCommand=function(self) self:play() end
    }
}

return t

