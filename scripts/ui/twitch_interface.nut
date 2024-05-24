//contains things that will be passed from js, passed to js and the functions to do that
this.twitch_interface <- {
    m = {
        JSHandle = null,
        TwitchNames = {
            List =[],
            dirty = false
        } 
    },

    function create()
    {
        //this.connect();

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

    function transferNames(){
        this.m.JSHandle.asyncCall("transferNames", null);
    }

    function transferNamesCallback(_names){
        this.m.TwitchNames.List = _names;
        this.m.TwitchNames.dirty = false;
    }

    function namesDirtyCallback(){
        this.m.TwitchNames.dirty = true;
    }

    function updateBlacklist(){
        if(::Const.TwitchInterface.m.JSHandle){
            if(::TwitchBrothers.Content.Settings.blacklistedBots.getValue()){
                ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", "Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs ," + ::TwitchBrothers.Content.Settings.blacklistedNames.getValue());
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

};

