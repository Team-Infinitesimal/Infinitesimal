local PanelX, PanelY = ...

local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {
        Def.ActorFrame {
            InitCommand=function(self)
                self:xy(PanelX, PanelY)
            end,
            SongChosenMessageCommand=function(self) 
                self:stoptweening():easeoutexpo(0.5):x(PanelX - (pn == PLAYER_2 and -380 or 380))
            end,
            SongUnchosenMessageCommand=function(self) 
                self:stoptweening():easeoutexpo(0.5):x(PanelX)
            end,
            
            ["CurrentSteps" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(self) self:playcommand("Refresh") end,
            RefreshCommand=function(self)
                -- Personal best score
                if PROFILEMAN:IsPersistentProfile(pn) then
					CurProfile = PROFILEMAN:GetProfile(pn)
					CurSong = GAMESTATE:GetCurrentSong()
					CurChart = GAMESTATE:GetCurrentSteps(pn)

					if CurProfile and CurSong and CurChart then
						CurProfileCardList = CurProfile:GetHighScoreList(CurSong, CurChart)
						CurProfileScores = CurProfileCardList:GetHighScores()

						if CurProfileScores[1] ~= nil then
                            self:GetChild("PersonalGrade"):Load(THEME:GetPathG("", "LetterGrades/" .. 
                                LoadModule("PIU/Score.Grading.lua")(CurProfileScores[1])))
                            self:GetChild("PersonalScore"):settext(CurProfileScores[1]:GetScore())
                        else
                            self:GetChild("PersonalGrade"):Load(nil)
                            self:GetChild("PersonalScore"):settext("")
                        end
                    else
                        self:GetChild("PersonalGrade"):Load(nil)
                        self:GetChild("PersonalScore"):settext("")
                    end
                else
                    self:GetChild("PersonalGrade"):Load(nil)
                    self:GetChild("PersonalScore"):settext("")
                end
            end,
                
            Def.Sprite {
                Texture=THEME:GetPathG("", "UI/ScoreDisplay"),
                InitCommand=function(self)
                    self:xy(0, 0):zoom(0.75)
                end,
            },
            
            Def.Sprite {
                Name="PersonalGrade",
                Texture=THEME:GetPathG("", "LetterGrades/FailF"),
                InitCommand=function(self)
                    self:xy(-50, -43):zoom(0.2)
                end,
            },
            
            Def.BitmapText {
                Name="PersonalScore",
                Font="Common normal",
                InitCommand=function(self)
                    self:xy(80, -20):zoom(1)
                    :halign(1):valign(1)
                    :diffuse(Color.Black)
                end,
            },
            
            Def.Sprite {
                Name="MachineGrade",
                Texture=THEME:GetPathG("", "LetterGrades/FailF"),
                InitCommand=function(self)
                    self:xy(-50, 43):zoom(0.2)
                end,
            },
        }
    }
end

return t