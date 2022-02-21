local t = Def.ActorFrame {
    LoadActor("EvalLines"),
    
    -- TODO: Dynamically adjust the Y position relative to the amount of lines on screen?
    LoadActor("EvalSongInfo") .. {
        InitCommand=function(self) self:xy(SCREEN_CENTER_X, 140) end,
    },
    
    LoadActor("../HudPanels")
}

for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
    t[#t+1] = Def.ActorFrame {
        LoadActor("../ModIcons", pn) .. {
            InitCommand=function(self)
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT + 40 * 2 or -40 * 2, 160)
                :easeoutexpo(1):x(pn == PLAYER_2 and SCREEN_RIGHT - 40 or 40)
            end,
        },
		
		LoadActor("EvalBall", pn) .. {
			InitCommand=function(self)
				self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 130 or -130), SCREEN_CENTER_Y + 6)
			end,
		},
        
        Def.Sprite {
            InitCommand=function(self)
				local GradeX = IsUsingWideScreen() and 350 or 225
                self:xy(pn == PLAYER_2 and SCREEN_RIGHT - GradeX or GradeX, SCREEN_CENTER_Y + 6)
                
				local PlayerScore = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                local Grade = "FailF"
                Grade = LoadModule("PIU/Score.GradingEval.lua")(PlayerScore)
                
                self:Load(THEME:GetPathG("", "LetterGrades/" .. Grade))
                :diffusealpha(0):sleep(2):easeoutexpo(0.25):zoom(IsUsingWideScreen() and 0.6 or 0.5):diffusealpha(1)
            end
        },
        
        Def.Sound {
            File=THEME:GetPathS("", "EvalLetterHit"),
            InitCommand=function(self) self:sleep(2):queuecommand("Play") end,
            PlayCommand=function(self) self:play() end,
        }
    }
end

return t