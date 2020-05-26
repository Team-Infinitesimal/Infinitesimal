function wheelTransformNyoom(self,offsetFromCenter,itemIndex,numItems)
    self:zoom(0.85)
    self:x(offsetFromCenter*270);
    local rot = -20;
    self:rotationy(offsetFromCenter*15);
    self:z(math.abs(offsetFromCenter*5)*-10);
end;
