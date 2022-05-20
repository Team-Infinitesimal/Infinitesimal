t = Def.ActorFrame {}

local isSelectingDifficulty = false

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do

    -- Larger stationary difficulty icons
    t[#t+1] = Def.ActorFrame {
        Name="BigPreviewBallContainer",

    CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
    SongChosenMessageCommand=function(self) isSelectingDifficulty = true self:playcommand("Refresh") end,
    SongUnchosenMessageCommand=function(self) isSelectingDifficulty = false self:playcommand("Refresh") end,

    RefreshCommand=function(self)
      if isSelectingDifficulty then
        local Chart = GAMESTATE:GetCurrentSteps(pn)
        local ChartMeter = Chart:GetMeter()
        if ChartMeter == 99 then ChartMeter = "??" end
        self:GetChild("BigPreviewBallContainer_"..pn):GetChild("BigPreviewBall"):diffuse(ChartTypeToColor(Chart))
        self:GetChild("BigPreviewBallContainer_"..pn):GetChild("MeterText"):settext(ChartMeter)
      end
    end,

    Def.ActorFrame {
      Name="BigPreviewBallContainer_"..pn,

      InitCommand=function(self)
        self:zoom(2)
        :xy(pn == PLAYER_1 and -350 or 350, 135)
      end,

      OnCommand=function(self)
        self:diffusealpha(0)
      end,

      SongChosenMessageCommand=function(self)
        self:stoptweening()
        :easeoutexpo(0.5)
        :diffusealpha(1)
        :x(pn == PLAYER_1 and -375 or 375)
      end,

      SongUnchosenMessageCommand=function(self)
        self:stoptweening()
        :easeoutexpo(0.25)
        :diffusealpha(0)
        :x(pn == PLAYER_1 and -350 or 350)
      end,

        Def.Sprite {
            Texture=THEME:GetPathG("", "DifficultyDisplay/Ball"),
            Name="BigPreviewBall"
        },

      Def.Sprite {
        Texture=THEME:GetPathG("", "DifficultyDisplay/Trim"),
        Name="PreviewBallTrim"
      },

      Def.BitmapText {
        Font="Montserrat numbers 40px",
        Name="MeterText",
        InitCommand=function(self)
          self:zoom(0.6)
        end
      }
    }
    }

end

return t
