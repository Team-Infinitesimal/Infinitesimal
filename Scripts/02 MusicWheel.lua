function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
		local offsetAbs = math.abs(offsetFromCenter)
    self:x(offsetFromCenter*375);
		self:y(math.abs(offsetFromCenter)*-1)
    self:rotationy(clamp(offsetFromCenter*22, -87, 87));
    self:z(math.abs(offsetFromCenter)*-100);
end;

--[[ Circular wheel transform --]]

--[[ function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
	local offsetAbs = math.abs(offsetFromCenter);

	self:x(offsetFromCenter * 300)
	:z(offsetAbs * -(100 * offsetAbs))
	:rotationy(offsetFromCenter * -5)
end; --]]
