//contains things that will be passed from js, passed to js and the functions to do that
this.twitch_interface <- 
{
    m = 
    {
        JSHandle = null,
        TwitchNames = 
        {
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

    function updateChannels()
    {
        this.m.JSHandle.asyncCall("updateChannels",::TwitchBrothers.Content.Settings.channelNames.getValue());
    }

    function logCallback(val)
    {
        this.logDebug("twitch log: " + val);
    }

    function updateNameCounter()
    {
        ::TwitchBrothers.Content.Settings.channelNames.setDescription(
            "Tracked names: " + (this.m.TwitchNames.Free.len()+this.m.TwitchNames.Hired.len()+this.m.TwitchNames.Dead.len()+this.m.TwitchNames.Retired.len())
            + "\nFree: " + this.m.TwitchNames.Free.len()
            + "\nHired: " + this.m.TwitchNames.Hired.len()
            + "\nDead: " + this.m.TwitchNames.Dead.len()
            + "\nRetired: " + this.m.TwitchNames.Retired.len()
            );
    }

    function updateBlacklist()
    {
        if(::Const.TwitchInterface.m.JSHandle)
        {
            if(::TwitchBrothers.Content.Settings.blacklistedBots.getValue())
            {
                if(::TwitchBrothers.Content.Settings.blacklistedNames.getValue().len())
                {
                    ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", "Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs ," + ::TwitchBrothers.Content.Settings.blacklistedNames.getValue());
                }else{
                    ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", "Nightbot, Streamlabs, Moobot, StreamElements, Wizebot, PhantomBot, Stay_Hydrated_Bot, TidyLabs"); 
                }
            }else{
                ::Const.TwitchInterface.m.JSHandle.asyncCall("updateBlacklist", ::TwitchBrothers.Content.Settings.blacklistedNames.getValue());
            }
        }
    }

    function banTwitchID(_twitchID)
    {
        if(_twitchID.len())
        {
            if(::TwitchBrothers.Content.Settings.blacklistedNames.getValue().len())
            {
                ::TwitchBrothers.Content.Settings.blacklistedNames.set(::TwitchBrothers.Content.Settings.blacklistedNames.getValue() + "," + _twitchID);
            }
            else
            {
                ::TwitchBrothers.Content.Settings.blacklistedNames.set(_twitchID);
            }
            this.updateBlacklist();
            this.deleteTwitchName(_twitchID);
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

        foreach(key, value in settings.Commands)
        {
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

    function addTwitchName(_data)
    {
        if(!this.m.TwitchNames.Hired.updateEntry(_data) && !this.m.TwitchNames.Dead.updateEntry(_data))
        {
            !this.m.TwitchNames.Free.addEntry(_data);
        }
        this.updateNameCounter();
    }

    function updateTwitchName(_data)
    {
        this.m.TwitchNames.Free.updateEntry(_data);
        this.m.TwitchNames.Hired.updateEntry(_data);
        this.m.TwitchNames.Dead.updateEntry(_data);
        this.m.TwitchNames.Retired.updateEntry(_data);
        this.updateNameCounter();
    }
    
    function deleteTwitchName(_twitchID)
    {
        local toRemove = this.lookupName(_twitchID);
        if(toRemove != null)
        {
            local removed = toRemove.ParentTable.deleteEntry(toRemove.TwitchID);
        }
        this.updateNameCounter();
    }

    function nameToNamePool(_nameObject,_namePool)
    { 
        _namePool.addEntry(_nameObject.ParentTable.deleteEntry(_nameObject.TwitchID));
        this.updateNameCounter();
    }

    function twitchIDToNamePool(_twitchID,_namePool)
    {
        if(_twitchID.len() == 0)
            return;
        local nameObj = ::Const.TwitchInterface.lookupName(_twitchID);
        if(nameObj == null)
        {
            this.logInfo("Tried to move name to "+ _namePool.tostring() +": " + _twitchID + " is not in any name pool!");
        }else{
            if(nameObj.ParentTable != _namePool)
                ::Const.TwitchInterface.nameToNamePool(nameObj,_namePool);              
        }
    }

    function lookupName(_twitchID)
    {
        if(_twitchID in this.m.TwitchNames.Free.m.Data)
            return this.m.TwitchNames.Free.m.Data[_twitchID];
        if(_twitchID in this.m.TwitchNames.Hired.m.Data)
            return this.m.TwitchNames.Hired.m.Data[_twitchID];
        if(_twitchID in this.m.TwitchNames.Dead.m.Data)
            return this.m.TwitchNames.Dead.m.Data[_twitchID];
        if(_twitchID in this.m.TwitchNames.Retired.m.Data)
            return this.m.TwitchNames.Retired.m.Data[_twitchID];
        return null;
    }

    function lookupNamesWithSubstring(_twitchIDPart)
    {
        local list = [];
        foreach(twitchID, val in this.m.TwitchNames.Free.m.Data)
        {
            if(twitchID.find(_twitchIDPart) != null)
                list.push(this.m.TwitchNames.Free.m.Data[twitchID]);
        }
        foreach(twitchID, val in this.m.TwitchNames.Hired.m.Data)
        {
            if(twitchID.find(_twitchIDPart) != null)
                list.push(this.m.TwitchNames.Hired.m.Data[twitchID]);
        }
        foreach(twitchID, val in this.m.TwitchNames.Dead.m.Data)
        {
            if(twitchID.find(_twitchIDPart) != null)
                list.push(this.m.TwitchNames.Dead.m.Data[twitchID]);
        }
        foreach(twitchID, val in this.m.TwitchNames.Retired.m.Data)
        {
            if(twitchID.find(_twitchIDPart) != null)
                list.push(this.m.TwitchNames.Retired.m.Data[twitchID]);
        }

        if(list.len())
        {
            return list;
        }
        else
        {
            return null;
        }
    }

    function getRandomTwitchName(_category)
    {
        local names = [];
        local totalWeight = 0;

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
                totalWeight += this.m.TwitchNames[key].len();
            }
        }

        if(names.len() > 0)
        {
            local rand = this.Math.rand(1, totalWeight);
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

    function getRandomTwitchDisplayName(_category, _otherNames = null, _phaseOutThreshold = 0)
    {
        local names = [];
        local totalWeight = 0;

        if(!(_category in ::TwitchBrothers.Content.Settings.Spawn.Free))
        {
            this.logError(_category + " is not a valid spawn category or was misspelled!");
            throw ::MSU.Exception.InvalidValue(_category);
        }


        foreach (key, value in this.m.TwitchNames)
        {
            if(this.m.TwitchNames[key].len() && ::TwitchBrothers.Content.Settings.Spawn[key][_category].getValue())
            {
                names.push({"name": this.m.TwitchNames[key].randValue().DisplayName, "weight": this.m.TwitchNames[key].len()});
                totalWeight += this.m.TwitchNames[key].len();
            }
        }

        if(_otherNames != null)
        {   
            if(_phaseOutThreshold > 0)
            {
                if(_phaseOutThreshold - totalWeight > 0)
                {
                    names.push({"name": _otherNames[this.Math.rand(0, _otherNames.len() - 1)], "weight": _phaseOutThreshold - totalWeight});
                    totalWeight += _phaseOutThreshold - totalWeight;
                }
            }
            else
            {
                names.push({"name": _otherNames[this.Math.rand(0, _otherNames.len() - 1)], "weight": _otherNames.len()});
                totalWeight += _otherNames.len();
            }

        }

        if(names.len() > 0)
        {
            local rand = this.Math.rand(1, totalWeight);
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
        //should only be call when bro is in settlement roster
        //TODO: move twitch name to hired if bro is in player roster, so this function can savely be called from everywhere
        local name = this.getRandomTwitchName("AsRecruit");
        
        if(name != null)
        {
            _bro.restoreOriginalName();

            _bro.setName(name.getName());

            if(_bro.m.OriginalTitle.len()==0 && name.Title)
                _bro.setTitle(name.Title);
            
            _bro.m.TwitchID = name.TwitchID;
            
            return true;
        }else{
            return false;
        }
    }

    function onSerialize(_out)
    {
        local serializationEmulator = ::TwitchBrothers.MSU.Serialization.getSerializationEmulator("TwitchInterface");
        this.m.TwitchNames.Hired.onSerialize(serializationEmulator);
        this.m.TwitchNames.Dead.onSerialize(serializationEmulator);
        this.m.TwitchNames.Retired.onSerialize(serializationEmulator);
    }

    function onDeserialize(_in)
    {
        if(::TwitchBrothers.MSU.Serialization.isSavedVersionAtLeast("0.3.0", _in.getMetaData()))
        {
            local deserializationEmulator = ::TwitchBrothers.MSU.Serialization.getDeserializationEmulator("TwitchInterface");
            this.m.TwitchNames.Hired.onDeserialize(deserializationEmulator);
            this.m.TwitchNames.Dead.onDeserialize(deserializationEmulator);
            this.m.TwitchNames.Retired.onDeserialize(deserializationEmulator);

            //update loaded pools with tracked names
            foreach (name in this.m.TwitchNames.Hired.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
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
            foreach (name in this.m.TwitchNames.Hired.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
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
            foreach (name in this.m.TwitchNames.Hired.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Hired);
                }
            }
            
            foreach (name in this.m.TwitchNames.Dead.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Dead);
                }
            }
            
            foreach (name in this.m.TwitchNames.Retired.m.Data)
            {
                if(name.TwitchID in this.m.TwitchNames.Free.m.Data)
                {
                    this.nameToNamePool(this.m.TwitchNames.Free.m.Data[name.TwitchID],this.m.TwitchNames.Retired);
                }
            } 
            this.updateNameCounter();   
        }     
    }
};

