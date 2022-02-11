return Def.ActorFrame {

    Def.Sprite {
        Texture=THEME:GetPathG("", "UI/Secret"),
        InitCommand=function(self)
            self:visible(false):halign(0):valign(0):zoom(0.3):y(SCREEN_TOP-40)
        end,
        SecretUpdatedMessageCommand=function(self, param)
            if _G["Secret"] == true then
                self:visible(true)
                :decelerate(1)
                :y(SCREEN_TOP)
            else
                self:visible(false)
            end
        end
    }
}
