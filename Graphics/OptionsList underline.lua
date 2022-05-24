return Def.ActorFrame {

    Def.Quad {
        InitCommand=function(self)
            self:draworder(200)
            :diffuseshift()
            :effectcolor1(color("#606060"))
            :effectcolor2(color("#303030"))
            :effectperiod(0.75)
            :zoomto(150,24)
            :fadeleft(0.75)
            :faderight(0.75)
            :blend(Blend.Add)
            :MaskDest()
        end
    },

    Def.Quad {
        Name="BottomLine",
        InitCommand=function(self)
            self:draworder(200)
            :diffuseshift()
            :effectcolor1(color("#808080"))
            :effectcolor2(color("#505050"))
            :effectperiod(0.75)
            :zoomto(150,2)
            :valign(0)
            :fadeleft(0.75)
            :faderight(0.75)
            :y(10)
            :blend(Blend.Add)
            :MaskDest()
        end
    },

    Def.Quad {
        Name="TopLine",
        InitCommand=function(self)
            self:draworder(200)
            :diffuseshift()
            :effectcolor1(color("#808080"))
            :effectcolor2(color("#505050"))
            :effectperiod(0.75)
            :zoomto(150,2)
            :valign(1)
            :fadeleft(0.75)
            :faderight(0.75)
            :y(-10)
            :blend(Blend.Add)
            :MaskDest()
        end
    }

}
