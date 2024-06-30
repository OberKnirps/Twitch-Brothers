this.twitch_character_name_screen <- 
{
    m = 
    {
    	JSHandle = null
    },

    function create()
    {

    }
    
    function onInit()
    {

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
        this.m.JSHandle = ::UI.connect("TwitchCharacterNameScreen",this);
    }

    function logCallback(_msg)
    {
        this.logDebug(_msg);
    }

    function getTwitchInfoOfID(_twitchID)
    {
        local nameObj = ::Const.TwitchInterface.lookupName(_twitchID);
        local data = null;
        if(nameObj != null)
            data = nameObj.toData();                  
        return data;
    }

    function getNewTwitchInfo()
    {
        local nameObj = ::Const.TwitchInterface.getRandomTwitchName("AsRecruit");
        local data = null;
        if(nameObj != null)
            data = nameObj.toData();          
        return data;
    }

    function getSelectedBroInfo(_id)
    {
        local data = null;
        local bro = this.Tactical.getEntityByID(_id);

        if(bro != null && bro.isPlayerControlled())
        {
            data = 
            {
                Name = bro.m.Name,
                Title = bro.m.Title,
                TwitchID = bro.m.TwitchID,
                OriginalName = bro.m.OriginalName,
                OriginalTitle = bro.m.OriginalTitle
            }
        }
        else
        {
            this.logInfo("Entity is not a bro.")
        }      
        return data;
    }

    function updateTwitchInfo(_data) //_data.id and _data.twitchID
    {
        local bro = this.Tactical.getEntityByID(_data.id);

        if(bro != null && bro.isPlayerControlled())
        {
            ::Const.TwitchInterface.twitchIDToNamePool(bro.m.TwitchID, ::Const.TwitchInterface.m.TwitchNames.Free);
            bro.m.TwitchID = _data.twitchID;
            ::Const.TwitchInterface.twitchIDToNamePool(_data.twitchID, ::Const.TwitchInterface.m.TwitchNames.Hired);
        }
        else
        {
            this.logInfo("Entity is not a bro.")
        }      
    }

    function onBanThisID(_twitchID)
    {
        return;
    }
    
    function onHireID(_twitchID)
    {
        //free old ID
        //hire new, if ID not in all pools, add an offline entry to hired
        return;
    }

    function onSerialize(_out)
    {
      
    }

    function onDeserialize(_in)
    {
           
    }
};