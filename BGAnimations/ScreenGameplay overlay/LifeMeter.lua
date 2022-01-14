local pn = ...

local BarW = math.ceil(GAMESTATE:GetCurrentStyle():GetWidth(pn) * 1.5 + 8)
local BarH = 30

local MeterHot = false
local SongPos = GAMESTATE:GetPlayerState(pn):GetSongPosition()
local MeterActor
local MeterUpdate = function(self)
	if not MeterActor then return end
	local MeterVelocity = -(SongPos:GetCurBPS() * 0.5)
	if SongPos:GetFreeze() or SongPos:GetDelay() then MeterVelocity = 0 end
	MeterActor:texcoordvelocity(MeterVelocity, 0)
end

local IsReverse = GAMESTATE:GetPlayerState(pn):GetCurrentPlayerOptions():Reverse() > 0

local t = Def.ActorFrame {
	InitCommand=function(self) self:SetUpdateFunction(MeterUpdate):addy(IsReverse and 100 or -100) end,
	OnCommand=function(self) self:sleep(0.5):easeoutexpo(0.5):addy(IsReverse and -100 or 100) end,
    OffCommand=function(self) self:easeinexpo(1):addy(IsReverse and 100 or -100) end,

    Def.Sprite {
        Name="Avatar",
		Texture=LoadModule("Options.GetProfileData.lua")(pn)["Image"],
		InitCommand=function(self)
			self:scaletofit(0, 0, 30, 30)
			:xy(pn == PLAYER_1 and -BarW / 2 - 15 or BarW / 2 + 15, 0)
		end
	},

	Def.Quad {
		Name="Background",
		InitCommand=function(self)
			self:zoomto(BarW, BarH)
      :diffuse(color("#353535"))
			:diffusebottomedge(color("#5f5f5f"))
		end
	},

	Def.Quad {
		Name="Meter",
		InitCommand=function(self)
			self:zoomto(BarW - 12, BarH - 12)
			:cropright(0.5)
		end,
		LifeChangedMessageCommand=function(self, params)
			if params.Player == pn then
				local LifeAmount = params.LifeMeter:GetLife()

				self:diffusetopedge(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
				:diffusebottomedge(pn == PLAYER_1 and (LifeAmount < 0.33 and Color.Red or color("#ed1e79")) or (LifeAmount < 0.33 and Color.Red or color("#1fbcff")))
				--self:diffuse(LifeAmount < 0.33 and Color.Red or color(0,0,0,0))
				:cropright(1 - LifeAmount)
			end
		end
	},

	Def.Quad {
		Name="PulseMask",
		InitCommand=function(self)
			self:zoomto(BarW - 12, BarH - 12)
			:diffuse(color(1,1,1,1))
			:MaskSource()
		end
	},

	Def.Quad {
		Name="Pulse",
		InitCommand=function(self)
			self:zoomto(20, BarH - 12):halign(0)
			self:bounce():effectmagnitude(20,0,0):effectclock("bgm"):effecttiming(0,0,1,0)
			self:MaskDest():ztestmode("ZTestMode_WriteOnFail")
		end,
		LifeChangedMessageCommand=function(self, params)
			if params.Player == pn then
				local LifeAmount = params.LifeMeter:GetLife()
				if LifeAmount > 0 and LifeAmount < 1 then
					self:visible(true)
					:diffusetopedge(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
					:diffusebottomedge(pn == PLAYER_1 and (LifeAmount < 0.33 and Color.Red or color("#ed1e79")) or (LifeAmount < 0.33 and Color.Red or color("#1fbcff")))

					self:x(-((BarW / 2) - ((BarW - 12) * LifeAmount)) - 15)
				else
					self:visible(false)
				end
			end
		end
	},

	Def.Quad {
		Name="RainbowMeter",
		InitCommand=function(self)
			self:zoomto(BarW - 12, BarH - 12)
			:rainbow()
			:texcoordvelocity(-0.5, 0)
      :diffusealpha(0)
		end,
		LifeChangedMessageCommand=function(self, params)
			if params.Player == pn then
				local LifeAmount = params.LifeMeter:GetLife()

                if LifeAmount >= 1 and not MeterHot then
                    self:diffusealpha(1)
                    MeterHot = true
                elseif LifeAmount < 1 and MeterHot then
                    self:diffusealpha(0)
                    MeterHot = false
                end
			end
		end
	},

    --[[
    Def.Quad {
		Name="MeterPulse",
        Texture="InsertPulseTextureHere",
		InitCommand=function(self)
			MeterActor = self
			self:zoomto(BarW - 12, BarH - 12)
			:cropright(0.5)
		end,
		LifeChangedMessageCommand=function(self, params)
			if params.Player == pn then
				local LifeAmount = params.LifeMeter:GetLife()

				self:cropright(1 - LifeAmount)
			end
		end
	},
    ]]

		Def.BitmapText{
			Font="Montserrat semibold 20px",
			InitCommand=function(self)
				self:zoom(0.9):x(-175):skewx(-0.2):halign(0):diffuse(1,1,1,1)
				self:playcommand("Refresh")
			end,
			OnCommand=function(self)self:playcommand("Refresh")end,
			JudgmentMessageCommand=function(self)self:playcommand("Refresh")end,
			RefreshCommand=function(self)
				if ScoreDisplay then
					local PSS = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
					self:settext(PSS:GetScore())
				end
			end
		},

	Def.SongMeterDisplay {
		InitCommand=function(self)
            self:SetStreamWidth(BarW):y(-(BarH / 2) - 1)
        end,
        Stream=Def.Quad {
            InitCommand=function(self) self:zoomto(384, 2):diffuse(Color.Yellow) end
        }
	}
}

return t
