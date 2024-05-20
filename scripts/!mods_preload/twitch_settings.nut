::Const.TwitchMod.addSettings <- function() {
    //create a page

    local testPage = TwitchBres.Mod.ModSettings.addPage("TwitchPage", "TwitchBres");
    // add a title
    testPage.addTitle("titleTest", "Test Title");
    // add a divider
    testPage.addDivider("dividertest");

    //TwitchBres.Settings.Textfield
    local buttonTest = testPage.addButtonSetting("TestButton", "Click Me", null);
    ::Const.TwitchMod.DescriptionTest = buttonTest;
    buttonTest.addCallback(function(_data = null){
        this.logInfo("Button " + this.ID + " was pressed");
        buttonTest.setDescription(buttonTest.Description + " TBD");
    });

    local buttonTest = testPage.addButtonSetting("TwitchConnect", "Connect", null);
    buttonTest.addCallback(function(_data = null){
        this.logInfo("Connect " + this.ID + " was pressed");
        ::Const.TwitchInterface.connect();
    });

    local buttonTest = testPage.addButtonSetting("TwitchSend", "Send Message", null);
    buttonTest.addCallback(function(_data = null){
        this.logInfo("Send " + this.ID + " was pressed");
        ::Const.TwitchInterface.sendMessage("JOIN #Bonjwa");
    });

}