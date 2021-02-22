local TNS = {
    ['TapNoteScore_HitMine'] = {"Mine","Score"},
    ['TapNoteScore_Attack'] = {"Attack", "Score"},
    ['TapNoteScore_Hold'] = {"Hold","Timing"},
    ['TapNoteScore_Roll'] = {"Roll","Timing"},
    ['TapNoteScore_Checkpoint'] = {"Checkpoint","Timing"}
}

return Def.ActorFrame{
    OnCommand=function(self)
        self.mode = LoadModule("Config.Load.lua")("SmartTimings","Save/Infinitesimal.ini") or "Normal"
        self.PadRelation = LoadModule("Config.Load.lua")("DisableLowerWindows","Save/Infinitesimal.ini") or false
        self.TimingTable = nil
        self.TimingOrdering = {}

        for k,v in pairs( TimingWindow ) do
            local Name,Timings = TimingWindow[k]()
            if self.mode == Name then
                self.TimingTable = Timings
                break
            end
        end

        if self.TimingTable ~= nil then
            self.TimingOrdering = TimingOrder(self.TimingTable)
        end

        self.Scale = PREFSMAN:GetPreference("TimingWindowScale")
        self.Add = PREFSMAN:GetPreference("TimingWindowAdd")
    end,
    JudgmentWindowMessageCommand=function(self, params)
        local score = 'TapNoteScore_None'
        local TimingTable = self.TimingTable

        for _,v in pairs( self.TimingOrdering ) do
            local CurTiming = GetWindowSeconds(v[2], self.Scale, self.Add)
            if "Note" == params.Type or (TNS[v[1]] and TNS[v[1]][1] == params.Type) then
                if TNS[v[1]] and TNS[v[1]][2] == "Timing" then params.timing = CurTiming break
                else if (CurTiming >= params.Window and (CurTiming*-1) <= params.Window) then score = v[1] break end
                end
            end
        end

        if score == 'TapNoteScore_Attack' then score = 'TapNoteScore_W1' end
        if self.PadRelation then
            for i=0,1 do
                if (score == 'TapNoteScore_W'..(5-i) and tonumber(self.PadRelation) >= (i+1)) then score = 'TapNoteScore_None' end
            end
        end

        params.score = score
    end
}
