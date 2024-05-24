//sets all the settings up
::TwitchBrothers.Content.addSettings <- function() {
    //create a page

    local testPage = TwitchBrothers.MSU.ModSettings.addPage("TwitchPage", "TwitchBrothers");
    // add a title
    testPage.addTitle("titleTest", "Test Title");
    // add a divider
    testPage.addDivider("dividertest");

    ::TwitchBrothers.Content.Settings <- {
        channelNames = testPage.addStringSetting("channelNames", "", "Channels")
        blacklistedBots = testPage.addBooleanSetting("blacklistedBots", true, "Remove common Chatbots")
        blacklistedNames = testPage.addStringSetting("blacklistedNames", "", "Blacklist for Names")
    }

    //Channels to Monitor
    ::TwitchBrothers.Content.Settings.channelNames.addAfterChangeCallback(function ( _oldValue )
    {
        if(::Const.TwitchInterface.m.JSHandle){
            ::Const.TwitchInterface.m.JSHandle.asyncCall("initTwitchClient", null);
        }
    })

    //Bot blacklist
    ::TwitchBrothers.Content.Settings.blacklistedBots.setDescription("Removes common bots from the name pool. List includes: Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs");
    ::TwitchBrothers.Content.Settings.blacklistedBots.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    })

    //Custom balacklist
    ::TwitchBrothers.Content.Settings.blacklistedNames.setDescription("Specify names, name parts or regular expretions, seperated by by SPACE, ',' or ';'. The filtering is case insensitive. E.g. 'TWITCH' will remove 'TwitchBot'.");

    ::TwitchBrothers.Content.Settings.blacklistedNames.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    })

}