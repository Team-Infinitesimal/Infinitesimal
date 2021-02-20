return function( TweenTime, TweenType, ColorMethod1, ColorMethod2 )
    return Def.ActorFrame{
        Def.Quad {
            InitCommand=function(self)
                self:Center()
                :zoomto(SCREEN_WIDTH+10,SCREEN_HEIGHT+10)
            end,
            OnCommand=function(self)
                self:diffuse( ColorMethod1 )
                :tween( TweenTime, TweenType )
                :diffuse( ColorMethod2 )
                :sleep(0.5)
            end
        }
    }
end