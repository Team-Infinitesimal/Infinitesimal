local CurPrefTiming = LoadModule("Options.ReturnCurrentTiming.lua")().Name
local Name,Length = LoadModule("Options.SmartTapNoteScore.lua")()
table.sort(Name)
Name[#Name+1] = "Miss"
Name[#Name+1] = "MaxCombo"
Name[#Name+1] = "Accuracy"
Name[#Name+1] = "Score"
Length = Length + 4

local RowAmount = Length
local RowH = 40
local RowX = IsUsingWideScreen() and 150 or 100
local RowY = SCREEN_CENTER_Y - (RowAmount * RowH) / 2

-- And a function to make even better use out of the table.
local function GetJLineValue(line, pl)
    local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pl)
	if line == "W1" then
		return PSS:GetTapNoteScores("TapNoteScore_W1") + PSS:GetTapNoteScores("TapNoteScore_CheckpointHit")
	elseif line == "MaxCombo" then
		return PSS:MaxCombo()
    elseif line == "Accuracy" then
		return round(PSS:GetPercentDancePoints() * 100, 2) .. "%"
    elseif line == "Score" then
		return PSS:GetScore()
	else
		return PSS:GetTapNoteScores("TapNoteScore_" .. line)
	end
	return "???"
end

local t = Def.ActorFrame {}

-- We want the row lines to stay behind the main column 
for i = 1, RowAmount do
    t[#t+1] = Def.ActorFrame {
        Def.Sprite {
            Name="RowGraphic",
            Texture=THEME:GetPathG("", "Evaluation/EvalRow"),
            InitCommand=function(self) 
                self:xy(SCREEN_CENTER_X, RowY + RowH * (i - 1))
                :valign(0):zoom(0.8)
            end
        }
    }
end

t[#t+1] = Def.ActorFrame {
    Def.Sprite {
        Name="ColumnGraphic",
        Texture=THEME:GetPathG("", "Evaluation/EvalColumn"),
        InitCommand=function(self)
            self:Center()
        end
    }
}

for i = 1, RowAmount do
    t[#t+1] = Def.ActorFrame {
        InitCommand=function(self) self:diffusealpha(0):sleep(0.5 + i * 0.1):linear(0.1):diffusealpha(1) end,
        Def.BitmapText {
            Name="RowLabel",
            Font="Montserrat normal 40px",
            InitCommand=function(self)
                self:xy(SCREEN_CENTER_X, RowY + RowH * (i - 1) + 15)
                :valign(0):maxwidth(360):skewx(-0.2):zoom(0.75):visible(true)
                
                if Name[i] == "Accuracy" or Name[i] == "Score" then
                    self:settext(ToUpper(THEME:GetString("EvaluationLabel", Name[i])))
                else
                    self:settext(ToUpper(THEME:GetString(CurPrefTiming or "Original" , "Judgment" .. Name[i])))
                end
            end
        },
        
        Def.BitmapText {
            Name="RowTextP1",
            Font="Montserrat semibold 40px",
            Text=GetJLineValue(Name[i], PLAYER_1),
            InitCommand=function(self)
                self:xy(RowX, RowY + RowH * (i - 1) + 15):shadowlength(1):zoom(0.8)
                :halign(0):valign(0):maxwidth(360):visible(GAMESTATE:IsSideJoined(PLAYER_1))
            end
        },
        
        Def.BitmapText {
            Name="RowTextP2",
            Font="Montserrat semibold 40px",
            Text=GetJLineValue(Name[i], PLAYER_2),
            InitCommand=function(self)
                self:xy(SCREEN_RIGHT - RowX, RowY + RowH * (i - 1) + 15):shadowlength(1):zoom(0.8)
                :halign(0):valign(0):maxwidth(360):visible(GAMESTATE:IsSideJoined(PLAYER_2))
            end
        }
    }
end

return t