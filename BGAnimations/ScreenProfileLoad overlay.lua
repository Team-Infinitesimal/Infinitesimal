return Def.ActorFrame {

    LoadActor("LoadingIcon")..{
        InitCommand=function(self)
            self:GetChild("Text"):settext("LOAD PROFILE DATA...")
        end
    },

    Def.Actor {
        BeginCommand=function(self)
            if SCREENMAN:GetTopScreen():HaveProfileToLoad() then self:sleep(1) end
            self:queuecommand("Load")
        end,
        LoadCommand=function() SCREENMAN:GetTopScreen():Continue() end
    }
}
