//sets all the settings up
::TwitchBrothers.Content.addSettings <- function() 
{
    ::TwitchBrothers.Content.Settings <- 
        {
            channelNames = null,
            blacklistedBots = null,
            blacklistedNames = null,
            Commands = 
            {
                Name  =
                {
                    String  = null,
                    Enabled = null,
                    Role    = null
                },
                Title = 
                {
                    String  = null,
                    Enabled = null,
                    Role    = null
                },
                Clear =
                {
                    String  = null,
                    Enabled = null,
                    Role    = null
                },
                Block = 
                {
                    String  = null,
                    Enabled = null,
                    Role    = null
                }
            },
            AutoBan = null,
            Filter = null,
            Spawn = {
                Free = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null,
                    AsItem = null
                },
                Hired = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null,
                    AsItem = null
                },
                Dead = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null,
                    AsItem = null
                },
                Retired = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null,
                    AsItem = null
                }
            },
            Event =
            {
                Active = null,
                Timer =
                {
                    Active = null,
                    WaitForVote = null,
                    Duration = null,
                    Selection = 
                    {
                        Manual = null,
                        Auto = null,
                        Duration = null,
                        Speed = null,
                        Delay = null
                    },
                    RandomizeChoice =
                    {
                        Active = null,
                        Duration = null,
                        Speed = null,
                    }        
                },
                Color =
                {
                    Active = null,
                    ColorGood = null,
                    ColorBad = null,
                    VoteOffset = null
                }
            }
        }

    //create pages
    local streamSettings = TwitchBrothers.MSU.ModSettings.addPage("SettingsPage", "Stream Settings");
    local commandSettings = TwitchBrothers.MSU.ModSettings.addPage("CommandPage", "Commands");
    local spawnSettings = TwitchBrothers.MSU.ModSettings.addPage("SpawnPage", "Spawn Settings");
    local eventSettings = TwitchBrothers.MSU.ModSettings.addPage("EventPage", "Event Settings");
    
    //Stream Settings
    streamSettings.addTitle("General", "General");
    streamSettings.addDivider("DividerGeneral");

    //TODO: make IDs UpperCamelCase
    //Channels to Monitor
    ::TwitchBrothers.Content.Settings.channelNames = streamSettings.addStringSetting("channelNames", "", "Channels");
    ::TwitchBrothers.Content.Settings.channelNames.addAfterChangeCallback(function ( _oldValue )
    {
        if(::Const.TwitchInterface.m.JSHandle)
        {
            ::Const.TwitchInterface.m.JSHandle.asyncCall("initTwitchClient", null);
        }
    });

    //Bot blacklist
    ::TwitchBrothers.Content.Settings.blacklistedBots = streamSettings.addBooleanSetting("blacklistedBots", true, "Remove common Chatbots","Removes common bots from the name pool. List includes: Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs");
    ::TwitchBrothers.Content.Settings.blacklistedBots.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    });

    //Custom balacklist
    ::TwitchBrothers.Content.Settings.blacklistedNames = streamSettings.addStringSetting("blacklistedNames", "", "Blacklist for Names", "Specify names, name parts or regular expretions, seperated by by SPACE, ',' or ';'. The filtering is case insensitive. E.g. 'TWITCH' will remove 'TwitchBot'.");
    ::TwitchBrothers.Content.Settings.blacklistedNames.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    });

    //Character filter
    ::TwitchBrothers.Content.Settings.Filter = streamSettings.addBooleanSetting("CharacterFilter", true, "Filter special characters","Removes special characters from custom names and titles to prevent twitch chat from doing shenanigans with the scripting languages. Even when disabled, there shouldn't be any Problems, but better safe than sorry, a good name doesn't need these characters. Remeoved characters: |&;$%@<>(),.:+{}[]\\/");
    ::TwitchBrothers.Content.Settings.Filter.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });          

    //auto banning
    ::TwitchBrothers.Content.Settings.AutoBan = streamSettings.addBooleanSetting("AutoBan", true, "Auto ban names","EXPERIMENTAL. Automaically ban names(for this session) when people are getting banned in twitch chat.");
    ::TwitchBrothers.Content.Settings.AutoBan.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });            

    //Chat command settings
    local defaultValues = 
    {
        Name  =
        {
            Name    = "Name",
            String  = "bbname",
            Role    = "Everyone",
            Enabled = true
        },
        Title = 
        {
            Name    = "Title",
            String  = "bbtitle",
            Role    = "Everyone",
            Enabled = true
        },
        Clear =
        {
            Name    = "Clear",
            String  = "bbclear",
            Role    = "... and Moderators",
            Enabled = true
        },
        Block = 
        {
            Name    = "Block",
            String  = "bbblock",
            Role    = "... and Moderators",
            Enabled = true
        }
    }

    foreach (command in defaultValues)
    {
        commandSettings.addTitle(command.Name + "Command", command.Name + "-Command");
        commandSettings.addDivider("DividerCommand" + command.Name);

        ::TwitchBrothers.Content.Settings.Commands[command.Name].String = commandSettings.addStringSetting(command.Name + "CommandString", command.String, "Command name");
        ::TwitchBrothers.Content.Settings.Commands[command.Name].String.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchInterface.updateSettings();}); 

        ::TwitchBrothers.Content.Settings.Commands[command.Name].Role = commandSettings.addEnumSetting(command.Name + "CommandRole" , command.Role, ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles", "Broadcaster - Only broadcaster of the tracked channels can use that commmand\n\n ... and Moderators - Only broadcaster and moderators can use that commmand\n\n ... and Subscriber - Only broadcaster, moderators and subscriber can use that command\n\n Everyone - Everyone can use that command");
        ::TwitchBrothers.Content.Settings.Commands[command.Name].Role.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchInterface.updateSettings();}); 

        ::TwitchBrothers.Content.Settings.Commands[command.Name].Enabled = commandSettings.addBooleanSetting(command.Name + "CommandEnabled" , command.Enabled, "Enable command");
        ::TwitchBrothers.Content.Settings.Commands[command.Name].Enabled.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchInterface.updateSettings();}); 
    }

    //Spawn settings
    //Free
    spawnSettings.addTitle("SpawnFree", "Free");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsRecruit = spawnSettings.addBooleanSetting("SpawnFreeAsRecruit" , true, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsEnemy = spawnSettings.addBooleanSetting("SpawnFreeAsEnemy" , true, "As Enemy");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsDog = spawnSettings.addBooleanSetting("SpawnFreeAsDog" , true, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsItem = spawnSettings.addBooleanSetting("SpawnFreeAsItem" , true, "As Item");



    //Hired
    spawnSettings.addTitle("SpawnHired", "Hired");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsRecruit = spawnSettings.addBooleanSetting("SpawnHiredAsRecruit" , false, "As Recruit", "Disabled for now to prevent duplication.");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsEnemy = spawnSettings.addBooleanSetting("SpawnHiredAsEnemy" , false, "As Enemy");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsDog = spawnSettings.addBooleanSetting("SpawnHiredAsDog" , false, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsItem = spawnSettings.addBooleanSetting("SpawnHiredAsItem" , false, "As Item");

    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsRecruit.lock();

    //Dead
    spawnSettings.addTitle("SpawnDead", "Dead");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsRecruit = spawnSettings.addBooleanSetting("SpawnDeadAsRecruit" , false, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsEnemy = spawnSettings.addBooleanSetting("SpawnDeadAsEnemy" , true, "As Enemy");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsDog = spawnSettings.addBooleanSetting("SpawnDeadAsDog" , true, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsItem = spawnSettings.addBooleanSetting("SpawnDeadAsItem" , true, "As Item");
    
    
    //Retired
    spawnSettings.addTitle("SpawnRetired", "Retired");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsRecruit = spawnSettings.addBooleanSetting("SpawnRetiredAsRecruit" , false, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsEnemy = spawnSettings.addBooleanSetting("SpawnRetiredAsEnemy" , true, "As Enemy");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsDog = spawnSettings.addBooleanSetting("SpawnRetiredAsDog" , true, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsItem = spawnSettings.addBooleanSetting("SpawnRetiredAsItem" , true, "As Item");


    //Event settings
    ::TwitchBrothers.Content.Settings.Event.Active = eventSettings.addBooleanSetting("EventActive", true, "Enable event vote system", "If disabled, all options on this page won't have any effect.");

    eventSettings.addTitle("Color", "Color");
    eventSettings.addDivider("DividerColor");
    ::TwitchBrothers.Content.Settings.Event.Color.Active = eventSettings.addBooleanSetting("EventColorActive", true, "Color event decisions", "If enabled, the decisions in an event will be colored based on how many votes they receive relative to the rest of the options.");
    ::TwitchBrothers.Content.Settings.Event.Color.VoteOffset = eventSettings.addRangeSetting("EventColorVoteOffset", 2, 0, 10, 1, "Vote offset", "Adds the offset to the votes when calculating the colors, smoothing the color transition on early votes. At least 1 is recommended.");
    ::TwitchBrothers.Content.Settings.Event.Color.ColorGood = eventSettings.addColorPickerSetting( "EventColorGood", "0,255,0,1", "Color most votes");
    ::TwitchBrothers.Content.Settings.Event.Color.ColorBad = eventSettings.addColorPickerSetting( "EventColorBad", "255,0,0,1", "Color least votes");

    eventSettings.addTitle("TimedEvents", "Timed Events");
    eventSettings.addDivider("DividerTimedEvents");
    ::TwitchBrothers.Content.Settings.Event.Timer.Active = eventSettings.addBooleanSetting("EventTimerActive", true, "Enable timed event votes", "If disabled, all options bellow will have no effect.");
    ::TwitchBrothers.Content.Settings.Event.Timer.WaitForVote = eventSettings.addBooleanSetting("EventTimerWaitForVote", true, "Wait for first Vote", "If enabled, starts the countdown once the first vote is received. Waits indefinitly if no one votes.");
    ::TwitchBrothers.Content.Settings.Event.Timer.Duration = eventSettings.addRangeSetting("EventTimerDuration", 30, 0, 900, 10, "Duration", "In seconds");

    eventSettings.addTitle("TimedEventsSelection", "Event Selection");
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Manual = eventSettings.addBooleanSetting("EventTimerSelectionManual", true, "Select decisions manually", "Choose event option yourself, bypassing the votes.");
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Auto = eventSettings.addBooleanSetting("EventTimerSelectionAuto", true, "Select decisions automatically", "The option with the most votes is selected, when the countdown reaches 0. Chooses random on tie.");
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Duration = eventSettings.addRangeSetting("EventTimerSelectionDuration", 1, 0, 10, 1, "Select-Animation duration", "In seconds");
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Speed = eventSettings.addRangeSetting("EventTimerSelectionSpeed", 10, 0, 100, 1, "Select-Animation speed");
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Delay = eventSettings.addRangeSetting("EventTimerSelectionDelay", 2, 0, 10, 1, "Delay before selecting the option");

    eventSettings.addTitle("TimedEventsRandomizeChoice", "Randomization Animation");

    ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Active = eventSettings.addBooleanSetting("EventTimerRandomizeChoiceActive", true, "Show animation");
    eventSettings.addSpacer("TimedEventsRandomizeChoiceSpacer1", "35rem", "8rem");
    ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Duration = eventSettings.addRangeSetting("EventTimerRandomizeChoiceDuration", 1, 0, 10, 1, "Select-Animation duration", "In seconds");
    ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Speed = eventSettings.addRangeSetting("EventTimerRandomizeChoiceSpeed", 10, 0, 100, 1, "Select-Animation speed");

    //add update callbacks
    ::TwitchBrothers.Content.Settings.Event.Color.Active.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Color.VoteOffset.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Color.ColorGood.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Color.ColorBad.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Active.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.WaitForVote.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Duration.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Manual.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Auto.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Duration.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Speed.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.Selection.Delay.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Active.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Duration.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
    ::TwitchBrothers.Content.Settings.Event.Timer.RandomizeChoice.Speed.addAfterChangeCallback(function ( _oldValue ) {::Const.TwitchEventVotes.updateSettings();});
}