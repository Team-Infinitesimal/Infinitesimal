function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
	local offsetAbs = math.abs(offsetFromCenter);

	self:x(offsetFromCenter * 300)
	:z(offsetAbs * -(100 * offsetAbs))
	:rotationy(offsetFromCenter * -5)
end;
