//contains things that will be passed from js, passed to js and the functions to do that
this.twitch_interface <- {
    m = {
        JSHandle = null,
        TwitchNames = {
            Free     = null,
            Hired    = null,
            Dead     = null,
            Retired  = null
        } 
    },

    function create()
    {
        this.m.TwitchNames.Free = this.new("scripts/mod_twitch_brothers/twitch_name_pool");
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
            "Tracked names: " + (this.m.TwitchNames.Free.len()+this.m.TwitchNames.Hired.len()+this.m.TwitchNames.Dead.len()+this.m.TwitchNames.Retired.len())
            + "\nFree: " + this.m.TwitchNames.Free.len()
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
            !this.m.TwitchNames.Free.addEntry(_data);
        }
        this.updateNameCounter();
    }

    function updateTwitchName(_data){
        this.m.TwitchNames.Free.updateEntry(_data);
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
        if(_TwitchID in this.m.TwitchNames.Free.m.Data)
            return this.m.TwitchNames.Free.m.Data[_TwitchID];
        if(_TwitchID in this.m.TwitchNames.Hired.m.Data)
            return this.m.TwitchNames.Hired.m.Data[_TwitchID];
        if(_TwitchID in this.m.TwitchNames.Dead.m.Data)
            return this.m.TwitchNames.Dead.m.Data[_TwitchID];
        if(_TwitchID in this.m.TwitchNames.Retired.m.Data)
            return this.m.TwitchNames.Retired.m.Data[_TwitchID];
        return null;
    }

    function getRandomTwitchName(_category){
        local names = [];
        local total_weight = 0;

        if(!(_category in ::TwitchBrothers.Content.Settings.Spawn.Free))
        {
            this.logError(_category + " is not a valid spawn category or was misspelled!");
            throw ::MSU.Exception.InvalidValue(_category);
        }

        foreach (key, value in this.m.TwitchNames)
        {
            if(this.m.TwitchNames[key].len() && ::TwitchBrothers.Content.Settings.Spawn[key][_category].getValue())
            {
                names.push({"elem": this.m.TwitchNames[key].randValue(), "weight": this.m.TwitchNames[key].len()});
                total_weight += this.m.TwitchNames[key].len();
            }
        }

        if(names.len() > 0)
        {
            local rand = this.Math.rand(1, total_weight);
            local elem;

            for (local i = 0; i < names.len() && rand > 0; ++i)
            {
                rand -= names[i].weight;
                elem = names[i].elem; 
            }

            return elem;
        }
        else
        {
            return null;
        }
    }

    function getRandomTwitchDisplayName(_category, _other_names = null){
        local names = [];
        local total_weight = 0;

        if(!(_category in ::TwitchBrothers.Content.Settings.Spawn.Free))
        {
            this.logError(_category + " is not a valid spawn category or was misspelled!");
            throw ::MSU.Exception.InvalidValue(_category);
        }
        if(_other_names != null)
        {
            names.push({"name": _other_names[this.Math.rand(0, _other_names.len() - 1)], "weight": _other_names.len()});
            total_weight += _other_names.len();
            
        }

        foreach (key, value in this.m.TwitchNames)
        {
            if(this.m.TwitchNames[key].len() && ::TwitchBrothers.Content.Settings.Spawn[key][_category].getValue())
            {
                names.push({"name": this.m.TwitchNames[key].randValue().DisplayName, "weight": this.m.TwitchNames[key].len()});
                total_weight += this.m.TwitchNames[key].len();
            }
        }

        if(names.len() > 0)
        {
            local rand = this.Math.rand(1, total_weight);
            local name;

            for (local i = 0; i < names.len() && rand > 0; ++i)
            {
                rand -= names[i].weight;
                name = names[i].name; 
            }

            return name;
        }
        else
        {
            return null;
        }
    }

    function giveBroNewTwitchName(_bro)
    {
        local name = this.getRandomTwitchName("AsRecruit");
        
        if(name != null)
        {
            if(_bro.m.TwitchID.len() == 0)
                _bro.m.OriginalName = _bro.m.Name;
            _bro.setName(name.getName());
            if(_bro.m.Title.len()==0 && name.Title)
                _bro.setTitle(name.Title);
            _bro.m.TwitchID = name.TwitchID;
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

    }

    function onDeserialize(_in){
        if(::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.3.0", _in.getMetaData()))
        {
            local deserializationEmulator = ::TwitchBrothers.MSU.Serialization.getDeserializationEmulator("TwitchInterface");
            this.m.TwitchNames.Hired.onDeserialize(deserializationEmulator);
            this.m.TwitchNames.Dead.onDeserialize(deserializationEmulator);
            this.m.TwitchNames.Retired.onDeserialize(deserializationEmulator);

            //update loaded pools with tracked names
            foreach (name in this.m.TwitchNames.Hired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Retired);
                }
            } 
            this.updateNameCounter();  
        }
        else if(::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.2.1", _in.getMetaData()))
        {
            //v0.2.1+v0.2.2 to v0.3.0
            local deserializationEmulator = ::TwitchBrothers.MSU.Serialization.getDeserializationEmulator("TwitchInterface");
            this.m.TwitchNames.Hired.onDeserialize022(deserializationEmulator);
            this.m.TwitchNames.Dead.onDeserialize022(deserializationEmulator);
            this.m.TwitchNames.Retired.onDeserialize022(deserializationEmulator);

            //update loaded pools with tracked names
            foreach (name in this.m.TwitchNames.Hired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Retired);
                }
            } 
            this.updateNameCounter();  
        }
        else
        {
            //v0.2.0 to v0.2.1
            local deserializationEmulator = ::TwitchBrothers.MSU.Serialization.getDeserializationEmulator("TwitchInterface");
            this.m.TwitchNames.Hired.onDeserialize020(deserializationEmulator);
            this.m.TwitchNames.Dead.onDeserialize020(deserializationEmulator);
            this.m.TwitchNames.Retired.onDeserialize020(deserializationEmulator);

            //update loaded pools with tracked names
            foreach (name in this.m.TwitchNames.Hired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data){
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data){
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Retired);
                }
            } 
            this.updateNameCounter();   
        }     
    }

};

