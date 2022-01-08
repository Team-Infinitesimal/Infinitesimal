local t = Def.ActorFrame {
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

-- Special thanks to RhythmLunatic/Accelerator and ROAD24
for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
	-- This will allow us to determine the position of the list
    local OptionsListActor
    
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self,params)
            self:xy(pn == PLAYER_1 and -200 or SCREEN_RIGHT + 200, SCREEN_CENTER_Y - 70)
        end,
        
        OnCommand=function(self)
			OptionsListActor = SCREENMAN:GetTopScreen():GetChild("OptionsList" .. pname(pn))
		end,
        
        -- Move the list around when opened/closed
        OptionsListOpenedMessageCommand=function(self, params)
            if params.Player == pn then
                self:stoptweening():easeoutexpo(0.5):x(pn == PLAYER_1 and 200 or SCREEN_RIGHT - 200)
            end
        end,
        
        OptionsListClosedMessageCommand=function(self, params)
            if params.Player == pn then 
                self:stoptweening():easeoutexpo(0.5):x(pn == PLAYER_1 and -200 or SCREEN_RIGHT + 200)
            end
        end,
        
        -- Make us able to view what menu we're in (and also reset changes)
        OptionsMenuChangedMessageCommand=function(self, params)
            if params.Player == pn then 
                local OptionsListMenu = params.Menu
                
                -- Appropriately grab the amount of items
                OptionsListNumItems = tonumber(THEME:GetMetric("ScreenOptionsMaster", OptionsListMenu))
                
                if OptionsListMenu ~= "Noteskins" and OptionsListMenu ~= "TimingWindow" then
                    OptionsListActor:stoptweening():y(SCREEN_CENTER_Y - 180)
                end
            end
        end,
        
        OptionsListLeftMessageCommand=function(self, params) self:playcommand("Adjust", params) end,
        OptionsListRightMessageCommand=function(self, params) self:playcommand("Adjust", params) end,
        OptionsListStartMessageCommand=function(self, params) self:playcommand("Adjust", params) end,
        OptionsListQuickChangeMessageCommand=function(self, params) self:playcommand("Adjust", params) end,
        
        AdjustCommand=function(self, params)
            if params.Player == pn then
                --SCREENMAN:SystemMessage(params.Selection)
                if params.Selection + 1 > 10 then
                    OptionsListActor:stoptweening():linear(0.1):y(SCREEN_CENTER_Y - 180 - (26 * (params.Selection - 10)))
                else
                    OptionsListActor:stoptweening():linear(0.1):y(SCREEN_CENTER_Y - 180)
                end
            end
        end,
        
        Def.Sprite {
            Texture=THEME:GetPathG("", "MusicWheel/Options"),
            InitCommand=function(self) self:zoom(0.7) end
        },
        
        -- Masks that will hide the off limits portion of the list, shhh
        Def.Quad {
            InitCommand=function(self) self:setsize(206, 170):xy(0, -205):MaskSource() end,
        },
        
        Def.Quad {
            InitCommand=function(self) self:setsize(206, 268):xy(0, 296):MaskSource() end,
        }
    }
end

return t