local t = Def.ActorFrame {
    -- Background image
    Def.Sprite {
        InitCommand=function(self)
            local Path = GAMESTATE:GetCurrentSong():GetBackgroundPath()
            if Path and FILEMAN:DoesFileExist(Path) then
				self:Load(Path):scale_or_crop_background():diffusealpha(0.5)
            end
        end
    },
    
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
		}
        
        --[[ No grades for now due to engine limitations/difficulties :(
        Def.Sprite {
            InitCommand=function(self)
                self:xy(SCREEN_CENTER_X + (pn == PLAYER_2 and 200 or -200), SCREEN_CENTER_Y)
                
                local Grade = "FailF"
                local CurPrefTiming = LoadModule("Options.ReturnCurrentTiming.lua")().Name
                local PlayerScore = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                
                if CurPrefTiming == "Pump Normal" or CurPrefTiming == "Pump Hard" or CurPrefTiming == "Pump Very Hard" then
                    Grade = LoadModule("PIU/Score.Grading.lua")(PlayerScore)
                else
                    Grade = LoadModule("PIU/Score.AccGrading.lua")(PlayerScore)
                end
                
                self:Load(THEME:GetPathG("", "LetterGrades/" .. Grade))
                :diffusealpha(0):sleep(2):easeoutexpo(0.25):zoom(0.6):diffusealpha(1)
            end
        },]]
    }
end

return t