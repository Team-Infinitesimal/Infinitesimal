function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
    self:x(offsetFromCenter*350);
    local rot = -20;
    self:rotationy(offsetFromCenter*5);
    self:z(math.abs(offsetFromCenter*5)*-10);
end;
