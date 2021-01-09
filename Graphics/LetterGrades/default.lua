local vars = ...

local lgoffset = vars[1];
local superbs = vars[2];
local perfects = vars[3];
local greats = vars[4];
local goods = vars[5];
local bads = vars[6];
local misses = vars[7];
local accuracy = vars[8];
local player = vars[9];

local dancepoints = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(player):GetPercentDancePoints())*1000000))/10000

local t = Def.ActorFrame {}

if getenv(pname(player).."Failed") == true then
    lifeState = "Fail"
else
    lifeState = "Pass"
end;

local tripleS = "LetterGrades/"..lifeState.."3S"
local doubleS = "LetterGrades/"..lifeState.."2S"
local singleS = "LetterGrades/"..lifeState.."1S"
local letA = "LetterGrades/"..lifeState.."A"
local letB = "LetterGrades/"..lifeState.."B"
local letC = "LetterGrades/"..lifeState.."C"
local letD = "LetterGrades/"..lifeState.."D"
local letF = "LetterGrades/"..lifeState.."F"

--[[ local tripleS = "LetterGrades/Pass3S"
local doubleS = "LetterGrades/Pass2S"
local singleS = "LetterGrades/Pass1S"
local letA = "LetterGrades/PassA"
local letB = "LetterGrades/PassB"
local letC = "LetterGrades/PassC"
local letD = "LetterGrades/PassD"
local letF = "LetterGrades/PassF" ]]

-- I'm so sorry you have to see this

if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then

    t[#t+1] = Def.Sprite {
        InitCommand=function(self)
            self:zoom(0.8):diffusealpha(0):addx(lgoffset);
            self:sleep(2.5);
            if misses == 0 then
                if bads <= 0 then
                    if goods <= 0 then
                        if greats <= 0 then
                            self:Load(THEME:GetPathG("", ""..tripleS));
                        else
                            self:Load(THEME:GetPathG("", ""..doubleS));
                        end;
                    else
                        self:Load(THEME:GetPathG("", ""..singleS));
                    end;
                else
                    self:Load(THEME:GetPathG("", ""..singleS));
                end;
            else
                if dancepoints >= 50 then
                    self:Load(THEME:GetPathG("", ""..letD));;
                    if dancepoints >= 60 then
                        self:Load(THEME:GetPathG("", ""..letC));
                        if dancepoints >= 70 then
                            self:Load(THEME:GetPathG("", ""..letB));
                            if dancepoints >= 80 then
                                self:Load(THEME:GetPathG("", ""..letA));
                            end
                        end
                    end
                else
                    self:Load(THEME:GetPathG("", ""..letF));
                end
            end;
            self:accelerate(0.3):diffusealpha(1):zoom(0.4);
        end;
    };

else

    t[#t+1] = Def.Sprite {
        InitCommand=function(self)
            self:zoom(0.8):diffusealpha(0):addx(lgoffset);
            self:sleep(2.5);
            if misses == 0 then
                if bads <= 0 then
                    if goods <= 0 then
                        if greats <= 0 then
                            if perfects <= 0 then
                                self:Load(THEME:GetPathG("", ""..tripleS));
                            else
                                self:Load(THEME:GetPathG("", ""..doubleS));
                            end;
                        else
                            self:Load(THEME:GetPathG("", ""..doubleS));
                        end;
                    else
                        self:Load(THEME:GetPathG("", ""..singleS));
                    end;
                else
                    self:Load(THEME:GetPathG("", ""..singleS));
                end;
            else
                if dancepoints >= 50 then
                    self:Load(THEME:GetPathG("", ""..letD));
                    if dancepoints >= 60 then
                        self:Load(THEME:GetPathG("", ""..letC));
                        if dancepoints >= 70 then
                            self:Load(THEME:GetPathG("", ""..letB));
                            if dancepoints >= 80 then
                                self:Load(THEME:GetPathG("", ""..letA));
                            end
                        end
                    end
                else
                    self:Load(THEME:GetPathG("", ""..letF));
                end
            end;
            self:accelerate(0.3):diffusealpha(1):zoom(0.4);
        end;
      };
end;

return t;
