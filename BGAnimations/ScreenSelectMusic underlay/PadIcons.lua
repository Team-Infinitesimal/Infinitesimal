local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do

    t[#t+1] = Def.Sprite {
        Name="Pad_"..pn,
        InitCommand=function(self)
            self:zoom(0.3):xy((pn == PLAYER_1 and -243.5 or 243.5), 0)
            :queuecommand("Refresh")
        end,
        SongChosenMessageCommand=function(self) self:stoptweening():easeoutexpo(0.25):y(-55):diffusealpha(1) end,
        SongUnchosenMessageCommand=function(self) self:stoptweening():y(0) end,
        StepsChosenMessageCommand=function(self, params)
            if params.Player == pn then
                self:stoptweening():linear(0.125):diffusealpha(0)
            end
        end,
        CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
        CurrentStepsP2ChangedMessageCommand=function(self) self:queuecommand("Refresh") end,
        RefreshCommand=function(self)
            local StepsType = ToEnumShortString(ToEnumShortString(GAMESTATE:GetCurrentSteps(pn):GetStepsType()))
            if StepsType == "Single" then
                self:Load(THEME:GetPathG("", string.format("UI/PadIcons/p%ssingle", (pn == PLAYER_1 and 1 or 2))))
            elseif StepsType == "Halfdouble" then
                self:Load(THEME:GetPathG("", "UI/PadIcons/halfdouble"))
            elseif StepsType == "Double" then
                self:Load(THEME:GetPathG("", "UI/PadIcons/double"))
            end
        end
    }

end

return t
