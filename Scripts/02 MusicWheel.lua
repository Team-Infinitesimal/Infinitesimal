function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
    self:x(offsetFromCenter*320);
    local rot = -10;
    self:rotationy(offsetFromCenter*-8);
    self:z(math.abs(offsetFromCenter)*-100);
end;
