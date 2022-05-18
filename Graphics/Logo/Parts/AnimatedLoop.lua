return Def.ActorFrame {

    Def.Sprite {
        Name="PlainLoop",
        Texture="PlainLoop"
    },

    Def.Sprite {
        Name="InnerLoop",
        Texture="InnerLoop",
        InitCommand=function(self)
          self:MaskSource()
        end
    },

    Def.Sprite {
        Name="ArrowPattern",
        Texture="ArrowPattern",
        InitCommand=function(self)
            self:blend("BlendMode_Subtract"):diffusealpha(0.02)
            :rotationz(-10)
            :zoomto(750, 475)
            :customtexturerect(0,0,4,2.4)
            :texcoordvelocity(-0.25,0)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    LoadActor("Hat")..{
        Condition = IsAnniversary()
    }

}
