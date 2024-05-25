//contains things that will be passed from js, passed to js and the functions to do that
this.twitch_interface <- {
    m = {
        JSHandle = null,
        TwitchNames = {
            Pool  = null,
            Hired = null,
            Dead  = null
        } 
    },

    function create()
    {
        this.m.TwitchNames.Pool = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
        this.m.TwitchNames.Hired = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
        this.m.TwitchNames.Dead = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
    }
    
    function onInit()
    {
        this.logDebug("twitch test: init");

    }

    function destroy()
    {
        if (this.m.JSHandle != null)
        {
            this.m.JSHandle = this.UI.disconnect(this.m.JSHandle);
        }
    }

    function connect()
    {
        this.m.JSHandle = ::UI.connect("TwitchInterface",this);
        this.m.JSHandle.asyncCall("initTwitchClient", null);
        this.updateBlacklist();
    }

    function updateChannels(){
        this.m.JSHandle.asyncCall("updateChannels",::TwitchBrothers.Content.Settings.channelNames.getValue());
        this.logDebug("updateChannels: " + ::TwitchBrothers.Content.Settings.channelNames.getValue());
    }

    function logCallback(val){
        this.logDebug("twitch log: " + val);
    }

    function updateNameCounter(){
        ::TwitchBrothers.Content.Settings.channelNames.setDescription("Number of currently tracked names: " + this.m.TwitchNames.Pool.len());
    }

    function updateBlacklist(){
        if(::Const.TwitchInterface.m.JSHandle){
            if(::TwitchBrothers.Content.Settings.blacklistedBots.getValue()){
                if(::TwitchBrothers.Content.Settings.blacklistedNames.getValue().len()){
                    ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", "Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs ," + ::TwitchBrothers.Content.Settings.blacklistedNames.getValue());
                }else{
                    ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", "Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs"); 
                }
            }else{
                ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", ::TwitchBrothers.Content.Settings.blacklistedNames);
            }
        }
    }

    function testCallback(_data){
        this.logDebug("Something:");
        this.logDebug("x: " + _data.x);
        this.logDebug("y: " + _data.y);
        this.logDebug("z: " + _data.z);
    }

    function addTwitchName(_data){
        if(!this.m.TwitchNames.Hired.updateEntry(_data) && !this.m.TwitchNames.Dead.updateEntry(_data)){
            !this.m.TwitchNames.Pool.addEntry(_data);
        }
        this.updateNameCounter();
    }

    function updateTwitchName(_data){
        this.m.TwitchNames.Pool.updateEntry(_data);
        this.m.TwitchNames.Hired.updateEntry(_data);
        this.m.TwitchNames.Dead.updateEntry(_data);
        this.updateNameCounter();
    }

};

