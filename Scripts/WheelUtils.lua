function WheelTransform (self, OffsetFromCenter, ItemIndex, NumItems) 
	local Spacing = math.abs(math.sin(OffsetFromCenter / math.pi));
	self:x(OffsetFromCenter * (250 - Spacing * 100));
	self:rotationy(clamp(OffsetFromCenter * 30, -85, 85));
    
    self:zoom(clamp(1.1 - (math.abs(OffsetFromCenter) / 3), 0.8, 1.1));
end