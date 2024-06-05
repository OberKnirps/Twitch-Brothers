//sets all the settings up
::TwitchBrothers.Content.addSettings <- function() {
    
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
                    AsDog = null
                },
                Hired = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null
                },
                Dead = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null
                },
                Retired = 
                {
                    AsRecruit = null,
                    AsEnemy = null,
                    AsDog = null
                }
            } 
        }

    //create pages
    local stream_settings = TwitchBrothers.MSU.ModSettings.addPage("SettingsPage", "Stream Settings");
    local command_settings = TwitchBrothers.MSU.ModSettings.addPage("CommandPage", "Commands");
    local spawn_settings = TwitchBrothers.MSU.ModSettings.addPage("SpawnPage", "Spawn Settings");
    
    //Stream Settings
    stream_settings.addTitle("General", "General");
    stream_settings.addDivider("DividerGeneral");


//TODO: make IDs UpperCamelCase
    //Channels to Monitor
    ::TwitchBrothers.Content.Settings.channelNames = stream_settings.addStringSetting("channelNames", "", "Channels");
    ::TwitchBrothers.Content.Settings.channelNames.addAfterChangeCallback(function ( _oldValue )
    {
        if(::Const.TwitchInterface.m.JSHandle){
            ::Const.TwitchInterface.m.JSHandle.asyncCall("initTwitchClient", null);
        }
    });

    //Bot blacklist
    ::TwitchBrothers.Content.Settings.blacklistedBots = stream_settings.addBooleanSetting("blacklistedBots", true, "Remove common Chatbots","Removes common bots from the name pool. List includes: Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs");
    ::TwitchBrothers.Content.Settings.blacklistedBots.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    });

    //Custom balacklist
    ::TwitchBrothers.Content.Settings.blacklistedNames = stream_settings.addStringSetting("blacklistedNames", "", "Blacklist for Names", "Specify names, name parts or regular expretions, seperated by by SPACE, ',' or ';'. The filtering is case insensitive. E.g. 'TWITCH' will remove 'TwitchBot'.");
    ::TwitchBrothers.Content.Settings.blacklistedNames.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateBlacklist();
    });

    //Character filter
    ::TwitchBrothers.Content.Settings.Filter = stream_settings.addBooleanSetting("CharacterFilter", true, "Filter special characters","Removes special characters from custom names and titles to prevent twitch chat from doing shenanigans with the scripting languages. Even when disabled, there shouldn't be any Problems, but better safe than sorry, a good name doesn't need these characters. Remeoved characters: |&;$%@<>(),.:+{}[]\\/");
    ::TwitchBrothers.Content.Settings.Filter.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });          

    //auto banning
    ::TwitchBrothers.Content.Settings.AutoBan = stream_settings.addBooleanSetting("AutoBan", true, "Auto ban names","EXPERIMENTAL. Automaically ban names(for this session) when people are getting banned in twitch chat.");
    ::TwitchBrothers.Content.Settings.AutoBan.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });            


    //Chat command settings
    //Name command
    command_settings.addTitle("NameCommand", "Name-Command");

    ::TwitchBrothers.Content.Settings.Commands.Name.String = command_settings.addStringSetting("NameCommandString", "bbname", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Name.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Name.Role = command_settings.addEnumSetting("NameCommandRole" , "Everyone", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Name.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Name.Enabled = command_settings.addBooleanSetting("NameCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Name.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Title command
    command_settings.addTitle("TitleCommand", "Title-Command");

    ::TwitchBrothers.Content.Settings.Commands.Title.String = command_settings.addStringSetting("TitleCommandString", "bbtitle", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Title.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Title.Role = command_settings.addEnumSetting("TitleCommandRole" , "Everyone", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Title.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Title.Enabled = command_settings.addBooleanSetting("TitleCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Title.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Clear command
    command_settings.addTitle("ClearCommand", "Clear-Command");

    ::TwitchBrothers.Content.Settings.Commands.Clear.String = command_settings.addStringSetting("ClearCommandString", "bbclear", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Clear.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Clear.Role = command_settings.addEnumSetting("ClearCommandRole" , "... and Moderators", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Clear.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Clear.Enabled = command_settings.addBooleanSetting("ClearCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Clear.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Block command
    command_settings.addTitle("BlockCommand", "Block-Command");

    ::TwitchBrothers.Content.Settings.Commands.Block.String = command_settings.addStringSetting("BlockCommandString", "bbblock", "Command name");
    ::TwitchBrothers.Content.Settings.Commands.Block.String.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    ::TwitchBrothers.Content.Settings.Commands.Block.Role = command_settings.addEnumSetting("BlockCommandRole" , "... and Moderators", ["Broadcaster", "... and Moderators", "... and Subscriber", "Everyone"], "Allowed roles");
    ::TwitchBrothers.Content.Settings.Commands.Block.Role.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    });

    ::TwitchBrothers.Content.Settings.Commands.Block.Enabled = command_settings.addBooleanSetting("BlockCommandEnabled" , true, "Enable command");
    ::TwitchBrothers.Content.Settings.Commands.Block.Enabled.addAfterChangeCallback(function ( _oldValue )
    {
        ::Const.TwitchInterface.updateSettings();
    }); 

    //Spawn settings
    //Free
    spawn_settings.addTitle("SpawnFree", "Free");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsRecruit = spawn_settings.addBooleanSetting("SpawnFreeAsRecruit" , true, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsEnemy = spawn_settings.addBooleanSetting("SpawnFreeAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Free.AsDog = spawn_settings.addBooleanSetting("SpawnFreeAsDog" , false, "As Dog");

    ::TwitchBrothers.Content.Settings.Spawn.Free.AsEnemy.lock();


    //Hired
    spawn_settings.addTitle("SpawnHired", "Hired");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsRecruit = spawn_settings.addBooleanSetting("SpawnHiredAsRecruit" , false, "As Recruit", "Disabled for now to prevent duplication.");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsEnemy = spawn_settings.addBooleanSetting("SpawnHiredAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsDog = spawn_settings.addBooleanSetting("SpawnHiredAsDog" , false, "As Dog");

    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsRecruit.lock();
    ::TwitchBrothers.Content.Settings.Spawn.Hired.AsEnemy.lock();

    //Dead
    spawn_settings.addTitle("SpawnDead", "Dead");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsRecruit = spawn_settings.addBooleanSetting("SpawnDeadAsRecruit" , false, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsEnemy = spawn_settings.addBooleanSetting("SpawnDeadAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsDog = spawn_settings.addBooleanSetting("SpawnDeadAsDog" , false, "As Dog");
    
    ::TwitchBrothers.Content.Settings.Spawn.Dead.AsEnemy.lock();
    
    //Retired
    spawn_settings.addTitle("SpawnRetired", "Retired");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsRecruit = spawn_settings.addBooleanSetting("SpawnRetiredAsRecruit" , false, "As Recruit");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsEnemy = spawn_settings.addBooleanSetting("SpawnRetiredAsEnemy" , false, "As Enemy", "Not implemented!");
    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsDog = spawn_settings.addBooleanSetting("SpawnRetiredAsDog" , false, "As Dog");

    ::TwitchBrothers.Content.Settings.Spawn.Retired.AsEnemy.lock();

}