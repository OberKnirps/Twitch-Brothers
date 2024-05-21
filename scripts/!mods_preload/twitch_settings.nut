::Const.TwitchMod.addSettings <- function() {
    //create a page

    local testPage = TwitchBres.Mod.ModSettings.addPage("TwitchPage", "TwitchBres");
    // add a title
    testPage.addTitle("titleTest", "Test Title");
    // add a divider
    testPage.addDivider("dividertest");

    //TwitchBres.Settings.Textfield
    ::Const.TwitchMod.Settings <- {
        channelNames = testPage.addStringSetting("Channels", "", null)
    }

    ::Const.TwitchMod.Settings.channelNames.addAfterChangeCallback(function ( _oldValue )
    {
        if(::Const.TwitchInterface.m.JSHandle){
            ::Const.TwitchInterface.m.JSHandle.asyncCall("initTwitchClient", null);
        }
    })

}