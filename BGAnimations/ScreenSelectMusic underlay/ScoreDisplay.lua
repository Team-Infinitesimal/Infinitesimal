local t = Def.ActorFrame {}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    -- Player 2's panel is slightly adjusted, so we need to correct
    -- the positioning of actors so that they fit in properly
    local CorrectionX = pn == PLAYER_2 and -15 or 0
    
    t[#t+1] = Def.ActorFrame {
        Def.ActorFrame {
            SongChosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.5)
                :x(358 * (pn == PLAYER_2 and 1 or -1))
            end,
            SongUnchosenMessageCommand=function(self)
                self:stoptweening():easeoutexpo(0.5):x(0)
            end,

            ["CurrentSteps" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(self) self:playcommand("Refresh") end,
            RefreshCommand=function(self)
                Song = GAMESTATE:GetCurrentSong()
                Chart = GAMESTATE:GetCurrentSteps(pn)

                -- Personal best score
                if PROFILEMAN:IsPersistentProfile(pn) then
                    ProfileScores = PROFILEMAN:GetProfile(pn):GetHighScoreList(Song, Chart):GetHighScores()

                    if ProfileScores[1] ~= nil then
                        local ProfileScore = ProfileScores[1]:GetScore()
                        local ProfileDP = round(ProfileScores[1]:GetPercentDP() * 100, 2) .. "%"
                        local ProfileName = ProfileScores[1]:GetName()

                        self:GetChild("PersonalGrade"):Load(THEME:GetPathG("", "LetterGrades/" ..
                            LoadModule("PIU/Score.Grading.lua")(ProfileScores[1])))
                        self:GetChild("PersonalScore"):settext(ProfileName .. "\n" .. ProfileDP .. "\n" .. ProfileScore)
                    else
                        self:GetChild("PersonalGrade"):Load(nil)
                        self:GetChild("PersonalScore"):settext("")
                    end
                else
                    self:GetChild("PersonalGrade"):Load(nil)
                    self:GetChild("PersonalScore"):settext("")
                end

                -- Machine best score
                local MachineHighScores = PROFILEMAN:GetMachineProfile():GetHighScoreList(Song, Chart):GetHighScores()
                if MachineHighScores[1] ~= nil then
                    local MachineScore = MachineHighScores[1]:GetScore()
                    local MachineDP = round(MachineHighScores[1]:GetPercentDP() * 100, 2) .. "%"
                    local MachineName = MachineHighScores[1]:GetName()

                    self:GetChild("MachineGrade"):Load(THEME:GetPathG("", "LetterGrades/" ..
                            LoadModule("PIU/Score.Grading.lua")(MachineHighScores[1])))
                    self:GetChild("MachineScore"):settext(MachineName .. "\n" .. MachineDP .. "\n" .. MachineScore)
                else
                    self:GetChild("MachineGrade"):Load(nil)
                    self:GetChild("MachineScore"):settext("")
                end
            end,

            Def.Sprite {
                -- Texture=THEME:GetPathG("", "UI/ScoreDisplay"),
                InitCommand=function(self)
                    self:Load(THEME:GetPathG("", "UI/ScoreDisplay" .. ToEnumShortString(pn)))
                    self:xy(0, 0):zoom(0.75)
                end,
            },
            
            Def.Sprite {
                Name="PersonalGrade",
                Texture=THEME:GetPathG("", "LetterGrades/FailF"),
                InitCommand=function(self)
                    self:xy(-40 + CorrectionX, -35):zoom(0.2)
                end,
            },

            Def.BitmapText {
                Name="PersonalScore",
                Font="Common normal",
                InitCommand=function(self)
                    self:xy(90 + CorrectionX, -35):zoom(1):halign(1)
                    :diffuse(Color.White):vertspacing(-6)
                end,
            },
            
            Def.Sprite {
                Name="MachineGrade",
                Texture=THEME:GetPathG("", "LetterGrades/FailF"),
                InitCommand=function(self)
                    self:xy(-40 + CorrectionX, 60):zoom(0.2)
                end,
            },

            Def.BitmapText {
                Name="MachineScore",
                Font="Common normal",
                InitCommand=function(self)
                    self:xy(90 + CorrectionX, 60):zoom(1):halign(1)
                    :diffuse(Color.White):vertspacing(-6)
                end,
            },
        }
    }
end

return t
