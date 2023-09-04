local CurPrefTiming = LoadModule("Options.ReturnCurrentTiming.lua")().Name
local Scoring = LoadModule("Config.Load.lua")("ScoringSystem", "Save/OutFoxPrefs.ini") or "Old"
local Name, Length = LoadModule("Options.SmartTapNoteScore.lua")()
table.sort(Name)
Name[#Name+1] = "Miss"
Name[#Name+1] = "MaxCombo"
Name[#Name+1] = "Accuracy"
Name[#Name+1] = "Score"
Length = Length + 4

local RowAmount = Length
local RowH = 40
local RowX = IsUsingWideScreen() and 490 or 400
local RowY = SCREEN_CENTER_Y - (RowAmount * RowH) / 2

-- And a function to make even better use out of the table.
local function GetJLineValue(line, pl)
    local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl)
    if line == "W1" then
        return PSS:GetTapNoteScores("TapNoteScore_W1") + PSS:GetTapNoteScores("TapNoteScore_CheckpointHit")
    elseif line == "Miss" then
        return PSS:GetTapNoteScores("TapNoteScore_Miss") + PSS:GetTapNoteScores("TapNoteScore_CheckpointMiss")
    elseif line == "MaxCombo" then
        return PSS:MaxCombo()
    elseif line == "Accuracy" then
        return round(PSS:GetPercentDancePoints() * 100, 2) .. "%"
    elseif line == "Score" then -- jank
        local PSS_Score = PSS:GetScore()
        local PrevHighScore = nil

        ProfileScores = PROFILEMAN:GetProfile(pl):GetHighScoreList(GAMESTATE:GetCurrentSong(), GAMESTATE:GetCurrentSteps(pl)):GetHighScores()
        if ProfileScores[1] ~= nil then
            PrevHighScore = ProfileScores[1]:GetScore()
        end

        if PROFILEMAN:GetProfile(pl) and PrevHighScore and PSS_Score > PrevHighScore then
            local ScoreUp = string.format("[+%s]", (Scoring == "New" and FormatScore((PSS_Score - PrevHighScore)) or (PSS_Score - PrevHighScore)))
            return string.format("%d %s", (Scoring == "New" and FormatScore(PSS_Score) or PSS_Score), ScoreUp)
        end
        
        return (Scoring == "New" and FormatScore(PSS_Score) or PSS_Score)
    else
        return PSS:GetTapNoteScores("TapNoteScore_" .. line)
    end
    return "???"
end

-- Used for displying the additional score on a new personal best in another colour
local function ColourHighScoreCount(child)
    local str = child:GetText()
    local charindex = 0
    local ColoringProcess = {}

    for k in string.gmatch(str, "(%g+)") do
        for m in string.gmatch(k, "%[(.-)%]") do
            ColoringProcess[#ColoringProcess+1] = {
                Start = charindex > 1 and charindex + 1 or 0,
                Attr = {
                    Diffuse = color("#1fbcff"),
                    Length = m:len()
                }
            }
        end
        charindex = charindex + k:len()
    end
    child:settext(str:gsub("%[",""):gsub("%]",""))
    for k,v in pairs(ColoringProcess) do
        child:AddAttribute(v.Start, v.Attr)
    end
end

local t = Def.ActorFrame {}

-- We want the row lines to stay behind the main column, so we create them first
for i = 1, RowAmount do
    t[#t+1] = Def.ActorFrame {
        Def.Sprite {
            Texture=THEME:GetPathG("", "Evaluation/EvalRow"),
            InitCommand=function(self)
                self:xy(SCREEN_CENTER_X, RowY + RowH * (i - 1) + 24):zoom(0.8)
            end
        }
    }
end

-- Step artists will also stay behind the main column, this looks a bit ugly but works
t[#t+1] = Def.ActorFrame {
    Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, RowY + RowH * RowAmount + 20)
        end,

        Def.Sprite {
            Texture=THEME:GetPathG("", "Evaluation/StepArtistP1"),
            InitCommand=function(self)
                self:x(-140):halign(1):valign(0):zoom(0.75)
                :visible(GAMESTATE:IsSideJoined(PLAYER_1))
            end
        },

        Def.Quad {
            InitCommand=function(self)
                self:xy(-138, RowH):halign(1):valign(0):zoomto(192, 26)
                :diffuse(Color.Black):diffusealpha(0.5):fadeleft(0.5)
                :visible(GAMESTATE:IsSideJoined(PLAYER_1))
            end
        },

        Def.BitmapText {
            Font="Montserrat semibold 40px",
            Text=GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit() ~= "" and GAMESTATE:GetCurrentSteps(PLAYER_1):GetAuthorCredit() or "Unknown",
            InitCommand=function(self)
                self:xy(-146, RowH + 4):halign(1):valign(0):shadowlength(1)
                :zoom(0.6):visible(GAMESTATE:IsSideJoined(PLAYER_1))
            end
        },

        Def.Sprite {
            Texture=THEME:GetPathG("", "Evaluation/StepArtistP2"),
            InitCommand=function(self)
                self:x(140):halign(0):valign(0):zoom(0.75)
                :visible(GAMESTATE:IsSideJoined(PLAYER_2))
            end
        },

        Def.Quad {
            InitCommand=function(self)
                self:xy(138, RowH):halign(0):valign(0):zoomto(192, 26)
                :diffuse(Color.Black):diffusealpha(0.5):faderight(0.5)
                :visible(GAMESTATE:IsSideJoined(PLAYER_2))
            end
        },

        Def.BitmapText {
            Font="Montserrat semibold 40px",
            Text=GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit() ~= "" and GAMESTATE:GetCurrentSteps(PLAYER_2):GetAuthorCredit() or "Unknown",
            InitCommand=function(self)
                self:xy(146, RowH + 4):halign(0):valign(0):shadowlength(1)
                :zoom(0.6):visible(GAMESTATE:IsSideJoined(PLAYER_2))
            end
        }
    },

    Def.Sprite {
        Texture=THEME:GetPathG("", "Evaluation/EvalColumn"),
        InitCommand=function(self)
            self:Center()
        end
    }
}

-- Separation lines between the center column text
for i = 1, RowAmount + 1 do
    t[#t+1] = Def.ActorFrame {
        Def.Quad {
            InitCommand=function(self)
                self:xy(SCREEN_CENTER_X, RowY + RowH * (i - 1) + 24 - (RowH / 2))
                :zoomto(150 + math.sin(math.abs(self:GetY() - SCREEN_CENTER_Y) / SCREEN_CENTER_Y) * 60, 2)
                :diffuse(RowAmount == 9 and color("#FFA4FF") or color("#99D3FF"))
                :fadeleft(0.1):faderight(0.1)
            end
        }
    }
end

for i = 1, RowAmount do
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, RowY + RowH * (i - 1) + 24)
            :diffusealpha(0):sleep(0.5 + i * 0.1):linear(0.1):diffusealpha(1)
        end,
        Def.BitmapText {
            Font="Montserrat normal 40px",
            InitCommand=function(self)
                self:maxwidth(360):skewx(-0.2):zoom(0.75):visible(true)

                if Name[i] == "Accuracy" or Name[i] == "Score" then
                    self:settext(ToUpper(THEME:GetString("EvaluationLabel", Name[i])))
                else
                    self:settext(ToUpper(THEME:GetString(CurPrefTiming or "Original" , "Judgment" .. Name[i])))
                end
            end
        },

        Def.BitmapText {
            Font="Montserrat numbers 40px",
            Text=string.rep("0",3-string.len(GetJLineValue(Name[i], PLAYER_1)))..GetJLineValue(Name[i], PLAYER_1),
            InitCommand=function(self)
                self:x(-RowX):shadowlength(1):zoom(0.8)
                :halign(0):maxwidth(360):visible(GAMESTATE:IsSideJoined(PLAYER_1))
				if Name[i] ~= "Score" and Name[i] ~= "Accuracy" then
					self:AddAttribute(0, { Length = math.max(3-string.len(GetJLineValue(Name[i], PLAYER_1)), 0) ; Diffuse = color("#FFFFFF88"); })
                end
				if Name[i] == "Score" then
                    ColourHighScoreCount(self)
                end
            end
        },

        Def.BitmapText {
            Font="Montserrat numbers 40px",
            Text=string.rep("0",3-string.len(GetJLineValue(Name[i], PLAYER_2)))..GetJLineValue(Name[i], PLAYER_2),
            InitCommand=function(self)
                self:x(RowX):shadowlength(1):zoom(0.8)
                :halign(1):maxwidth(360):visible(GAMESTATE:IsSideJoined(PLAYER_2))
                if Name[i] ~= "Score" and Name[i] ~= "Accuracy" then
						self:AddAttribute(0, { Length = math.max(3-string.len(GetJLineValue(Name[i], PLAYER_2)), 0) ; Diffuse = color("#FFFFFF88"); })
                end
				if Name[i] == "Score" then
                    ColourHighScoreCount(self)
                end
            end
        }
    }
end

for pn in ivalues(GAMESTATE:GetEnabledPlayers()) do
    if STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):IsDisqualified() then
        t[#t+1] = Def.BitmapText {
            Font="Montserrat semibold 20px",
            Text="Disqualified",
            InitCommand=function(self)
                self:diffuse(1,1,1,1):valign(1)
                :xy((pn == PLAYER_1 and (SCREEN_LEFT + 10) or (SCREEN_RIGHT - 10)), SCREEN_BOTTOM - 90)
                :halign((pn == PLAYER_1 and 0 or 1))
            end
        }
    end
end

return t
