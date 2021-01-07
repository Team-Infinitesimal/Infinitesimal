local c
local player = Var "Player"
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
		Font="_Plex Numbers 60px",
		Name="Number",
		OnCommand = THEME:GetMetric("Combo", "NumberOnCommand"),
	},
	Def.BitmapText {
		Font="_Condensed Semibold",
		Name="Label",
		OnCommand = THEME:GetMetric("Combo", "LabelOnCommand"),
	},

	InitCommand = function(self)
		-- We'll have to deal with this later
		--self:draworder(notefield_draw_order.over_field)
		c = self:GetChildren()
		c.Number:visible(false)
		c.Label:visible(false)
	end,

	ComboCommand=function(self, param)
		local iCombo = param.Misses or param.Combo
		if not iCombo or iCombo < ShowComboAt then
			c.Number:visible(false)
			c.Label:visible(false)
			return
		end

		local labeltext = param.Combo and "COMBO" or "MISSES"
		c.Label:settext( labeltext )
		c.Label:visible(false)

		param.Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom )
		param.Zoom = clamp( param.Zoom, NumberMinZoom, NumberMaxZoom )

		param.LabelZoom = scale( iCombo, 0, NumberMaxZoomAt, LabelMinZoom, LabelMaxZoom )
		param.LabelZoom = clamp( param.LabelZoom, LabelMinZoom, LabelMaxZoom )

		c.Number:visible(true)
		c.Label:visible(true)
		c.Number:settext( string.format("%i", iCombo) )

		c.Number:finishtweening()
		c.Label:finishtweening()

		-- FullCombo Rewards
		if param.FullComboW1 then
			c.Number:diffuse(color("#8CCBFF")):diffusetopedge(color("#ACFFFD")):strokecolor(color("#345660"))
			c.Label:diffuse(color("#8CCBFF")):diffusetopedge(color("#ACFFFD")):strokecolor(color("#345660"))
		elseif param.FullComboW2 then
			c.Number:diffuse(color("#FAFAFA")):diffusetopedge(color("#FFFBA3")):strokecolor(color("#A27000"))
			c.Label:diffuse(color("#FAFAFA")):diffusetopedge(color("#FFFBA3")):strokecolor(color("#A27000"))
		elseif param.FullComboW3 then
			c.Number:diffuse(color("#8CFFB8")):diffusetopedge(color("#C5FFA3")):strokecolor(color("#1B7E16"))
			c.Label:diffuse(color("#8CFFB8")):diffusetopedge(color("#C5FFA3")):strokecolor(color("#1B7E16"))
		elseif param.Combo then
			c.Number:diffuse(color("#FFFFFF")):diffusetopedge(color("#DCE7FB")):strokecolor(color("#101E4B")):stopeffect()
			c.Label:diffuse(color("#FFFFFF")):diffusetopedge(color("#DCE7FB")):strokecolor(color("#101E4B")):stopeffect()
		else
			c.Number:diffuse(color("#f7d8d8")):diffusetopedge(color("#db7d7d")):strokecolor(color("#4b1010")):stopeffect()
			c.Label:diffuse(color("#f7d8d8")):diffusetopedge(color("#db7d7d")):strokecolor(color("#4b1010")):stopeffect()
		end
		-- Pulse
		Pulse( c.Number, param )
		PulseLabel( c.Label, param )
	end
};

return t;
