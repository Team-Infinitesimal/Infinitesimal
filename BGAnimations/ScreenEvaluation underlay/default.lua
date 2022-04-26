local CenterPressCount = 0
local CenterPress3xEnabled = LoadModule("Config.Load.lua")("EvalCenter3xExit", "Save/OutFoxPrefs.ini")
local AdvScoresShown = false

local GradeZoom = IsUsingWideScreen() and 0.6 or 0.5

local function InputHandler(event)
    local pn = event.PlayerNumber
    local button = event.button

    if not pn then return end
    if event.type == "InputEventType_Repeat" or event.type == "InputEventType_Release" then return end

		if button == "Center" or button == "Start" then
        if CenterPressCount == (CenterPress3xEnabled and 2 or 0) then
            SCREENMAN:set_input_redirected(PLAYER_1, false)
            SCREENMAN:set_input_redirected(PLAYER_2, false)
            SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
        else
            CenterPressCount = CenterPressCount + 1
        end
    elseif button == "Back" then
        SCREENMAN:set_input_redirected(PLAYER_1, false)
        SCREENMAN:set_input_redirected(PLAYER_2, false)
        SCREENMAN:GetTopScreen():Cancel()
    end
    return false
end

local t = Def.ActorFrame {
    LoadActor("EvalLines"),

    -- TODO: Dynamically adjust the Y position relative to the amount of lines on screen?
    LoadActor("EvalSongInfo") .. {
        InitCommand=function(self) self:xy(SCREEN_CENTER_X, 140) end,
    },

    LoadActor("../HudPanels")
}

t[#t+1] = Def.ActorFrame {
	OnCommand=function(self)
        SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
        SCREENMAN:set_input_redirected(PLAYER_1, true)
        SCREENMAN:set_input_redirected(PLAYER_2, true)
		local pn = GAMESTATE:GetMasterPlayerNumber()
		local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
		local StepOrTrails = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(pn) or GAMESTATE:GetCurrentSteps(pn)
		if GAMESTATE:GetCurrentSong() then
            local title = PREFSMAN:GetPreference("ShowNativeLanguage") and GAMESTATE:GetCurrentSong():GetDisplayMainTitle() or GAMESTATE:GetCurrentSong():GetTranslitFullTitle()
			local details = not GAMESTATE:IsCourseMode() and title .. " - " .. SongOrCourse:GetDisplayArtist() or title
			details = string.len(details) < 128 and details or string.sub(details, 1, 124) .. "..."
			local Difficulty = ToEnumShortString(ToEnumShortString((StepOrTrails:GetStepsType()))) .. " " .. StepOrTrails:GetMeter()
			local Percentage = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetPercentDancePoints()
			local states = Difficulty .. " (" .. string.format( "%.2f%%", Percentage*100) .. ")"
			GAMESTATE:UpdateDiscordProfile(GAMESTATE:GetPlayerDisplayName(pn))
			GAMESTATE:UpdateDiscordScreenInfo(details, states, 1)
		end
	end
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
                :diffusealpha(0):sleep(2):easeoutexpo(0.25):zoom(GradeZoom):diffusealpha(1)
            end,
        },

        Def.Sound {
            File=THEME:GetPathS("", "EvalLetterHit"),
            InitCommand=function(self) self:sleep(2):queuecommand("Play") end,
            PlayCommand=function(self) self:play() end,
        }
    }
end

return t
