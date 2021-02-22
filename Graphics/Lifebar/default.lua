local args = ...
local pn = args.Player
local needsdouble = args.Double

local dgthreshold = 0.2
local lifebarwidth = needsdouble and 985 or 495

local t = Def.ActorFrame {
	OnCommand=function(self)
		self:zoomy(0.8*0.66):zoomx((340/384)*0.85*0.66)
	end,
	LifeChangedMessageCommand=function(self,params)
		if params.Player == pn then
			local life = params.LifeMeter:GetLife()
			-- lua.ReportScriptError( "Life has changed " .. life )
			self:GetChild("Background"):visible( life > dgthreshold )
			self:GetChild("DangerBar"):visible( life < dgthreshold )

			local Pulsexpos = life*(needsdouble and 1000 or 500)

			if Pulsexpos <= 4 then
				Pulsexpos = 4
			elseif Pulsexpos >= lifebarwidth+3 then
				Pulsexpos = lifebarwidth+3
			end
			
			self:GetChild("Pulse"):x(Pulsexpos-(needsdouble and 540 or 270))
			self:GetChild("Gradient1"):x(Pulsexpos-(needsdouble and 540 or 270))
			self:GetChild("TipHot"):x(Pulsexpos-(needsdouble and 500 or 250)):visible( life > dgthreshold )
			self:GetChild("TipDanger"):x(Pulsexpos-(needsdouble and 500 or 250)):visible( life < dgthreshold )
			
			self:GetChild("Hot"):stoptweening():linear(0.25):diffusealpha( life >= 1 and 1 or 0 )
			if life >= 1 then
				self:GetChild("Gradient2"):cropright(1-life)
			else
				self:GetChild("Gradient2"):cropright(1.075-life)
			end
		end
	end,

	Def.Sprite{
		Texture="mask",
		BeginCommand=function(self) self:x( needsdouble and -561 or -308):zoomx( needsdouble and 1.2 or self:GetZoomX() ):MaskSource() end
	},

	Def.Sprite{
		Texture="Life bar bg ".. (needsdouble and "double" or "single"),
		Name="Background",
		BeginCommand=function(self) self:diffusealpha(0.75):zoomx( needsdouble and 1 or 1.01 ) end,
	},

	Def.Sprite{
		Texture="Bar danger ".. (needsdouble and "double" or "single"),
		Name="DangerBar",
		OnCommand=function(self)
			self:diffuseshift()
			:effectperiod(0.3)
			:effectcolor1(color("#FFFFFF"))
			:effectcolor2(color("#aeaeae"))
			:diffusealpha(0.9)
			:visible(false)
		end
	},

	Def.Sprite{
		Texture="Pulse",
		Name="Pulse",
		BeginCommand=function(self)
			self:zoomto(40,40)
			:blend(Blend.Add)
			:diffuseshift()
			:effectcolor1(1,1,1,1)
			:effectcolor2(1,1,1,0)
			:effectclock("bgm")
			:effecttiming(1,0,0,0)
			:MaskDest()
		end
	},

	Def.Sprite{
		Texture="Blue gradient",
		Name="Gradient1",
		BeginCommand=function(self) self:zoomto(needsdouble and 80 or 40,40):MaskDest() end,
		InitCommand=function(self) self:glowshift():effectperiod(0.6):effectcolor1(1,1,1,0):effectcolor2(1,1,1,1) end,
		OnCommand=function(self) self:bounce():effectmagnitude(-40,0,0):effectclock("bgm"):effecttiming(1,0,0,0) end
	},

	Def.Sprite{
		Texture="Blue gradient",
		Name="Gradient2",
		BeginCommand=function(self) self:zoomto(lifebarwidth,40):ztest(true) end
	},

	Def.Sprite{
		Texture="Bar hot",
		Name="Hot",
		BeginCommand=function(self)
			self:draworder(5):zoomto(lifebarwidth,40):customtexturerect(0,0,.5,1):texcoordvelocity(0.7,0)
			:glowblink()
			:effectperiod(0.05)
			:effectcolor1(1,1,1,0)
			:effectcolor2(1,1,1,.8)
		end
	},

	 --frame
	Def.Sprite{ Texture="Life bar "..(needsdouble and "double" or "single") },

	Def.Sprite{
		Texture="Tip hot",
		Name="TipHot",
		BeginCommand=function(self) self:draworder(5):y(0.5) end
	},

	Def.Sprite{
		Texture="Tip danger",
		Name="TipDanger",
		BeginCommand=function(self) self:draworder(5):y(0.5):visible(false) end
	}
}

return t