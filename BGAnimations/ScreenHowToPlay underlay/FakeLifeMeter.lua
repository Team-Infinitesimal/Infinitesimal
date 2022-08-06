local BarW = 375
local BarH = 30

local MeterHot = false
local MeterDanger = false
local MeterFail = false

local MeterActor
local MeterUpdate = function(self)
    if not MeterActor then return end
    MeterActor:texcoordvelocity(-0.488, 0)
end

local t = Def.ActorFrame {
    InitCommand=function(self) self:SetUpdateFunction(MeterUpdate):addy(IsReverse and 100 or -100) end,
    OnCommand=function(self) 
        self:easeoutexpo(1):addy(IsReverse and -100 or 100):playcommand("Refresh", {Life = 0.5}) 
        
        -- Queueing commands does not allow parameters to be passed.
        -- Playing commands does not obey the actor's sleep status.
        
        -- Why?
        
        :sleep(6.81):queuecommand("Update1")
        :sleep(1.95):queuecommand("Update2")
        :sleep(1.95):queuecommand("Update3")
        :sleep(1.95):queuecommand("Update4")
        :sleep(3.9):queuecommand("Update5")
        :sleep(5.85):queuecommand("Update6")
        :sleep(0.488):queuecommand("Update7")
        :sleep(0.488):queuecommand("Update8")
        :sleep(0.488):queuecommand("Update9")
        :sleep(0.488):queuecommand("Update10")
    end,
    
    Update1Command=function(self) self:playcommand("Refresh", {Life = 0.6}) end,
    Update2Command=function(self) self:playcommand("Refresh", {Life = 0.7}) end,
    Update3Command=function(self) self:playcommand("Refresh", {Life = 0.8}) end,
    Update4Command=function(self) self:playcommand("Refresh", {Life = 0.9}) end,
    Update5Command=function(self) self:playcommand("Refresh", {Life = 1.0}) end,
    Update6Command=function(self) self:playcommand("Refresh", {Life = 0.8}) end,
    Update7Command=function(self) self:playcommand("Refresh", {Life = 0.6}) end,
    Update8Command=function(self) self:playcommand("Refresh", {Life = 0.4}) end,
    Update9Command=function(self) self:playcommand("Refresh", {Life = 0.2}) end,
    Update10Command=function(self) self:playcommand("Refresh", {Life = 0.01}) end,
    
    RefreshCommand=function(self, params)
        local LifeAmount = params.Life or 0.5

        if LifeAmount <= 0.33 and not MeterDanger then
            self:GetChild("BarBody"):diffusebottomedge(Color.Red)
            self:GetChild("BarEdgeL"):diffusebottomedge(Color.Red)
            self:GetChild("BarEdgeR"):diffusetopedge(Color.Red) -- This one is flipped :)
            MeterDanger = true
        elseif LifeAmount > 0.33 and MeterDanger and not MeterFail then
            self:GetChild("BarBody"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
            self:GetChild("BarEdgeL"):stoptweening():linear(0.5):diffusebottomedge(Color.White)
            self:GetChild("BarEdgeR"):stoptweening():linear(0.5):diffusetopedge(Color.White)
            MeterDanger = false
        end
        
        if LifeAmount >= 1 and not MeterHot then
            self:GetChild("RainbowMeter"):stoptweening():linear(0.5):diffusealpha(1)
            MeterHot = true
        elseif LifeAmount < 1 and MeterHot then
            self:GetChild("RainbowMeter"):diffusealpha(0)
            MeterHot = false
        end
        
        if LifeAmount <= 0 and not MeterFail then
            MeterFail = true
        elseif LifeAmount > 0 and MeterFail and (PlayerOptions:FailSetting() == "FailType_Off") then
            MeterFail = false
        end
        
        self:GetChild("Meter"):finishtweening():x(MeterHot and 0 or -20):linear(0.1):cropright(1 - LifeAmount)
        self:GetChild("Pulse"):finishtweening():linear(0.1):x(-(((BarW - 12) / 2) - ((BarW - 12) * LifeAmount)) - 20)
    end,
    
    Def.Sprite {
        Name="BarBody",
        Texture=THEME:GetPathG("", "UI/BarBody"),
        InitCommand=function(self)
            self:setsize(BarW - 12, BarH)
        end
    },
    
    Def.Sprite {
        Name="BarEdgeL",
        Texture=THEME:GetPathG("", "UI/BarEdge"),
        InitCommand=function(self)
            self:x(-BarW / 2):halign(0)
        end
    },
    
    Def.Sprite {
        Name="BarEdgeR",
        Texture=THEME:GetPathG("", "UI/BarEdge"),
        InitCommand=function(self)
            self:x(BarW / 2):halign(0):rotationz(180)
        end
    },
    
    Def.Quad {
        Name="Mask",
        InitCommand=function(self)
            self:zoomto(BarW - 12, BarH - 12)
            :diffuse(color(1,1,1,1))
            :MaskSource()
        end
    },

    Def.Quad {
        Name="Meter",
        InitCommand=function(self)
            self:zoomto(BarW - 12, BarH - 12):x(-20):cropright(0.5)
            :diffuse(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
            :diffusebottomedge(pn == PLAYER_1 and color("#ed1e79") or color("#1fbcff"))
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    Def.Quad {
        Name="Pulse",
        InitCommand=function(self)
            self:zoomto(20, BarH - 12):halign(0)
            :diffuse(pn == PLAYER_1 and color("#f7931e") or color("#ab78f5"))
            :diffusebottomedge(pn == PLAYER_1 and color("#ed1e79") or color("#1fbcff"))
            
            self:bounce():effectmagnitude(-20,0,0):effectclock("bgm"):effecttiming(1,0,0,0)
            :MaskDest():ztestmode("ZTestMode_WriteOnFail")
        end
    },

    Def.Sprite {
        Name="RainbowMeter",
        Texture=THEME:GetPathG("", "UI/RainbowBar"),
        InitCommand=function(self)
            self:zoomto(BarW - 12, BarH - 12)
            :texcoordvelocity(-0.5, 0)
            :diffusealpha(0)
        end
    }
}

return t
