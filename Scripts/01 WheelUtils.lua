function WheelTransform(self, OffsetFromCenter, ItemIndex, NumItems) 
    local absOffset = math.abs(OffsetFromCenter)
    local Spacing = absOffset / math.pi
    local rotation = clamp(OffsetFromCenter * 36, -85, 85)
    local zoom = clamp(1.1 - (absOffset / 3), 0.8, 1.1)

    self:x(OffsetFromCenter * (250 - Spacing * 100))
    self:rotationy(rotation)
    self:z(-absOffset)
    self:zoom(zoom)
end


function WheelTransformGroup (self, OffsetFromCenter, ItemIndex, NumItems) 
    local Spacing = math.abs(math.sin(OffsetFromCenter / math.pi))
    self.container:x(OffsetFromCenter * (250 - Spacing * 100))
    self.container:rotationy(clamp(OffsetFromCenter * 30, -85, 85))
    
    self.container:zoom(clamp(1.1 - (math.abs(OffsetFromCenter) / 3), 0.8, 1.1))
end


-------------------------------------------------------------------------------------------------------------------
-- Better version of function, but commented to provide a reference instead of getting in the way of development --
-------------------------------------------------------------------------------------------------------------------
-- local WHEEL_X_OFFSET = 250
-- local WHEEL_X_SPACING = 100
-- local WHEEL_ROTATION_LIMIT = 85
-- local WHEEL_ZOOM_MIN = 0.8
-- local WHEEL_ZOOM_MAX = 1.1

-- function WheelTransformGroup (self, OffsetFromCenter, ItemIndex, NumItems) 
--     local container = self.container
--     local spacing = math.abs(math.sin(OffsetFromCenter / math.pi))
--     container:x(OffsetFromCenter * (WHEEL_X_OFFSET - spacing * WHEEL_X_SPACING))
--     container:rotationy(clamp(OffsetFromCenter * 30, -WHEEL_ROTATION_LIMIT, WHEEL_ROTATION_LIMIT))
    
--     container:zoom(clamp(WHEEL_ZOOM_MAX - (math.abs(OffsetFromCenter) / 3), WHEEL_ZOOM_MIN, WHEEL_ZOOM_MAX))
-- end
