::Const.TwitchMod.addSettings <- function() {
    //create a page

    local testPage = TwitchBres.Mod.ModSettings.addPage("TwitchPage", "TwitchBres");
    // add a title
    testPage.addTitle("titleTest", "Test Title");
    // add a divider
    testPage.addDivider("dividertest");

    ::Const.TwitchMod.Settings <- {
        channelNames = testPage.addStringSetting("channelNames", "", "Channels")
        blacklistedBots = testPage.addBooleanSetting("blacklistedBots", true, "Remove common Chatbots")
        blacklistedNames = testPage.addStringSetting("blacklistedNames", "", "Blacklist for Names")
    }

    //Channels to Monitor
    ::Const.TwitchMod.Settings.channelNames.addAfterChangeCallback(function ( _oldValue )
    {
        if(::Const.TwitchInterface.m.JSHandle){
            ::Const.TwitchInterface.m.JSHandle.asyncCall("initTwitchClient", null);
        }
    })

    //Bot blacklist
    ::Const.TwitchMod.Settings.blacklistedBots.setDescription("Removes common bots from the name pool. List includes: Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs");
    ::Const.TwitchMod.Settings.blacklistedBots.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    })

    //Custom balacklist
    ::Const.TwitchMod.Settings.blacklistedNames.setDescription("Specify names, name parts or regular expretions, seperated by by SPACE, ',' or ';'. The filtering is case insensitive. E.g. 'TWITCH' will remove 'TwitchBot'.");

    ::Const.TwitchMod.Settings.blacklistedNames.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    })

}