-- Credits to quietly-turning

local player = ...

return Def.Actor{
	OnCommand=function(self)
        if IsGame("pump") or IsGame("piu") then
            local screen = SCREENMAN:GetTopScreen()
            if screen then
                local playerAF = screen:GetChild("Player"..ToEnumShortString(player))
                if playerAF then
                    local notefield = playerAF:GetChild("NoteField")
                    if notefield then
                        local columns = notefield:get_column_actors()
                        local spacing = 2

                        if #columns == 5 then
                            for i, column in ipairs(columns) do
                                column:addx((i-3)*spacing)
                            end
                        elseif #columns == 6 then
                            for i, column in ipairs(columns) do
                                column:addx(((i-3)*spacing) + (i <= 3 and 2 or -2))
                            end
                        elseif #columns == 10 then
                            for i, column in ipairs(columns) do
                                column:addx(((i-5)*spacing) + (i <= 5 and 2 or -2))
                            end
                        end
                    end
                end
            end
        end
	end
}