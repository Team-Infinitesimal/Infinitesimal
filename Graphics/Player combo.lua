local c
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = THEME:GetMetric("Combo", "PulseCommand")
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand")

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom")
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom")

local t = Def.ActorFrame {

	Def.BitmapText {
		Font="Combo numbers",
		Name="Number",
		OnCommand = function(self) self:valign(0):y(-20) end,
		ComboCommand=function(self, params)
            self:diffuse(params.Misses and Color.Red or Color.White)
		end
	},

	Def.Sprite {
		Texture="ComboLabel",
		Name="ComboLabel",
		OnCommand = function(self) self:valign(0):y(-40) end,
        ComboCommand=function(self, params)
            self:diffuse(params.Misses and Color.Red or Color.White)
		end
	},

	InitCommand = function(self)
		-- We'll have to deal with this later
		--self:draworder(notefield_draw_order.over_field)
		c = self:GetChildren()
		c.Number:visible(false)
		c.ComboLabel:visible(false)
	end,

	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false)
			c.ComboLabel:visible(false)
			return
		end

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom )
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom )

		c.ComboLabel:visible(true)
		c.Number:visible(true)
		c.Number:settext( string.format("%i", iCombo) )

		c.Number:finishtweening()
		c.ComboLabel:finishtweening()

		-- Pulse
		Pulse( c.Number, param )
		Pulse( c.ComboLabel, param )
	end
}

return t
