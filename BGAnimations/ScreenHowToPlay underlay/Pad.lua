local function FlashPanel(panel, beat, length)
    local bps = (122.990 / 60)
    local num_beats = beat / bps
    local length_beats

    if length then
        length_beats = length / bps
    else length_beats = 0 end

    -- Texture names are UL, UR, CN, DL, DR
    return Def.Sprite {
        Texture=THEME:GetPathG("", "UI/BigPad/"..panel),
        InitCommand=function(self)
            self:diffusealpha(0):blend("BlendMode_Add"):sleep(0.1)
        end,
        OnCommand=function(self)
            self:sleep(num_beats)
            :diffusealpha(1)
            :sleep(length_beats)
            :linear(0.4)
            :addy(-8)
            :zoom(1.025)
            :diffusealpha(0)
        end
    }
end

local t = Def.ActorFrame {

    Def.Sprite {
        Name="Pad",
        Texture=THEME:GetPathG("", "UI/BigPad/FullPad")
    },

    FlashPanel("UL", 16, 0),
    FlashPanel("UR", 20, 0),
    FlashPanel("CN", 24, 0),
    FlashPanel("DL", 28, 0),
    FlashPanel("DR", 28, 0),
    FlashPanel("CN", 36, 4),
    FlashPanel("DL", 48, 0),
    FlashPanel("UL", 49, 0),
    FlashPanel("CN", 50, 0),
    FlashPanel("UR", 51, 0),
    FlashPanel("DR", 52, 0),
}

return t
