//::mods_registerJS("twitch/tmi.js");

this.twitch_interface <- {
    m = {
        JSHandle = null,
        Parent = null,
        ID = "",
        Visible = null,
        Animating = null
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
        this.logDebug("twitch: call connect");

        this.m.JSHandle = ::UI.connect("TwitchInterface",this);
    }

    function sendMessage(data){
        this.m.JSHandle.asyncCall("sendMSG", data);
    }
    
    function logCallback(val){
        this.logDebug("twitch log: " + val);
    }

    function messageCallback(message){
        //::Const.TwitchMod.DescriptionTest.setDescription(::Const.TwitchMod.DescriptionTest.Description + "\n" + message);
    }

};

