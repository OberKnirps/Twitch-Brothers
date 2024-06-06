this.twitch_name_pool <-{
	m = {
		Data = {}
	}, 

	function updateEntry(_data)
	{
		if(_data.TwitchID in this.m.Data){
			this.m.Data[_data.TwitchID].initWithData(_data);
			return true;
		}else{
			return false;
		}
	}
	function addEntry(_data, _live = true){
		if(!this.updateEntry(_data)){
            this.m.Data[_data.TwitchID] <- this.new("scripts/mod_twitch_brothers/twitch_name_object");
            this.m.Data[_data.TwitchID].initWithData(_data, _live);
            this.m.Data[_data.TwitchID].ParentTable = this;
        }
	}

	function deleteEntry(_TwitchID){
		return delete this.m.Data[_TwitchID];
	}
	function len(){
		return this.m.Data.len();
	}
	function randValue(){
		return ::MSU.Table.randValue(this.m.Data);
	}


	function onSerialize(_out){
		_out.writeI32(this.m.Data.len());

		foreach (entry in this.m.Data){
			entry.onSerialize(_out)
		}

    }

    function onDeserialize(_in)
	{
		if (this.m.Data.len()){
			this.logDebug("This name pool shoudn't contain any entries! Clearing it now to avoid contamination.");
			this.m.Data.clear();
		}

		local len = _in.readI32();
		
		for (local i = 0; i < len; i++){
	        local name_object = this.new("scripts/mod_twitch_brothers/twitch_name_object");
	        name_object.ParentTable = this;
	        name_object.onDeserialize(_in);
	        this.m.Data[name_object.TwitchID] <- name_object;

		}
	}

	function onDeserialize022(_in)
	{
		if (this.m.Data.len()){
			this.logDebug("This name pool shoudn't contain any entries! Clearing it now to avoid contamination.");
			this.m.Data.clear();
		}

		//deserialize this.m.Data.len()
		//local len = ::MSU.Utils.deserialize(_in);
		_in.readU8();

		local len = _in.readBool() ? _in.readI32() : _in.readU32();
		
		for (local i = 0; i < len; i++){
	        local name_object = this.new("scripts/mod_twitch_brothers/twitch_name_object");
	        name_object.ParentTable = this;
	        name_object.onDeserialize022(_in);
	        this.m.Data[name_object.TwitchID] <- name_object;

		}
	}

	function onDeserialize020(_in)
	{
		if (this.m.Data.len()){
			this.logDebug("This name pool shoudn't contain any entries! Clearing it now to avoid contamination.");
			this.m.Data.clear();
		}

		//deserialize this.m.Data.len()
		//local len = ::MSU.Utils.deserialize(_in);
		_in.readU8();

		local len = _in.readBool() ? _in.readI32() : _in.readU32();
		
		for (local i = 0; i < len; i++){
	        local name_object = this.new("scripts/mod_twitch_brothers/twitch_name_object");
	        name_object.ParentTable = this;
	        name_object.onDeserialize020(_in);
	        this.m.Data[name_object.TwitchID] <- name_object;

		}
	}
};