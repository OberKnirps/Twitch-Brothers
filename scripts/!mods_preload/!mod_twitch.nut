::TwitchBres <- {
    ID = "mod_twitchtest",
    Version = "1.0.0",
    Name = "twitch"
};
::Const.TwitchMod <- {
    DescriptionTest = null
};



::mods_registerMod(::TwitchBres.ID, ::TwitchBres.Version, ::TwitchBres.Name);
::mods_queue(::TwitchBres.ID, "mod_msu", function()
{
    ::TwitchBres.Mod <- ::MSU.Class.Mod( ::TwitchBres.ID, ::TwitchBres.Version, ::TwitchBres.Name);
    ::mods_registerJS("twitch/promise.js");
    ::mods_registerJS("twitch/tmi_es5/lib/utils.js");
    ::mods_registerJS("twitch/tmi_es5/lib/commands.js");
    ::mods_registerJS("twitch/tmi_es5/lib/events.js");
    ::mods_registerJS("twitch/tmi_es5/lib/logger.js");
    ::mods_registerJS("twitch/tmi_es5/lib/parser.js");
    ::mods_registerJS("twitch/tmi_es5/lib/timer.js");
    ::mods_registerJS("twitch/tmi_es5/lib/client.js");
    ::mods_registerJS("twitch/twitch_interface.js");
   
    //::TwitchBres.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.GitHub, "https://github.com/");
    //::TwitchBres.Mod.Registry.addModSource(::MSU.System.Registry.ModSourceDomain.NexusMods, "https://www.nexusmods.com/");
    //::TwitchBres.Mod.Registry.setUpdateSource(::MSU.System.Registry.ModSourceDomain.GitHub);


    this.logDebug("twitch test: JS");
    ::Const.TwitchMod.addSettings();

    local gt = this.getroottable();
    gt.Const.TwitchInterface <- this.new("scripts/ui/twitch_interface");
    


})