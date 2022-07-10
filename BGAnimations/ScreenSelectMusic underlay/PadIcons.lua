local SongIsChosen = false

local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do

    t[#t+1] = Def.Sprite {
        Name="Pad_"..pn,
        InitCommand=function(self)
            self:zoom(0.4):queuecommand("Refresh")
        end,
        
        SongChosenMessageCommand=function(self)
            SongIsChosen = true
            self:stoptweening():easeoutexpo(0.5)
            :x(307 * (pn == PLAYER_2 and 1 or -1))
            self:playcommand("Refresh")
        end,
        SongUnchosenMessageCommand=function(self)
            SongIsChosen = false
            self:stoptweening():easeoutexpo(0.5):x(0)
        end,
        CurrentChartChangedMessageCommand=function(self) if SongIsChosen then self:playcommand("Refresh") end end,
        
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
