return Def.ActorFrame {

    Def.BitmapText {
        Font="VCR OSD Mono 20px",
        InitCommand=function(self)
            self:xy(SCREEN_LEFT + 20, SCREEN_BOTTOM - 20)
            :halign(0):valign(1)
            :settext("INFINITESIMAL\n"..string.upper(string.format("OutFox %s - %s", ProductVersion(), VersionDate())))
        end
    }

}
