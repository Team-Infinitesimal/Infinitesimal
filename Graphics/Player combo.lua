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
        OnCommand = function(self) self:valign(0):y(-20) end
    },

    Def.Sprite {
        Texture="ComboLabel",
        Name="ComboLabel",
        OnCommand = function(self) self:valign(1):y(-20) end
    },

    InitCommand = function(self)
        -- We'll have to deal with this later
        --self:draworder(notefield_draw_order.over_field)
        c = self:GetChildren()
        c.Number:visible(false)
        c.ComboLabel:visible(false)
    end,

    ComboCommand=function(self, params)
        local iCombo = params.Misses or params.Combo
        if not iCombo or iCombo < ShowComboAt then
            c.Number:visible(false)
            c.ComboLabel:visible(false)
            return
        end

        local Zoom = scale( iCombo, 0, NumberMaxZoomAt, NumberMinZoom, NumberMaxZoom )
        local Zoom = clamp( Zoom, NumberMinZoom, NumberMaxZoom )

        c.ComboLabel:visible(true)
        c.Number:visible(true)
        c.Number:settext(string.rep("0",3-string.len(iCombo))..iCombo)

        c.Number:stoptweening():diffuse(params.Misses and Color.Red or Color.White)
        :diffusealpha(0.85):zoom(1.25*Zoom):decelerate(0.15):diffusealpha(1.0):zoom(Zoom)
        :sleep(0.35):decelerate(0.3):diffusealpha(0)
        
        c.ComboLabel:stoptweening():diffuse(params.Misses and Color.Red or Color.White)
        :diffusealpha(0.85):zoom(0.75):decelerate(0.15):diffusealpha(1.0):zoom(0.65)
        :sleep(0.35):decelerate(0.3):diffusealpha(0):zoomy(0.4):zoomx(0.85)
    end
}

return t
