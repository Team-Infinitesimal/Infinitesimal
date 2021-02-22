function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)

	local offsetAbs = math.abs(offsetFromCenter)
	local spacing = math.abs(math.sin(offsetFromCenter/math.pi))
	
	self:zoom(clamp(1-(offsetAbs/3), 0.8, 1));
	
    self:x(offsetFromCenter * (350 - spacing * 150))
    :rotationy(clamp(offsetFromCenter * 45, -90, 90))
    :z(offsetAbs * -20);
    
end;

-- Circular wheel transform

--[[
function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)

	local offsetAbs = math.abs(offsetFromCenter);

	self:x(offsetFromCenter * 300)
	:z(offsetAbs * -(100 * offsetAbs))
	:rotationy(offsetFromCenter * -5)
	
end;
--]]

function playModeScroller(self,offset,itemIndex,numItems)
    self:x(offset*270);
end;
