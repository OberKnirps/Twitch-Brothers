::TwitchBrothers <- {
    ID = "mod_twitch_brothers",
    Version = "0.3.0",
    Name = "Twitch Brothers",
    Content = {}
};

::TwitchBrothers.Mod <- ::Hooks.register(::TwitchBrothers.ID, ::TwitchBrothers.Version, ::TwitchBrothers.Name);
::TwitchBrothers.Mod.require("mod_msu(>=1.2.7)");
::TwitchBrothers.Mod.queue(">mod_msu", function()
{
    ::TwitchBrothers.MSU <- ::MSU.Class.Mod(::TwitchBrothers.ID, ::TwitchBrothers.Version, ::TwitchBrothers.Name);

    ::TwitchBrothers.MSU.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/OberKnirps/Twitch-Brothers");
    //::TwitchBrothers.MSU.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/battlebrothers/mods/569");
    ::TwitchBrothers.MSU.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);

    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/promise.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/utils.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/utils.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/commands.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/events.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/logger.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/parser.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/timer.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/tmi_es5/lib/client.js");
    ::Hooks.registerJS("ui/mods/mod_twitch_brothers/twitch_interface.js");
   
    ::Const.TwitchInterface <- this.new("scripts/ui/twitch_interface");
    ::MSU.UI.registerConnection(::Const.TwitchInterface);

    ::TwitchBrothers.Content.addSettings();
    ::TwitchBrothers.Content.hook_player();
    ::TwitchBrothers.Content.hook_character_screen();
    ::TwitchBrothers.Content.hook_asset_manager();
    ::TwitchBrothers.Content.hook_world_state();
    ::TwitchBrothers.Content.hook_settlement();
    ::TwitchBrothers.Content.hook_dogs();
    ::TwitchBrothers.Content.hook_items();
    ::TwitchBrothers.Content.override_world_entity_common();
    ::TwitchBrothers.Content.hook_actor();
})