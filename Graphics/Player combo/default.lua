local c
local ShowComboAt = THEME:GetMetric("Combo", "ShowComboAt")
local Pulse = THEME:GetMetric("Combo", "PulseCommand")
local PulseLabel = THEME:GetMetric("Combo", "PulseLabelCommand")

local NumberMinZoom = THEME:GetMetric("Combo", "NumberMinZoom")
local NumberMaxZoom = THEME:GetMetric("Combo", "NumberMaxZoom")
local NumberMaxZoomAt = THEME:GetMetric("Combo", "NumberMaxZoomAt")

local LabelMinZoom = THEME:GetMetric("Combo", "LabelMinZoom")
local LabelMaxZoom = THEME:GetMetric("Combo", "LabelMaxZoom")

local colours = {
	FullComboW1 = color("#febdff"),
	FullComboW2 = color("#81c1ff"),
	FullComboW3 = color("#59fe5d"),
	FullComboW4 = color("#fff46b"),
	Miss = color("#f04030")
}

local t = Def.ActorFrame {

	Def.BitmapText {
		Font="Combo numbers",
		Name="Number",
		OnCommand = THEME:GetMetric("Combo", "NumberOnCommand"),
		ComboCommand=function(self, params)
			self:diffuseshift():effectclock("bgm"):playcommand("Colour", params)
		end,
		ColourCommand=function(self, params)
			if params.FullComboW1 then
				self:effectcolor1(colours.FullComboW1)
			elseif params.FullComboW2 then
				self:effectcolor1(colours.FullComboW2)
			elseif params.FullComboW3 then
				self:effectcolor1(colours.FullComboW3)
			elseif params.FullComboW4 then
				self:effectcolor1(colours.FullComboW2)
			elseif params.Combo then
				self:stopeffect()
			elseif params.Misses then
				self:effectcolor1(colours.Miss):effectcolor2(colours.Miss)
			end
		end,
	},

	Def.Sprite {
		Texture="ComboLabel",
		Name="ComboLabel";
		OnCommand = function(self)self:vertalign(top):y(-45)end;
	};

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
