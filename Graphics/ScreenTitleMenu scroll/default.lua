local gc = Var("GameCommand");

local t = Def.ActorFrame{

    LoadFont("Montserrat normal 20px")..{
        Text=gc:GetText();
        InitCommand=function(self)
            self:y(150)
            end;
        GainFocusCommand=function(self)
            self:linear(0.25)
            :diffuse(Color("Red"))
            end;
        LoseFocusCommand=function(self)
            self:linear(0.25)
            :diffuse(Color("White"))
            end;
    };
};

return t;
