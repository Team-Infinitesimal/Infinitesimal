-- Original NPS graph from Soundwaves by Team Rizu
local GraphX, GraphY, GraphW, GraphH, Gameplay, pn = ...
GraphH = GraphH / 2

local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")

local colorrange = function(val,range,color1,color2)
    return lerp_color((val/range), color1, color2)
end

local amv = Def.ActorFrame{
    OnCommand=function(self) 
        if GAMESTATE:GetCurrentSong() then
            self:stoptweening():sleep(PreviewDelay):queuecommand("ShowAMV")
        end
    end,
    Def.ActorMultiVertex{
        OnCommand=function(self)
            self:SetDrawState{Mode="DrawMode_QuadStrip"}
            :xy(GraphX, GraphY):MaskDest()
        end,
        ShowAMVCommand=function(self)
            local verts = {}
            self:SetNumVertices(#verts):SetVertices(verts)
            if GAMESTATE:GetCurrentSong() and GAMESTATE:IsHumanPlayer(pn) and GAMESTATE:GetCurrentSteps(pn) then
                -- Grab every instance of the NPS data.
                local song = GAMESTATE:GetCurrentSong() 
                local step = GAMESTATE:GetCurrentSteps(pn)
                local steplength = step:GetChartLength()
                local stepcolor = ChartTypeToColor(step)
                local graphcolor = ColorDarkTone(stepcolor)
                
                local npsdata = LoadModule("Chart.Density.lua")(pn)
                local data = npsdata:ObtainSongInformation(step, song)
                if not data and step then return end
                local peak, npst = data.PeakNPS, data.Density
                
                if npst then
                    for k,v in pairs( npst ) do
                        -- Each NPS area is per MEASURE. not beat. So multiply the area by 4 beats.
                        local t = step:GetTimingData():GetElapsedTimeFromBeat((k-1)*4)
                        -- With this conversion on t, we now apply it to the x coordinate.
                        local x
                        if Gameplay then
                            x = scale( t, GAMESTATE:GetCurrentSong():GetFirstSecond(), 
                            steplength, -(GraphW/2), (GraphW/2))
                        else
                            x = scale( t, math.min(step:GetTimingData():GetElapsedTimeFromBeat(0), 0), 
                            steplength, -(GraphW/2)+5, (GraphW/2)-5)
                        end
                        -- Clamp the graph to ensure it will stay within boundaries.
                        if x < -(GraphW/2) then x = -(GraphW/2) end
                        if x > (GraphW/2) then x = (GraphW/2) end
                        -- Now scale that position on v to the y coordinate.
                        local y = math.round( scale( v, 0, peak, GraphH, -GraphH ) )
                        local colrange = colorrange( v, peak, graphcolor, stepcolor )
                        -- And send them to the table to be rendered.
                        if #verts > 2 and (verts[#verts][1][2] == y and verts[#verts-2][1][2] == y) then
                            verts[#verts][1][1] = x
                            verts[#verts-1][1][1] = x
                        else
                            if x < (GraphW/2) then
                                verts[#verts+1] = {{x, GraphH, 0}, graphcolor }
                                verts[#verts+1] = {{x, y, 0}, colrange}
                            end
                        end
                    end
                end
            end
            self:SetNumVertices(#verts):SetVertices(verts)
            verts = {} -- To free some memory, let's empty the table.
        end
    }
}

return amv
