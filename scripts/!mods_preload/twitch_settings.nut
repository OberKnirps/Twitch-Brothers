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
            } 
        }

    //create pages
    local streamSettings = TwitchBrothers.MSU.ModSettings.addPage("SettingsPage", "Stream Settings");
    local commandSettings = TwitchBrothers.MSU.ModSettings.addPage("CommandPage", "Commands");
    local spawnSettings = TwitchBrothers.MSU.ModSettings.addPage("SpawnPage", "Spawn Settings");
    
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
    //Name command
    commandSettings.addTitle("NameCommand", "Name-Command");

    ::TwitchBrothers.Content.Settings.Commands.Name.String = commandSettings.addStringSetting("NameCommandString", "bbname", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Name.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Name.Role = commandSettings.addEnumSetting("NameCommandRole" , "Everyone", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Name.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Name.Enabled = commandSettings.addBooleanSetting("NameCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Name.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Title command
    commandSettings.addTitle("TitleCommand", "Title-Command");

    ::TwitchBrothers.Content.Settings.Commands.Title.String = commandSettings.addStringSetting("TitleCommandString", "bbtitle", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Title.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Title.Role = commandSettings.addEnumSetting("TitleCommandRole" , "Everyone", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Title.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Title.Enabled = commandSettings.addBooleanSetting("TitleCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Title.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Clear command
    commandSettings.addTitle("ClearCommand", "Clear-Command");

    ::TwitchBrothers.Content.Settings.Commands.Clear.String = commandSettings.addStringSetting("ClearCommandString", "bbclear", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Clear.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Clear.Role = commandSettings.addEnumSetting("ClearCommandRole" , "... and Moderators", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Clear.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Clear.Enabled = commandSettings.addBooleanSetting("ClearCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Clear.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Block command
    commandSettings.addTitle("BlockCommand", "Block-Command");

    ::TwitchBrothers.Content.Settings.Commands.Block.String = commandSettings.addStringSetting("BlockCommandString", "bbblock", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Block.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Block.Role = commandSettings.addEnumSetting("BlockCommandRole" , "... and Moderators", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Block.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Block.Enabled = commandSettings.addBooleanSetting("BlockCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Block.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Spawn settings
    //Free
    spawnSettings.addTitle("SpawnFree", "Free");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsRecruit = spawnSettings.addBooleanSetting("SpawnFreeAsRecruit" , true, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsEnemy = spawnSettings.addBooleanSetting("SpawnFreeAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsDog = spawnSettings.addBooleanSetting("SpawnFreeAsDog" , true, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsItem = spawnSettings.addBooleanSetting("SpawnFreeAsItem" , true, "As Item");

    ::TwitchBrothers.Content.Settings.Spawn.Free.AsEnemy.lock();


    //Hired
    spawnSettings.addTitle("SpawnHired", "Hired");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsRecruit = spawnSettings.addBooleanSetting("SpawnHiredAsRecruit" , false, "As Recruit", "Disabled for now to prevent duplication.");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsEnemy = spawnSettings.addBooleanSetting("SpawnHiredAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsDog = spawnSettings.addBooleanSetting("SpawnHiredAsDog" , false, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsItem = spawnSettings.addBooleanSetting("SpawnHiredAsItem" , false, "As Item");

    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsRecruit.lock();
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsEnemy.lock();

    //Dead
    spawnSettings.addTitle("SpawnDead", "Dead");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsRecruit = spawnSettings.addBooleanSetting("SpawnDeadAsRecruit" , false, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsEnemy = spawnSettings.addBooleanSetting("SpawnDeadAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsDog = spawnSettings.addBooleanSetting("SpawnDeadAsDog" , true, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsItem = spawnSettings.addBooleanSetting("SpawnDeadAsItem" , true, "As Item");
    
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsEnemy.lock();
    
    //Retired
    spawnSettings.addTitle("SpawnRetired", "Retired");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsRecruit = spawnSettings.addBooleanSetting("SpawnRetiredAsRecruit" , false, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsEnemy = spawnSettings.addBooleanSetting("SpawnRetiredAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsDog = spawnSettings.addBooleanSetting("SpawnRetiredAsDog" , true, "As Dog");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsItem = spawnSettings.addBooleanSetting("SpawnRetiredAsItem" , true, "As Item");

    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsEnemy.lock();

}