//contains things that will be passed from js, passed to js and the functions to do that
this.twitch_interface <- {
    m = {
        JSHandle = null,
        TwitchNames = {
            Pool     = null,
            Hired    = null,
            Dead     = null,
            Retired  = null
        } 
    },

    function create()
    {
        this.m.TwitchNames.Pool = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
        this.m.TwitchNames.Hired = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
        this.m.TwitchNames.Dead = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
        this.m.TwitchNames.Retired = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
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
        this.updateSettings();
    }

    function updateChannels(){
        this.m.JSHandle.asyncCall("updateChannels",::TwitchBrothers.Content.Settings.channelNames.getValue());
        this.logDebug("updateChannels: " + ::TwitchBrothers.Content.Settings.channelNames.getValue());
    }

    function logCallback(val){
        this.logDebug("twitch log: " + val);
    }

    function updateNameCounter(){
        ::TwitchBrothers.Content.Settings.channelNames.setDescription(
            "Tracked names: " + (this.m.TwitchNames.Pool.len()+this.m.TwitchNames.Hired.len()+this.m.TwitchNames.Dead.len()+this.m.TwitchNames.Retired.len())
            + "\nFree: " + this.m.TwitchNames.Pool.len()
            + "\nHired: " + this.m.TwitchNames.Hired.len()
            + "\nDead: " + this.m.TwitchNames.Dead.len()
            + "\nRetired: " + this.m.TwitchNames.Retired.len()
            );
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

    function updateSettings()
    {
        local settings = 
        {
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
            AutoBan = ::TwitchBrothers.Content.Settings.AutoBan.getValue(),
            Filter = ::TwitchBrothers.Content.Settings.Filter.getValue()
        }

        foreach(key, value in settings.Commands){
            settings.Commands[key].String = ::TwitchBrothers.Content.Settings.Commands[key].String.getValue();
            settings.Commands[key].Enabled = ::TwitchBrothers.Content.Settings.Commands[key].Enabled.getValue();
            switch (::TwitchBrothers.Content.Settings.Commands[key].Role.getValue())
            {
                case "Broadcaster":
                    settings.Commands[key].Role = "broadcaster";
                    break;
                case "... and Moderators":
                    settings.Commands[key].Role = "broadcaster|moderator";
                    break;            
                case "... and Subscriber":
                    settings.Commands[key].Role = "broadcaster|moderator|subscriber";
                    break;
                case "Everyone":
                    settings.Commands[key].Role = "";
                    break;            
                default:
                    this.logError("Command couldn't be set because it's no case in switch statment!");   
            }
        }
        ::Const.TwitchInterface.m.JSHandle.asyncCall("updateSettings", settings);
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
        this.m.TwitchNames.Retired.updateEntry(_data);
        this.updateNameCounter();
    }
    
    function deleteTwitchName(_TwitchID){
        local toRemove = this.lookupName(_TwitchID);
        if(toRemove != null){
            local removed = toRemove.ParentTable.deleteEntry(toRemove.TwitchID);
            //this.logDebug("Removed: "+ removed.TwitchID);
        }
        this.updateNameCounter();
    }

    function nameToNamePool(_name_object,_name_pool)
    { 
        _name_pool.addEntry(_name_object.ParentTable.deleteEntry(_name_object.TwitchID));
        this.updateNameCounter();
    }

    function twitchIDToNamePool(_TwitchID,_name_pool)
    {
        if(_TwitchID.len() == 0)
            return;
        local name_obj = ::Const.TwitchInterface.lookupName(_TwitchID);
        if(name_obj == null){
            this.logError("Tried to move name to "+ _name_pool.tostring() +": " + _TwitchID + " is not in any name pool!");
        }else{
            ::Const.TwitchInterface.nameToNamePool(name_obj,_name_pool);              
        }
    }

    function lookupName(_TwitchID)
    {
        if(_TwitchID in this.m.TwitchNames.Pool.m.Data)
            return this.m.TwitchNames.Pool.m.Data[_TwitchID];
        if(_TwitchID in this.m.TwitchNames.Hired.m.Data)
            return this.m.TwitchNames.Hired.m.Data[_TwitchID];
        if(_TwitchID in this.m.TwitchNames.Dead.m.Data)
            return this.m.TwitchNames.Dead.m.Data[_TwitchID];
        if(_TwitchID in this.m.TwitchNames.Retired.m.Data)
            return this.m.TwitchNames.Retired.m.Data[_TwitchID];
        return null;
    }

    function giveBroNewTwitchName(_bro){
        if(::Const.TwitchInterface.m.TwitchNames.Pool.len()){
            local elem = ::Const.TwitchInterface.m.TwitchNames.Pool.randValue();
            if(_bro.m.TwitchID.len() == 0)
                _bro.m.OriginalName = _bro.m.Name;
            _bro.setName(elem.getName());
            if(_bro.m.Title.len()==0 && elem.Title)
                _bro.setTitle(elem.Title);
            _bro.m.TwitchID = elem.TwitchID;
            return true;
        }else{
            return false;
        }
    }

    function onSerialize(_out){
        local serializationEmulator = ::TwitchBrothers.MSU.Serialization.getSerializationEmulator("TwitchInterface");
        this.m.TwitchNames.Hired.onSerialize(serializationEmulator);
        this.m.TwitchNames.Dead.onSerialize(serializationEmulator);
        this.m.TwitchNames.Retired.onSerialize(serializationEmulator);
        //::TwitchBrothers.MSU.Serialization.flagSerialize("Hired", this.m.TwitchNames.Hired);
        //::TwitchBrothers.MSU.Serialization.flagSerialize("Dead", this.m.TwitchNames.Dead);
        //::TwitchBrothers.MSU.Serialization.flagSerialize("Retired", this.m.TwitchNames.Retired);

    }

    function onDeserialize(_in){
        if(::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.2.1", _in.getMetaData())){
            local deserializationEmulator = ::TwitchBrothers.MSU.Serialization.getDeserializationEmulator("TwitchInterface");
            this.m.TwitchNames.Hired.onDeserialize(deserializationEmulator);
            this.m.TwitchNames.Dead.onDeserialize(deserializationEmulator);
            this.m.TwitchNames.Retired.onDeserialize(deserializationEmulator);

            //update loaded pools with tracked names
            foreach (name in this.m.TwitchNames.Hired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Pool.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Pool.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Pool.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Pool.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Pool.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Pool.m.Data[name.TwitchID],this.m.TwitchNames.Retired);
                }
            } 
            this.updateNameCounter();  
        }else{
            //v0.2.0 to v0.2.1
            local deserializationEmulator = ::TwitchBrothers.MSU.Serialization.getDeserializationEmulator("TwitchInterface");
            this.m.TwitchNames.Hired.onDeserialize020(deserializationEmulator);
            this.m.TwitchNames.Dead.onDeserialize020(deserializationEmulator);
            this.m.TwitchNames.Retired.onDeserialize020(deserializationEmulator);

            //update loaded pools with tracked names
            foreach (name in this.m.TwitchNames.Hired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Pool.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Pool.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Pool.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Pool.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Pool.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Pool.m.Data[name.TwitchID],this.m.TwitchNames.Retired);
                }
            } 
            this.updateNameCounter();   
        }     
    }

};

