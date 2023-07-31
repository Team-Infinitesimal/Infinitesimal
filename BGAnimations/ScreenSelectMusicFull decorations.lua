local t = Def.ActorFrame {}

for _,v in pairs(NOTESKIN:GetNoteSkinNames()) do
    t[#t+1] = NOTESKIN:LoadActorForNoteSkin("UpRight", "Tap Note", v)..{
        Name="NS"..string.lower(v), InitCommand=function(s) s:visible(false) end,
    }
end

return t
