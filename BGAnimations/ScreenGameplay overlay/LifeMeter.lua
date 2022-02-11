local pn = ...

local BarW = math.ceil(GAMESTATE:GetCurrentStyle():GetWidth(pn) * 1.5)
local BarH = 30

local MeterHot = false
local MeterDanger = false
local MeterFail = false

local SongPos = GAMESTATE:GetPlayerState(pn):GetSongPosition()
local MeterActor
local MeterUpdate = function(self)
	if not MeterActor then return end
	local MeterVelocity = -(SongPos:GetCurBPS() * 0.5)
	if SongPos:GetFreeze() or SongPos:GetDelay() then MeterVelocity = 0 end
	MeterActor:texcoordvelocity(MeterVelocity, 0)
end

local IsReverse = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():Reverse() > 0
local ScoreDisplay = LoadModule("Config.Load.lua")("ScoreDisplay", CheckIfUserOrMachineProfile(string.sub(pn, -1) - 1).."/OutFoxPrefs.ini")
local SongProgress = LoadModule("Config.Load.lua")("SongProgress", CheckIfUserOrMachineProfile(string.sub(pn, -1) - 1).."/OutFoxPrefs.ini")

local t = Def.ActorFrame {
	InitCommand=function(self) self:SetUpdateFunction(MeterUpdate):addy(IsReverse and 100 or -100) end,
	OnCommand=function(self) self:easeoutexpo(1):addy(IsReverse and -100 or 100) end,
    
    LifeChangedMessageCommand=function(self, params)
        if params.Player == pn then
            local LifeAmount = params.LifeMeter:GetLife()
            self:GetChild("Meter"):stoptweening():x(MeterHot and 0 or -20):linear(0.1):cropright(1 - LifeAmount)
            self:GetChild("Pulse"):stoptweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * LifeAmount)) - 20)

            if LifeAmount <= 0.33 and not MeterDanger then
                self:GetChild("BarBody"):diffusebottomedge(Color.Red)
                self:GetChild("BarEdgeL"):diffusebottomedge(Color.Red)
                self:GetChild("BarEdgeR"):diffusetopedge(Color.Red) -- This one is flipped :)
                MeterDanger = true
            elseif LifeAmount > 0.33 and MeterDanger and not MeterFail then
                self:GetChild("BarBody"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
                self:GetChild("BarEdgeL"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
                self:GetChild("BarEdgeR"):stoptweening():linear(0.5):diffusetopedge(Color.White)
                MeterDanger = false
            end
            
            if LifeAmount >= 1 and not MeterHot then
                self:GetChild("RainbowMeter"):stoptweening():linear(0.5):diffusealpha(1)
                MeterHot = true
            elseif LifeAmount < 1 and MeterHot then
                self:GetChild("RainbowMeter"):diffusealpha(0)
                MeterHot = false
            end
            
            local PlayerOptions = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
            if LifeAmount <= 0 and not MeterFail then
                self:GetChild("Pulse"):visible(false)
                MeterFail = true
            elseif LifeAmount > 0 and MeterFail and (PlayerOptions:FailSetting() == "FailType_Off") then
                self:GetChild("Pulse"):visible(true)
                MeterFail = false
            end
        end
    end,

    Def.Sprite {
        Name="Avatar",
		Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
		InitCommand=function(self)
			self:scaletofit(0, 0, 30, 30)
			:xy(pn == PLAYER_1 and -BarW / 2 - 15 or BarW / 2 + 15, 0)
		end
	},

	Def.Sprite {
		Name="BarBody",
        Texture=THEME:GetPathG("", "UI/BarBody"),
		InitCommand=function(self)
			self:setsize(BarW - 12, BarH)
		end
	},
    
    Def.Sprite {
		Name="BarEdgeL",
        Texture=THEME:GetPathG("", "UI/BarEdge"),
		InitCommand=function(self)
			self:x(-BarW / 2):halign(0)
		end
	},
    
    Def.Sprite {
		Name="BarEdgeR",
        Texture=THEME:GetPathG("", "UI/BarEdge"),
		InitCommand=function(self)
			self:x(BarW / 2):halign(0):rotationz(180)
		end
	},
    
    Def.Quad {
		Name="Mask",
		InitCommand=function(self)
			self:zoomto(BarW - 12, BarH - 12)
			:diffuse(color(1,1,1,1))
			:MaskSource()
		end
	},

	Def.Quad {
		Name="Meter",
		InitCommand=function(self)
			self:zoomto(BarW - 12, BarH - 12):x(-20):cropright(0.5)
            :diffuse(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
            :diffusebottomedge(pn == PLAYER_1 and color("#ed1e79") or color("#1fbcff"))
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
		end
	},

	Def.Quad {
		Name="Pulse",
		InitCommand=function(self)
			self:zoomto(20, BarH - 12):halign(0)
            :diffuse(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
            :diffusebottomedge(pn == PLAYER_1 and color("#ed1e79") or color("#1fbcff"))
            
			self:bounce():effectmagnitude(-20,0,0):effectclock("bgm"):effecttiming(1,0,0,0)
			:MaskDest():ztestmode("ZTestMode_WriteOnFail")
		end
	},

	Def.Sprite {
		Name="RainbowMeter",
        Texture=THEME:GetPathG("", "UI/RainbowBar"),
		InitCommand=function(self)
			self:zoomto(BarW - 12, BarH - 12)
			:texcoordvelocity(-0.5, 0)
            :diffusealpha(0)
		end
	},
    
    Def.BitmapText{
        Font="Montserrat semibold 20px",
        InitCommand=function(self)
            self:x(BarW / 2 - 10):zoom(0.8):skewx(-0.2):halign(1)
            :diffuse(Color.Yellow):shadowlength(1):playcommand("Refresh")
        end,
        JudgmentMessageCommand=function(self)
            if ScoreDisplay == "Percent" then
                local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
                local TotalAcc = PSS:GetCurrentPossibleDancePoints()
                local CurrentAcc = PSS:GetActualDancePoints()
                
                if TotalAcc ~= 0 then
                    self:settext(math.floor(CurrentAcc / TotalAcc * 10000) / 100 .. "%")
                else
                    self:settext("0%")
                end
            end
        end,
        UpdateScoreMessageCommand=function(self, params)
            if ScoreDisplay == "Score" then
                self:settext(params.Score or 0)
            end
        end
    }
}

if LoadModule("Config.Load.lua")("SongProgress", CheckIfUserOrMachineProfile(string.sub(pn, -1) - 1).."/OutFoxPrefs.ini") then
    t[#t+1] = Def.ActorFrame {
        Def.SongMeterDisplay {
            InitCommand=function(self)
                self:SetStreamWidth(BarW - 12):y(-(BarH / 2) - 1)
            end,
            Stream=Def.Quad {
                InitCommand=function(self) self:zoomto(384, 2):diffuse(Color.Yellow) end
            }
        }
    }
end

return t
