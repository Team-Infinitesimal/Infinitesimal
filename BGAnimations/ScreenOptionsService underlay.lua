return Def.ActorFrame {
    OnCommand=function(self)
        SCREENMAN:set_input_redirected(PLAYER_1, false)
        SCREENMAN:set_input_redirected(PLAYER_2, false)
    end,

    Def.BitmapText {
        Font="VCR OSD Mono 20px",
        InitCommand=function(self)
            self:xy(SCREEN_LEFT + 20, SCREEN_BOTTOM - 20)
            :halign(0):valign(1)
            :settext("INFINITESIMAL\n"..ToUpper(string.format("OutFox %s - %s", ProductVersion(), VersionDate())))
        end
    }
}
