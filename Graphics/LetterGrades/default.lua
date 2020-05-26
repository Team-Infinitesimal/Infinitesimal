local vars = ...

local lgoffset = vars[1];
local superbs = vars[2];
local perfects = vars[3];
local greats = vars[4];
local goods = vars[5];
local bads = vars[6];
local misses = vars[7];
local accuracy = vars[8];

local dP1 = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1):GetPercentDancePoints())*1000000))/10000
local dP2 = (math.floor((STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_2):GetPercentDancePoints())*1000000))/10000
local dancepoints = math.max(dP1,dP2)

local t = Def.ActorFrame {}

if PREFSMAN:GetPreference("AllowW1") == 'AllowW1_Never' then

    t[#t+1] = Def.Sprite {
        InitCommand=function(self)
            self:zoom(0.125):diffusealpha(0):addx(lgoffset);
            self:sleep(2.5);
            if misses == 0 then
                if bads <= 0 then
                    if goods <= 0 then
                        if greats <= 0 then
                            self:Load(THEME:GetPathG("","LetterGrades/Pass3S"));
                        else
                            self:Load(THEME:GetPathG("","LetterGrades/Pass2S"));
                        end;
                    else
                        self:Load(THEME:GetPathG("","LetterGrades/Pass1S"));
                    end;
                else
                    self:Load(THEME:GetPathG("","LetterGrades/Pass1S"));
                end;
            else
                if dancepoints >= 50 then
                    self:Load(THEME:GetPathG("","LetterGrades/PassD"));;
                    if dancepoints >= 60 then
                        self:Load(THEME:GetPathG("","LetterGrades/PassC"));
                        if dancepoints >= 70 then
                            self:Load(THEME:GetPathG("","LetterGrades/PassB"));
                            if dancepoints >= 80 then
                                self:Load(THEME:GetPathG("","LetterGrades/PassA"));
                            end
                        end
                    end
                else
                    self:Load(THEME:GetPathG("","LetterGrades/PassF"));
                end
            end;
            self:accelerate(0.3):diffusealpha(1);
        end;
    };

else

    t[#t+1] = Def.Sprite {
        InitCommand=function(self)
            self:zoom(0.125):diffusealpha(0):addx(lgoffset);
            self:sleep(2.5);
            if misses == 0 then
                if bads <= 0 then
                    if goods <= 0 then
                        if greats <= 0 then
                            if perfects <= 0 then
                                self:Load(THEME:GetPathG("","LetterGrades/Pass3S"));
                            else
                                self:Load(THEME:GetPathG("","LetterGrades/Pass2S"));
                            end;
                        else
                            self:Load(THEME:GetPathG("","LetterGrades/Pass2S"));
                        end;
                    else
                        self:Load(THEME:GetPathG("","LetterGrades/Pass1S"));
                    end;
                else
                    self:Load(THEME:GetPathG("","LetterGrades/Pass1S"));
                end;
            else
                if dancepoints >= 50 then
                    self:Load(THEME:GetPathG("","LetterGrades/PassD"));;
                    if dancepoints >= 60 then
                        self:Load(THEME:GetPathG("","LetterGrades/PassC"));
                        if dancepoints >= 70 then
                            self:Load(THEME:GetPathG("","LetterGrades/PassB"));
                            if dancepoints >= 80 then
                                self:Load(THEME:GetPathG("","LetterGrades/PassA"));
                            end
                        end
                    end
                else
                    self:Load(THEME:GetPathG("","LetterGrades/PassF"));
                end
            end;
            self:accelerate(0.3):diffusealpha(1);
        end;
      };
end;

return t;
