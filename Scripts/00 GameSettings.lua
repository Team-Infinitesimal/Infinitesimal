function SetPlayMode()
    GAMESTATE:SetCurrentPlayMode("PlayMode_Regular");
    GAMESTATE:SetCurrentStyle("Single");
    return "ScreenSelectMusic"
end

--Adds commas to your score, apparently
function scorecap(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end