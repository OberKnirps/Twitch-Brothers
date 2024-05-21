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
        this.logDebug("twitch test: create");

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
    }

    function updateChannels(){
        this.m.JSHandle.asyncCall("updateChannels",::Const.TwitchMod.Settings.channelNames.getValue());
        this.logDebug("updateChannels: " + ::Const.TwitchMod.Settings.channelNames.getValue());
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

};

