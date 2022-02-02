function WheelTransform (self, OffsetFromCenter, ItemIndex, NumItems) 
	local Spacing = math.abs(math.sin(OffsetFromCenter / math.pi))
	self:x(OffsetFromCenter * (250 - Spacing * 100))
	self:rotationy(clamp(OffsetFromCenter * 36, -85, 85))
    self:z(-math.abs(OffsetFromCenter))
    
    self:zoom(clamp(1.1 - (math.abs(OffsetFromCenter) / 3), 0.8, 1.1))
end

function WheelTransformGroup (self, OffsetFromCenter, ItemIndex, NumItems) 
	local Spacing = math.abs(math.sin(OffsetFromCenter / math.pi))
	self.container:x(OffsetFromCenter * (250 - Spacing * 100))
	self.container:rotationy(clamp(OffsetFromCenter * 30, -85, 85))
    
    self.container:zoom(clamp(1.1 - (math.abs(OffsetFromCenter) / 3), 0.8, 1.1))
end