function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
    self:x(offsetFromCenter*385);
    local rot = -20;
    self:rotationy(offsetFromCenter*5);
    self:z(math.abs(offsetFromCenter*5)*-10);
end;
